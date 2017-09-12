//
//  CYBleConnect.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYBleConnect.h"

#import "CYBleScanning.h"
#import "CYBleDevice.h"

@interface CYBleConnect ()

@property (nonatomic, strong) CYBleManagerConnect connectState;

@property (nonatomic, assign) BOOL isTimeout;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CYBleConnect

+ (instancetype)connect {
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
        _timeoutTime = 5;
        _isTimeout = YES;
    }
    return self;
}

#pragma mark - setter & getter

- (void)setTimeoutTime:(int)timeoutTime {
    _timeoutTime = timeoutTime;
}

- (void)setIsAutoConnect:(BOOL)isAutoConnect {
    _isAutoConnect = isAutoConnect;
    [CYBleScanning scanning].isAutoConnect = isAutoConnect;
}

#pragma mark - public method

- (void)connectBle:(CBPeripheral *)peripheral timeout:(int)time state:(CYBleManagerConnect)state {
    if (!peripheral) {
        return;
    }
    [CYBleScanning scanning].isManualDisconnect = NO;
    _timeoutTime = time;
    _connectState = state;
    [CYBleScanning scanning].connectState = state;
    if ([CYBleDevice device].peripheral) {
        [self disconnectBle:[CYBleDevice device].peripheral state:nil];   // 一次只允许连接一台蓝牙设备
    }
    
    [[CYBleScanning scanning].manager connectPeripheral:peripheral options:nil];
    [self setConnectTimeout:peripheral];
    if (_connectState) {
        _connectState(CYBleManagerConnecting);
    }
}

- (void)disconnectBle:(CBPeripheral *)peripheral state:(CYBleManagerDisconnect)state {
    if (!peripheral) {
        return;
    }
    [self cancelPeripheral:peripheral];
    _isTimeout = NO;
    [CYBleScanning scanning].disconnectState = state;
    if (state) {
        state(CYBleManagerDisconnecting);
    }
}

- (void)cancelPeripheral:(CBPeripheral *)peripheral {
    [CYBleScanning scanning].isManualDisconnect = YES;
    [[CYBleScanning scanning].manager cancelPeripheralConnection:peripheral];
}

#pragma mark - privte method
// 连接超时
- (void)setConnectTimeout:(CBPeripheral *)peripheral {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timeoutTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (peripheral.state == CBPeripheralStateConnecting) {
            if (_connectState) {
                _connectState(CYBleManagerConnectTimeout);
            }
            [self disconnectBle:peripheral state:nil];
        }
        _isTimeout = YES;
    });
}

@end
