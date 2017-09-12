//
//  CYBlock.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/8.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#ifndef CYBlock_h
#define CYBlock_h

typedef enum : NSUInteger {
    CYBleManagerConnecting,
    CYBleManagerConnected,
    CYBleManagerConnectFail,
    CYBleManagerConnectTimeout,
    CYBleManagerDisconnectAccident      // 意外断开蓝牙连接
} CYBleManagerConnectState;

typedef enum : NSUInteger {
    CYBleManagerDisconnecting,
    CYBleManagerDisconnected
} CYBleManagerDisconnectState;

typedef enum : NSUInteger {
    CYDFUStateStart,
    CYDFUStateFail,
    CYDFUStateUpdating,
    CYDFUStateCompleted,
} CYDFUState;

// 连接状态
typedef void(^CYBleManagerConnect)(CYBleManagerConnectState state);
typedef void(^CYBleManagerDisconnect)(CYBleManagerDisconnectState state);

// 向特征写数据
typedef void(^CYBleManagerWriteResponse)(NSData *data);

// 从特征读数据
typedef void(^CYBleManagerReadValueResponse)(NSData *data);

// 扫描到的蓝牙设备
typedef void(^CYBleManagerPeripherals)(NSArray <CBPeripheral *> *peripherals);


/**
 ota升级返回数据

 @param message message
 @param state 升级状态
 */
typedef void(^CYBleManagerOTAResponse)(NSString *message, CYDFUState state);

/**
 ota升级进程
 
 @param part 当前升级第几部分
 @param totalPart 总共有几个部分
 @param progress 进程
 */
typedef void(^CYBleManagerOTAProgress)(NSInteger part, NSInteger totalPart, NSInteger progress);


#endif /* CYBlock_h */
