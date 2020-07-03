//
//  TurePayView.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/19.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TurePayView.h"

@implementation TurePayView
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self createUI];
    }
    return self;
}
- (void)createUI{
    UIView *allView = [[UIView alloc]init];
    allView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-64);
    allView.bounds = CGRectMake(0, 0, 250, 160);
    allView.backgroundColor = [UIColor whiteColor];
    self.conView = allView;
    [self addSubview:allView];
    
    allView.layer.cornerRadius = 5;
    allView.clipsToBounds = YES;
    
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"充值金额提示";
    [titleL setTextColor:[UIColor colorWithHexString:@"333333"]];
    titleL.textAlignment = 1;
    self.titleL = titleL;
    [allView addSubview:titleL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.mas_equalTo(self);
    }];
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelBtn setImage:[UIImage imageNamed:@"payViewCancel"] forState:(UIControlStateNormal)];
    //    cancelBtn.backgroundColor = [UIColor redColor];
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 15)];
    [cancelBtn addTarget:self action:@selector(cancelSelf) forControlEvents:(UIControlEventTouchUpInside)];
    [allView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-5);
        make.right.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [allView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleL.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = [UIColor colorWithHexString:@"696969"];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"此次充值   100元";
    self.valueMoneyL = label1;
    [allView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(lineV.mas_bottom).offset(8);
    }];
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor colorWithHexString:@"696969"];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"实际到账   100元";
    self.presentMoneyL = label2;
    [allView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(label1.mas_bottom).offset(16);
    }];
    
    UIView *lineV1 = [[UIView alloc]init];
    lineV1.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [allView addSubview:lineV1];
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(label2.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [payBtn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [payBtn setTitleColor:[UIColor colorWithHexString:@"39d5b8"] forState:(UIControlStateNormal)];
    self.turePay = payBtn;
    [payBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lineV1.mas_bottom).offset(1);
        make.height.mas_equalTo(40);
    }];
    
}
- (void)cancelSelf{
    if (self) {
        [self removeFromSuperview];
    }
}
- (void)onClick{
    [self cancelSelf];
}
- (void)setValueMoney:(NSInteger)valueMoney money:(NSString *)presentMoney addTarget:(id)target action:(SEL)action{
    self.valueMoneyL.text = [NSString stringWithFormat:@"此次充值   %ld元",(long)valueMoney];
    NSString *presentM = [NSString stringWithFormat:@"%@",presentMoney];
    self.presentMoneyL.text = [NSString stringWithFormat:@"实际到账   %@元",presentM];
    NSMutableAttributedString  *attribute = [UtilTool getLableText:self.presentMoneyL.text changeText:presentM Color:[UIColor colorWithHexString:@"39d5b8"] font:15];
    self.presentMoneyL.attributedText = attribute;
    [self.turePay addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.conView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.3f animations:^{
       self.conView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
