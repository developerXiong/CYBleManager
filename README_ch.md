# CYBleManager  **[English](README.md)**
关于蓝牙库，包含连接，数据收发器，OTA。

[![Version](http://img.shields.io/cocoapods/v/iOSDFULibrary.svg)](http://cocoapods.org/pods/iOSDFULibrary)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## 安装

**对于Cocoapods:**

- 使用以下内容创建/更新您的Podfile

    ```
    target 'YourProjectName' do
    use_frameworks!
    pod 'CYBleManager'
    end
    ```

- 安装依赖关系

    ```
    pod install
    pod update
    ```

- 通过使用`@import CYBleManager`并开始处理您的项目，将库导入任何类

**对于Carthage:**

- 更新 **Cartfile** 

```
github "developerXiong/CYBleManagerLibrary",
github "NordicSemiconductor/IOS-Pods-DFU-Library"
```

- 运行命令:

```
carthage update
```

- Carthage生成的**CYBleManagerLibrary**, **iOSDFULibrary.framework** and **Zip.framework**三个文件是我们需要使用的

## 用法

- 扫描蓝牙设备

    ```
    [[CYBleManager manager] startScan:10 services:nil isFilter:YES result:^(NSArray<CBPeripheral *> *peripherals) {
        // your code

    }];
    ```

- 连接蓝牙设备

    ```
    [[CYBleManager manager] connectBle:peripheral timeout:10 state:^(CYBleManagerConnectState state) {
        // your code

    }];
    ```

- 断开蓝牙设备

    ```
    [[CYBleManager manager] disconnectBle:peripheral state:^(CYBleManagerDisconnectState state) {
        // your code

    }];
    ```

- 收发数据

    ```
    [[CYBleManager manager] writeStringValue:value toCharacter:character back:^(NSData *data) {
        // your code

    }];
    ```

    ```
    [[CYBleManager manager] readValueForCharacteristic:character back:^(NSData *data) {
        // your code

    }];
    ```

- 蓝牙空中升级

    ```
    [[CYBleManager manager] startScan:10 services:@[[CBUUID UUIDWithString:@"FE59"]] isFilter:NO result:^(NSArray<CBPeripheral *> *peripherals) {
        CBPeripheral *peripheral = peripherals[0];
        [[CYBleManager manager] firmwareUpdateWithDFUPeripheral:peripheral filePath:filePath response:^(NSString *message, CYDFUState state) {
            // your code

        } progress:^(NSInteger part, NSInteger totalPart, NSInteger progress) {
            // your code

        }];
    }]
    ```


