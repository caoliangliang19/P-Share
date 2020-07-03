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
    
    UILabel *topLeftL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"333333"] font:[UIFont boldSystemFontOfSize:16] textAlignment:1 numberOfLine:1];
//    topLeftL.backgroundColor = [UIColor yellowColor];
    _topLeftL = topLeftL;
    
    UILabel *topRightL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
//    topRightL.backgroundColor = [UIColor redColor];

    _topRightL = topRightL;
    
    UILabel *bottomLeftL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
//    bottomLeftL.backgroundColor = [UIColor greenColor];
    _bottomLeftL = bottomLeftL;
    
    UILabel *bottomRight = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
//    bottomRight.backgroundColor = [UIColor blueColor];
    _bottomRightL = bottomRight;
//    _containV.backgroundColor = [UIColor purpleColor];
    [_containV sd_addSubviews:@[topRightL,_topLeftL,_bottomLeftL,_bottomRightL]];
    
    [self layoutViews];
}
- (void)layoutViews
{
    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
    }];
    
    [_topLeftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(SCREEN_HEIGHT/2);
    }];
    
    [_topRightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topLeftL.mas_right).offset(14);
        make.top.mas_equalTo(_topLeftL.mas_top);
        
    }];
    
    [_bottomLeftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topLeftL.mas_leading);
        make.width.mas_lessThanOrEqualTo(SCREEN_HEIGHT/2);
        make.top.mas_equalTo(_topLeftL.mas_bottom).offset(10);
    }];
    
    [_bottomRightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomLeftL.mas_right).offset(14);
        make.top.mas_equalTo(_bottomLeftL.mas_top);
    }];
}
- (void)setTemModel:(TemParkingListModel *)temModel
{
    _temModel = temModel;
}
- (void)setDataModel:(ParkingModel *)dataModel
{
    _dataModel = dataModel;
    [self reloadYuYueTingChe:dataModel Completion:^(int resultNum, TemParkingListModel *model) {
        
        self.temModel = model;
        
        if (resultNum == 0) {//有可用凭证
            self.status = YuYueViewStatusSuccess;
        }else if (resultNum == 1){//无可用凭证
            self.status = YuYueViewStatusNoOrder;
        }
        
    }];
    [self layoutViews];
    
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
    if ([_dataModel.parkingCanUse intValue]==0 && status != YuYueViewStatusSuccess) {
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
            
            if (![[NSString stringWithFormat:@"%@",_dataModel.parkingCanUse] isEqualToString:@"(null)"]) {
                _bottomRightL.text = [NSString stringWithFormat:@"%@个",_dataModel.parkingCanUse];
                NSAttributedString *aStr = [MyUtil getLableText:_bottomRightL.text changeText:[NSString stringWithFormat:@"%@",_dataModel.parkingCanUse] Color:NEWMAIN_COLOR font:13];
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
            _bottomLeftL.text = [NSString stringWithFormat:@"停车码:%@",[MyUtil parking_code:_temModel.parkingCode]];

        }
            break;
            
        case YuYueViewStatusNoParking:
        {
            _topLeftL.text = _dataModel.parkingName;
            _topRightL.text = _distance;
            _bottomLeftL.text = @"剩余优惠车位数";
            
            _bottomRightL.text = [NSString stringWithFormat:@"预约已满,下次早来哦!"];
            NSAttributedString *aStr = [MyUtil getLableText:_bottomRightL.text changeText:_bottomRightL.text Color:[UIColor redColor] font:13];
            _bottomRightL.attributedText = aStr;
            
                
           
            
        }
            break;
            
        default:
            break;
    }
    
   
    [_containV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bottomLeftL.mas_bottom).offset(0);
    }];
    if (self.statusCompleteBlock) {
        self.statusCompleteBlock(self);
    }
   
    
}

#pragma mark -- 刷新预约停车数据
- (void)reloadYuYueTingChe:(ParkingModel *)model Completion:(void (^)(int resultNum,TemParkingListModel *model))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *carNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carNumber"];
        NewCarModel *carModel = [DataSource shareInstance].carModel;

//        NSAssert(carNum != nil, @"预约停车车牌错误");
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",[MyUtil getCustomId],@"customerId",carModel.carNumber,@"carNumber",model.parkingId,@"parkingId",@"0",@"voucherStatus",@"1",@"pageIndex", nil];
        
        [RequestModel requestDaiBoOrder:queryVoucherPage WithType:@"getPingZheng" WithDic:dic Completion:^(NSArray *dataArray) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                TemParkingListModel *model = dataArray[0];
                
                if (completion) {
                    completion(0,model);
                }
                
            });
            
            
            
        } Fail:^(NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(1,nil);
                }
            });
        }];
        
    });
    
}


@end
