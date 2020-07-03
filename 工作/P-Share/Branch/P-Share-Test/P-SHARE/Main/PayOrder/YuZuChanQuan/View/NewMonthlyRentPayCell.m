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

    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTapGesture:)];
    _agreeL.userInteractionEnabled = YES;
    [_agreeL addGestureRecognizer:tapGesture];
    
 
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    _monthNum = 1;
    _setMonthlyNum = 1;
 
    
}

- (void)labTapGesture:(UITapGestureRecognizer *)tapGesture
{

    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"PshareProtrol" ofType:@"doc"];
    WebInfoModel *webModel      = [WebInfoModel new];
    webModel.urlType            = URLTypeNetLocal;
    webModel.shareType          = WebInfoModelTypeNoShare;
    webModel.title              = @"口袋停线上缴费协议";
    webModel.url                = filePath;
    webModel.imagePath          = @"";
    webModel.descibute          = @"";
    WebViewController *webView  = [[WebViewController alloc] init];
    webView.webModel            = webModel;
    [self.viewController.rt_navigationController pushViewController:webView animated:YES];
}


- (IBAction)ensurePay:(UIButton *)sender {
    self.gotoMonthiyPayVC(self);
    
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
                [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"您已经超出续费期限"];
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
                [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"您已经超出续费期"];
                _alert = nil;
                return;
            }
        }
        
    }
    
   
    _monthNumL.text = [NSString stringWithFormat:@"%d",_setMonthlyNum];
    
    _priceL.text = [NSString stringWithFormat:@"%d",[_danJiaL.text intValue] * _setMonthlyNum];
    
    _jiaoFeeEndTimeL.text = [UtilTool getCalendar:[[_endTimeL.text componentsSeparatedByString:@": "] lastObject] WithMonthlyNum:_setMonthlyNum];
    
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSwitchIsOn:)]) {
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
    if (self.payBtn.userInteractionEnabled) {
        self.selectImgV.image = [UIImage imageNamed:@"disagree"];
        self.payBtn.backgroundColor = [UIColor grayColor];
        self.payBtn.userInteractionEnabled = NO;
    }else
    {
        self.selectImgV.image = [UIImage imageNamed:@"agree"];
        self.payBtn.backgroundColor = KMAIN_COLOR;
        self.payBtn.userInteractionEnabled = YES;
    }
}

- (void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    
    self.agreeL.attributedText = [UtilTool getLableText:self.agreeL.text changeText:@"《口袋停线上缴费协议》" Color:KMAIN_COLOR font:11];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.parkingNameL.text = _orderModel.parkingName;
    self.carNumL.text = _orderModel.carNumber;
    self.endTimeL.text = [NSString stringWithFormat:@"到期时间: %@", [[_orderModel.endDate componentsSeparatedByString:@" "] firstObject]];
    self.danJiaL.text = [NSString stringWithFormat:@"%@",_orderModel.price];
    self.priceL.text = self.danJiaL.text;

    self.jiaoFeeEndTimeL.text = [UtilTool getCalendar:[[self.endTimeL.text componentsSeparatedByString:@": "] lastObject] WithMonthlyNum:1];
    self.maxDate = _orderModel.maxDate;
    self.InvoiceSwitch.on = NO;

}
@end
