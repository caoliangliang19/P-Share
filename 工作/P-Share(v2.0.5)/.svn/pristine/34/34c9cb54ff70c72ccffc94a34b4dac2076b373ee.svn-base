//
//  SuccessView.m
//  P-Share
//
//  Created by fay on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "SuccessView.h"

@implementation SuccessView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        
        __weak typeof(self) weakSelf = self;
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"selected_w"];
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf.mas_width).dividedBy(281/30);
            make.height.mas_equalTo(img.mas_width).dividedBy(30/20);
            make.top.mas_equalTo(40);
//            make.left.mas_equalTo(55);
            make.centerX.mas_equalTo(weakSelf).offset(-60);
        }];
        
        UILabel *successL = [[UILabel alloc]init];
        successL.text = @"添加成功";
        [self addSubview:successL];
        [successL mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(weakSelf);
            make.centerY.mas_equalTo(img);
            
        }];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(weakSelf.mas_centerY).offset(15);
            
        }];

        UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [sureBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
        [sureBtn setTitle:@"确 认" forState:(UIControlStateNormal)];
        [sureBtn addTarget:self action:@selector(sureBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-14);
        }];
        
    }
    return self;
    
}

- (void)sureBtn
{
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
