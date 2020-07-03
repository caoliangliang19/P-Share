//
//  CalendarView.m
//  BQLCalendar
//
//  Created by fay on 16/4/20.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "CalendarView.h"
#import "BQLCalendar.h"

@interface CalendarView ()
{
    UIView *_grayView;
    UILabel *_yearL;
    UILabel *_monthL;
    NSArray *_monthArray;
    long  temMonth;
    
    NSString *_temDate;
    

    
}

@end

@implementation CalendarView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;

        _monthArray = [NSArray arrayWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月", nil];
        [self layoutSubviews];

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _grayView = [[UIView alloc] initWithFrame:window.bounds];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0.5f;
        [window addSubview:_grayView];
        [window addSubview:self];
        [self animatedIn];
        
        
    }
    return self;
    
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];

//    titleView
    UIView *titleView = [[UIView alloc]init];
//    titleView.backgroundColor = [UIColor ]
    [self addSubview:titleView];
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"预约日期";
    title.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
    
        make.center.mas_equalTo(titleView);
        
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage imageNamed:@"payViewCancel"] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 15)];
    [titleView addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
    }];
    
//    chooseDateView
    UIView *chooseDateView = [[UIView alloc] init];
    chooseDateView.backgroundColor = [MyUtil colorWithHexString:@"607686"];
    [self addSubview:chooseDateView];
    [chooseDateView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleView.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(58);
        
    }];
    
    _monthL = [[UILabel alloc]init];
    _monthL.text = @"四月";
    _monthL.font = [UIFont boldSystemFontOfSize:14];
    _monthL.textColor = [MyUtil colorWithHexString:@"fcfcfc"];
    [chooseDateView addSubview:_monthL];
    [_monthL makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(chooseDateView);
        make.centerY.mas_equalTo(chooseDateView).mas_equalTo(10);
    }];
    
    _yearL = [[UILabel alloc]init];
    _yearL.text = @"2016";
    _yearL.font = [UIFont systemFontOfSize:12];
    _yearL.textColor = [MyUtil colorWithHexString:@"fcfcfc"];
    [chooseDateView addSubview:_yearL];
    [_yearL makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(chooseDateView);
        make.centerY.mas_equalTo(chooseDateView).mas_equalTo(-10);
    }];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.tag = 0;
    [leftBtn addTarget:self action:@selector(changeDate:) forControlEvents:(UIControlEventTouchUpInside)];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 16.5, 14, 16.5)];
    [leftBtn setImage:[UIImage imageNamed:@"left_w"] forState:(UIControlStateNormal)];
    [chooseDateView addSubview:leftBtn];
    
    [leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_monthL.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(chooseDateView.mas_left);
        
    }];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(changeDate:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 16.5, 14, 16.5)];
    [rightBtn setImage:[UIImage imageNamed:@"right_w"] forState:(UIControlStateNormal)];
    [chooseDateView addSubview:rightBtn];
    [rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_monthL.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(chooseDateView.mas_right);
        
    }];

    
    

  //bottomView
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        
    }];
    
    
    UIButton *removeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    removeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    removeBtn.tag = 0;
    [removeBtn addTarget:self action:@selector(decideClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [removeBtn setTitle:@"取 消" forState:(UIControlStateNormal)];
    [removeBtn setTitleColor:[MyUtil colorWithHexString:@"aaaaaa"] forState:(UIControlStateNormal)];
    [bottomView addSubview:removeBtn];
    [removeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.48f);;
        
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.tag = 1;
    [sureBtn addTarget:self action:@selector(decideClick:) forControlEvents:(UIControlEventTouchUpInside)];

    sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sureBtn setTitle:@"确 定" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    [bottomView addSubview:sureBtn];
    [sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.48f);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = NEWMAIN_COLOR;
    [bottomView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(1, 44));
    }];
    
    [self setTitleView:[NSDate date]];
    
    
}



- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    _grayView.alpha = 0;
    
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        _grayView.alpha = 0.5f;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0.0;
        _grayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark --改变月份
- (void)changeDate:(UIButton *)sender
{
    [_calendar.signedArray removeAllObjects];
    
    if (sender.tag == 0) {
        //        上个月
        temMonth--;
    }else
    {
        //        下个月
        temMonth++;
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +temMonth;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    _calendar.dateSource = newDate;
    [_calendar updateDateSource:newDate];
    [self setTitleView:newDate];
    
}
- (void)cancelClick
{
    [self animatedOut];
}
#pragma mark --用户选择操作
- (void)decideClick:(UIButton *)btn
{
    if (btn.tag == 0) {
//        取消
    }else
    {
//        确定
        if (self.sureClick) {
            
            self.sureClick(_temDate);
            
        }
    }
    
    [self animatedOut];
}

#pragma mark -- 设置titleView
- (void)setTitleView:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSArray *temArr = [dateStr componentsSeparatedByString:@"/"];
    _yearL.text = temArr[0];
    _monthL.text = [_monthArray objectAtIndex:[temArr[1] integerValue]-1];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
