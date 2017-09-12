//
//  UIButton+buttonState.m
//  GeneralHealth15
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/6/15.
//  Copyright © 2017年 shiyc. All rights reserved.
//

#import "UIButton+buttonState.h"
#import <objc/runtime.h>

static char *StateNameKey = "StateNameKey";
@implementation UIButton (buttonState)

- (void)setCy_state:(ButtonState)cy_state {
    
    objc_setAssociatedObject(self, StateNameKey, [NSNumber numberWithInteger:cy_state], OBJC_ASSOCIATION_ASSIGN);
//    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    switch (cy_state) {
        case ButtonStateNormal:
            [self setTitle:@"连接" forState:UIControlStateNormal];
            self.enabled = YES;
            break;
        case ButtonStateConnecting:
            [self setTitle:@"连接中..." forState:UIControlStateNormal];
            self.enabled = NO;
            break;
        case ButtonStateDidConnect:
            [self setTitle:@"断开" forState:UIControlStateNormal];
            self.enabled = YES;
            break;
        case ButtonStateDisconnecting:
            [self setTitle:@"断开中..." forState:UIControlStateNormal];
            self.enabled = NO;
            break;
            
        default:
            break;
    }
}

- (ButtonState)cy_state {
    return [objc_getAssociatedObject(self, StateNameKey) integerValue];
}

@end
