//
//  CYReadAWriteDataViewController.m
//  CYBluetoothManager
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/8.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "CYReadAWriteDataViewController.h"

#import "CYBleManager.h"
#import "CYBleServiceCell.h"
#import "CYCharacteristicsController.h"

#define DFUSERVICEUUID @"8E400001-F315-4F60-9FB8-838830DAEA50"

@interface CYReadAWriteDataViewController ()

@end

@implementation CYReadAWriteDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [CYBleManager manager].services.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYBleServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CYBleServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    CBService *service = [CYBleManager manager].services[indexPath.row];
    
    cell.titleLabel.text = [self serviceName:service];
    cell.UUID.text = service.UUID.UUIDString;
    cell.serviceLevel.text = service.isPrimary ? @"Primary service" : @"Secondary service";
    
    NSString *uuid = service.UUID.UUIDString;
    NSArray *characters = [CYBleManager manager].characters[uuid];
    cell.characters = characters;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.allowsSelection = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toCharacteristics"]) {        
        CYBleServiceCell *cell = (CYBleServiceCell *)sender;
        CYCharacteristicsController *chVc = (CYCharacteristicsController *)[segue destinationViewController];
        chVc.characters = cell.characters;
    }
    
}


- (NSString *)serviceName:(CBService *)service {
    NSString *name = @"";
    
    if ([service.UUID.UUIDString isEqualToString:DFUSERVICEUUID]) {
        name = @"Experimental DFU Service";
    } else if ([service.UUID.description containsString:@"Device Information"]) {
        name = @"Device Information";
    } else {
        name = @"Unknown Service";
    }
    
    return name;
}


@end
