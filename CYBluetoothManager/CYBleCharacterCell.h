//
//  CYBleCharacterCell.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/11.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYBleManager.h"

@interface CYBleCharacterCell : UITableViewCell <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *UUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptorLabel;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) CBCharacteristic *character;

@end
