//
//  NotificationView.m
//  P-Share
//
//  Created by fay on 16/6/14.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "BreakNetWorkAlertV.h"

@implementation BreakNetWorkAlertV

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.backgroundColor = [UIColor colorWithHexString:@"e4f6ff"];
    [self.layer setBorderColor:[UIColor colorWithHexString:@"3eb5f3"].CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 11;
    self.layer.masksToBounds = YES;
    
    UIImageView *leftImage = [UIImageView new];
    [leftImage setImage:[UIImage imageNamed:@"notification_v2"]];
    
    UIImageView *rightImage = [UIImageView new];
    [rightImage setImage:[UIImage imageNamed:@"close_v2"]];
    
    UILabel *titleL = [UILabel new];
    titleL.text = @"网络异常,请检查网络设置。";
    [titleL setTextColor:[UIColor colorWithHexString:@"335a7f"]];;
    titleL.font = [UIFont systemFontOfSize:12];
    [self addSubview:leftImage];
    [self addSubview:rightImage];
    [self addSubview:titleL];

    
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftImage);
        make.left.mas_equalTo(leftImage.mas_right).offset(8);
        make.right.mas_equalTo(rightImage.mas_left).offset(-8);
    }];
    
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftImage);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNotificationView)];
    [self addGestureRecognizer:tapGesture];
    
}
- (void)removeNotificationView
{
    
    if (self.removeNotificationViewBlock) {
        self.removeNotificationViewBlock(self);
    }
    
}
- (void)breakNetWorkAlertVHidden
{
    [self removeFromSuperview];
}
@end
