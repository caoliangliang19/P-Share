//
//  DatePickView.m
//  P-Share
//
//  Created by 亮亮 on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DatePickView.h"
@interface DatePickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *_yearTimer;
    NSString *_MonthTimer;
    
}
@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,assign)NSInteger minYear;
@property (nonatomic ,assign)NSInteger maxYear;

@property (nonatomic ,strong)NSArray *firstMonthArray;
@property (nonatomic ,strong)NSArray *monthArray;

@property (nonatomic ,strong)NSMutableArray *yearArray;




@end
@implementation DatePickView
- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"DatePickView" owner:nil options:nil]lastObject];
        
        // 初始化设置
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
     
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        
        [window addSubview:self.bgView];
        
        [window addSubview:self];
        
        
    }
    
    return self;
    
}
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bgView;
}
- (IBAction)tureBtn:(UIButton *)sender {
    [self hide];
    if (_myBlock) {
        self.myBlock(_yearTimer,_MonthTimer);
    }
}

- (IBAction)cancleBtn:(UIButton *)sender {
    [self hide];
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
            if (self.bgView) {
                [self.bgView removeFromSuperview];
                
            }
            [self removeFromSuperview];
        }
    }];
    
}
- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBgView)];
    [self.bgView addGestureRecognizer:tap];
    self.minYear = 1990;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    self.maxYear = [[formatter stringFromDate:date] integerValue];
    self.yearArray =[NSMutableArray arrayWithArray:[self nameOfYears]];
    self.firstMonthArray = [NSMutableArray arrayWithArray:[self firstArray:self.maxYear]];
    self.monthArray = [NSMutableArray arrayWithArray:[self nameOfMonths]];
    self.datePickView.delegate = self;
    self.datePickView.dataSource = self;
    
}
- (void)onClickBgView{
    [self hide];
}
-(NSArray *)nameOfMonths
{
    
    return @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    
}
- (NSArray *)firstArray:(NSInteger)year{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"M"];
    NSString *month = [formatter1 stringFromDate:date];
    
    if (year == [[formatter stringFromDate:date] integerValue] ) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSInteger i = 1; i <= [month integerValue]; i++) {
            NSString *month1 = [NSString stringWithFormat:@"%ld",i];
            [array addObject:month1];
        }
        return array;
    }
    return nil;
}
-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear; year <= self.maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%li", (long)year];
        [years addObject:yearStr];
    }
    return years;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0){
        
        return self.yearArray.count;
        
    }else{
        
        NSInteger seletNum = [pickerView selectedRowInComponent:0];
        if (seletNum == self.yearArray.count-1) {
            return self.firstMonthArray.count;
            
        }else{
            
            return self.monthArray.count;
        }
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        _yearTimer = [self.yearArray objectAtIndex:row];
        return [NSString stringWithFormat:@"%@年",_yearTimer];
        
    }
    else
    {
        NSInteger seletNum = [pickerView selectedRowInComponent:0];
        if (seletNum ==self.yearArray.count-1) {
            if (self.firstMonthArray.count <= row) {
                return nil;
            }
            
            _MonthTimer =[self.firstMonthArray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@月",_MonthTimer];
            
        }else{
            
            if (self.monthArray.count <= row) {
                return nil;
            }
            
            _MonthTimer =[self.monthArray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@月",_MonthTimer];
            
        }
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        [pickerView reloadComponent:1];
        [pickerView selectRow:self.yearArray.count-1 inComponent:1 animated:YES];
        
       
        
        _yearTimer =[NSString stringWithFormat:@"%@",[self.yearArray objectAtIndex:row]];
    }
    
    else if (component == 1)
    {
        
        NSInteger seletNum = [pickerView selectedRowInComponent:0];
        
       
        if (seletNum == self.yearArray.count-1) {
            if (self.firstMonthArray.count <= row) {
                return ;
            }
            _MonthTimer =[NSString stringWithFormat:@"%@",[self.firstMonthArray objectAtIndex:row]];
        }else{
            if (self.monthArray.count <= row) {
                return ;
            }
            _MonthTimer =[NSString stringWithFormat:@"%@",[self.monthArray objectAtIndex:row]];
        }
        
        
        
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
