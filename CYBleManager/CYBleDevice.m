//
//  CYBleDevice.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYBleDevice.h"

#import "CYBleScanning.h"


@interface CYBleDevice () <CBPeripheralDelegate>

@property (nonatomic, strong) CYBleManagerWriteResponse writeResponse;

@property (nonatomic, strong) CYBleManagerWriteResponse readResponse;

@end

@implementation CYBleDevice

+ (instancetype)device {
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
        _characters = [NSMutableDictionary dictionary];
        _services = [NSMutableArray array];
    }
    return self;
}

#pragma mark - setter & getter

- (void)setServicesUUIDs:(NSArray<NSString *> *)servicesUUIDs {
    _servicesUUIDs = servicesUUIDs;
}

- (void)setCharacterUUIDs:(NSArray<NSString *> *)characterUUIDs {
    _characterUUIDs = characterUUIDs;
}

- (void)setPeripheral:(CBPeripheral *)peripheral {
    if (!peripheral) {
        return;
    }
    _peripheral = peripheral;
    _peripheral.delegate = self;
    if (!_servicesUUIDs) {
        [peripheral discoverServices:nil];
    } else {
        NSMutableArray *uuids = [NSMutableArray array];
        for (NSString *uuid in _servicesUUIDs) {
            CBUUID *uid = [CBUUID UUIDWithString:uuid];
            [uuids addObject:uid];
        }
        [peripheral discoverServices:uuids];
    }
}

#pragma mark - public method
- (void)writeValue:(NSData *)data toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response {
    if (!character) {
        return;
    }
    [self.peripheral writeValue:data forCharacteristic:character type:CBCharacteristicWriteWithResponse];
    _writeResponse = response;
}
- (void)writeStringValue:(NSString *)value toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response {
    NSData *data = [self hexToBytes:value];
    [self writeValue:data toCharacter:character back:response];
}

- (NSString *)UUIDString {
    if (!_peripheral) {
        return @"未连接蓝牙设备";
    }
    return _peripheral.identifier.UUIDString;
}
- (NSString *)UUIDStringWithPeripheral:(CBPeripheral *)peripheral {
    if (!peripheral) {
        return @"未识别的蓝牙设备";
    }
    return peripheral.identifier.UUIDString;
}

- (CBPeripheral *)peripheralWithUUIDString:(NSString *)uuid {
    if (!uuid.length) {
        return nil;
    }
    
    NSArray *peripherals = [[CYBleScanning scanning].manager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:uuid]]];
    if (!peripherals.count) {
        return nil;
    } else {
        return peripherals[0];
    }
}

- (void)setNotify:(BOOL)n forCharacter:(CBCharacteristic *)c {
    if (!_peripheral || !c) {
        return;
    }
    [_peripheral setNotifyValue:n forCharacteristic:c];
}

- (void)readValueForCharacteristic:(CBCharacteristic *)c back:(CYBleManagerReadValueResponse)response {
    if (!_peripheral || !c) {
        return;
    }
    [_peripheral readValueForCharacteristic:c];
    _readResponse = response;
}

#pragma mark - peripheral delegate
// 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        return;
    }
    for (CBService *service in peripheral.services) {
//        NSLog(@"service---%@", service);
        [_services addObject:service];
        if (!_characterUUIDs) {
            [service.peripheral discoverCharacteristics:nil forService:service];
        } else {
            NSMutableArray *uuids = [NSMutableArray array];
            for (NSString *uuid in _servicesUUIDs) {
                CBUUID *uid = [CBUUID UUIDWithString:uuid];
                [uuids addObject:uid];
            }
            [service.peripheral discoverCharacteristics:uuids forService:service];
        }
    }
    
}
// 发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {
    if (error) {
        return;
    }
    NSMutableArray *characters = [NSMutableArray array];
    for (CBCharacteristic *charcater in service.characteristics) {
//        NSLog(@"charcater---%@", charcater);
        [characters addObject:charcater];
    }
    _characters[service.UUID.UUIDString] = characters;
}
// 获取数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (_writeResponse) {
        _writeResponse(characteristic.value);
    }
    if (_readResponse) {
        _readResponse(characteristic.value);
    }
}

#pragma mark - utils
/**
 16进制字符串转NSData类型
 */
- (NSData *)hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
