# CYBleManager
About bluetooth library, contains connection, data transceiver, OTA.

[![Version](http://img.shields.io/cocoapods/v/iOSDFULibrary.svg)](http://cocoapods.org/pods/iOSDFULibrary)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installation

**For Cocoapods:

- Create/Update your **Podfile** with the following contents

    ```
    target 'YourProjectName' do
        use_frameworks!
        pod 'CYBleManager'
    end
    ```

- Install dependencies
    
    ```
    pod install
    pod update
    ```

- Import the library to any of your classes by using `@import CYBleManager` and begin working on your project

**For Carthage:**

## Usage

- scanning ble

    ```
    [[CYBleManager manager] startScan:10 services:nil isFilter:YES result:^(NSArray<CBPeripheral *> *peripherals) {
        // your code

    }];
    ```

- connect ble

    ```
    [[CYBleManager manager] connectBle:peripheral timeout:10 state:^(CYBleManagerConnectState state) {
        // your code

    }];
    ```

- disconnect ble

    ```
    [[CYBleManager manager] disconnectBle:peripheral state:^(CYBleManagerDisconnectState state) {
        // your code

    }];
    ```

- receive data

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

- OTA

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

    
