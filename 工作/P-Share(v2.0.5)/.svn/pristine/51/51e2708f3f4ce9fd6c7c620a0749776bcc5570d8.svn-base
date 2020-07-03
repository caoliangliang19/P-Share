//
//  DaiBoAlertView.m
//  P-Share
//
//  Created by fay on 16/6/30.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaiBoAlertView.h"
@interface DaiBoAlertView()
{
    UIView *_topView;
}
@end

@implementation DaiBoAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupSubView];
        
    }
    
    return self;
}

- (void)setupSubView
{
    [self loadTopView];
    [self loadCenterView];
}
- (void)loadTopView
{
    UIView *topView = [UIView new];
    _topView = topView;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    
    UILabel *title = [MyUtil createLabelFrame:CGRectZero title:@"代泊订单" textColor:[MyUtil colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:18] textAlignment:0 numberOfLine:0];
    
    [topView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.centerY.mas_equalTo(topView.mas_centerY).offset(6);
    }];

    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [topView addSubview:cancelBtn];
    [cancelBtn setImage:[UIImage imageNamed:@"payViewCancel"] forState:(UIControlStateNormal)];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43, 43));
        make.right.top.mas_equalTo(0);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)loadCenterView
{
    UIView *centerView = [UIView new];
    _centerView = centerView;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    
    UIImageView *daiBoImage = [UIImageView new];
    daiBoImage.image = [UIImage imageNamed:@"point_v2.0.1"];
    [centerView addSubview:daiBoImage];
    [daiBoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *daiBoL = [MyUtil createLabelFrame:CGRectZero title:@"代泊车场" textColor: [MyUtil colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    [centerView addSubview:daiBoL];
    [daiBoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(daiBoImage.mas_centerY);
        make.left.mas_equalTo(daiBoImage.mas_right).offset(8);
    }];
    
    UILabel *parkNameL = [MyUtil createLabelFrame:CGRectZero title:@"太阳都市" textColor: [MyUtil colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:2];
    [centerView addSubview:parkNameL];
    
    [parkNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(daiBoImage.mas_centerY);
        make.right.mas_equalTo(-14);
    }];
   
    
    UIImageView *carImage = [UIImageView new];
    carImage.image = [UIImage imageNamed:@"carImage_v2.0.1"];
    [centerView addSubview:carImage];
    [carImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(daiBoImage.mas_bottom).offset(18);
        make.leading.mas_equalTo(daiBoImage.mas_leading);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *carNumL = [MyUtil createLabelFrame:CGRectZero title:@"车牌号码" textColor: [MyUtil colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    [centerView addSubview:carNumL];
    [carNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(carImage.mas_centerY);
        make.leading.mas_equalTo(daiBoL.mas_leading);
    }];
    
    UILabel *carNum = [MyUtil createLabelFrame:CGRectZero title:@"沪A12345" textColor: [MyUtil colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:2];
    [centerView addSubview:carNum];
    [carNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(carImage.mas_centerY);
        make.trailing.mas_equalTo(parkNameL.mas_trailing);
    }];
    
    
    UIImageView *jiaoCheImage = [UIImageView new];
    jiaoCheImage.image = [UIImage imageNamed:@"calendar_v2.0.1"];
    [centerView addSubview:jiaoCheImage];
    [jiaoCheImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(carImage.mas_bottom).offset(18);
        make.leading.mas_equalTo(daiBoImage.mas_leading);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *jiaoCheL = [MyUtil createLabelFrame:CGRectZero title:@"交车时间" textColor: [MyUtil colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    [centerView addSubview:jiaoCheL];
    [jiaoCheL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(jiaoCheImage.mas_centerY);
        make.leading.mas_equalTo(daiBoL.mas_leading);
    }];
    
    UILabel *jiaoCheTime = [MyUtil createLabelFrame:CGRectZero title:@"今日: 17:00" textColor: [MyUtil colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:2];
    [centerView addSubview:jiaoCheTime];
    [jiaoCheTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(jiaoCheImage.mas_centerY);
        make.trailing.mas_equalTo(parkNameL.mas_trailing);
    }];
    
    UIImageView *quCheImage = [UIImageView new];
    quCheImage.image = [UIImage imageNamed:@"getCarImage_v2.0.1"];
    [centerView addSubview:quCheImage];
    [quCheImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jiaoCheImage.mas_bottom).offset(18);
        make.leading.mas_equalTo(daiBoImage.mas_leading);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
   
    UILabel *quCheL = [MyUtil createLabelFrame:CGRectZero title:@"交车时间" textColor: [MyUtil colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    [centerView addSubview:quCheL];
    [quCheL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(quCheImage.mas_centerY);
        make.leading.mas_equalTo(daiBoL.mas_leading);
    }];
    
    UIView *getCarTimeV = [UIView new];
    [centerView addSubview:getCarTimeV];
    getCarTimeV.layer.cornerRadius = 4;
    getCarTimeV.layer.borderWidth = 1;
    getCarTimeV.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    [getCarTimeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(quCheImage.mas_centerY);
        make.height.mas_equalTo(40);
        make.trailing.mas_equalTo(parkNameL.mas_trailing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    UIImageView *leftImage = [UIImageView new];
    leftImage.image = [UIImage imageNamed:@"listRight"];
    [getCarTimeV addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(getCarTimeV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    UILabel *timeL = [MyUtil createLabelFrame:CGRectZero title:@"您要几点取车" textColor: [MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    [centerView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftImage.mas_centerY);
        make.right.mas_equalTo(leftImage.mas_left).offset(-6);
        make.left.mas_equalTo(getCarTimeV.mas_left).offset(6);
    }];
    
    
    
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(getCarTimeV.mas_bottom);
        
    }];


}

@end
