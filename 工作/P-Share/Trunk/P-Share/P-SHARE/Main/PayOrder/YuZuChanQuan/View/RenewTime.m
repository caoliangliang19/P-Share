//
//  TimePickerView.m
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "RenewTime.h"


@interface RenewTime ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary    *_timerDic;

    UIView          *_grayView;
    
}
@property (nonatomic ,strong)NSArray *dataArray;

@end
@implementation RenewTime
NSString    *const      KLittleNum      = @"littleNum";
NSString    *const      KBigNum         = @"bigNum";



- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"RenewTime" owner:nil options:nil]lastObject];
        
        // 初始化设置
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        UIView *grayView = [UIView new];
        _grayView = grayView;
        grayView.backgroundColor = [UIColor blackColor];
        grayView.alpha = 0.5;
        [window addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];

        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        
        [window addSubview:self];
        
        
    }
    
    return self;
    
}

- (void)show {
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    _grayView.hidden = NO;
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
            [_grayView removeFromSuperview];
            [self removeFromSuperview];
            
        }
    }];
    
}
//页面设置
- (void)awakeFromNib {
    [super awakeFromNib];
    _dataArray = @[@{
                       KLittleNum   : @"1",
                       KBigNum      : @"一个月"
                       },
                   @{
                       KLittleNum   : @"2",
                       KBigNum      : @"二个月"
                       },
                   @{
                       KLittleNum   : @"3",
                       KBigNum      : @"三个月"
                       },
                   @{
                       KLittleNum   : @"4",
                       KBigNum      : @"四个月"
                       },
                   @{
                       KLittleNum   : @"5",
                       KBigNum      : @"五个月"
                       },
                   @{
                       KLittleNum   : @"6",
                       KBigNum      : @"六个月"
                       },
                   @{
                       KLittleNum   : @"7",
                       KBigNum      : @"七个月"
                       },
                   @{
                       KLittleNum   : @"8",
                       KBigNum      : @"八个月"
                       },
                   @{
                       KLittleNum   : @"9",
                       KBigNum      : @"九个月"
                       },
                   @{
                       KLittleNum   : @"10",
                       KBigNum      : @"十个月"
                       },
                   @{
                       KLittleNum   : @"11",
                       KBigNum      : @"十一个月"
                       },
                   @{
                       KLittleNum   : @"12",
                       KBigNum      : @"十二个月"
                       },
                   ];
    _timerDic = _dataArray[0];

    self.dataPickView.delegate = self;
    self.dataPickView.dataSource = self;
    
}

#pragma mark- Picker Data Source 代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    return  [self.dataArray objectAtIndex:row][KBigNum];
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _timerDic = _dataArray[row];
    MyLog(@"%@",_dataArray[row]);
    
}

- (IBAction)tureBtn:(UIButton *)sender {
    if (self.renewTimeCallBackBlock) {
        self.renewTimeCallBackBlock(_timerDic);
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
