//
//  PayKindView.m
//  P-Share
//
//  Created by fay on 16/6/15.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "PayKindView.h"
const float PayKindViewMargin = 18.0f;
@interface PayKindView ()
{
    UILabel *_parkName;
    UILabel *_carNumL;
    UILabel *_upLabel;
    UILabel *_downLabel;
}

@end
@implementation PayKindView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
        
    }
    
    return self;
}

- (void)setUpSubViews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *bgView = [UIView new];
    _bgView = bgView;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}
/**
 PayKindLinTing, //临停支付
 PayKindYueZu,   //月租支付
 PayKindChanQuan,//产权支付
 PayKindNoCar,   //未绑定车辆
 */
- (void)setPayKind:(PayKind)payKind
{
    _payKind = payKind;
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
    
    switch (payKind) {
            
        case PayKindLinTing:
        {
            [self setUpYueZuChanQuanLinTingWithTitle:@"临停"];
        }
            break;
            
        case PayKindYueZu:
        {
            [self setUpYueZuChanQuanLinTingWithTitle:@"月租"];

        }
            break;
            
        case PayKindChanQuan:
        {
            [self setUpYueZuChanQuanLinTingWithTitle:@"产权"];

        }
            break;
            
        case PayKindNoCar:
        {
            [self setNoCarView];
            
        }
            break;
            
        case PayKindNoOrder:
        {
            [self setNoCarView];
            
        }
            break;
        
            
        default:
            break;
    }
}
#pragma mark -- 给界面赋值
- (void)setModel:(OrderModel *)model
{
    _model = model;
    if (_payKind == PayKindLinTing) {
        
        _parkName.text = model.parkingName;
        _carNumL.text = model.carNumber;
        _downLabel.text = [NSString stringWithFormat:@"停车金额:¥%@",model.amountPayable];
        _upLabel.text = [NSString stringWithFormat:@"停车时长:%@",model.parkingTime];
        NSMutableAttributedString *attrStr = [UtilTool getLableText:_upLabel.text changeText:[NSString stringWithFormat:@"%@",model.parkingTime] Color:KMAIN_COLOR font:14];
        _upLabel.attributedText = attrStr;
        
        NSMutableAttributedString *attrStr1 = [UtilTool getLableText:_downLabel.text changeText:[NSString stringWithFormat:@"¥%@",model.amountPayable] Color:KMAIN_COLOR font:14];
        _downLabel.attributedText = attrStr1;
        
    }else{
        _parkName.text = model.parkingName;
        _carNumL.text = model.carNumber;
        _upLabel.text = [NSString stringWithFormat:@"上次缴费:%@",[model.beginDate componentsSeparatedByString:@" "][0]];
        
        _downLabel.text = [NSString stringWithFormat:@"有效期至:%@",[model.endDate componentsSeparatedByString:@" "][0]];
        
        NSMutableAttributedString *attrStr = [UtilTool getLableText:_upLabel.text changeText:[NSString stringWithFormat:@"%@",model.beginDate] Color:KMAIN_COLOR font:14];
        _upLabel.attributedText = attrStr;
        
        NSMutableAttributedString *attrStr1 = [UtilTool getLableText:_downLabel.text changeText:[NSString stringWithFormat:@"%@",model.endDate] Color:KMAIN_COLOR font:14];
        _downLabel.attributedText = attrStr1;

    }

}
- (void)setUpYueZuChanQuanLinTingWithTitle:(NSString *)title
{
    UIImageView *headImage = [UIImageView new];
    headImage.image = [UIImage imageNamed:@"pay_v2"];
    [_bgView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    UILabel *nameL = [UtilTool createLabelFrame:CGRectZero title:title textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    [_bgView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headImage);
        make.top.mas_equalTo(headImage.mas_bottom).offset(4);
        make.width.mas_lessThanOrEqualTo(40);
    }];

   
    
    UILabel *parkName =  [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont boldSystemFontOfSize:16] textAlignment:1 numberOfLine:1];
    _parkName = parkName;
    [_bgView addSubview:parkName];
    [parkName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).offset(14);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/2);
        make.centerY.mas_equalTo(headImage);
    }];
    UILabel *carNumL =  [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:16] textAlignment:1 numberOfLine:1];
    [_bgView addSubview:carNumL];
    _carNumL = carNumL;
  
    
    
    UILabel *upLabel = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:1];
    _upLabel = upLabel;
    [_bgView addSubview:upLabel];
    [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_parkName.mas_leading);
        make.top.mas_equalTo(parkName.mas_bottom).offset(4);
    }];
    UILabel *downLabel = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:1];
    _downLabel = downLabel;
    
    [_bgView addSubview:downLabel];
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(upLabel.mas_leading);
        make.top.mas_equalTo(upLabel.mas_bottom).offset(4);
    }];

    
//    左边支付按钮
    UILabel *rightL = [UILabel new];
    rightL.backgroundColor = [UIColor whiteColor];
    rightL.text = @"立即缴费";
    rightL.textColor = KMAIN_COLOR;
    rightL.textAlignment = 1;
    rightL.font = [UIFont systemFontOfSize:14];
    rightL.layer.cornerRadius = 4;
    rightL.layer.borderColor = KMAIN_COLOR.CGColor;
    rightL.layer.borderWidth = 1;
    rightL.layer.masksToBounds = YES;
    [_bgView addSubview:rightL];
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(_downLabel.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    [carNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightL.mas_right);
        make.width.mas_greaterThanOrEqualTo(rightL.mas_width);
        make.centerY.mas_equalTo(parkName.mas_centerY);
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(downLabel.mas_bottom).offset(8);
    }];
    
}

- (void)setNoCarView
{
    UILabel *noCarL = [UtilTool createLabelFrame:CGRectZero title:@"您未绑定车牌,请绑定后查看" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:12] textAlignment:1 numberOfLine:1];
    noCarL.userInteractionEnabled = YES;
    [_bgView addSubview:noCarL];
    [noCarL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgView);
        make.top.mas_equalTo(PayKindViewMargin);
    }];
    
    UILabel *addCarL = [UtilTool createLabelFrame:CGRectZero title:@"添加车辆" textColor:KMAIN_COLOR font:[UIFont systemFontOfSize:16] textAlignment:1 numberOfLine:1];
    [_bgView addSubview:addCarL];
    addCarL.userInteractionEnabled = YES;

    [addCarL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgView.mas_centerX);
        make.top.mas_equalTo(noCarL.mas_bottom).offset(PayKindViewMargin);
    }];
    
    UIImageView *imageV = [UIImageView new];
    imageV.userInteractionEnabled = YES;

    imageV.image = [UIImage imageNamed:@"add_v2"];
    [_bgView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addCarL.mas_left).offset(-PayKindViewMargin);
        make.centerY.mas_equalTo(addCarL);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(addCarL.mas_bottom).offset(PayKindViewMargin);
    }];
    
    if (_payKind == PayKindNoOrder) {
        noCarL.text = @"您当前无月租、产权车辆";
        noCarL.font = [UIFont systemFontOfSize:13];
        imageV.hidden = YES;
        addCarL.hidden = YES;
        [noCarL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView);

            make.top.mas_equalTo(30);
        }];
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(noCarL.mas_bottom).offset(PayKindViewMargin);
        }];
    }
}


@end
