//
//  ChooseCheXing.m
//  P-Share
//
//  Created by fay on 16/4/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ChooseCheXing.h"
#import "MHDatePicker.h"
#import "ClearCarPay.h"
#import "FullAlert.h"

#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
@interface ChooseCheXing()<UITextFieldDelegate,CLLocationManagerDelegate>
{
    NSString *_chooseCar;
    UIButton *_temBtn;
    NSString *_reserveMoney;
    NSString *_carType;
    NSDictionary *_carDic;
    NSDictionary *_busyCarDic;
    NSString *_parkId;
    
    NSMutableArray *_dataArray;
    CLLocationManager *_cllManager;
    CGFloat _myLatitude;
    CGFloat _myLongitude;
    NSString *_minuteDistance;
    
    NSInteger _tureIndex;
    
    UIAlertView *_alert;
    
    __weak IBOutlet UIButton *btn2;
    
    __weak IBOutlet UIButton *btn1;
}
@property (strong, nonatomic) MHDatePicker *selectDatePicker;
@property (strong, nonatomic) UIViewController *controller;
@property (nonatomic,strong) UIView *bgView;
@end
@implementation ChooseCheXing
- (instancetype)initWithController:(UIViewController *)controller;{
    if (self = [super init]) {
        
        self =  [[NSBundle mainBundle] loadNibNamed:@"ChooseCheXing" owner:nil options:nil][0];
       
        _tureIndex = 1;
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, 280, 394);
        self.controller = controller;
        [controller.view addSubview:self.bgView];
        
        [controller.view addSubview:self];
       }
    return self;
}
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        _bgView.hidden =YES;
        
    }
    
    return _bgView;
    
}
- (void)getLocationAndPushAndMob
{
    
    _cllManager = [[CLLocationManager alloc] init];
    _cllManager.distanceFilter = kCLDistanceFilterNone;
    _cllManager.desiredAccuracy = kCLLocationAccuracyBest;
    _cllManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [_cllManager requestWhenInUseAuthorization];
    }
    [_cllManager startUpdatingLocation];
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    _myLatitude = location.coordinate.latitude;
    _myLongitude = location.coordinate.longitude;
    //    保存用户坐标到单例
    _carType = @"1";
    [self netWorkingRequest];
    [_cllManager stopUpdatingLocation];
    
    
}
- (void)creteUI{
    if ([_carType integerValue] == 1) {
        //        轿车
        _chooseCar = @"轿车";
        _reserveMoney = [NSString stringWithFormat:@"%d",[_carDic[@"srvPrice"] integerValue]+[_carDic[@"nowPrice"]integerValue]];
       
        
        
    }else
    {
        //        商务车
        _chooseCar = @"商务车";
        _reserveMoney = [NSString stringWithFormat:@"%d",[_busyCarDic[@"srvPrice"] integerValue]+[_busyCarDic[@"nowPrice"]integerValue]];
        
    }
//    _chooseCar = @"轿车";
//    _reserveMoney = [NSString stringWithFormat:@"%ld",[_carDic[@"srvPrice"] integerValue]+[_carDic[@"nowPrice"]integerValue]];
//    _carType = @"1";
 
  self.parkingName.text =_carDic[@"parkingName"];
  self.washCarMoneyL.text = [NSString stringWithFormat:@"%@元",_reserveMoney];
    NSMutableAttributedString *attributedString = [MyUtil getLableText:self.washCarMoneyL.text changeText:_reserveMoney Color:[MyUtil colorWithHexString:@"FD913A"] font:20];
    self.washCarMoneyL.attributedText = attributedString;
    
  
}
- (void)setParkingId:(NSString *)parkingId{
    _parkId = parkingId;
    NSString *summary = [[NSString stringWithFormat:@"%@%@",parkingId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",queryCharge,parkingId,summary];
    //        BEGIN_MBPROGRESSHUD;
    [RequestModel requestGetQueryChargeWithURL:url Completion:^(NSDictionary *dict) {
        NSArray *array = dict[@"srvList"];
        //            END_MBPROGRESSHUD;
        if (array.count == 2) {
            _carDic = [NSDictionary dictionaryWithDictionary:array[0]];
            _busyCarDic = [NSDictionary dictionaryWithDictionary:array[1]];
            
            [self creteUI];
            
            
            
        }else{
            //                ALERT_VIEW(@"此停车场暂未开通,敬请期待");
            //                _alert = nil;
        }
        
    } Fail:^(NSString *error) {
        //            ALERT_VIEW(@"此停车场暂未开通,敬请期待");
        //            _alert = nil;
        //            END_MBPROGRESSHUD;
    }];
}
- (void)awakeFromNib
{
    
    
    [self getLocationAndPushAndMob];
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    
    btn1.layer.borderWidth = 2;
    btn1.layer.borderColor = NEWMAIN_COLOR.CGColor;
    btn1.layer.cornerRadius = 6;
    _temBtn = btn1;
    
    btn1.clipsToBounds = YES;
    btn2.layer.cornerRadius = 6;
    btn2.clipsToBounds = YES;
    
    _timeT.delegate = self;
    self.parkingName.delegate = self;
    self.carNumT.delegate = self;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:currentDate];
    _timeT.text = dateStr;
    
    
    
}
- (void)netWorkingRequest{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3",@"srvId",@"2.0.0",@"version", nil];
    NSString *url = [NSString stringWithFormat:@"%@",getParkingList];
    [RequestModel requestGetParkingListWith:url WithDic:dict type:@"parkingList" Completion:^(NSMutableArray *array) {
        _dataArray = [NSMutableArray arrayWithArray:array];
        if (_dataArray.count == 0) {
            _tureIndex = 1;
        }else{
            _tureIndex = 2;
        }
       
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_myLatitude,_myLongitude));
        NSMutableArray *array1 = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < _dataArray.count; i++) {
            ParkingModel *model = _dataArray[i];
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]));
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            NSString *distanceString = [NSString stringWithFormat:@"%lf",distance];
            [array1 addObject:distanceString];
        }
        NSArray *array2 = [self paixu:array1];
        if (array2.count > 0) {
            _minuteDistance = array2[0];
            for (NSInteger i = 0; i < _dataArray.count; i++) {
                ParkingModel *model = _dataArray[i];
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]));
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                NSString *distanceString = [NSString stringWithFormat:@"%lf",distance];
                if ([_minuteDistance isEqualToString: distanceString]) {
                    self.parkingName.text = model.parkingName;
                    [self setParkingId:model.parkingId];
                }
            }
        }
        
        
    } Fail:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)chooseCar:(UIButton *)sender {
    
    _temBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    sender.layer.borderWidth = 2;
    sender.layer.borderColor = NEWMAIN_COLOR.CGColor;
    _temBtn = sender;
    
    if (sender.tag == 0) {
//        轿车
        _chooseCar = @"轿车";
        _reserveMoney = [NSString stringWithFormat:@"%d",[_carDic[@"srvPrice"] integerValue]+[_carDic[@"nowPrice"]integerValue]];
        _carType = @"1";
      
        
    }else
    {
//        商务车
        _chooseCar = @"商务车";
        _reserveMoney = [NSString stringWithFormat:@"%d",[_busyCarDic[@"srvPrice"] integerValue]+[_busyCarDic[@"nowPrice"]integerValue]];
        _carType = @"2";
    }
      self.washCarMoneyL.text = [NSString stringWithFormat:@"%@元",_reserveMoney];
    NSMutableAttributedString *attributedString = [MyUtil getLableText:self.washCarMoneyL.text changeText:_reserveMoney Color:[MyUtil colorWithHexString:@"FD913A"] font:20];
    self.washCarMoneyL.attributedText = attributedString;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField ==self.timeT) {
        CGFloat selfHight = SCREEN_HEIGHT/2+394/2;
        if ((selfHight - (SCREEN_HEIGHT-230)) > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-(selfHight - (SCREEN_HEIGHT-230)));
            }];
        }
        _selectDatePicker = [[MHDatePicker alloc] init];
        _selectDatePicker.isBeforeTime = YES;
        _selectDatePicker.datePickerMode = UIDatePickerModeDate;
        __weak typeof(self) weakSelf = self;
        [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            [UIView animateWithDuration:0.2 animations:^{
                self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            }];
            weakSelf.timeT.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
            
        }];
        _selectDatePicker.cancleBlock = ^(){
            [weakSelf animatedOut];
            
        };
        
        return NO;
    }else if(textField ==  self.carNumT){
        if (self.chooseCarBlock) {
            self.chooseCarBlock();
        }
        return NO;
    }else if (textField == self.parkingName){
        if (_tureIndex == 2) {
            FullAlert *full = [[FullAlert alloc]init];
            full.dataArray = _dataArray;
            full.selectParking = ^(ParkingModel *model){
                _parkingName.text = model.parkingName;
                [self setParkingId:model.parkingId];
            };
            [full show];
        }else{
            [MyUtil alertController:@"您未拿到停车场,无法查看!" viewController:self.controller Completion:^{
                
            } Fail:^{
                
            }];
        }
       
        return NO;
    }
    return NO;
}
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
- (IBAction)sureBtnClick:(id)sender {
    
    [self getDictionaryGoPayFor];
    
}
- (IBAction)cancelClick:(id)sender {
    
    [self animatedOut];
    
}

- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.bgView.hidden = NO;
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [self performSelector:@selector(MyClick) withObject:self afterDelay:0.2];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
}
- (void)MyClick{
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
    }
    [self removeFromSuperview];
}
- (void)getDictionaryGoPayFor{
    if (_tureIndex == 2) {
        
   
    if ([MyUtil isBlankString:self.parkingName.text] == YES) {
        ALERT_VIEW(@"停车场不能为空");
        return;
    }
    if ([MyUtil isBlankString:self.carNumT.text] == YES) {
        ALERT_VIEW(@"车牌号不能为空");
        return;
    }
   
    NSString *money = [NSString stringWithFormat:@"%ld",[_reserveMoney integerValue]*100];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",_carType,@"carType",money,@"amountPayable",_parkId,@"parkingId",_timeT.text,@"reserveDate",@"17",@"orderType",[MyUtil getTimeStamp],@"timestamp",self.carNumT.text,@"carNumber",nil];
    if (_sureChooserCarBlocl) {
        _sureChooserCarBlocl(_parkId,dict);
    }
    }else{
        [MyUtil alertController:@"您未添加车场!" viewController:self.controller Completion:^{
            
        } Fail:^{
            
        }];
    }
}
- (NSArray *)paixu:(NSMutableArray *)array1{
    
    if(array1.count>1){
        
        for (int i = 0; i < array1.count; i++) {
            for (int j = 0; j < array1.count-1; j++) {
                if ([array1[j+1] doubleValue] < [array1[j] doubleValue]) {
                    NSInteger temp = [array1[j] doubleValue];
                    array1[j]= array1[j+1];
                    array1[j+1]= [NSNumber numberWithDouble:temp];
                }
            }
        }
        
        
        return array1;
    }
    
    return nil;
}
@end
