//
//  CYBleOTA.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//  蓝牙设备空中升级相关的类

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CYBlock.h"

@interface CYBleOTA : NSObject

+ (instancetype)ota;

/**
 固件升级

 @param peripheral dfu模式下的设备
 @param filePath 固件包url地址
 */
- (void)firmwareUpdateWithDFUPeripheral:(CBPeripheral *)peripheral filePath:(NSURL *)filePath response:(CYBleManagerOTAResponse)response progress:(CYBleManagerOTAProgress)progress;

@end
