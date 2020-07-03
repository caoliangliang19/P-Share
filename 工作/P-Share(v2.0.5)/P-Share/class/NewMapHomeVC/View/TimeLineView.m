//
//  TimeLineView.m
//  P-Share
//
//  Created by fay on 16/6/16.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TimeLineView.h"
#define    rowMargin  14.0f
#define    colMargin  10.0f
@interface TimeLineView ()
{
    UILabel         *_topLeftLabel;
    UILabel         *_toprightLabel;
    UILabel         *_bottomLabel;
    UIImageView     *_centerImageV;
    UIButton        *_bottomRightBtn;
}

@end
@implementation TimeLineView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUpSubViews];
    }
    
    return self;
}

- (void)setUpSubViews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageView *bgImageV = [UIImageView new];
    _bgImageV = bgImageV;
    UIImage *image = [UIImage imageNamed:@"prompt_v2"];
    
    bgImageV.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2 +20];
    MyLog(@"%lf %lf",image.size.height,image.size.width);
    [self addSubview:bgImageV];
    
    UILabel *topLeftLabel = [MyUtil createLabelFrame:CGRectZero title:@"代泊远接单成功" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont boldSystemFontOfSize:15] textAlignment:1 numberOfLine:1];
    _topLeftLabel = topLeftLabel;
    
    UILabel *toprightLabel = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:1];
    _toprightLabel = toprightLabel;
    
    UIImageView *centerImageV = [UIImageView new];
    _centerImageV = centerImageV;
    centerImageV.layer.cornerRadius = 4;
    centerImageV.layer.masksToBounds = YES;
    
    UILabel *bottomLabel = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
    _bottomLabel = bottomLabel;
    
    UIButton *bottomRightBtn = [UIButton new];
    _bottomRightBtn = bottomRightBtn;
    bottomRightBtn.layer.cornerRadius = 4;
    bottomRightBtn.layer.masksToBounds = YES;
    bottomRightBtn.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    bottomRightBtn.layer.borderWidth = 1;
    [bottomRightBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:(UIControlStateNormal)];
    bottomRightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];

    [self addSubview:_topLeftLabel];
    [self addSubview:_toprightLabel];
    [self addSubview:_centerImageV];
    [self addSubview:_bottomLabel];
    [self addSubview:_bottomRightBtn];
    [self setSubViewsLayout];
//    [self upDataLine:model row:row];
}
//- (void)upDataLine:(TemParkingListModel *)model row:(NSInteger)row;{
//    if (row == 0) {
//        _bottomLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",model.parkerName,model.parkerMobile];
//        NSArray *array = [model.createDate componentsSeparatedByString:@" "];
//        _toprightLabel.text = array[1];
//    }else if (row == 1){
//        _bottomLabel.text = [NSString stringWithFormat:@"您的车况图片"];
//    }else if (row == 2){
//        _topLeftLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",model.parkerName,model.parkerMobile];
//        _bottomLabel.text = [NSString stringWithFormat:@"前往%@",model.parkerName];
//    }else if (row == 3){
//        _bottomLabel.text = [NSString stringWithFormat:@"%@",model.parkerName];
//    }
//    _bottomLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",model.parkerName,model.parkerMobile];
//    NSArray *array = [model.createDate componentsSeparatedByString:@" "];
//    _toprightLabel.text = array[1];
//}
//行、列 :Rows, columns,
- (void)setSubViewsLayout
{

    [_topLeftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2 * rowMargin);
        make.top.mas_equalTo(colMargin);
        make.width.mas_lessThanOrEqualTo(self.mas_width).offset(30);
    }];
    
    [_toprightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_topLeftLabel);
        make.right.mas_equalTo(-rowMargin);
        make.width.mas_lessThanOrEqualTo(100);
    }];
   
    
    if (!_centerImageV.hidden) {
        [_centerImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_topLeftLabel.mas_bottom).offset(colMargin);
            make.right.mas_equalTo(-rowMargin);
            make.height.mas_equalTo(_centerImageV.mas_width).multipliedBy(0.42);
        }];
        [_bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_centerImageV.mas_bottom).offset(colMargin);
            
        }];
    }else
    {
        [_bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_topLeftLabel.mas_bottom).offset(colMargin);
        }];
    }
    
    /**
     _bottomRightBtn  不再展示
     */
    [_bottomRightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomLabel.mas_centerY);
        make.right.mas_equalTo(-rowMargin);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
   

  
    
}

/**
 TimeLineDaiBoSatusGetOrder,         //接单成功
 TimeLineDaiBoSatusYanChe,           //代泊远验车(带图片)
 TimeLineDaiBoSatusGoTopark,         //代泊员前往停车场
 TimeLineDaiBoSatusParkSuccess,      //车辆存放成功(带图片)
 TimeLineDaiBoSatusSaveKey,          //钥匙存入密码箱
 fTimeLineDaiBoSatusTimeWillEnd,      //车位服务时间即将结束
 TimeLineDaiBoSatusPayMoney,         //支付代泊费用
 TimeLineDaiBoSatusGetCarOrderSuccess,//取车派单成功
 TimeLineDaiBoSatusGetCaring,        //代泊远取车中
 TimeLineDaiBoSatusGetCarSuccess,    //车辆到达指定位置
 TimeLineDaiBoSatusEnd               //代泊服务结束 (立即评价)
 */
- (void)setTimeLineDaiBoSatus:(TimeLineDaiBoSatus)timeLineDaiBoSatus
{
    if (_timeLinePayStyle != TimeLineViewPayTypeDaiBo) {
        return;
    }
    
    _timeLineDaiBoSatus = timeLineDaiBoSatus;
    _centerImageV.hidden = YES;
    _bottomRightBtn.hidden = YES;
    
    switch (timeLineDaiBoSatus) {
            
        case TimeLineDaiBoSatusGoTopark:
        {
//            去停车
            
            _topLeftLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",_dataModel.parkerName,_dataModel.parkerMobile];
            _bottomLabel.text = [NSString stringWithFormat:@"前往%@停车场",_dataModel.targetParkingName];
            

        }
            break;
            
        case TimeLineDaiBoSatusSaveKey:
        {
            _topLeftLabel.text = @"钥匙已存入“门岗密码箱”";
            _bottomLabel.text = [NSString stringWithFormat:@"编号:%@",_dataModel.keyBox];
        }
            break;
            
//        case TimeLineDaiBoSatusGetCarOrderSuccess:
//        {
//            
//        }
//            break;
//        case TimeLineDaiBoSatusGetCarSuccess:
//        {
//            
//        }
//            break;
            
        case TimeLineDaiBoSatusGetCaring:
        {
            _topLeftLabel.text = @"代泊员取车中";
            _bottomLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",_dataModel.parkerBackName,_dataModel.parkerBackMobile];
        }
            break;
            
        case TimeLineDaiBoSatusYanChe:
        {
            _topLeftLabel.text = @"代泊员验车";
            _centerImageV.hidden = NO;
            
            NSMutableArray *imageArray = [NSMutableArray array];
            [imageArray addObjectsFromArray:[_dataModel.validateImagePath componentsSeparatedByString:@","]];
            [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                    [imageArray removeObject:imagePath];
                }
            }];
            _bottomLabel.text = [NSString stringWithFormat:@"您的车况照片(1/%ld)",(unsigned long)imageArray.count];
            
            [_centerImageV sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultImage_v2"]];

        }
            
            break;
            
        case TimeLineDaiBoSatusParkSuccess:
        {
            _topLeftLabel.text = @"爱车已存放妥当";
            NSMutableArray *imageArray = [NSMutableArray array];
            [imageArray addObjectsFromArray:[_dataModel.parkingImagePath componentsSeparatedByString:@","]];
            [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                    [imageArray removeObject:imagePath];
                }
            }];
            [_centerImageV sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultImage_v2"]];

//            _bottomLabel.text = [NSString stringWithFormat:@"%@====",self.model.parkerHead];
            _centerImageV.hidden = NO;
            _bottomLabel.text = [NSString stringWithFormat:@"%@停车场",_dataModel.targetParkingName];

        }
            
            break;
            
        case TimeLineDaiBoSatusGetOrder:
        {
            _bottomRightBtn.hidden = NO;
            _topLeftLabel.text = @"代泊员接单成功";
            if ([_dataModel.parkerMobile rangeOfString:@"null"].length>0 || _dataModel.parkerMobile == nil) {
                _dataModel.mobile = @"";
            }
            _bottomLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",_dataModel.parkerName,_dataModel.parkerMobile];
            [_bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];

        }
            
            break;
            
        case TimeLineDaiBoSatusTimeWillEnd:
        {
            _bottomRightBtn.hidden = NO;
            _topLeftLabel.text = @"车位服务时间即将结束";
            
            NSString *outTime = [self intervalSinceNow:_dataModel.orderEndDate];
            if ([outTime intValue] > 0 ) {
                _bottomLabel.text = [NSString stringWithFormat:@"还有%@分钟到期!",outTime];

            }else
            {
                _bottomLabel.text = [NSString stringWithFormat:@"取车时间已到期"];

            }

            [_bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];

        }
//
//            break;
//            
//        case TimeLineDaiBoSatusPayMoney:
//        {
//            _bottomRightBtn.hidden = NO;
//            _topLeftLabel.text = @"代泊费用:30元";
//
//            [_bottomRightBtn setTitle:@"立即支付" forState:(UIControlStateNormal)];
//
//        }
            
            break;
            
        case TimeLineDaiBoSatusEnd:
        {
            _bottomRightBtn.hidden = NO;
            [_bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];
            _topLeftLabel.text = @"服务已顺利结束";
            _bottomLabel.text = @"任何建议与吐槽我们都竭诚欢迎";

        }
            
            break;
            
        default:
        {
            
        }
            break;
    }
    
   if (!_centerImageV.hidden) {
       [_centerImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_topLeftLabel.mas_bottom).offset(colMargin);
            make.right.mas_equalTo(-rowMargin);
            make.height.mas_equalTo(_centerImageV.mas_width).multipliedBy(0.42);
        }];
        [_bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_centerImageV.mas_bottom).offset(colMargin);
            
        }];
    }else
    {
        [_bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_topLeftLabel.mas_bottom).offset(colMargin);
        }];
    }
    
    
    
    [_bottomRightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomLabel.mas_centerY);
        make.right.mas_equalTo(-rowMargin);
        make.size.mas_equalTo(CGSizeMake(0,0));
    }];
    

    [_bgImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);

        make.top.left.right.mas_equalTo(0);
        
        make.bottom.mas_equalTo(_bottomLabel.mas_bottom).offset(10);
    }];

    [self layoutSubviews];
    [_bgImageV layoutIfNeeded];
    
    MyLog(@"+_bgImageV.frame.size.height+++++++%lf",_bgImageV.frame.size.height);
    
}



- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
//    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@", timeString];
        
//    }
//    if (cha/3600>1&&cha/86400<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@小时", timeString];
//    }
//    if (cha/86400>1)
//    {
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@天", timeString];
//        
//    }
    return timeString;
}

/**
 TimeLineYuYueSatusStart,//开始预约
 TimeLineYuYueSatusYuYueSuccess,//预约成功
 TimeLineYuYueSatusPingZhengInPark,//凭证入场
 TimeLineYuYueSatusTimeWillEnd,//时间即将结束
 TimeLineYuYueSatusPingZhengOutPark,//凭证出场
 TimeLineYuYueSatusEnd//服务结束 (立即评价)
 */
- (void)setTimeLineYuYueSatus:(TimeLineYuYueSatus)timeLineYuYueSatus
{
    if (_timeLinePayStyle != TimeLineViewPayTypeYuYueParking) {
        return;
    }
    _timeLineYuYueSatus = timeLineYuYueSatus;
    _bottomRightBtn.hidden = YES;
    switch (timeLineYuYueSatus) {
        case TimeLineYuYueSatusStart:
        {
            _topLeftLabel.text = @"预约昼锦路停车场车位";
            _toprightLabel.text = @"";
            _bottomLabel.hidden = YES;
            
        }
            break;
            
        case TimeLineYuYueSatusYuYueSuccess:
        {
            _topLeftLabel.text = @"预约车位成功";
            NSString *parkCode = [MyUtil parking_code:_parkCode];
            _bottomLabel.text =  [NSString stringWithFormat:@"停车码:%@",parkCode];
            _toprightLabel.text = @"";
            _bottomRightBtn.hidden = NO;
            _bottomLabel.hidden = NO;
            [_bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];

        }
            break;
            
        case TimeLineYuYueSatusPingZhengInPark:
        {
            _topLeftLabel.text = @"凭证入场确认";
            _toprightLabel.text = @"";
            _bottomLabel.hidden = YES;

        }
            break;
            
        case TimeLineYuYueSatusTimeWillEnd:
        {
            _topLeftLabel.text = @"停车时间将于9:00结束";
            _bottomLabel.text = @"还有30分钟到期";
            _toprightLabel.text = @"";
            _bottomRightBtn.hidden = NO;
            _bottomLabel.hidden = NO;

            [_bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];
        }
            break;
            
        case TimeLineYuYueSatusPingZhengOutPark:
        {
            _topLeftLabel.text = @"凭证出场确认";
            _toprightLabel.text = @"";
            _bottomLabel.hidden = YES;

        }
            break;
            
        case TimeLineYuYueSatusEnd:
        {
            _topLeftLabel.text = @"服务已顺利结束";
            _bottomLabel.text = @"任何建议与吐槽我们都竭诚欢迎";
            _toprightLabel.text = @"";
            _bottomRightBtn.hidden = NO;
            _bottomLabel.hidden = NO;

            [_bottomRightBtn setTitle:@"" forState:(UIControlStateNormal)];
            
        }
            break;
        default:
            break;
    }
    
    if (_bottomLabel.hidden) {
        [_toprightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
        }];
        
    }else
    {
        [_toprightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
        }];
        [_bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_topLeftLabel.mas_leading);
            make.top.mas_equalTo(_topLeftLabel.mas_bottom).offset(colMargin);
        }];
        
        [_bottomRightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomLabel.mas_centerY);
            make.right.mas_equalTo(-rowMargin);
            make.size.mas_equalTo(CGSizeMake(0,0));
        }];
    }

    
    [_bgImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    
}
- (void)setTimeLinePayStyle:(TimeLineViewPayType)timeLinePayStyle
{
    _timeLinePayStyle = timeLinePayStyle;
    
}
@end
