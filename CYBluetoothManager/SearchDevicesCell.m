//
//  SearchDevicesCell.m
//  GeneralHealth15
//
//  Created by healthmemac2 on 2017/5/31.
//  Copyright © 2017年 shiyc. All rights reserved.
//

#import "SearchDevicesCell.h"

@implementation SearchDevicesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFirstView];//初始化界面
    }
    return self;
}
-(void)setFirstView{
    _devicesLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 30)];
    [self.contentView addSubview:_devicesLB];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.layer.cornerRadius = 15;
    _selectBtn.layer.masksToBounds = YES;
    _selectBtn.layer.borderWidth = 1;
    _selectBtn.layer.borderColor = [UIColor blueColor].CGColor;
    
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_selectBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 65 - 8, 10, 65, 30)];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_selectBtn];

    // 线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];

}

@end
