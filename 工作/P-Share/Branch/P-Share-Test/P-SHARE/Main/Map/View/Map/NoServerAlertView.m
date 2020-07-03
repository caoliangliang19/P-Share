//
//  SelfAlertViewTwo.m
//  P-Share
//
//  Created by fay on 16/3/10.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NoServerAlertView.h"

@implementation NoServerAlertView

- (void)setUpSubView
{
    _bgImageView = [[UIImageView alloc] init];
    _mainL = [[UILabel alloc] init];
    _subL = [[UILabel alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"prompt"];
    [self addSubview:_bgImageView];
    
    _mainL.text = @"口袋停服务暂未覆盖到当前位置";
    _subL.text = @"敬请期待";
    
    __weak typeof(self)weakSelf = self;
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:_mainL];
    _mainL.font = [UIFont systemFontOfSize:13];
    [_mainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf).offset(-10);
        
    }];
    
    [self addSubview:_subL];
    _subL.font = [UIFont systemFontOfSize:11];
    _subL.textColor = [UIColor grayColor];
    [_subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf).offset(6);
        
    }];
    
}


@end
