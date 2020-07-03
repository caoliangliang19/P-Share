//
//  YuYueView.m
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YuYueView.h"
@interface YuYueView()
{
    UILabel *_topLeftL;
    UILabel *_topRightL;
    UILabel *_bottomLeftL;
 
}

@end


@implementation YuYueView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}
- (void)setUpViews
{
    UIView *conatinV = [UIView new];
    _containV = conatinV;
    [self addSubview:conatinV];
    
    UILabel *topLeftL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont boldSystemFontOfSize:16] textAlignment:1 numberOfLine:1];
    _topLeftL = topLeftL;
    
    UILabel *topRightL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _topRightL = topRightL;
    
    UILabel *bottomLeftL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _bottomLeftL = bottomLeftL;
    
    UILabel *bottomRight = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _bottomRightL = bottomRight;
    [_containV addSubview:_topRightL];
    [_containV addSubview:_topLeftL];
    [_containV addSubview:_bottomLeftL];
    [_containV addSubview:_bottomRightL];

    [self layoutViews];
}
- (void)layoutViews
{
    
    _topLeftL.mas_key = @"yuyueView.topLeftL";
    [_topLeftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(6);
        make.width.mas_lessThanOrEqualTo(SCREEN_HEIGHT/2);
    }];
    _topRightL.mas_key = @"yuyueView.topRightL";

    [_topRightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topLeftL.mas_right).offset(14);
        make.top.mas_equalTo(_topLeftL.mas_top);
        
    }];
    _bottomLeftL.mas_key = @"yuyueView.bottomLeftL";

    [_bottomLeftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topLeftL.mas_leading);
        make.width.mas_lessThanOrEqualTo(SCREEN_HEIGHT/2);
        make.top.mas_equalTo(_topLeftL.mas_bottom).offset(6);
    }];
    _bottomRightL.mas_key = @"yuyueView.bottomRightL";

    [_bottomRightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomLeftL.mas_right).offset(14);
        make.top.mas_equalTo(_bottomLeftL.mas_top);
    }];
    _containV.mas_key = @"yuyueView.containV";

    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_bottomLeftL.mas_bottom).offset(0);
    }];
}

/**
 YuYueViewStatusNoOrder,             //没有订单
 YuYueViewStatusSuccess,             //预约成功
 YuYueViewStatusCarInPark,           //车辆入场
 YuYueViewStatusTimeNotification,    //时间提醒
 YuYueViewStatusEnd                  //服务结束
 */
- (void)setStatus:(YuYueViewStatus)status
{
    _status = status;
    if (_dataModel.parkingCanUse ==0 && status != YuYueViewStatusSuccess) {
        _status = YuYueViewStatusNoParking;
    }
    
    _topLeftL.hidden = NO;
    _topRightL.hidden = NO;
    _bottomLeftL.hidden = NO;
    _bottomRightL.hidden = NO;
    
    switch (_status) {
        case YuYueViewStatusNoOrder:
        {
            _topLeftL.text = _dataModel.parkingName;
            _topRightL.text = _distance;
            _bottomLeftL.text = @"剩余优惠车位数";
            
            if (![[NSString stringWithFormat:@"%ld",_dataModel.parkingCanUse] isEqualToString:@"(null)"]) {
                
                _bottomRightL.text = [NSString stringWithFormat:@"%ld个",_dataModel.parkingCanUse];
                NSAttributedString *aStr = [UtilTool getLableText:_bottomRightL.text changeText:[NSString stringWithFormat:@"%ld",_dataModel.parkingCanUse] Color:KMAIN_COLOR font:14];
                
                _bottomRightL.attributedText = aStr;
                
            }else
            {
                _bottomRightL.text = @"";
            }

        }
            break;
            
        case YuYueViewStatusSuccess:
        {
            _topRightL.hidden = YES;
            _bottomRightL.hidden = YES;
            _topLeftL.text = @"预约车位成功";
            _bottomLeftL.text = [NSString stringWithFormat:@"停车码:%@",[UtilTool separateParkingCode:_temModel.parkingCode]];
            

        }
            break;
            
        case YuYueViewStatusNoParking:
        {
            _topLeftL.text = _dataModel.parkingName;
            _topRightL.text = _distance;
            _bottomLeftL.text = @"剩余优惠车位数";
            
            _bottomRightL.text = [NSString stringWithFormat:@"预约已满,下次早来哦!"];
            NSAttributedString *aStr = [UtilTool getLableText:_bottomRightL.text changeText:_bottomRightL.text Color:[UIColor redColor] font:13];
            _bottomRightL.attributedText = aStr;
            
        }
            break;
            
        default:
            break;
    }
   
   
    if (self.statusCompleteBlock) {
        self.statusCompleteBlock(self);
    }
   
}




@end
