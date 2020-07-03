//
//  SwitchCell.m
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:1];
    _titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    UISwitch *rightSwitch = [[UISwitch alloc]init];
    _rightSwitch = rightSwitch;
    [rightSwitch addTarget:self action:@selector(onSwith:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:rightSwitch];
    [rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
    }];
}
- (void)onSwith:(UISwitch *)rightSwitch
{
    if (self.switchClick) {
        self.switchClick(self,rightSwitch);
    }
}

@end
