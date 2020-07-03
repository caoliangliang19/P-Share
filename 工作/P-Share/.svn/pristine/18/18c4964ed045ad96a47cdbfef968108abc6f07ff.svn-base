//
//  StartDaiBoView.m
//  P-SHARE
//
//  Created by fay on 16/10/24.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "StartDaiBoView.h"
#import "TimePickerView.h"
#import "DaiBoRequest.h"
#import "BusyDaiBoAlert.h"
#import "DaiBoSuccessView.h"
#import "TimeLineVC.h"
@interface StartDaiBoView()
{
    UIWindow *_window;
}
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *parkNameL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *daiBoStartTime;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *detailPriceL;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *descributeL;
@property (nonatomic,strong)Car               *carModel;
@property (nonatomic,strong)Parking           *parkingModel;
@property (nonatomic,strong)UIView            *bgView;
@property (nonatomic,strong)TimePickerView    *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong)GroupManage       *manage;
@property (nonatomic,copy) NSString *day,*hours,*miunte;
@end
@implementation StartDaiBoView
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"StartDaiBoView" owner:nil options:nil]lastObject];
        // 初始化设置
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _window = window;
        [window addSubview:self.bgView];
        [window addSubview:self];
        [_sureBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        _sureBtn.userInteractionEnabled = NO;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.superview);
            make.width.mas_equalTo(280);
        }];
    }
    
    return self;
    
}
#pragma mark -- 选择取车时间
- (IBAction)chooseTimeBtnClick:(UIButton *)sender {
    [self setChooseBtnStyle:YES];
    
    self.layer.zPosition = 1000;
    [self ChageTransformDown:YES completion:^{
        [self.pickerView show];
    }];

}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    [self setChooseBtnStyle:NO];

}
- (void)setChooseBtnStyle:(BOOL)selected
{
    if (selected) {
        _chooseTimeBtn.userInteractionEnabled = NO;
        _chooseTimeBtn.layer.borderWidth = 1;
        _chooseTimeBtn.layer.cornerRadius = 4;
        _chooseTimeBtn.layer.borderColor = KMAIN_COLOR.CGColor;
    }else
    {
        _chooseTimeBtn.userInteractionEnabled = YES;
        _chooseTimeBtn.layer.borderWidth = 1;
        _chooseTimeBtn.layer.cornerRadius = 4;
        _chooseTimeBtn.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    }
}
- (void)StartDaiBoViewShow{
    self.carModel = self.manage.car;
    self.parkingModel = self.manage.parking;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    _daiBoStartTime.text =[NSString stringWithFormat:@" 今日:  %@",dateString];
    self.bgView.hidden =NO;
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)hiddenSelf:(id)sender {
    if(_pickerView){
        [self.pickerView hide];
    }
    [self StartDaiBoViewHidden];
}
- (void)StartDaiBoViewHidden{
    _priceL.text = @"预计费用0元";
    _detailPriceL.text = @"";
    [_chooseTimeBtn setTitle:@"您要几点取车" forState:(UIControlStateNormal)];
    [_sureBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    _sureBtn.userInteractionEnabled = NO;
    self.day = nil;self.hours = nil;self.miunte = nil;
    [self setChooseBtnStyle:NO];
    self.transform =CGAffineTransformIdentity;
    self.bgView.hidden = YES;
    self.hidden = YES;
}

- (void)setCarModel:(Car *)carModel{
    _carModel = carModel;
    _carNumL.text = carModel.carNumber;
}
- (void)setParkingModel:(Parking *)parkingModel{
    _parkingModel = parkingModel;
    _parkNameL.text = parkingModel.parkingName;
    NSString *temStr = [NSString stringWithFormat:@"说明: %@",parkingModel.parkPriceComment];
    _descributeL.text = temStr;

}
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bgView.hidden =YES;
    }
    return _bgView;
    
}
- (TimePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[TimePickerView alloc]init];
        WS(ws)
        _pickerView.myblock = ^(NSString *day,NSString *hour,NSString *miunte){
            [ws setChooseBtnStyle:NO];
            ws.day = day;ws.hours = hour;ws.miunte = miunte;
            [ws ChageTransformDown:NO completion:nil];
            [ws.chooseTimeBtn setTitle:[NSString stringWithFormat:@" %@  %@:%@",day,hour,miunte] forState:(UIControlStateNormal)];
            NSDictionary *dic = @{@"day":day,
                                  @"hour":hour,
                                  @"miunte":miunte,
                                  }.copy;
            [DaiBoRequest requestDaiBoPriceWithURL:APP_URL(calcParkPrice) WithDic:dic Completion:^(NSDictionary *dic) {
                ws.priceL.text = [NSString stringWithFormat:@"预计费用%@元",dic[@"data"][@"price"]];
                NSMutableAttributedString *attstr = [UtilTool getLableText:ws.priceL.text changeText:dic[@"data"][@"price"] Color:KMAIN_COLOR font:25];
                ws.priceL.attributedText = attstr;
                ws.detailPriceL.text = dic[@"data"][@"description"];
                [ws.sureBtn setTitleColor:KMAIN_COLOR forState:(UIControlStateNormal)];
                ws.sureBtn.userInteractionEnabled = YES;
                [ws layoutSubviews];
            } Fail:^(NSString *error) {
                [ws.sureBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
                ws.sureBtn.userInteractionEnabled = NO;
            }];
            MyLog(@"%@  %@  %@",day,hour,miunte);
        };
        _pickerView.cblock = ^(){
            [ws setChooseBtnStyle:NO];
            [ws ChageTransformDown:NO completion:nil];
        };
    }
    return _pickerView;
}
#pragma  mark -- 提交订单
- (IBAction)commitOrder:(UIButton *)sender {
    if ([UtilTool isBlankString:_day] || [UtilTool isBlankString:_hours] || [UtilTool isBlankString:_miunte]) {
        [_manage groupAlertShowWithTitle:@"请先选择取车时间"];
        return;
    }
    sender.userInteractionEnabled = NO;
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"1.3.7",@"version",
                                     _carModel.carNumber,@"carNumber",
                                     [UtilTool getCustomId],@"customerId",
                                                                    @"12",@"orderType",
                                     _parkingModel.parkingId,@"parkingId",
                                     [DaiBoRequest getToday:[NSDate date] withFormatter:@"YYYY-MM-dd HH:mm:ss"],@"startTime",
                                     [DaiBoRequest getEndTimeDay:_day hour:_hours miunte:_miunte],@"endTime",
                                     @"0",@"isContinue",
                                     @"2.0.0",@"version", nil];
        [self commitDaiBoOrderWithDic: dataDic];
    
}
- (void)commitDaiBoOrderWithDic:(NSMutableDictionary *)dataDic{
    [DaiBoRequest requestCreateDaiBoOrderWithDic:dataDic Completion:^(OrderModel *model) {
        MyLog(@"%@",model);
        _commitBtn.userInteractionEnabled = YES;
        [self showDaiBoSuccessWith:model withPropertyDic:dataDic];
    } Fail:^(NSString *error) {
        _commitBtn.userInteractionEnabled = YES;
    }];
    [self StartDaiBoViewHidden];
}
- (void)showDaiBoSuccessWith:(OrderModel *)model withPropertyDic:(NSMutableDictionary *)datadic{
    if ([model.waitCarCount intValue] > 0) {//有等待车辆
        BusyDaiBoAlert *busyView = [[BusyDaiBoAlert alloc] init];
        busyView.carQuantityL.text = [NSString stringWithFormat:@"前面等待%@辆车",model.waitCarCount];
        NSMutableAttributedString *string = [UtilTool getLableText:busyView.carQuantityL.text changeText:model.waitCarCount Color:[UIColor orangeColor] font:25];
        [busyView.carQuantityL setAttributedText:string];
        NSArray *timeArray = [model.startTime componentsSeparatedByString:@" "];
        NSInteger compareNum = [UtilTool compareOneDay:[NSDate date] withAnotherDay:[UtilTool StringChangeDate:[timeArray firstObject]]];
        
        NSString *temDay;
        
        if (compareNum == 0) {
            temDay = @"今天 ";
        }else if (compareNum == -1){
            temDay = @"明天 ";
        }else
        {
            temDay = @"";
        }
        busyView.AppointmentL.text = [NSString stringWithFormat:@"预计代泊时间为:%@%@",temDay,timeArray[1]];
        [busyView show];
        busyView.tureBlock = ^(){
            
            [datadic setValue:@"1" forKey:@"isContinue"];
            [datadic setValue:model.startTime forKey:@"startTime"];
            [datadic removeObjectForKey:@"summary"];
            [self commitDaiBoOrderWithDic:datadic];
        };
    }else
    {
        DaiBoSuccessView *successView = [[DaiBoSuccessView alloc] init];
        successView.getCarTimeL.text = model.endTime;
        NSArray *temArrar = [model.orderEndDate componentsSeparatedByString:@" "];
        NSInteger compareNum = [UtilTool compareOneDay:[NSDate date] withAnotherDay:[UtilTool StringChangeDate:[temArrar firstObject]]];
        NSString *temDay;
        if (compareNum == 0) {
            temDay = @"今天 ";
        }else if (compareNum == -1){
            temDay = @"明天 ";
        }else{
            temDay = @"";
        }
        successView.getCarTimeL.text = [NSString stringWithFormat:@"%@%@",temDay,[temArrar lastObject]];
        successView.carMasterPhone.text = model.parkerMobile;
        successView.reckonMoneyL.text = [NSString stringWithFormat:@"%@元",model.amountPaid];
        successView.tureBlock = ^(){
            TimeLineVC *timeLineVC = [[TimeLineVC alloc] init];
            timeLineVC.timeLineVCStyle = YES;
            timeLineVC.orderModel = model;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goToTimeLine" object:timeLineVC];
            
        };
        [successView show];
        //为了刷新首页statusView的数据
        [GroupManage shareGroupManages].car = [GroupManage shareGroupManages].car;
    }
}
- (void)ChageTransformDown:(BOOL)position completion:(void (^)())completion
{

    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.35 animations:^{
            
            self.layer.transform = [self stepOneTransform];
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.35 relativeDuration:0.65 animations:^{
            
            if (!position) {
                self.layer.transform = CATransform3DIdentity;
            }else
            {
                 self.layer.transform = [self stepTwoTransForWithView];
            }
        }];
        
    }completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];

}

- (CATransform3D)stepOneTransform
{
    CGFloat rotationRadio = 1+(0.95 - 0.95)*3.0f;
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = -1.0/900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f * rotationRadio *1, YES, NO, 0);
    return t1;
}
- (CATransform3D)stepTwoTransForWithView{
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self stepOneTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, -60, 0);
    return t2;
}
- (GroupManage *)manage
{
    if (!_manage) {
        _manage = [GroupManage shareGroupManages];
    }
    return _manage;
}


@end
