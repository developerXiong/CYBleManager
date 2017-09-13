//
//  CYBleManager.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYBleManager.h"

#import "CYBleDevice.h"
#import "CYBleScanning.h"
#import "CYBleConnect.h"
#import "CYBleOTA.h"

@implementation CYBleManager

+ (instancetype)manager {
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
        [CYBleConnect connect].isAutoConnect = YES;
    }
    return self;
}

#pragma mark - setter & getter
- (void)setUUIDString:(NSString *)UUIDString {
    _UUIDString = UUIDString;
    [CYBleScanning scanning].UUIDString = UUIDString;
}

- (void)setPeripheralName:(NSString *)peripheralName {
    _peripheralName = peripheralName;
    [CYBleScanning scanning].peripheralName = peripheralName;
}

- (NSMutableArray<CBService *> *)services {
    return [CYBleDevice device].services;
}

- (NSMutableDictionary *)characters {
    return [CYBleDevice device].characters;
}

- (CBPeripheral *)peripheral {
    return [CYBleDevice device].peripheral;
}

- (void)setIsAutoConnect:(BOOL)isAutoConnect {
    _isAutoConnect = isAutoConnect;
    [CYBleConnect connect].isAutoConnect = isAutoConnect;
}

#pragma mark - public method

- (void)startScan:(int)time services:(NSArray<CBUUID *> *)services isFilter:(BOOL)isFilter result:(CYBleManagerPeripherals)result {
    [[CYBleScanning scanning] startScan:time services:services isFilter:isFilter result:result];
}

- (void)stopScan {
    [[CYBleScanning scanning] stopScan];
}

- (void)connectBle:(CBPeripheral *)peripheral timeout:(int)time {
    [[CYBleConnect connect] connectBle:peripheral timeout:time];
}

- (void)disconnectBle:(CBPeripheral *)peripheral{
    [[CYBleConnect connect] disconnectBle:peripheral];
}

- (void)moniterBleConnectState:(CYBleManagerConnect)state {
    [[CYBleConnect connect] moniterBleConnectState:state];
}

- (void)setNotify:(BOOL)n forCharacter:(CBCharacteristic *)c {
    [[CYBleDevice device] setNotify:n forCharacter:c];
}

- (void)writeValue:(NSData *)data toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response {
    [[CYBleDevice device] writeValue:data toCharacter:character back:response];
}

- (void)writeStringValue:(NSString *)value toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response {
    [[CYBleDevice device] writeStringValue:value toCharacter:character back:response];
}

- (void)readValueForCharacteristic:(CBCharacteristic *)c back:(CYBleManagerReadValueResponse)response {
    [[CYBleDevice device] readValueForCharacteristic:c back:response];
}

- (void)firmwareUpdateWithDFUPeripheral:(CBPeripheral *)peripheral filePath:(NSURL *)filePath response:(CYBleManagerOTAResponse)response progress:(CYBleManagerOTAProgress)progress {
    [[CYBleOTA ota] firmwareUpdateWithDFUPeripheral:peripheral filePath:filePath response:response progress:progress];
}

@end
