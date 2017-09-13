//
//  CYBleManager.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CYBlock.h"

@interface CYBleManager : NSObject

/**
 根据名称搜索设备,不设置代表搜索所有设备
 */
@property (nonatomic, copy) NSString *peripheralName;

/**
 根据设备UUID搜索设备,不设置代表搜索所有设备
 */
@property (nonatomic, copy) NSString *UUIDString;

@property (nonatomic, strong) NSMutableArray <CBService *> *services;

/**
 特征值 @{service:@[character] ...}
 */
@property (nonatomic, strong) NSMutableDictionary *characters;

/**
 已连接的蓝牙设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 是否自动连接蓝牙设备, 默认开启
 */
@property (nonatomic, assign) BOOL isAutoConnect;

+ (instancetype)manager;

/**
 扫描
 
 @param time :扫描时间 0代表无时间限制
 @param services :根据服务搜索蓝牙设备,nil代表搜索所有
 */
- (void)startScan:(int)time services:(NSArray <CBUUID* > *)services isFilter:(BOOL)isFilter result:(CYBleManagerPeripherals)result;
- (void)stopScan;

/**
 连接蓝牙设备
 
 @param time 连接超时时间 默认5秒
 */
- (void)connectBle:(CBPeripheral *)peripheral timeout:(int)time;

/**
 断开蓝牙连接
 */
- (void)disconnectBle:(CBPeripheral *)peripheral;

/**
 监测蓝牙连接状态
 */
- (void)moniterBleConnectState:(CYBleManagerConnect)state;

/**
 使能通知
 */
- (void)setNotify:(BOOL)n forCharacter:(CBCharacteristic *)c;

/**
 向特征写入值
 */
- (void)writeValue:(NSData *)data toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response;
- (void)writeStringValue:(NSString *)value toCharacter:(CBCharacteristic *)character back:(CYBleManagerWriteResponse)response;

/**
 从特征读数据
 */
- (void)readValueForCharacteristic:(CBCharacteristic *)c back:(CYBleManagerReadValueResponse)response;

/**
 固件升级
 
 @param peripheral dfu模式下的设备
 @param filePath 固件包url地址
 */
- (void)firmwareUpdateWithDFUPeripheral:(CBPeripheral *)peripheral filePath:(NSURL *)filePath response:(CYBleManagerOTAResponse)response progress:(CYBleManagerOTAProgress)progress;

@end
