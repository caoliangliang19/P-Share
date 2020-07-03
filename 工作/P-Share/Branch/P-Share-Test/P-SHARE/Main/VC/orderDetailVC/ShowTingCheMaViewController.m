//
//  ShowTingCheMaViewController.m
//  P-Share
//
//  Created by fay on 16/1/20.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "ShowTingCheMaViewController.h"


@interface ShowTingCheMaViewController ()

@end

@implementation ShowTingCheMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadUI];
    [self myanimation];
    
   
}
- (void)loadUI
{
    self.title = @"停车凭证";
    if([self.model.orderType integerValue] == 10){
        [self shareTemUI];
    }else if([self.model.orderType integerValue] == 11){
        [self temPayUI];
    }else if([self.model.orderType integerValue] == 12){
        
    }else if([self.model.orderType integerValue] == 13){
        [self rentMoneyPayUI];
    }else if([self.model.orderType integerValue] == 14){
        [self rentMoneyPayUI];
    }
    
   
}
#pragma mark -
#pragma mark - 月租产权支付凭证
- (void)rentMoneyPayUI{
    if([self.model.orderType integerValue] == 13){
        self.rendL.text = @"月租支付凭证";
    }else if ([self.model.orderType integerValue] == 14){
        self.rendL.text = @"产权支付凭证";
    }
    self.tingCheCons.constant = 40;
    self.headLable.text = @"支付凭证";
    self.tingCheMaL.text = self.model.parkingName;
    self.temLable.text = @"付款时间";
    self.promptLable.textAlignment = NSTextAlignmentLeft;
    self.promptLable.hidden = YES;
    NSArray *array1 = nil;
    NSArray *array2 = nil;
    _cheChangNameL.text = _model.parkingName;
    NSArray *array = [_model.payTime componentsSeparatedByString:@" "];
    if (_model.payTime.length > 0) {
        
        if (array[0]) {
            array1 = [array[0] componentsSeparatedByString:@"-"];
        }
        if (array[1]) {
            array2 = [array[1] componentsSeparatedByString:@":"];
        }
    }
    if (array[0]&&array2[0]&&array2[1]) {
        _tingCheMaL.textAlignment = NSTextAlignmentLeft;
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _tingCheMaL.font = [UIFont systemFontOfSize:28];
        }else{
        _tingCheMaL.font = [UIFont systemFontOfSize:30];
        }
        _tingCheMaL.text = [NSString stringWithFormat:@"%@  %@:%@",array[0],array2[0],array2[1]];
    }else{
        _tingCheMaL.text = [NSString stringWithFormat:@"%@",_model.payTime];
    }
    self.chePaiHaoL.text = self.model.carNumber;
    self.ruChangL.text = @"续费到期时间";

    self.monthL.text = [NSString stringWithFormat:@"%@",self.model.monthNum ];
    self.payTimeL.text = [NSString stringWithFormat:@"%@",self.model.effectEndDate];
    self.moneyL.text = [NSString stringWithFormat:@"%@元",self.model.amountPaid];
    
}
#pragma mark -
#pragma mark - 临停支付凭证
- (void)temPayUI{
    self.rendL.hidden = YES;
    self.headLable.text = @"支付凭证";
    self.tingCheMaL.text = self.model.parkingName;
    self.temLable.text = @"付款时间";
    self.promptLable.textAlignment = NSTextAlignmentLeft;
    self.promptLable.text = @"*请于付款后15分钟内离场";
    NSArray *array1 = nil;
    NSArray *array2 = nil;
    _cheChangNameL.text = _model.parkingName;
     NSArray *array = [_model.payTime componentsSeparatedByString:@" "];
    if (_model.payTime && _model.payTime.length>0) {
       
        if (array[0]) {
            array1 = [array[0] componentsSeparatedByString:@"-"];
        }
        if (array[1]) {
            array2 = [array[1] componentsSeparatedByString:@":"];
        }
    }
    if (array[0]&&array2[0]&&array2[1]) {
        _tingCheMaL.textAlignment = NSTextAlignmentLeft;
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _tingCheMaL.font = [UIFont systemFontOfSize:28];
        }else{
            _tingCheMaL.font = [UIFont systemFontOfSize:30];
        }
        _tingCheMaL.text = [NSString stringWithFormat:@"%@  %@:%@",array[0],array2[0],array2[1]];
    }else{
        _tingCheMaL.text = [NSString stringWithFormat:@"%@",_model.payTime];
    }
    self.chePaiHaoL.text = self.model.carNumber;
    self.ruChangL.text = @"入场时间";
    NSArray *array3 = [self.model.actualBeginDate componentsSeparatedByString:@" "];
    self.payTimeL.text = array3[0];
    self.moneyL.text = [NSString stringWithFormat:@"%@元",self.model.amountPaid];
    self.xuFeiL.hidden = YES;
    self.monthL.hidden = YES;
    self.yueL.hidden = YES;
    
}
#pragma mark -
#pragma mark - 共享临停凭证
- (void)shareTemUI{
    self.rendL.hidden = YES;
    //停车码
    NSString *str = [self parking_code:self.model.parkingCode];
    
    _tingCheMaL.text = str;
    _chePaiHaoL.text = _model.carNumber;
    if (_model.carNumber == nil) {
        _chePaiHaoL.text = @"";
    }
    NSArray *array1 = nil;
    NSArray *array2 = nil;
    _cheChangNameL.text = _model.parkingName;
    if (_model.payTime.length > 0) {
        NSArray *array = [_model.payTime componentsSeparatedByString:@" "];
        if (array[0]) {
            array1 = [array[0] componentsSeparatedByString:@"-"];
        }
        if (array[1]) {
            array2 = [array[1] componentsSeparatedByString:@":"];
        }
    }
    if (array1[1]&&array1[2]&&array2[0]&&array2[1]) {

        _payTimeL.text = [NSString stringWithFormat:@"%@-%@ %@:%@",array1[1],array1[2],array2[0],array2[1]];
    }else{
        _payTimeL.text = [NSString stringWithFormat:@"%@",_model.payTime];
    }
    
    _moneyL.text = [NSString stringWithFormat:@"%@元",_model.amountPaid];
    self.xuFeiL.hidden = YES;
    self.monthL.hidden = YES;
    self.yueL.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)myanimation{
    NSMutableArray *paidArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        //拼接图片名字
        NSString *name = [NSString stringWithFormat:@"paid%d.png",i+1];
        //创建图片
        UIImage *paidImg = [UIImage imageNamed:name];
        //将图片放入数组中
        [paidArr addObject:paidImg];
    }
    
    //动画时间
    _payImage.animationDuration = 0.5 * paidArr.count;
    
    //需要做动画的图片数组
    _payImage.animationImages = paidArr;
    
    //重复次数:0 默认是无穷大
    _payImage.animationRepeatCount = 0;
    
    //开始帧动画
    [_payImage startAnimating];
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
//根据两个日期计算天数
- (NSString *)planMonthAndDay:(NSString *)beginData AndendDay:(NSString *)endData{
    NSArray *array = [beginData componentsSeparatedByString:@" "];
    NSString *dateStr =array[0];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    MyLog(@"fromdate=%@",fromDate);
    //    注意:这里获取的时间要通过时区然后再转换为NSDate，不然转换为NSDate后和获取的字符串类型的日期 不一样
    
     NSArray *array1 = [endData componentsSeparatedByString:@" "];
    NSString *date =array1[0];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *enddate=[format dateFromString:date];
    NSTimeZone *endzone = [NSTimeZone systemTimeZone];
    NSInteger endinterval = [endzone secondsFromGMTForDate: enddate];
    NSDate *endDate = [enddate  dateByAddingTimeInterval: endinterval];
    MyLog(@"endDate=%@",endDate);
    
    //    NSDate *date = [NSDate date];
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: date];
    //    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    MyLog(@"enddate=%@",localeDate);
    //    注意:这里获系统的时间，为了确保准确性也要通过时区进行转换为本地的时间，如果直接用[NSDate date] 获取的时间和系统本地的时间不一样
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:endDate options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];//年[components year]
  
    if (days == 0) {
        return [NSString stringWithFormat:@"%ld",(long)months];
    }
    return [NSString stringWithFormat:@"%ld",(long)(months+1)];
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
