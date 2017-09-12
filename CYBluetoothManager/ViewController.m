//
//  ViewController.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/7.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "ViewController.h"

#import "CYBleManager.h"
#import "CYBleScanning.h"
#import "SearchDevicesCell.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *peripherals;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _peripherals = [[NSArray alloc] init];
    [self initBle];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(initBle) forControlEvents:UIControlEventValueChanged];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initBle {
    // 开始扫描
    [[CYBleManager manager] startScan:10 services:nil isFilter:YES result:^(NSArray<CBPeripheral *> *peripherals) {
        _peripherals = peripherals;
        [self.tableView reloadData];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}
    


#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchDevicesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SearchDevicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.selectionStyle = 0;
    
    CBPeripheral *peripheral = _peripherals[indexPath.row];
    cell.devicesLB.text = peripheral.name;
    switch (peripheral.state) {
        case CBPeripheralStateConnecting:
            cell.selectBtn.cy_state = ButtonStateConnecting;
            break;
        case CBPeripheralStateConnected:
            cell.selectBtn.cy_state = ButtonStateDidConnect;
            break;
        case CBPeripheralStateDisconnected:
            cell.selectBtn.cy_state = ButtonStateNormal;
            break;
            
        default:
            break;
    }
    cell.selectBtn.tag = indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)clickSelectBtn:(UIButton *)btn {
    _selectBtn = btn;
    CBPeripheral *peripheral = _peripherals[btn.tag];
    switch (btn.cy_state) {
        case ButtonStateConnecting:
        {
            // 连接中
        }
            break;
        case ButtonStateDidConnect:
        {
            // 已连接
            [[CYBleManager manager] disconnectBle:peripheral state:^(CYBleManagerDisconnectState state) {
                switch (state) {
                    case CYBleManagerDisconnected:
                        NSLog(@"手动断开连接");
                        _selectBtn.cy_state = ButtonStateNormal;
                        break;
                    case CYBleManagerDisconnecting:
                        NSLog(@"断开连接中");
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
        case ButtonStateDisconnecting:
        {
            // 断开连接中
        }
            break;
        case ButtonStateNormal:
        {
            //
            [[CYBleManager manager] connectBle:peripheral timeout:10 state:^(CYBleManagerConnectState state) {
                switch (state) {
                    case CYBleManagerConnected:
                    {
                        NSLog(@"连接成功");
                        _selectBtn.cy_state = ButtonStateDidConnect;
                    }
                        break;
                    case CYBleManagerConnecting:
                    {
                        NSLog(@"连接中");
                        _selectBtn.cy_state = ButtonStateConnecting;
                    }
                        break;
                    case CYBleManagerConnectFail:
                    {
                        NSLog(@"连接失败");
                        _selectBtn.cy_state = ButtonStateNormal;
                    }
                        break;
                    case CYBleManagerConnectTimeout:
                    {
                        NSLog(@"连接超时");
                        _selectBtn.cy_state = ButtonStateNormal;
                    }
                        break;
                    case CYBleManagerDisconnectAccident:
                    {
                        NSLog(@"意外断开连接");
                        _selectBtn.cy_state = ButtonStateNormal;
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
