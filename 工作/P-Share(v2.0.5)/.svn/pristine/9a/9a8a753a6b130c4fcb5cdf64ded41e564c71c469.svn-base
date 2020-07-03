//
//  DVYearMonthDatePicker.m
//  DVYearMonthDatePicker
//
//  Created by Fire on 15/11/18.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVYearMonthDatePicker.h"

// Identifiers of components
#define MONTH ( 1 )
#define YEAR ( 0 )


// Identifies for component views
#define LABEL_TAG 43

@interface DVYearMonthDatePicker ()

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *Lastmonths;
@property (nonatomic, strong) NSArray *years;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@end

@implementation DVYearMonthDatePicker


const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

#pragma mark - Properties

-(void)setMonthFont:(UIFont *)monthFont
{
    if (monthFont)
    {
        _monthFont = monthFont;
    }
}

-(void)setMonthSelectedFont:(UIFont *)monthSelectedFont
{
    if (monthSelectedFont)
    {
        _monthSelectedFont = monthSelectedFont;
    }
}

-(void)setYearFont:(UIFont *)yearFont
{
    if (yearFont)
    {
        _yearFont = yearFont;
    }
}

-(void)setYearSelectedFont:(UIFont *)yearSelectedFont
{
    if (yearSelectedFont)
    {
        _yearSelectedFont = yearSelectedFont;
    }
}

#pragma mark - Init

- (instancetype)initWithController:(UIViewController *)controller;
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        [self loadDefaultsParameters];
        [controller.view addSubview:self.bgView];
        [controller.view addSubview:self];
    }
    return self;
}
- (instancetype)initWithView:(UIView *)mainView
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        [self loadDefaultsParameters];
        [mainView addSubview:self.bgView];
        [mainView addSubview:self];
    }
    return self;
}
#pragma mark -
#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bgView;
}
- (void)show{
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.frame = CGRectMake(0, SCREEN_HEIGHT-216, SCREEN_WIDTH, 216);
    }];
    
}
- (void)hide{
    [UIView animateWithDuration:.35 animations:^{
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.bgView) {
                [self.bgView removeFromSuperview];
                
            }
            [self removeFromSuperview];
        }
    }];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}

#pragma mark - Open methods

-(NSDate *)date
{
    NSInteger monthCount = self.months.count;
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年M月"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
    return date;
}

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    self.minYear = minYear;
    
    if (maxYear > minYear)
    {
        self.maxYear = maxYear;
    }
    else
    {
        self.maxYear = minYear + 10;
    }
    
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
}

-(void)selectToday
{
    [self selectRow: self.todayIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: self.todayIndexPath.section
        inComponent: YEAR
           animated: NO];
}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    
    BOOL selected = NO;
    if(component == MONTH)
    {
         NSInteger seletNum = [pickerView selectedRowInComponent:0];
        if (seletNum == 0) {
            NSInteger monthCount = self.Lastmonths.count;
            NSString *monthName = [self.Lastmonths objectAtIndex:(row % monthCount)];
            NSString *currentMonthName = [self currentMonthName];
            if([monthName isEqualToString:currentMonthName] == YES)
            {
                selected = YES;
            }
        }else{
            NSInteger monthCount = self.months.count;
            NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
            NSString *currentMonthName = [self currentMonthName];
            if([monthName isEqualToString:currentMonthName] == YES)
            {
                selected = YES;
            }
        }
       
    }
    else
    {
        NSInteger yearCount = self.years.count;
        NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    returnView.font = selected ? [self selectedFontForComponent:component] : [self fontForComponent:component];
    returnView.textColor = selected ? [self selectedColorForComponent:component] : [self colorForComponent:component];
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 1)
    {
        NSInteger seletNum = [pickerView selectedRowInComponent:0];
        if (seletNum == 0) {
            return self.Lastmonths.count;
        }else{
        return [self bigRowMonthCount];
        }
    }else{
        return [self bigRowYearCount];
    }
}

#pragma mark - Util

-(NSInteger)bigRowMonthCount
{
    return self.months.count  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return self.years.count  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = self.years.count;
    return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;    // UITextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
//     NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY"];
//    
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateFormat:@"M"];
//    NSString *month = [formatter1 stringFromDate:date];
//    
//    if (year == [[formatter stringFromDate:date] integerValue] ) {
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//        for (NSInteger i = [month integerValue]; i <= 12; i++) {
//            NSString *month1 = [NSString stringWithFormat:@"%ld月",i];
//            [array addObject:month1];
//        }
//        return array;
//    }else{
    return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
//    }
//    return nil;
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
            for (NSInteger i = [month integerValue]; i <= 12; i++) {
                NSString *month1 = [NSString stringWithFormat:@"%ld月",i];
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
        NSString *yearStr = [NSString stringWithFormat:@"%li年", (long)year];
        [years addObject:yearStr];
    }
    return years;
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:[NSDate date]];
}

- (UIColor *)selectedColorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedTextColor;
    }
    return self.yearSelectedTextColor;
}

- (UIColor *)colorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthTextColor;
    }
    return self.yearTextColor;
}

- (UIFont *)selectedFontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedFont;
    }
    return self.yearSelectedFont;
}

- (UIFont *)fontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthFont;
    }
    return self.yearFont;
}

-(void)loadDefaultsParameters
{
//    self.backgroundColor = [UIColor whiteColor];
    self.minYear = 1990;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    
    self.maxYear = [[formatter stringFromDate:date] integerValue];
    self.rowHeight = 44;
    self.years = [self nameOfYears];
    self.months = [self nameOfMonths];
    self.Lastmonths = [self firstArray:self.maxYear];
    
    self.todayIndexPath = [self todayPath];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectToday];
    
    self.monthSelectedTextColor = [UIColor blackColor];
    self.monthTextColor = [UIColor blackColor];
    
    self.yearSelectedTextColor = [UIColor blackColor];
    self.yearTextColor = [UIColor blackColor];
    
    self.monthSelectedFont = [UIFont systemFontOfSize:17];
    self.monthFont = [UIFont systemFontOfSize:17];
    
    self.yearSelectedFont = [UIFont systemFontOfSize:17];
    self.yearFont = [UIFont systemFontOfSize:17];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBgView)];
    [self.bgView addGestureRecognizer:tap];
}
- (void)onClickBgView{
    [self hide];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([self.dvDelegate respondsToSelector:@selector(yearMonthDatePicker:didSelectedDate:)]) {
        [self.dvDelegate yearMonthDatePicker:self didSelectedDate:[self date]];
    }
    
}

- (void)selectDate:(NSDate *)date{
    
    NSIndexPath *selectIndexPath = [self selectPathWithDate:date];
    
    [self selectRow: selectIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: selectIndexPath.section
        inComponent: YEAR
           animated: NO];
    
    [self pickerView:self didSelectRow:selectIndexPath.row inComponent:MONTH];
    [self pickerView:self didSelectRow:selectIndexPath.row inComponent:YEAR];
}


-(NSString *)selectMonthName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:date];
}

-(NSString *)selectYearName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:date];
}

-(NSIndexPath *)selectPathWithDate:(NSDate *)date // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self selectMonthName:date];
    NSString *year  = [self selectYearName:date];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

@end
