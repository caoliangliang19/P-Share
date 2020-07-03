//
//  NewMonthlyRentPayCell.m
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewMonthlyRentPayCell.h"

@interface NewMonthlyRentPayCell()
{
    int _setMonthlyNum;
    UIAlertView *_alert;

}
@end

@implementation NewMonthlyRentPayCell

- (void)awakeFromNib {

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTapGesture:)];
    _agreeL.userInteractionEnabled = YES;
    [_agreeL addGestureRecognizer:tapGesture];
    
 
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    _monthNum = 1;
    _setMonthlyNum = 1;
    _payBtn.userInteractionEnabled = NO;
    _selectBtn.userInteractionEnabled = NO;
    
}

- (void)labTapGesture:(UITapGestureRecognizer *)tapGesture
{
    self.gotoWebVC();
    
}


- (IBAction)ensurePay:(UIButton *)sender {
    self.gotoMonthiyPayVC();
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)setMonthlyNum:(UIButton *)sender {
    
    if ([_danJiaL.text isEqualToString:@"-"]) {
        return;
    }
    
    if (sender.tag == 0) {
//        减
        if (_setMonthlyNum < 2) {
            return;
        }
        
        _setMonthlyNum -- ;
    }else
    {
//        加
        
        if (_maxDate.length > 0) {
            NSInteger num = [self compareOneDay:[self StringChangeDate:_jiaoFeeEndTimeL.text] withAnotherDay:[self StringChangeDate:_maxDate]];
            
            if ( num == 0 || num == 1 ) {
                
                ALERT_VIEW(@"您已经超出续费期限");
                _alert = nil;
                
                return;
            }
            _setMonthlyNum ++;
        }else
        {
            if (_setMonthlyNum < 12) {
                
                _setMonthlyNum++;
                
            }else
            {
                ALERT_VIEW(@"您已经超出续费期限");
                _alert = nil;
                return;
            }
        }
        
    }
    
   
    _monthNumL.text = [NSString stringWithFormat:@"%d",_setMonthlyNum];
    
    _priceL.text = [NSString stringWithFormat:@"%d",[_danJiaL.text intValue] * _setMonthlyNum];
    
    _jiaoFeeEndTimeL.text = [MyUtil getCalendar:[[_endTimeL.text componentsSeparatedByString:@": "] lastObject] WithMonthlyNum:_setMonthlyNum];
    
}

- (NSDate*)StringChangeDate:(NSString *)str
{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [inputFormatter dateFromString:str];
    
    return inputDate;
    
}

- (IBAction)isNeedInvoice:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeBtnClick:)]) {
        [self.delegate getSwitchIsOn:sender];
        
    }
}
- (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    MyLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //MyLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //MyLog(@"Date1 is in the past");
        return -1;
    }
    //MyLog(@"Both dates are the same");
    return 0;
    
}


- (IBAction)agreeBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeBtnClick:)]) {
        [self.delegate agreeBtnClick:sender];
        
    }
}

@end
