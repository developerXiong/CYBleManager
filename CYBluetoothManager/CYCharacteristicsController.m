//
//  CYCharacteristicsController.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/11.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYCharacteristicsController.h"

#import "CYBleManager.h"
#import "CYBleCharacterCell.h"
#import "CYOTAViewController.h"


#define DFUCHARACTERUUID @"8E400001-F315-4F60-9FB8-838830DAEA50"

@interface CYCharacteristicsController ()

@end

@implementation CYCharacteristicsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"characters--->%@", _characters);
    
    BOOL isHidden = YES;
    for (CBCharacteristic *character in _characters) {
        if ([character.UUID.UUIDString isEqualToString:DFUCHARACTERUUID]) {
            isHidden = NO;
        }
    }
    
    if (!isHidden) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OTA" style:UIBarButtonItemStylePlain target:self action:@selector(clickOTA)];
    }
}

- (void)clickOTA {
    [self performSegueWithIdentifier:@"toOTA" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _characters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYBleCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CYBleCharacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        
    }
    
    CBCharacteristic *character = _characters[indexPath.row];
    
    cell.TitleLabel.text = [NSString stringWithFormat:@"%@", [self characterName:character]];
    cell.UUIDLabel.text = [NSString stringWithFormat:@"UUID %@", character.UUID.UUIDString];
    cell.propertiesLabel.text = [NSString stringWithFormat:@"Properties %@", [self properties:character.properties notifying:character.isNotifying]];
    NSString *value = @"";
    value = [character.value.description stringByReplacingOccurrencesOfString:@"<" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@">" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    cell.valueLabel.text = [NSString stringWithFormat:@"value 0x%@", value];
    cell.descriptorLabel.text = [NSString stringWithFormat:@"Descriptor %@", character.descriptors.count ? @"true" : @"false"];
    cell.index = indexPath.row;
    cell.character = character;
    
    if (character.isNotifying) {
        cell.notifyBtn.selected = YES;
        [cell.notifyBtn setTitle:@"可写" forState:UIControlStateSelected];
    } else {
        cell.notifyBtn.selected = NO;
        [cell.notifyBtn setTitle:@"使能" forState:UIControlStateNormal];
    }
    
    switch (character.properties) {
        case CBCharacteristicPropertyNotify:
            cell.notifyBtn.hidden = NO;
            break;
        case CBCharacteristicPropertyRead:
            cell.readBtn.hidden = NO;
            break;
        case CBCharacteristicPropertyWrite:
            cell.writeBtn.hidden = NO;
            break;
        case CBCharacteristicPropertyWriteWithoutResponse:
            cell.writeBtn.hidden = NO;
            break;
            
        default:
            cell.readBtn.hidden = YES;
            cell.writeBtn.hidden = YES;
            cell.notifyBtn.hidden = YES;
            if (character.properties == 0x18) {
                cell.notifyBtn.hidden = NO;
                cell.writeBtn.hidden = NO;
            } else if (character.properties == 0xc) {
                cell.writeBtn.hidden = NO;
            }
            break;
    }
    
    
    return cell;
}


- (NSString *)characterName:(CBCharacteristic *)c {
    NSString *result = @"";
    result = [c.UUID.description containsString:@"String"] ? c.UUID.description : @"Unknown Character";
    if ([c.UUID.UUIDString isEqualToString:DFUCHARACTERUUID]) {
        result = @"DFU Control Point";
    }
    
    return result;
}

- (NSString *)properties:(CBCharacteristicProperties)p notifying:(BOOL)n {
    NSString *result = @"";
    switch (p) {
        case CBCharacteristicPropertyAuthenticatedSignedWrites:
            result = @"Authenticated Signed Writes";
            break;
        case CBCharacteristicPropertyBroadcast:
            result = @"Broadcast";
            break;
        case CBCharacteristicPropertyExtendedProperties:
            result = @"Extended Properties";
            break;
        case CBCharacteristicPropertyIndicate:
            result = @"Indicate";
            break;
        case CBCharacteristicPropertyIndicateEncryptionRequired:
            result = @"Indicate Encryption Required";
            break;
        case CBCharacteristicPropertyNotify:
            result = @"Notify";
            break;
        case CBCharacteristicPropertyNotifyEncryptionRequired:
            result = @"Notify Encryption Required";
            break;
        case CBCharacteristicPropertyRead:
            result = @"Read";
            break;
        case CBCharacteristicPropertyWrite:
            result = @"Write";
            break;
        case CBCharacteristicPropertyWriteWithoutResponse:
            result = @"Write Without Response";
            break;
            
        default:
            result = @"Unknown Properties";
            if (p == 0x18) {
                result = @"Write Notify";
            }
            break;
    }
    if (n) {
        result = [result stringByAppendingString:@" Notify"];
    }
    
    return result;
}



@end
