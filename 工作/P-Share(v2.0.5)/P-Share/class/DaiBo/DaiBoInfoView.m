//
//  DaiBoInfoView.m
//  P-Share
//
//  Created by fay on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaiBoInfoView.h"
#import "UIImageView+WebCache.h"

#define PROGRESS @"progress"
#define Space 0.2
#define LabelGrayColor ([MyUtil colorWithHexString:@"#c8c8c8"])



@implementation DaiBoInfoView
{
    UILabel *_temLabel;
    NSMutableArray *_labelArray;
    NSInteger _orderStatus;
    
    NSInteger _hour;
    NSInteger _day;
    NSInteger _minute;
    NSInteger _seconds;
    
    
}


- (void)awakeFromNib
{
    _daiBoBtn.layer.cornerRadius = 4;
    _daiBoBtn.layer.masksToBounds = 6;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone)];
    _carMasterPhone.userInteractionEnabled = YES;
    [_carMasterPhone addGestureRecognizer:tapGesture];
    
    
}

- (void)callPhone
{
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_carMasterPhone.text]]]];
    
    [self addSubview:callWebview];
}
- (void)setOrderModel:(TemParkingListModel *)orderModel
{
    _orderModel = orderModel;
    
    _carMasterPhone.text = _orderModel.parkerMobile;
    _carMasterNameL.text = [NSString stringWithFormat:@"车管家: %@",_orderModel.parkerName];
    [_carMasterImage sd_setImageWithURL:[NSURL URLWithString:_orderModel.parkerHead] placeholderImage:[UIImage imageNamed:@"valet_pic"]];

    _jieCheTime.text = [NSString stringWithFormat:@"接车时间: %@",_orderModel.orderBeginDate];
    _quCheTime.text =[NSString stringWithFormat:@"预计取车: %@", _orderModel.orderEndDate];

    _moneyL.text = [NSString stringWithFormat:@"目前费用: %@元",_orderModel.amountPaid];
    _orderIdL.text = [NSString stringWithFormat:@"订单号: %@",_orderModel.orderId];
    
    NSMutableAttributedString *mutableStr = [MyUtil getLableText:_moneyL.text changeText:_orderModel.amountPaid Color:NEWMAIN_COLOR font:20];
    _moneyL.attributedText = mutableStr;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    
    if (_orderModel.parkingImagePath != nil && _orderModel.parkingImagePath.length > 0) {
        NSString *totalImagePath = [NSString stringWithFormat:@"%@,%@",_orderModel.validateImagePath,_orderModel.parkingImagePath];
        [imageArray addObjectsFromArray:[totalImagePath componentsSeparatedByString:@","]];
    }else
    {
        
        [imageArray addObjectsFromArray:[_orderModel.validateImagePath componentsSeparatedByString:@","]];
    }
    
    [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
            [imageArray removeObject:imagePath];
        }
        
    }];
    
    self.imageArray = imageArray;
    
    NSInteger state = [orderModel.orderStatus integerValue];
    
//    if (_orderStatus == state) {
//        return;
//    }
    
    _orderStatus = state;
    
    if (state == 14 || state == 15) {
        state = 4;
    }
    
    if (state == 8) {
        state = 9;
    }

    switch (state) {
        case 1:
        {
//             已预约
            self.orderStatue = DAIBOSTATUSAPPOINTMENT;
        }
            break;
            
        case 2:
        {
//            停车中/已接车
            self.orderStatue = DAIBOSTATUSPARKING;
            
            
        }
            break;
            
        case 4:
        {
            [self createTimer];

//            停车完毕/已停车
            self.orderStatue = DAIBOSTATUSPARKEND;
            
            

        }
            break;
            
        case 5:
        {
            [self createTimer];
//          订单完成/已完成
            self.orderStatue = DAIBOSTATUSORDEREND;


        }
            break;
            
        case 9:
        {
//             取车中/待取车
            [self createTimer];

            self.orderStatue = DAIBOSTATUSGETCARING;

        }
            break;
            
        case 12:
        {
//             订单取消/已取消
            self.orderStatue = DAIBOSTATUSCANCEL;

        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark -- 创建定时器
- (void)createTimer
{
    NSString *outTime = [MyUtil intervalSinceNow:_orderModel.actualBeginDate];
    MyLog(@"outTime------%@",outTime);
    
    [self separeteSingleTime:outTime];
    
    if (_timer==nil) {
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTime) userInfo:nil repeats:YES];
    }
}

- (void)setProgressView:(UIProgressView *)progressView
{
    _progressView = progressView;
    [_progressView setValue:@0.0f forKey:PROGRESS];
    [_progressView addObserver:self forKeyPath:PROGRESS options:NSKeyValueObservingOptionNew context:nil];

}
- (void)setTitleLabel0:(UILabel *)titleLabel0
{
    _titleLabel0 = titleLabel0;
    _titleLabel0.textColor = NEWMAIN_COLOR;
    _temLabel = _titleLabel0;
    
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        
        [_progressView removeObserver:self forKeyPath:PROGRESS];
        
    }
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    float spaceX = 16;
    float width = ((SCREEN_WIDTH - 100)-spaceX*4)/3;
    double imageCount = _imageArray.count;
    
    _imageViewScrollView.contentSize = CGSizeMake((spaceX+width)*imageCount+spaceX,0);
    
    for (int i=0; i< imageCount; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        imageView.tag = i;
        [_imageViewScrollView addSubview:imageView];
        imageView.center = CGPointMake(spaceX+(width/2)+(spaceX+width)*i, 47);
        imageView.bounds = CGRectMake(0, 0, width, width);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [imageView addGestureRecognizer:tapGesture];
    }

}



#pragma mark --- 代泊btnClick
- (IBAction)daiBoBtnClick:(id)sender {
    
    
    if (_orderStatue == DAIBOSTATUSAPPOINTMENT) {
        if (self.cancelOrderBlock) {
            self.cancelOrderBlock(_orderModel.orderId);
        }
    }else if (_orderStatue == DAIBOSTATUSPARKEND || _orderStatue == DAIBOSTATUSPARKEND ){
        if (self.getCarBlock) {
            self.getCarBlock(_orderModel.orderId);
        }
    }
    
    _daiBoBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _daiBoBtn.userInteractionEnabled = YES;
    });
}

#pragma mark -- 停止定时器
- (void)stopTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
//    移除scrollView上面的图片
    for (UIImageView *imageV in _imageViewScrollView.subviews) {
        [imageV removeFromSuperview];
        
    }
}
- (void)separeteSingleTime:(NSString *)timeStr
{
    NSRange dayRange = [timeStr rangeOfString:@"天"];
    NSRange hourRange = [timeStr rangeOfString:@"时"];
    NSRange minuteRange = [timeStr rangeOfString:@"分"];
    NSRange secondsRange = [timeStr rangeOfString:@"秒"];

    if ([timeStr rangeOfString:@"天"].location != NSNotFound) {
        _day = [[timeStr substringWithRange:NSMakeRange(0, dayRange.location)] integerValue];
                                                       
        _hour = [[timeStr substringWithRange:NSMakeRange(dayRange.location+1,hourRange.location-dayRange.location-1)] integerValue];
        
        _minute = [[timeStr substringWithRange:NSMakeRange(hourRange.location+1, minuteRange.location-hourRange.location-1)] integerValue];
                                                          
        _seconds = [[timeStr substringWithRange:NSMakeRange(minuteRange.location+1,secondsRange.location-minuteRange.location-1)] integerValue];
        
        self.timeType = TIMETYPEDAY;

    }else if ([timeStr rangeOfString:@"时"].location != NSNotFound) {
        
        _hour = [[timeStr substringWithRange:NSMakeRange(0,hourRange.location)] integerValue];
        
        _minute = [[timeStr substringWithRange:NSMakeRange(hourRange.location+1, minuteRange.location-hourRange.location-1)] integerValue];
        
        _seconds = [[timeStr substringWithRange:NSMakeRange(minuteRange.location+1,secondsRange.location-minuteRange.location-1)] integerValue];
        
        self.timeType = TIMETYPEHOUR;
        
    }else if ([timeStr rangeOfString:@"分"].location != NSNotFound) {
        
        
        _minute = [[timeStr substringWithRange:NSMakeRange(0, minuteRange.location)] integerValue];
        
        _seconds = [[timeStr substringWithRange:NSMakeRange(minuteRange.location+1,secondsRange.location-minuteRange.location-1)] integerValue];
        
        self.timeType = TIMETYPEMINITE;
        
    }else if ([timeStr rangeOfString:@"秒"].location != NSNotFound)
    {
        _seconds = [[timeStr substringWithRange:NSMakeRange(0,secondsRange.location)] integerValue];
        
        self.timeType = TIMETYPESECOND;
        
    }
    
}



#pragma mark ---重写timeType的set方法
- (void)setTimeType:(TIMETYPE)timeType
{
    _timeType = timeType;
    
 
    switch (timeType) {
        case TIMETYPEDAY:
        {
            
            _tingCheTime.text = [NSString stringWithFormat:@"停车时长: %ld天%ld时%ld分%ld秒",(long)_day,(long)_hour,(long)_minute,(long)_seconds];

        }
            break;
            
        case TIMETYPEHOUR:
        {
            _tingCheTime.text = [NSString stringWithFormat:@"停车时长: %ld时%ld分%ld秒",(long)_hour,(long)_minute,(long)_seconds];

        }
            break;
            
        case TIMETYPEMINITE:
        {
            _tingCheTime.text = [NSString stringWithFormat:@"停车时长: %ld分%ld秒",(long)_minute,(long)_seconds];

        }
            break;
            
        case TIMETYPESECOND:
        {
            _tingCheTime.text = [NSString stringWithFormat:@"停车时长: %ld秒",(long)_seconds];
        }
            break;
            
        default:
            break;
    }
   
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_tingCheTime.text];
    NSRange range = NSMakeRange(5, _tingCheTime.text.length-5);
    NSDictionary *dict = @{NSForegroundColorAttributeName:NEWMAIN_COLOR};
    [noteStr addAttributes:dict range:range];
    _tingCheTime.attributedText = noteStr;
    
}
#pragma mark -- 定时器方法
- (void)increaseTime
{
    
    _seconds ++;
    
    self.timeType = _timeType;
    
    if (_seconds >= 60) {
        
        _seconds = 0;
        _minute++;
        if (self.timeType == TIMETYPESECOND) {
            self.timeType = TIMETYPEMINITE;
        }
        
        if (_minute >+ 60) {
            _minute = 0;
            _hour++;
            if (self.timeType == TIMETYPEMINITE) {
                self.timeType = TIMETYPEHOUR;
            }
            
            if (_hour >=24) {
                _hour = 0;
                _day++;
                if (self.timeType == TIMETYPEHOUR) {
                    self.timeType = TIMETYPEDAY;
                }
                
            }
        }
    }
    
    MyLog(@"_seconds -------%ld",(long)_seconds);
    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIProgressView *progressV = (UIProgressView *)object;
    
    if (!_labelArray) {
        NSArray *subViews = [_titleView subviews];
        _labelArray = [NSMutableArray array];
        [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj isKindOfClass:[UILabel class]]){
                [_labelArray addObject:obj];
            }
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _carImageLeading.constant = -(SCREEN_WIDTH-64)*progressV.progress;
        [self layoutIfNeeded];
    }];
    
    _temLabel.textColor = LabelGrayColor;
    for (int i=0; i<_labelArray.count;i++ ) {
        UILabel *lab = _labelArray[i];
        if (SCREEN_WIDTH == 320) {
            lab.font = [UIFont systemFontOfSize:11];
        }
        if (progressV.progress>=Space * i && progressV.progress < Space * (i + 1)) {
            if (lab.tag == i) {
                lab.textColor = NEWMAIN_COLOR;
                _temLabel = lab;
            }
        }
        
    }
    
}

- (void)setOrderStatue:(DAIBOSTATUS)orderStatue
{
    _orderStatue = orderStatue;
    
    switch (orderStatue) {
            
        case DAIBOSTATUSAPPOINTMENT://已预约
        {
//            _titleLabel0.textColor = NEWMAIN_COLOR;
//            _temLabel = _titleLabel0;
            [_progressView setValue:@(0.0f) forKey:PROGRESS];
            _quCheOutTime.hidden = YES;
            _tingCheTime.hidden = YES;
            //－－－－－－－－－－－类型1
            _muQianFeeLayout2.priority = 900;
            _muQianFeeLayout1.priority = 600;
            _muQinFeeLayout0.priority = 700;
            _mainViewHeight.constant = 392 - 56;
            //----------------------
            [_daiBoBtn setTitle:@"取消代泊" forState:(UIControlStateNormal)];
            
        }
            break;
            
        case DAIBOSTATUSPARKING://停车中
        {
            [_progressView setValue:@(0.23f) forKey:PROGRESS];
            _quCheOutTime.hidden = YES;
            _tingCheTime.hidden = YES;
            //------------类型1
            _muQianFeeLayout2.priority = 900;
            _muQianFeeLayout1.priority = 600;
            _muQinFeeLayout0.priority = 700;
            _mainViewHeight.constant = 392 - 56;
            [_daiBoBtn setTitle:@"我要取车" forState:(UIControlStateNormal)];
            //-------------


        }
            break;
            
        case DAIBOSTATUSPARKEND://停车完毕
        {
            [_progressView setValue:@(0.46f) forKey:PROGRESS];
  
            _quCheOutTime.hidden = [self getOutTime];
            _tingCheTime.hidden = NO;//判断是否超出预约时间
            if (!_quCheOutTime.hidden) {
                _mainViewHeight.constant = 362;
                _muQinFeeLayout0.priority = 900;
                _muQianFeeLayout1.priority = 700;
                _muQianFeeLayout2.priority = 600;
                
            }else
            {
                _mainViewHeight.constant = 362 - 28;
                _muQianFeeLayout1.priority = 900;
                _muQianFeeLayout2.priority = 700;
                _muQinFeeLayout0.priority = 600;
            }
            [_daiBoBtn setTitle:@"我要取车" forState:(UIControlStateNormal)];

        }
            break;
            
        case DAIBOSTATUSGETCARING:// 取车中
        {
            [_progressView setValue:@(0.69f) forKey:PROGRESS];

            _carMasterPhone.text = _orderModel.parkerBackMobile;
            _carMasterNameL.text = [NSString stringWithFormat:@"车管家: %@",_orderModel.parkerBackName];
            [_carMasterImage sd_setImageWithURL:[NSURL URLWithString:_orderModel.parkerBackHead] placeholderImage:[UIImage imageNamed:@"valet_pic"]];
            
            _quCheOutTime.hidden = [self getOutTime];
            _tingCheTime.hidden = NO;//判断是否超出预约时间
            if (!_quCheOutTime.hidden) {
                _mainViewHeight.constant = 362;
                _muQinFeeLayout0.priority = 900;
                _muQianFeeLayout1.priority = 700;
                _muQianFeeLayout2.priority = 600;
                
            }else
            {
                _mainViewHeight.constant = 362 - 28;
                _muQianFeeLayout1.priority = 900;
                _muQianFeeLayout2.priority = 700;
                _muQinFeeLayout0.priority = 600;
                
            }

            [_daiBoBtn setTitle:@"已预约取车" forState:(UIControlStateNormal)];

        }
            break;
            
        case DAIBOSTATUSORDEREND://订单完成
        {
            [_progressView setValue:@(0.92f) forKey:PROGRESS];
            [_daiBoBtn setTitle:@"完成支付" forState:(UIControlStateNormal)];
            _daiBoBtn.userInteractionEnabled = NO;
            _mainViewHeight.constant = 362;
            _quCheOutTime.hidden = [self getOutTime];
            _tingCheTime.hidden = NO;//判断是否超出预约时间
            if (!_quCheOutTime.hidden) {
                _mainViewHeight.constant = 362;
                _muQinFeeLayout0.priority = 900;
                _muQianFeeLayout1.priority = 700;
                _muQianFeeLayout2.priority = 600;
                
            }else
            {
                _mainViewHeight.constant = 362 - 28;
                _muQianFeeLayout1.priority = 900;
                _muQianFeeLayout2.priority = 700;
                _muQinFeeLayout0.priority = 600;
                
            }
            [_timer invalidate];
            _timer = nil;
            


        }
            break;
            
            case DAIBOSTATUSCANCEL:
        {
            [_daiBoBtn setTitle:@"订单已取消" forState:(UIControlStateNormal)];
            _mainViewHeight.constant = 392;

        } 
            break;
            
        default:
            break;
    }
}

- (BOOL)getOutTime
{
    NSString *shiCha = [MyUtil intervalSinceNow:_orderModel.orderEndDate];
    if (shiCha.length>0) {
        _quCheOutTime.text = [NSString stringWithFormat:@"目前已超出预约取车时间: %@",shiCha];
        NSMutableAttributedString *mutableStr = [MyUtil getLableText:_quCheOutTime.text changeText:shiCha Color:[MyUtil colorWithHexString:@"f98000"] font:15];
        _quCheOutTime.attributedText = mutableStr;
        return NO;
    }
    
    return YES;

}

#pragma mark -- 图片点击手势
- (void)tapImageAction:(UITapGestureRecognizer *)tapGesture
{

    if (self.tapPictureGestureBlock) {
        self.tapPictureGestureBlock(tapGesture);
        
    }
}



@end
