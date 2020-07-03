//
//  TimePickerView.m
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TimePickerView.h"


@interface TimePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *_dayTimer;
    NSString *_hourTimer;
    NSString *_minuteTimer;
    
}
@property (nonatomic ,strong)NSArray *firstArray;
@property (nonatomic ,strong)NSArray *secondArray;
@property (nonatomic ,strong)NSMutableArray *lastSecondArray;
@property (nonatomic ,strong)NSMutableArray *lastMinuteArray;

@property (nonatomic ,strong)NSArray *thirdArray;


@end
@implementation TimePickerView



- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"TimePickerView" owner:nil options:nil]lastObject];
        
        // 初始化设置
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
//        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 250);
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        
       
        
        [window addSubview:self];
        
        
    }
    
    return self;
    
}

- (void)show {
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
   [UIView animateWithDuration:.35 animations:^{
        
    self.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
        
} completion:^(BOOL finished) {
        
        
       
        
    }];
    
}
- (void)hide {
    
    [UIView animateWithDuration:.35 animations:^{
        
       self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
    
}
//页面设置
- (void)awakeFromNib {
    _lastSecondArray = [[NSMutableArray alloc]init];
    _lastMinuteArray = [[NSMutableArray alloc]init];
    self.firstArray = @[@"今日",@"明日"];
   
    
    self.secondArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setMinute:10];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:currentDate options:0];
    NSString *nextDateStr = [dateFormatter stringFromDate:mDate];
    NSArray *timeArray = [nextDateStr componentsSeparatedByString:@":"];
    NSString *hourTime = timeArray[0];
    NSString *minuteTime = timeArray[1];
    NSInteger minute = [minuteTime integerValue];
    NSInteger hour = [hourTime integerValue];
    if (hour == 23&&(minute>=50&&minute<60)) {
         self.firstArray = @[@"明日"];
    }
    if (minute>=0&&minute<10) {
        minute = 10;
    }else if (minute>=10&&minute<20){
        minute = 20;
    }else if (minute>=20&&minute<30){
        minute = 30;
    }else if (minute>=30&&minute<40){
        minute = 40;
    }else if (minute>=40&&minute<50){
        minute = 50;
    }else if (minute>=50&&minute<60){
        hour = [hourTime integerValue]+1;
        minute = 00;
        
    }
    if (hour == 24) {
        hour = 0;
    }
    
    for (NSInteger i = minute; i <=50; i+=10) {
        NSString *dataStr = [NSString stringWithFormat:@"%.2ld",(long)i];
        [_lastMinuteArray addObject:dataStr];
    }
    for (NSInteger i = hour; i<=23; i++) {
        NSString *dataStr = [NSString stringWithFormat:@"%ld",(long)i];
        [_lastSecondArray addObject:dataStr];
    }
    

    self.thirdArray = @[@"00",@"10",@"20",@"30",@"40",@"50"];
    self.dataPickView.delegate = self;
    self.dataPickView.dataSource = self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark- Picker Data Source 代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.firstArray.count;
    }
    else if(component == 1)
    {
        NSInteger seletNum = [pickerView selectedRowInComponent:0];
        if (seletNum == 0) {
          return self.lastSecondArray.count;
        }else{

        return self.secondArray.count;
        }
    }else{
        NSInteger selectMimute = [pickerView selectedRowInComponent:1];
        NSInteger selecthour = [pickerView selectedRowInComponent:0];
        if (selectMimute == 0 && selecthour == 0)  {
            
            return self.lastMinuteArray.count;
            
        }else{
            
            return self.thirdArray.count;
            
        }
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        _dayTimer = [self.firstArray objectAtIndex:row];
        return  _dayTimer;
        
    }
    else if (component == 1)
    {
         NSInteger seletNum = [pickerView selectedRowInComponent:0];
        if (seletNum == 0) {
            if (self.lastSecondArray.count <= row) {
                return nil;
            }
            
            _hourTimer =[self.lastSecondArray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@点",_hourTimer];
        
        }else{
            
            if (self.secondArray.count <= row) {
                return nil;
            }
            
            _hourTimer =[self.secondArray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@点",_hourTimer];
        
        }
    }else{
         NSInteger selectMimute = [pickerView selectedRowInComponent:1];
        NSInteger selecthour = [pickerView selectedRowInComponent:0];

        if (selectMimute == 0 && selecthour == 0) {
            if (self.lastMinuteArray.count <= row) {
                return nil;
            }
            _minuteTimer = [self.lastMinuteArray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@分",_minuteTimer];

        }else{
            if (self.thirdArray.count <= row) {
                return nil;
            }
        _minuteTimer =[self.thirdArray objectAtIndex:row];
          return [NSString stringWithFormat:@"%@分",_minuteTimer];
        }
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        _dayTimer =[NSString stringWithFormat:@"%@",[self.firstArray objectAtIndex:row]];
    }
    
    else if (component == 1)
    {
        
        NSInteger seletNum = [pickerView selectedRowInComponent:0];

        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
        if (seletNum == 0) {
            if (self.lastSecondArray.count <= row) {
                return ;
            }
         _hourTimer =[NSString stringWithFormat:@"%@",[self.lastSecondArray objectAtIndex:row]];
        }else{
            if (self.secondArray.count <= row) {
                return ;
            }
         _hourTimer =[NSString stringWithFormat:@"%@",[self.secondArray objectAtIndex:row]];
        }
        
        

    }
    else{
        NSInteger selectMimute = [pickerView selectedRowInComponent:1];
        NSInteger selecthour = [pickerView selectedRowInComponent:0];
        if (selectMimute == 0 && selecthour == 0)  {
            if (self.lastMinuteArray.count <= row) {
                return ;
            }
            _minuteTimer =[NSString stringWithFormat:@"%@",[self.lastMinuteArray objectAtIndex:row]];
        }else{
            if (self.thirdArray.count <= row) {
                return ;
            }
            _minuteTimer =[NSString stringWithFormat:@"%@",[self.thirdArray objectAtIndex:row]];
        }
       
    }
    
}

- (IBAction)tureBtn:(UIButton *)sender {
    if (self.myblock) {
        self.myblock(_dayTimer,_hourTimer,_minuteTimer);
    }
      [self hide];
}

- (IBAction)cancleBtn:(UIButton *)sender {
   
    if (self.cblock) {
        self.cblock();
    }
     [self hide];
}
@end
