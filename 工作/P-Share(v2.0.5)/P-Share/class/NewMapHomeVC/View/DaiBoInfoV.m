//
//  DaiBoInfoV.m
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaiBoInfoV.h"
@interface DaiBoInfoV()
{
    UILabel         *_bottomL;//下方label
    UIImageView     *_carPhoto;//车图片
    UIButton        *_greenBtn;
}
@end
@implementation DaiBoInfoV

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews
{
    UIView *containV = [UIView new];
    _containV = containV;
//    containV.backgroundColor = [UIColor purpleColor];
    [self addSubview:_containV];
    
    UILabel *topL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"333333"] font:[UIFont boldSystemFontOfSize:16] textAlignment:0 numberOfLine:1];
//    topL.backgroundColor = [UIColor greenColor];
    _topL = topL;
    
    UILabel *bottomL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:0];
//    bottomL.backgroundColor = [UIColor yellowColor];
    _bottomL = bottomL;
    
    UIImageView *carPhoto = [UIImageView new];
    carPhoto.layer.cornerRadius = 4;
    carPhoto.layer.masksToBounds =YES;
    _carPhoto = carPhoto;
    
    UIButton *greenBtn = [UIButton new];
    [self addSubview:greenBtn];
    _greenBtn = greenBtn;
    greenBtn.backgroundColor = NEWMAIN_COLOR;
    greenBtn.titleLabel.textColor = [UIColor whiteColor];
    greenBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    [containV sd_addSubviews:@[topL,bottomL,carPhoto,greenBtn]];
    [self layoutViews];
    
}
- (void)layoutViews
{
    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    
    [_topL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(self.mas_width);
    }];
    
    [_bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topL.mas_left);
        make.top.mas_equalTo(_topL.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo(self.mas_width);
    }];
    
    [_carPhoto mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topL.mas_leading);
        make.top.mas_equalTo(_topL.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(186, 72));
    }];
    
}
//停车场模型
- (void)setDataModel:(ParkingModel *)dataModel
{
    _dataModel = dataModel;
    [self reloadDaiBoDataWithParkingModel:dataModel];
}

//订单模型
- (void)setTemModel:(TemParkingListModel *)temModel
{
    _temModel = temModel;
    NSInteger state = [temModel.orderStatus integerValue];
    
    if (state == 1) {
        self.status = DaiBoInfoVStatusGetOrder;
    }else if ( state == 2 ) {
        
        if (temModel.parkingImagePath.length > 4 || temModel.validateImagePath.length >4 ) {
            self.status = DaiBoInfoVStatusShowCarPhoto;
        }else
        {
            self.status = DaiBoInfoVStatusParking;
            
        }
    }else if (state == 4 ){
        if (temModel.keyBox.length > 0) {
            self.status = DaiBoInfoVStatusSaveKey;
        }else
        {
            self.status = DaiBoInfoVStatusParkEnd;
        }
    }else if (state == 14 || state == 15) {
        self.status = DaiBoInfoVStatusTimeNotification;
    }else if (state == 8 || state == 9){
        self.status = DaiBoInfoVStatusGetCaring;
        
    }else if (state == 5){
        self.status = DaiBoInfoVStatusGetCarEnd;
    }else
    {
        self.status = DaiBoInfoVStatusNoCheWei;
    }
    
   
}
#pragma mark -- 刷新最新的代泊数据
- (void)reloadDaiBoDataWithParkingModel:(ParkingModel *)parkingModel
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *carNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carNumber"];
        NewCarModel *carModel = [DataSource shareInstance].carModel;
        
        
//        NSAssert(carNum != nil, @"代泊车牌错误");
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",[MyUtil getCustomId],@"customerId",carModel.carNumber,@"carNumber",parkingModel.parkingId,@"parkingId", nil];
        
        [RequestModel requestDaiBoOrder:queryParkerById WithType:@"getOrder" WithDic:dic Completion:^(NSArray *dataArray) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataArray.count>0) {
                    TemParkingListModel *model = [dataArray objectAtIndex:0];
                    self.temModel = model;
                }else
                {
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:parkingModel.parkingId,@"parkingId",@"2.0.0",@"version", nil];
                    
//                    查询代泊紧张
                    
                    
                    [self getBubbleInfoWith:parkingModel Completion:^(ParkingModel *newParkModel) {
                        
                        if ([newParkModel.statusInfo isEqualToString:@"空"]) {
                            [RequestModel requestDaiBoOrder:tenseTime WithType:@"getDaiBoTime" WithDic:dic Completion:^(NSArray *dataArray) {
                                
                                MyLog(@"DaiBoInfoVStatusHomeNoCheWei");
                                TemParkingListModel *model = [dataArray objectAtIndex:0];
                                _temModel= model;
                                self.status = DaiBoInfoVStatusHomeNoCheWei;
                                
                            } Fail:^(NSString *error) {
                                
                                MyLog(@"DaiBoInfoVStatusNoCheWei");
                                
                                self.status = DaiBoInfoVStatusNoCheWei;
                            }];
                            
                        }else
                        {
                            self.status = DaiBoInfoVStatusNoCheWei;

                        }

                        
                    }];
                }
            });
        } Fail:^(NSString *error) {
            
            [self getBubbleInfoWith:parkingModel Completion:^(ParkingModel *newParkModel) {
                
                if ([newParkModel.statusInfo isEqualToString:@"空"]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:parkingModel.parkingId,@"parkingId",@"2.0.0",@"version", nil];

                    [RequestModel requestDaiBoOrder:tenseTime WithType:@"getDaiBoTime" WithDic:dic Completion:^(NSArray *dataArray) {
                        
                        MyLog(@"DaiBoInfoVStatusHomeNoCheWei");
                        TemParkingListModel *model = [dataArray objectAtIndex:0];
                        _temModel= model;
                        self.status = DaiBoInfoVStatusHomeNoCheWei;
                        
                    } Fail:^(NSString *error) {
                        
                        MyLog(@"DaiBoInfoVStatusNoCheWei");
                        
                        self.status = DaiBoInfoVStatusNoCheWei;
                    }];
                    
                }else
                {
                    self.status = DaiBoInfoVStatusNoCheWei;
                    
                }
                
                
            }];
        }];
        
    });
    
}

#pragma mark -- 获取气泡内容
- (void)getBubbleInfoWith:(ParkingModel *)parkModel Completion:(void (^)(ParkingModel*newParkModel))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:parkModel.parkingId,@"parkingId",@"2.0.0",@"version", nil];
        NSString *url = [NSString stringWithFormat:@"%@",getParkingStatus];
        [RequestModel requestGetParkingStatusWith:url WithDic:dict Completion:^(ParkingModel *model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(model);
                }
            });
            
        } Fail:^(NSString *error) {
            
        }];
    });
    
    
}
/**
 DaiBoInfoVStatusNoCheWei,           //没有车位
 DaiBoInfoVStatusGetOrder,           //接单成功
 DaiBoInfoVStatusShowCarPhoto,       //展示车辆照片
 DaiBoInfoVStatusParking,            //停车中
 DaiBoInfoVStatusParkEnd,            //停车完成
 DaiBoInfoVStatusSaveKey,            //存钥匙
 DaiBoInfoVStatusTimeNotification,   //时间提醒
 DaiBoInfoVStatusGetCaring,          //取车中
 DaiBoInfoVStatusGetCarEnd,          //取车完成
 */
/**
 UILabel         *_topL;//上方label
 UILabel         *_bottomL;//下方label
 UIImageView     *_carPhoto;//车图片
 */

#pragma mark -- 设置样式并且赋值
- (void)setStatus:(DaiBoInfoVStatus)status
{
    _status = status;
    if (self.statusCompleteBlock) {
        self.statusCompleteBlock(self);
        
    }
    _carPhoto.hidden = YES;
    switch (status) {
        case DaiBoInfoVStatusHomeNoCheWei:
        {
            _topL.text = [NSString stringWithFormat:@"亲,预计%@开始紧张",_temModel.data];
            NSAttributedString *aAttr = [MyUtil getLableText:_topL.text changeText:_temModel.data Color:[MyUtil colorWithHexString:@"ff6160"] font:16];
            _topL.attributedText = aAttr;
            _bottomL.text = @"您可以选择代泊服务,\n也可以去周边停车场自停哦!";
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"blueAnnotationLittle_v2"];
            attch.bounds = CGRectMake(0, 0, 20, 20);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:_bottomL.text];
            [attriStr insertAttributedString:string atIndex:20];
            _bottomL.numberOfLines = 0;
            _bottomL.attributedText = attriStr;
        }
            break;

            
        case DaiBoInfoVStatusNoCheWei:
        {
            _topL.text = @"亲,目前停车位紧张";
            _bottomL.text = @"您可以选择代泊服务,\n也可以去周边停车场自停哦!";
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"blueAnnotationLittle_v2"];
            attch.bounds = CGRectMake(0, 0, 20, 20);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:_bottomL.text];
            [attriStr insertAttributedString:string atIndex:20];
            _bottomL.numberOfLines = 0;
            _bottomL.attributedText = attriStr;
        }
            break;
            
        case DaiBoInfoVStatusGetOrder:
        {
            _topL.text =@"代泊员接单成功";
            if ([_temModel.parkerMobile rangeOfString:@"null"].length>0 || _temModel.parkerMobile == nil) {
                _temModel.parkerMobile = @"";
            }
            _bottomL.numberOfLines = 0;
            _bottomL.text = [NSString stringWithFormat:@"代泊员:%@\n%@",_temModel.parkerName,_temModel.parkerMobile];

        }
            break;
            
        case DaiBoInfoVStatusShowCarPhoto:
        {
            NSString *totalImagePath = [NSString stringWithFormat:@"%@,%@",_temModel.validateImagePath,_temModel.parkingImagePath];
            NSMutableArray *imageArray = [NSMutableArray array];
            [imageArray addObjectsFromArray:[totalImagePath componentsSeparatedByString:@","]];
            [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                    [imageArray removeObject:imagePath];
                }
            }];
            _topL.text = [NSString stringWithFormat:@"您的车况照片(1/%ld)",(unsigned long)imageArray.count];
            _carPhoto.hidden = NO;
            _bottomL.text = @"";
            [_carPhoto sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultImage_v2"]];

        }
            break;
            
        case DaiBoInfoVStatusParking:
        {
            _topL.text = @"代泊员停车中";
            if ([_temModel.parkerMobile rangeOfString:@"null"].length>0 || _temModel.parkerMobile == nil) {
                _temModel.parkerMobile = @"";
            }
            _bottomL.numberOfLines = 0;
            _bottomL.text = [NSString stringWithFormat:@"代泊员:%@\n%@",_temModel.parkerName,_temModel.parkerMobile];
        }
            break;
            
        case DaiBoInfoVStatusParkEnd:
        {
            _topL.text = @"停车完成";
            _bottomL.text = [NSString stringWithFormat:@"位置:%@",_dataModel.parkingName];

        }
            break;
            
        case DaiBoInfoVStatusSaveKey:
        {
            _topL.text = @"钥匙已存入“门岗密码箱”";
            _bottomL.text = [NSString stringWithFormat:@"编号:%@",_temModel.keyBox];

        }
            break;
            
        case DaiBoInfoVStatusTimeNotification:
        {
            NSArray *temArray = [_temModel.orderEndDate componentsSeparatedByString:@" "];
            NSString *outTime = [self intervalSinceNow:_temModel.orderEndDate];
            MyLog(@"%@",outTime);
            NSArray *timeArr = [temArray[1] componentsSeparatedByString:@":"];
            NSArray *outTimeArr = [outTime componentsSeparatedByString:@"分钟"];
            if ([outTimeArr[0] intValue]>0) {
                _topL.text = [NSString stringWithFormat:@"您的车辆将于%@:%@代泊回指定地点,还有%@到期!",timeArr[0],timeArr[1],outTime];
            }else
            {
                _topL.text = [NSString stringWithFormat:@"您的车辆将于%@:%@代泊回指定地点,时间已到期!",timeArr[0],timeArr[1]];
            }
            NSAttributedString *attrStr = [MyUtil getLableText:_topL.text changeText:outTime Color:NEWMAIN_COLOR font:16];
            _bottomL.text = @"";
            _topL.numberOfLines = 0;
            _topL.attributedText = attrStr;
        }
            break;
            
        case DaiBoInfoVStatusGetCaring:
        {
            _topL.text = @"代泊员取车中";
            if ([_temModel.parkerBackMobile rangeOfString:@"null"].length>0 || _temModel.parkerBackMobile == nil) {
                _temModel.mobile = @"";
            }
            _bottomL.text = [NSString stringWithFormat:@"代泊员:%@\n%@",_temModel.parkerBackName,_temModel.parkerBackMobile];
        }
            break;
            
        case DaiBoInfoVStatusGetCarEnd:
        {
            _topL.text = @"您的爱车已到达交车位置";
            _bottomL.text = @"本次服务已顺利结束";
        }
            break;
            
        default:
            break;
    }
    
    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
       
        if (_carPhoto.hidden) {
            make.bottom.mas_equalTo(_bottomL.mas_bottom);
        }else
        {
            make.bottom.mas_equalTo(_carPhoto.mas_bottom).offset(0);
        }
    }];
    [_containV layoutIfNeeded];
    MyLog(@"%lf  %lf",_containV.frame.size.width,_containV.frame.size.height);

    
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
    timeString=[NSString stringWithFormat:@"%@分钟", timeString];
    
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


@end
