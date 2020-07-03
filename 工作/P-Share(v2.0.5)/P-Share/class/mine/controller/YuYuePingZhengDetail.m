//
//  YuYuePingZhengDetail.m
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "YuYuePingZhengDetail.h"
#import "LBXScanWrapper.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "NewParkingModel.h"

@interface YuYuePingZhengDetail ()
{
    NewParkingModel *_ParkingModel;
    NSString *_appointmentDate1;
    NSString *_appointmentDate2;
    NSString *_appointmentDate3;
    
    NSString *_startTime;
    NSString *_stopTime;
    float _value;
}
@end

@implementation YuYuePingZhengDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    _value = [UIScreen mainScreen].brightness;
    [[UIScreen mainScreen] setBrightness:1.0f];
    //监听home 键是否按下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    if ([MyUtil isBlankString:[NSString stringWithFormat:@"%@",self.pingZhengModel.startEndTime]] == NO) {
        _ParkingModel = [[NewParkingModel alloc]init];
        [_ParkingModel setValuesForKeysWithDictionary:self.pingZhengModel.startEndTime];
    }else{
//        return ;
    }
    
   //未付款，已付款，已取消
    if ([self.type isEqualToString:@"left"]) {
       [self myanimation];
    }else if ([self.type isEqualToString:@"center"]){
        self.imageV.image = [UIImage imageNamed:@"alreadyused"];
    }else if ([self.type isEqualToString:@"right"]){
        self.imageV.image = [UIImage imageNamed:@"expired1"];
    }
    
    [self loadUI];
    
}
- (void)applicationWillResignActive:(NSNotification *)notification

{
    [[UIScreen mainScreen] setBrightness:_value];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
     [[UIScreen mainScreen] setBrightness:1.0f];
}
- (void)loadUI
{
    MyLog(@"%@==",self.pingZhengModel.appointmentDate);
    [self explainRequest];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //停车场名字
    self.parkingNameL.text = self.pingZhengModel.parkingName;
    //车牌号
    self.carNumL.text = self.pingZhengModel.carNumber;
    //时间小时分
//    _hourOneL.text = _pingZhengModel.startTime;
//    _hourTwoL.text = _pingZhengModel.stopTime;
    //停车码
    self.stopCarNumberL.text =[self parking_code:self.pingZhengModel.parkingCode];
     //生成二维码条形码
    UIImage *image1 = nil;
    UIImage *image2 = nil;
    if (self.pingZhengModel.orderId.length>0) {
        
        NSError *error = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:self.pingZhengModel.orderId
                                      format:kBarcodeFormatCode128
                                       width:100
                                      height:50
                                       error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            MyLog(@"%@",image);
            image1 =[UIImage imageWithCGImage:image];
            
        } else {
           NSString *errorMessage = [error localizedDescription];
            MyLog(@"%@",errorMessage);
        }
//    image1 = [LBXScanWrapper createCodeWithString:@"ghgh324424324534" size:CGSizeMake(250, 70) CodeFomart:AVMetadataObjectTypeEAN13Code];
    
    image2 = [LBXScanWrapper createQRWithString:self.pingZhengModel.orderId QRSize:CGSizeMake(124, 124) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    }else{
    image1 = [LBXScanWrapper createCodeWithString:@" " size:CGSizeMake(250, 70) CodeFomart:AVMetadataObjectTypeCode39Code];
        
    image2 = [LBXScanWrapper createQRWithString:@" " QRSize:CGSizeMake(124, 124) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    }
   
   self.barCodeImageV.image = image1;
   self.twoCodeImageV.image = image2;
   
    //时间小时天
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *currnetDate;
    if (_pingZhengModel.appointmentDate.length != 0) {
        NSArray *array = [_pingZhengModel.appointmentDate componentsSeparatedByString:@","];
        NSLog(@"%d===",_pingZhengModel.appointmentDate.length);
        if (array.count == 4) {
            self.layOut1.constant = 10;
            self.layOut2.constant = 10;
            self.layOut3.constant = 10;
            _appointmentDate1 = array[0];
            _appointmentDate2 = array[1];
            _appointmentDate3 = array[2];
            self.dateTwoL.text = _appointmentDate1;
            self.hourOneL.text = _appointmentDate2;
            self.dateOneL.text = _appointmentDate3;
            self.weekdayL1.text = [self dataBecomeWeekday:_appointmentDate1];
            self.weekdayL2.text = [self dataBecomeWeekday:_appointmentDate2];
            self.weekdayL3.text = [self dataBecomeWeekday:_appointmentDate3];
            [self creatTimeL1];
        }else if (array.count == 3){
            self.layOut1.constant = 25;
            self.layOut2.constant = 25;
            self.layOut3.constant = 25;
            _appointmentDate1 = array[0];
            _appointmentDate2 = array[1];
            self.hourOneL.text = _appointmentDate1;
            self.dateOneL.text = _appointmentDate2;
            self.weekdayL2.text = [self dataBecomeWeekday:_appointmentDate1];
            self.weekdayL3.text = [self dataBecomeWeekday:_appointmentDate2];
            [self creatTimeL2];
        }else if (array.count == 2||array.count == 1){
            self.layOut1.constant = 10;
            self.layOut2.constant = 10;
            self.layOut3.constant = 10;
            NSLog(@"%@====",array);
            if (array[0]) {
                 _appointmentDate1 = array[0];
            }
           
            self.hourOneL.text = _appointmentDate1;
            self.weekdayL2.text = [self dataBecomeWeekday:_appointmentDate1];
            [self creatTimeL3];
        }
//        self.dateTwoL.text = _appointmentDate1;
//        self.hourOneL.text = _appointmentDate2;
//        self.dateOneL.text = _appointmentDate3;
        
       currnetDate = [inputFormatter dateFromString:_pingZhengModel.appointmentDate];
        
    }
//   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY/MM/dd"];
//    NSString *currentDateStr = [formatter stringFromDate:currnetDate];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setDay:1];
//    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *mDate = [calender dateByAddingComponents:comps toDate:currnetDate options:0];
//    NSString *nextDateStr = [formatter stringFromDate:mDate];
//    _dateTwoL.text = nextDateStr;
//    _dateOneL.text = currentDateStr;

}
- (void)creatTimeL1{
    NSLog(@"%ld",(long)[@"9:59" integerValue]);
    if ([self.weekdayL1.text isEqualToString:@"周日"]||[self.weekdayL1.text isEqualToString:@"周六"]) {
        [self startAngStopTime:self.weekdayL1.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.hourTwoL.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.hourTwoL.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
        
    }else{
        [self startAngStopTime:self.weekdayL1.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.hourTwoL.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.hourTwoL.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
        
    }
    if ([self.weekdayL2.text isEqualToString:@"周日"]||[self.weekdayL2.text isEqualToString:@"周六"]) {
        [self startAngStopTime:self.weekdayL2.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimerL1.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimerL1.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }else{
         [self startAngStopTime:self.weekdayL2.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimerL1.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimerL1.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }

    }
    if ([self.weekdayL3.text isEqualToString:@"周日"]||[self.weekdayL3.text isEqualToString:@"周六"]) {
        [self startAngStopTime:self.weekdayL3.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimeL2.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimeL2.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }else{
        [self startAngStopTime:self.weekdayL3.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimeL2.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimeL2.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }
}
- (void)creatTimeL2{
    if ([self.weekdayL2.text isEqualToString:@"周日"]||[self.weekdayL2.text isEqualToString:@"周六"]) {
        [self startAngStopTime:self.weekdayL2.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimerL1.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimerL1.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }else{
         [self startAngStopTime:self.weekdayL2.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimerL1.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimerL1.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }
    if ([self.weekdayL3.text isEqualToString:@"周日"]||[self.weekdayL3.text isEqualToString:@"周六"]) {
        [self startAngStopTime:self.weekdayL3.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimeL2.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimeL2.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }else{
        [self startAngStopTime:self.weekdayL3.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimeL2.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimeL2.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }
}
- (void)creatTimeL3{
    if ([self.weekdayL2.text isEqualToString:@"周日"]||[self.weekdayL2.text isEqualToString:@"周六"]) {
        [self startAngStopTime:self.weekdayL2.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimerL1.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimerL1.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }else{
        [self startAngStopTime:self.weekdayL2.text];
        if ([_startTime integerValue] >= [_stopTime integerValue]) {
            self.TimerL1.text = [NSString stringWithFormat:@"%@-次日%@",_startTime,_stopTime];
        }else{
            self.TimerL1.text = [NSString stringWithFormat:@"%@-当日%@",_startTime,_stopTime];
        }
    }
}
- (void)startAngStopTime:(NSString *)weekday{
    
    if ([weekday isEqualToString:@"周一"]) {
        if (self.pingZhengModel.startEndTime) {
            _startTime =_ParkingModel.mondayBeginTime;
            _stopTime = _ParkingModel.mondayEndTime;
        }else{
        _startTime = _pingZhengModel.mondayBeginTime;
        _stopTime = _pingZhengModel.mondayEndTime;
        }
    }else if ([weekday isEqualToString:@"周二"]){
        if (self.pingZhengModel.startEndTime) {
            _startTime = _ParkingModel.tuesdayBeginTime;
            _stopTime = _ParkingModel.tuesdayEndTime;
        }else{
        _startTime = _pingZhengModel.tuesdayBeginTime;
        _stopTime = _pingZhengModel.tuesdayEndTime;
        }
    }else if ([weekday isEqualToString:@"周三"]){
        if (self.pingZhengModel.startEndTime) {
            _startTime = _ParkingModel.wednesdayBeginTime;
            _stopTime = _ParkingModel.wednesdayEndTime;
        }else{
        _startTime = _pingZhengModel.wednesdayBeginTime;
        _stopTime = _pingZhengModel.wednesdayEndTime;
        }
    }else if ([weekday isEqualToString:@"周四"]){
        if (self.pingZhengModel.startEndTime) {
            _startTime = _ParkingModel.thursdayBeginTime;
            _stopTime = _ParkingModel.thursdayEndTime;

        }else{
        _startTime = _pingZhengModel.thursdayBeginTime;
        _stopTime = _pingZhengModel.thursdayEndTime;
        }
    }else if ([weekday isEqualToString:@"周五"]){
        if (self.pingZhengModel.startEndTime) {
            _startTime = _ParkingModel.fridayBeginTime;
            _stopTime = _ParkingModel.fridayEndTime;
        }else{
            _startTime = _pingZhengModel.fridayBeginTime;
            _stopTime = _pingZhengModel.fridayEndTime;
        }
      
    }else if ([weekday isEqualToString:@"周六"]){
        if (self.pingZhengModel.startEndTime) {
            _startTime = _ParkingModel.saturdayBeginTime;
            _stopTime = _ParkingModel.saturdayEndTime;
        }else{
        _startTime = _pingZhengModel.saturdayBeginTime;
        _stopTime = _pingZhengModel.saturdayEndTime;
        }
    }else if ([weekday isEqualToString:@"周日"]){
        if (self.pingZhengModel.startEndTime) {
            _startTime = _ParkingModel.sundayBeginTime;
            _stopTime = _ParkingModel.sundayEndTime;
        }else{
        _startTime = _pingZhengModel.sundayBeginTime;
        _stopTime = _pingZhengModel.sundayEndTime;
        }
    }
    
}
- (NSString *)dataBecomeWeekday:(NSString *)data{
    NSString *weekday = nil;
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    if (data) {
        NSArray *array = [data componentsSeparatedByString:@"-"];
       [comps setDay:[array[2] integerValue]];
       [comps setMonth:[array[1] integerValue]];
       [comps setYear:[array[0] integerValue]];
    }else{
        comps = nil;
    }
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    switch (_weekday) {
        case 1:
            weekday = @"周日";
            break;
        case 2:
            weekday = @"周一";
            break;
        case 3:
            weekday = @"周二";
            break;
        case 4:
            weekday = @"周三";
            break;
        case 5:
            weekday = @"周四";
            break;
        case 6:
            weekday = @"周五";
            break;
        case 7:
            weekday = @"周六";
            break;
            
        default:
            break;
    }
    return weekday;
}
- (void)explainRequest{
//    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",self.pingZhengModel.parkingId,[MyUtil getCustomId],[MyUtil getVersion],MD5_SECRETKEY] MD5];
//    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",parkingInfoDetail,self.pingZhengModel.parkingId,[MyUtil getCustomId],[MyUtil getVersion],summary];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[MyUtil getCustomId],@"customerId",self.pingZhengModel.parkingId,@"parkingId",@"2.0.2",@"version", nil];
    [RequestModel requestPostInvoiceInfoWithURL:parkingInfoDetail WithDic:dict Completion:^(NSDictionary *dict) {
        _ParkingModel = [[NewParkingModel alloc]initWithDic:dict];
        NSString *str =[NSString stringWithFormat:@"%@",_ParkingModel.sharePriceComment];
                if (str.length>0) {
                    self.explaintL.hidden = NO;
                    self.explainL.text = str;
                }else{
                    self.explaintL.hidden = YES;
                    
                }
        
    } Fail:^(NSString *fail) {
        
    }];
//    [RequestModel requstTopUpListAndConsumeListWithURL:parkingInfoDetail type:@"parkingInfoDetail" Completion:^(NSMutableArray *resultArray) {
//         _ParkingModel = resultArray[0];
//        //说明
//        NSString *str =[NSString stringWithFormat:@"%@",_ParkingModel.sharePriceComment];
//        if (str.length>0) {
//            self.explaintL.hidden = NO;
//            self.explainL.text = str;
//        }else{
//            self.explaintL.hidden = YES;
//            
//        }
//    } Fail:^(NSString *error) {
//        
//    }];
//    [RequestModel requestGetParkingListWithURL:urlStr WithTag:@"1" Completion:^(NSMutableArray *resultArray) {
//        
//        _ParkingModel = resultArray[0];
//        //说明
//        NSString *str =[NSString stringWithFormat:@"%@",_ParkingModel.sharePriceComment];
//        if (str.length>0) {
//            self.explaintL.hidden = NO;
//            self.explainL.text = str;
//        }else{
//            self.explaintL.hidden = YES;
//            
//        }
//        
//        
//    } Fail:^(NSString *error) {
//       
//        
//    }];
//    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),customer_id,self.pingZhengModel.parkingId,parking_id, nil];
//    [RequestModel requestGetPhoneNumWithURL:PARKINGDETAIL WithDic:paramDic Completion:^(NSDictionary *dict) {
//        MyLog(@"%@",dict);
//        if ([dict[@"code"] isEqualToString:@"000000"])
//        {
//           
//           
//            //说明
//            NSString *str =[NSString stringWithFormat:@"%@",dict[@"datas"][@"message"][@"sharePriceComment"]];
//            if (str.length>0) {
//                self.explaintL.hidden = NO;
//                 self.explainL.text = str;
//            }else{
//                self.explaintL.hidden = YES;
//                
//            }
//
//           
//            
//        }else{
//            
//         
//           
//        }
//       
//    } Fail:^(NSError *error) {
//    
//        
//        
//    }];
}
//-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
//    
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return scaledImage; //返回的就是已经改变的图片
//}
- (NSString *)getNetDate:(NSString *)date
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [inputFormatter dateFromString:date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:1];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:inputDate options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    return  [formatter stringFromDate:mDate];
    
}



- (void)myanimation{
    NSMutableArray *paidArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        //拼接图片名字
        NSString *name = [NSString stringWithFormat:@"unused_%d.png",i];
        //创建图片
        UIImage *paidImg = [UIImage imageNamed:name];
        //将图片放入数组中
        [paidArr addObject:paidImg];
    }
    
    //动画时间
    _imageV.animationDuration = 0.5 * paidArr.count;
    
    //需要做动画的图片数组
    _imageV.animationImages = paidArr;
    
    //重复次数:0 默认是无穷大
    _imageV.animationRepeatCount = 0;
    
    //开始帧动画
    [_imageV startAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backVC:(id)sender {
    [[UIScreen mainScreen] setBrightness:_value];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSString *)parking_code:(NSString *)parking_code{
    NSString *str = parking_code;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    MyLog(@"%ld",(unsigned long)str.length);
    if (str.length >6) {
        return str;
    }else{
        
        for (int i = 0; i<str.length; i++) {
            unichar an = [str characterAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%c",an];
            if (i == 1) {
                [array addObject:str];
                [array addObject:@"-"];
            }else if (i == 3) {
                [array addObject:str];
                [array addObject:@"-"];
            }else{
                [array addObject:str];
            }
            
        }
        
    }
    
    return [array componentsJoinedByString:@""];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
