//
//  CYBleScanning.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYBleScanning.h"
#import "CYBleDevice.h"
#import "CYBleConnect.h"
#import "CYBleOTA.h"

#define kAutoConnectBleDeviceKey @"CYAutoConnectBleDeviceKey"

@interface CYBleScanning () <CBCentralManagerDelegate>

@property (nonatomic, strong) NSMutableArray *peripheralArray;

@property (nonatomic, strong) CYBleManagerPeripherals scanResult;

/**
 是否对扫描的结果
 */
@property (nonatomic, assign) BOOL isFilter;

@property (nonatomic, assign) int scanTime;

@end

@implementation CYBleScanning

+ (instancetype)scanning {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _peripheralArray = [NSMutableArray array];
        _peripheralName = @"";
        _UUIDString = @"";
    }
    return self;
}

#pragma mark - setter & getter
- (void)setConnectState:(CYBleManagerConnect)connectState {
    _connectState = connectState;
}

- (void)setPeripheralName:(NSString *)peripheralName {
    _peripheralName = peripheralName;
}

- (void)setUUIDString:(NSString *)UUIDString {
    _UUIDString = UUIDString;
}

- (void)setIsManualDisconnect:(BOOL)isManualDisconnect {
    _isManualDisconnect = isManualDisconnect;
}

- (void)setIsAutoConnect:(BOOL)isAutoConnect {
    _isAutoConnect = isAutoConnect;
}

#pragma mark public method
- (void)startScan:(int)time services:(NSArray<CBUUID *> *)services isFilter:(BOOL)isFilter result:(CYBleManagerPeripherals)result {
    _scanResult = result;
    _scanTime = time;
    _isFilter = isFilter;
    if (_isOn) {
        _peripheralArray = [NSMutableArray array];
        [self stopScan];
        [self.manager scanForPeripheralsWithServices:services options:nil];
        if (time > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopScan];
            });
        }
    }
}

- (void)stopScan {
    if (self.manager.isScanning) {
        [self.manager stopScan];
    }
}

#pragma mark - 蓝牙设备管理者的代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"无法获取设备的蓝牙状态");
            self.isOn = NO;
            break;
        case CBManagerStateResetting:
            NSLog(@"蓝牙重置");
            self.isOn = NO;
            break;
        case CBManagerStateUnsupported:
            NSLog(@"该设备不支持蓝牙");
            self.isOn = NO;
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"未授权蓝牙权限");
            self.isOn = NO;
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙已关闭");
            self.isOn = NO;
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"蓝牙已打开");
            self.isOn = YES;
            [self startScan:_scanTime services:nil isFilter:YES result:_scanResult];
            break;
        default:
        {
            NSLog(@"未知的蓝牙错误");
            self.isOn = NO;
        }
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    NSString *peripheralName = peripheral.name;
    NSString *uuidString = peripheral.identifier.UUIDString;
    
    if (!_isFilter) {
        [self.peripheralArray addObject:peripheral];
        if (_scanResult) {
            _scanResult(_peripheralArray);
        }
    } else {
        if (![self.peripheralArray containsObject:peripheral] && ([localName containsString:_peripheralName] || [peripheralName containsString:_peripheralName] || !_peripheralName.length || !_UUIDString.length || [uuidString isEqualToString:_UUIDString]) && (localName.length || peripheralName.length)) {
            [self.peripheralArray addObject:peripheral];
            if (_scanResult) {
                _scanResult(_peripheralArray);
            }
            [self autoConnectPeripheral:peripheral];
        }
    }
}

- (void)autoConnectPeripheral:(CBPeripheral *)peripheral {
    if (!peripheral) {
        return;
    }
    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] stringForKey:kAutoConnectBleDeviceKey];
    if (![uuidStr isEqualToString:peripheral.identifier.UUIDString]) {
        return;
    }
    [[CYBleConnect connect] connectBle:peripheral timeout:8];
    
}

// 连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
//    NSLog(@"lib-连接成功");
    [CYBleDevice device].peripheral = peripheral;
    [CYBleOTA ota].dfuPeripheral = peripheral;
    if (_connectState) {
        _connectState(CYBleManagerConnected);
    }
    
    if (_isAutoConnect) {
        [[NSUserDefaults standardUserDefaults] setValue:peripheral.identifier.UUIDString forKey:kAutoConnectBleDeviceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
// 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (_connectState) {
        _connectState(CYBleManagerConnectFail);
    }
}

// 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:kAutoConnectBleDeviceKey];
    if ([uuid isEqualToString:peripheral.identifier.UUIDString]) {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kAutoConnectBleDeviceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [CYBleDevice device].peripheral = nil;
    [CYBleDevice device].services = [NSMutableArray array];
    [CYBleDevice device].characters = [NSMutableDictionary dictionary];
    if (_connectState) {
        if (!_isManualDisconnect) {
            _connectState(CYBleManagerDisconnectAccident);
        } else {
            _connectState(CYBleManagerDisconnected);
        }
    }
}

#pragma mark private method


@end
