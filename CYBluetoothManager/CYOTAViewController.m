//
//  CYOTAViewController.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/11.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYOTAViewController.h"

#import "CYBleManager.h"

#import "CYBleOTA.h"

@interface CYOTAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation CYOTAViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"dfu-2" withExtension:@"zip"];
    
    [[CYBleManager manager] startScan:10 services:@[[CBUUID UUIDWithString:@"FE59"]] isFilter:NO result:^(NSArray<CBPeripheral *> *peripherals) {
        CBPeripheral *peripheral = peripherals[0];
        [[CYBleManager manager] firmwareUpdateWithDFUPeripheral:peripheral filePath:filePath response:^(NSString *message, CYDFUState state) {
            NSLog(@"%@<--->%ld", message, (unsigned long)state);
            _logLabel.text = message;
        } progress:^(NSInteger part, NSInteger totalPart, NSInteger progress) {
            NSLog(@"%ld---%ld---%ld", part, totalPart, (long)progress);
            _progress.progress = progress/100.0;
            _partLabel.text = [NSString stringWithFormat:@"part:%ld/%ld", (long)part, totalPart];
            _progressLabel.text = [NSString stringWithFormat:@"prgress:%ld%%", (long)progress];
        }];
    }];
    
    
}




@end
