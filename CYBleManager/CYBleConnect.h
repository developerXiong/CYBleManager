//
//  CYBleConnect.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//  蓝牙连接相关的类

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CYBlock.h"

@interface CYBleConnect : NSObject

/**
 设置连接超时时间
 */
@property (nonatomic, assign) int timeoutTime;

@property (nonatomic, assign) BOOL isAutoConnect;

+ (instancetype)connect;

/**
 连接蓝牙设备
 */
- (void)connectBle:(CBPeripheral *)peripheral timeout:(int)time state:(CYBleManagerConnect)state;

/**
 断开蓝牙连接
 */
- (void)disconnectBle:(CBPeripheral *)peripheral state:(CYBleManagerDisconnect)state;

@end
