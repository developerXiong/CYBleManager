//
//  CYBleCharacterCell.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/11.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYBleCharacterCell.h"

@implementation CYBleCharacterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickWrite:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Write Value" message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"send", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *value = [alertView textFieldAtIndex:0].text;
        NSLog(@"write value --- %@", value);
        [[CYBleManager manager] writeStringValue:value toCharacter:_character back:^(NSData *data) {
            NSLog(@"write back value--->%@", data);
        }];
    }
}
- (IBAction)clickNotify:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [[CYBleManager manager] setNotify:sender.selected forCharacter:self.character];
    
}


- (IBAction)clickRead:(UIButton *)sender {
    
    [[CYBleManager manager] readValueForCharacteristic:self.character back:^(NSData *data) {
        NSLog(@"read back value---->%@", data);
        NSString *value = data ? data.description : @"";
        value = [value stringByReplacingOccurrencesOfString:@"<" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@">" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.valueLabel.text = [NSString stringWithFormat:@"value 0x%@", value];
    }];
    
}

// 16进制字符串->NSData
- (NSData *)hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
