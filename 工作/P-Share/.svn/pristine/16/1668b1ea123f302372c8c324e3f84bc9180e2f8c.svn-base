//
//  BaoYangAlertCell.m
//  P-Share
//
//  Created by fay on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "BaoYangAlertCell.h"

@implementation BaoYangAlertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView
{
    
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"remind"];
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(20);
        make.width.mas_equalTo(133);
        make.height.mas_equalTo(59);
    }];
    
    UILabel *title = [UILabel new];
    title.text = @"想要提醒 完善车型";
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(imageV.mas_bottom).offset(8);
    }];
    
}



@end
