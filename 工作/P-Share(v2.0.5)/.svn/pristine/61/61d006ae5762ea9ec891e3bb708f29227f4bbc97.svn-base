//
//  PayAlertView.m
//  P-Share
//
//  Created by fay on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "PayAlertView.h"

@interface PayAlertView ()
{
    NSString *_money1;
    NSString *_money2;
    
}

@end

@implementation PayAlertView



- (instancetype)initWithFrame:(CGRect)frame WithPayMoney:(NSString *)payMoney ActureMoney:(NSString *)money
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        _money2 = [NSString stringWithFormat:@"%@元",payMoney];
        _money1 = [NSString stringWithFormat:@"%@元",money];
        [self layoutSubviews];
        [self animatedIn];
        
    }
    return self;
}

- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
     __weak typeof(self)weakSelf = self;

    UIView *titleView = [[UIView alloc] init];
    
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(weakSelf.mas_height).multipliedBy(0.24);
    }];
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"充值金额提示";
    [titleL setTextColor:[MyUtil colorWithHexString:@"333333"]];
    titleL.textAlignment = 1;

    [titleView addSubview:titleL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(titleView);
    }];
   
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelBtn setImage:[UIImage imageNamed:@"payViewCancel"] forState:(UIControlStateNormal)];
//    cancelBtn.backgroundColor = [UIColor redColor];
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 15)];
    [cancelBtn addTarget:self action:@selector(cancelSelf) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(titleView).offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [MyUtil colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
   
    UIView *infoView = [[UIView alloc] init];
    [self addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom).offset(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(weakSelf.mas_height).multipliedBy(0.55);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = [MyUtil colorWithHexString:@"696969"];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"实际到账";
    [infoView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(infoView).offset(-40);
        make.centerY.mas_equalTo(infoView).offset(20);
    }];
    
    UILabel *moneyL = [[UILabel alloc]init];
    moneyL.text = _money2;
    moneyL.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attrbutedStr = [[NSMutableAttributedString alloc] initWithString:moneyL.text];
    [attrbutedStr addAttribute:NSForegroundColorAttributeName value:[MyUtil colorWithHexString:@"39d5b8"] range:NSMakeRange(0, attrbutedStr.length-1)];
    
    moneyL.attributedText = attrbutedStr;
    [infoView addSubview:moneyL];
    
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label1);
        make.left.mas_equalTo(label1.mas_right).offset(20);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [MyUtil colorWithHexString:@"696969"];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"此次充值";
    [infoView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(infoView).offset(-40);
        make.centerY.mas_equalTo(infoView).offset(-20);
        
    }];
    UILabel *moneyL1 = [[UILabel alloc]init];
    moneyL1.text = _money1;
    moneyL1.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attrbutedStr1 = [[NSMutableAttributedString alloc] initWithString:moneyL1.text];
    [infoView addSubview:moneyL1];
    [attrbutedStr1 addAttribute:NSForegroundColorAttributeName value:[MyUtil colorWithHexString:@"333333"] range:NSMakeRange(0, attrbutedStr1.length - 1)];
    
    moneyL1.attributedText = attrbutedStr1;
    [moneyL1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label2);

        make.left.mas_equalTo(label2.mas_right).offset(20);
        
    }];


    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [MyUtil colorWithHexString:@"E0E0E0"];
    [infoView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
   
    UIView *btnV = [[UIView alloc]init];
    [self addSubview:btnV];

    [btnV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(infoView.mas_bottom).offset(0);
        
    }];
    
    UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [payBtn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [payBtn setTitleColor:[MyUtil colorWithHexString:@"39d5b8"] forState:(UIControlStateNormal)];
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnV addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(btnV).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

//移除
- (void)cancelSelf
{

    if (self.cancelBlock) {
        self.cancelBlock();
        [self animatedOut];
    }
    
}

//支付
- (void)payClick
{
    if (self.payBlock) {
        self.payBlock();
        [self animatedOut];
    }
}



@end
