//
//  CYCharacteristicsController.h
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/11.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYBleManager.h"

@interface CYCharacteristicsController : UITableViewController

@property (nonatomic, strong) NSArray <CBCharacteristic *> *characters;

@end
