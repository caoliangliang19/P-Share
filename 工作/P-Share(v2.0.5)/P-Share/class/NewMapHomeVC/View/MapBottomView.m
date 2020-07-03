//
//  MapBottomView.m
//  P-Share
//
//  Created by fay on 16/6/14.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MapBottomView.h"

@implementation MapBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    
    return self;
}
- (void)setSubViews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.backgroundColor = [UIColor whiteColor];
    UIView *line = [UIView new];
    line.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *leftImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aroundLive"]];
    [self addSubview:leftImageV];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(22);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    UILabel *titleL = [UILabel new];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.text = @"发现社区更多爱车服务";
    titleL.textAlignment = 1;
    titleL.textColor = [MyUtil colorWithHexString:@"333333"];

    NSAttributedString *attri = [MyUtil getLableText:titleL.text changeText:@"社区" Color:[MyUtil colorWithHexString:@"ff6160"] font:13];
    titleL.attributedText = attri;
    [self addSubview:titleL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(leftImageV.mas_right).offset(22);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listRight"]];
    [self addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_equalTo(-22);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActivityView)];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showActivityView)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:swipeGesture];
}

- (void)showActivityView
{
    if (self.showActivityViewBlock) {
        self.showActivityViewBlock();
    }
}
@end
