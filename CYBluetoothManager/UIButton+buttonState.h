//
//  UIButton+buttonState.h
//  GeneralHealth15
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/6/15.
//  Copyright © 2017年 shiyc. All rights reserved.
//  按钮状态类别

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ButtonStateNormal,
    ButtonStateConnecting,
    ButtonStateDidConnect,
    ButtonStateDisconnecting    
} ButtonState;

@interface UIButton (buttonState)

@property (nonatomic, assign) ButtonState cy_state;

@end
