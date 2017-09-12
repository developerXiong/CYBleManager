//
//  CYBleOTA.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYBleOTA.h"
#import "CYBleScanning.h"
#import "CYBleConnect.h"

@import iOSDFULibrary;

@interface CYBleOTA () <DFUServiceDelegate, DFUProgressDelegate, LoggerDelegate>

@property (nonatomic, strong) DFUServiceController *dfuController;

@property (nonatomic, strong) CYBleManagerOTAResponse response;

@property (nonatomic, strong) CYBleManagerOTAProgress progress;

@end

@implementation CYBleOTA

+ (instancetype)ota {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)firmwareUpdateWithDFUPeripheral:(CBPeripheral *)peripheral filePath:(NSURL *)filePath response:(CYBleManagerOTAResponse)response progress:(CYBleManagerOTAProgress)progress {
    if (!peripheral || !filePath) {
        return;
    }
    _response = response;
    _progress = progress;
    [[CYBleConnect connect] connectBle:peripheral timeout:5 state:^(CYBleManagerConnectState state) {
        if (state == CYBleManagerConnected) {            
            DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager:[CYBleScanning scanning].manager target:peripheral];
            
            initiator.delegate = self;
            initiator.progressDelegate = self;
            initiator.logger = self;
            
            // This enables the experimental Buttonless DFU feature from SDK 12.
            // Please, read the field documentation before use.
            initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true;
            DFUFirmware *firmware = nil;
            
            firmware = [[DFUFirmware alloc] initWithUrlToZipFile:filePath];
            
            _dfuController = [[initiator withFirmware:firmware] start];
        }
    }];
}

#pragma mark - DFUServiceDelegate

// dfu状态改变调用
- (void)dfuStateDidChangeTo:(enum DFUState)state {
    // 升级状态变化过程 0->1->2->1->3->升级中->5->6
    switch (state) {
        case DFUStateConnecting:
        {
            // 连接中
            
        }
            break;
        case DFUStateStarting:
        {
            // dfu升级开始
        }
            break;
        case DFUStateEnablingDfuMode:
        {
            // 非dfu模式
            
        }
            break;
        case DFUStateUploading:
        {
            // start
            if (_response) {
                _response(@"", CYDFUStateStart);
            }
        }
            break;
        case DFUStateValidating:
        {
            //验证
        }
            break;
        case DFUStateDisconnecting:
        {
            // 断开dfu连接（升级成功之后）
        }
            break;
        case DFUStateCompleted:
        {
            // 升级完成
            _dfuController = nil;
            if (_response) {
                _response(@"", CYDFUStateCompleted);
            }
        }
            break;
        case DFUStateAborted:
        {
            // 升级中止
            if (_response) {
                _response(@"", CYDFUStateFail);
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
    if (_response) {
        _response(message, CYDFUStateUpdating);
    }
}

#pragma mark - DFUProgressDelegate

- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    if (_progress) {
        _progress(part, totalParts, progress);
    }
}

#pragma mark - LoggerDelegate

- (void)logWith:(enum LogLevel)level message:(NSString *)message {
    if (_response) {
        _response(message, CYDFUStateUpdating);
    }
}

@end
