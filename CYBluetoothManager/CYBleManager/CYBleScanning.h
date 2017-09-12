//
//  CYBleScanning.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//  蓝牙扫描相关的类

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CYBlock.h"

@interface CYBleScanning : NSObject

@property (nonatomic, strong) CBCentralManager *manager;

@property (nonatomic, copy) NSString *peripheralName;

@property (nonatomic, copy) NSString *UUIDString;

@property (nonatomic, strong) CYBleManagerConnect connectState;

@property (nonatomic, strong) CYBleManagerDisconnect disconnectState;

@property (nonatomic, assign) BOOL isManualDisconnect;

@property (nonatomic, assign) BOOL isAutoConnect;

/**
 蓝牙是否打开
 */
@property (nonatomic, assign) BOOL isOn;

+ (instancetype)scanning;

/**
 扫描  time:扫描时间 0代表无时间限制
 */
- (void)startScan:(int)time services:(NSArray <CBUUID *> *)services isFilter:(BOOL)isFilter result:(CYBleManagerPeripherals)result;
- (void)stopScan;

@end
