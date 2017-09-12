//
//  SearchDevicesCell.h
//  GeneralHealth15
//
//  Created by healthmemac2 on 2017/5/31.
//  Copyright © 2017年 shiyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+buttonState.h"

@interface SearchDevicesCell : UITableViewCell
@property (nonatomic,strong) UILabel * devicesLB;//蓝牙的lb显示
@property (nonatomic,strong) UIButton  * selectBtn;//连接的按钮
@end
