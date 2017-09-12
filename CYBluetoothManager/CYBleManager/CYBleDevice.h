//
//  CYBleDevice.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//  蓝牙设备信息相关的类

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CYBlock.h"

@interface CYBleDevice : NSObject

/**
 已连接的蓝牙设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) NSMutableArray <CBService *> *services;

/**
 特征值 @{service:@[character] ...}
 */
@property (nonatomic, strong) NSMutableDictionary *characters;

/**
 设置要查找的蓝牙服务的uuid,nil代表查找所有
 */
@property (nonatomic, strong) NSArray <NSString *> *servicesUUIDs;

/**
 设置要查找的蓝牙特征的uuid,nil代表查找所有
 */
@property (nonatomic, strong) NSArray <NSString *> *characterUUIDs;

+ (instancetype)device;

/**
 向特征写入值
 */
- (void)writeValue:(NSData *)data toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response;
- (void)writeStringValue:(NSString *)value toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response;

/**
 从设备中获取UUID
 */
- (NSString *)UUIDString;       // 从当前连接的设备中获取uuid
- (NSString *)UUIDStringWithPeripheral:(CBPeripheral *)peripheral;

/**
 根据UUID获取设备
 */
- (CBPeripheral *)peripheralWithUUIDString:(NSString *)uuid;

/**
 使能通知
 */
- (void)setNotify:(BOOL)n forCharacter:(CBCharacteristic *)c;

/**
 从特征读数据
 */
- (void)readValueForCharacteristic:(CBCharacteristic *)c back:(CYBleManagerReadValueResponse)response;

@end
