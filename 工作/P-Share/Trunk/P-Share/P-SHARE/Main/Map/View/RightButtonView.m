//
//  RightButtonView.m
//  P-SHARE
//
//  Created by fay on 16/8/31.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RightButtonView.h"
@interface RightButtonView()
{
    UILabel *_carNameL;
    
}
@end

@implementation RightButtonView

- (void)setUpSubView
{
    [super setUpSubView];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIButton *carBtn = [UIButton new];
    [carBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    carBtn.tag = 1;
    [carBtn setImage:[UIImage imageNamed:@"car_v2"] forState:(UIControlStateNormal)];
    [self addSubview:carBtn];
    [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    UILabel *carNameL = [UILabel new];
    _carNameL = carNameL;
    _carNameL.textColor = [UIColor colorWithHexString:@"6d7e8c"];
    _carNameL.font = [UIFont systemFontOfSize:10];
    _carNameL.textAlignment = 1;
    _carNameL.text = @"－－";
    [self addSubview:_carNameL];
    [_carNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(carBtn.mas_bottom).offset(-4);
        make.width.mas_lessThanOrEqualTo(36);
        make.centerX.mas_equalTo(carBtn);
    }];
    
    UIButton *homeBtn = [UIButton new];
    [homeBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    homeBtn.tag = 2;
    [homeBtn setImage:[UIImage imageNamed:@"home_v2"] forState:(UIControlStateNormal)];
    [self addSubview:homeBtn];
    [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(carBtn.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.centerX.mas_equalTo(carBtn);
    }];
    
    UIButton *collectionBtn = [UIButton new];
    [collectionBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    collectionBtn.tag = 3;
    [collectionBtn setImage:[UIImage imageNamed:@"shouCang_v2"] forState:(UIControlStateNormal)];
    [self addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeBtn.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(carBtn);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDefaultCar) name:KUSER_CAR_CHANGE object:nil];

    [self loadDefaultCar];
}
- (void)setCar:(Car *)car
{
    _car = car;
    if ([UtilTool isBlankString:car.carNumber]) {
        _carNameL.text = @"－－";
    }else
    {
        MyLog(@"%@",car.carNumber);
        _carNameL.text = [NSString stringWithFormat:@"*%@",[car.carNumber substringWithRange:NSMakeRange(4, car.carNumber.length-4)]];
        

    }
}
- (void)refreshDefaultCar
{
    [self loadDefaultCar];
    
}

- (void)rightBtnClick:(UIButton *)btn
{
    MyLog(@"%ld",btn.tag);
    if (self.rightButtonViewBlock) {
        self.rightButtonViewBlock(btn.tag);
    }
}
#pragma mark --获取用户默认车辆
- (void)loadDefaultCar
{
    NSString *summary = [NSString stringWithFormat:@"%@%@%@",[UtilTool getCustomId],@"2.0.2",SECRET_KEY];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(gaindefaultcar),[UtilTool getCustomId],@"2.0.2",[summary MD5]];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:NO showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        
        Car *car = [Car shareObjectWithDic:responseObject[@"data"]];
        GroupManage *manage = [GroupManage shareGroupManages];
        manage.car = car;
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
