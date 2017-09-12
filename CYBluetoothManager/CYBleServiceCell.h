//
//  CYBleServiceCell.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/11.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYBleServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *UUID;
@property (weak, nonatomic) IBOutlet UILabel *serviceLevel;

@property (nonatomic, strong) NSArray *characters;

@end
