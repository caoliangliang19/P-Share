//
//  ChooseTimeView.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ChooseTimeView.h"
#import "YuYueTimeModel.h"

@implementation ChooseTimeView
{
    UILabel *_weedLabel;
    UILabel *_dateLabel;
    UILabel *_moneyLabel;
    UILabel *_timeLabel;

    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
    
}
- (void)setUpViews
{
    UILabel *weedLabel = [self createLabelWithTitle:nil Color:[UIColor colorWithHexString:@"333333"] WithFont:13 withBackGroundColor:[UIColor whiteColor]];
    UILabel *dateLabel = [self createLabelWithTitle:nil Color:[UIColor whiteColor] WithFont:13 withBackGroundColor:[UIColor colorWithHexString:@"39d5b8"]];
    dateLabel.layer.cornerRadius = 13;
    dateLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    dateLabel.layer.borderWidth = 1;
    dateLabel.layer.masksToBounds = YES;
    
    UILabel *moneyLabel = [self createLabelWithTitle:nil Color:[UIColor colorWithHexString:@"39d5b8"] WithFont:13 withBackGroundColor:[UIColor whiteColor]];
    moneyLabel.font = [UIFont boldSystemFontOfSize:13];
    
    UILabel *timeLabel = [self createLabelWithTitle:nil Color:[UIColor colorWithHexString:@"333333"] WithFont:13 withBackGroundColor:[UIColor whiteColor]];
    _weedLabel = weedLabel;
    _dateLabel = dateLabel;
    _moneyLabel = moneyLabel;
    _timeLabel = timeLabel;
    [self addSubview:_weedLabel];
    [self addSubview:_dateLabel];
    [self addSubview:_moneyLabel];
    [self addSubview:_timeLabel];

    _weedLabel.textAlignment = 1;
    _dateLabel.textAlignment = 1;
    _moneyLabel.textAlignment = 1;
    _timeLabel.textAlignment = 1;

    _weedLabel.text = @"周五";
    _dateLabel.text = @"4.1";
    _moneyLabel.text = @"30元";
    _timeLabel.text = @"18:00-次日8:00";
    
    __weak typeof(self)weakSelf = self;
    CGFloat topMargin = 6;
    
    [_weedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf).offset(topMargin);
        make.width.mas_lessThanOrEqualTo(100);
        
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_weedLabel.mas_centerX);
        make.top.mas_equalTo(_weedLabel.mas_bottom).offset(topMargin);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(26);
        
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_weedLabel.mas_centerX);
        make.top.mas_equalTo(_dateLabel.mas_bottom).offset(topMargin);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_weedLabel.mas_centerX);
        make.top.mas_equalTo(_moneyLabel.mas_bottom).offset(topMargin);
        make.width.mas_lessThanOrEqualTo(200);
    }];

    UIButton *btn = [UIButton new];
    [self addSubview:btn];
    btn.titleLabel.text = @"";
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(changeStyle) forControlEvents:(UIControlEventTouchUpInside)];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)changeStyle
{
    if (self.changeStyleBlock) {
        self.changeStyleBlock(self);
    }
    
}

- (void)setModel:(YuYueTimeModel *)model
{
    _model = model;
    _weedLabel.text = model.week;
    _dateLabel.text = model.date;
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",model.price];
    if ([model.week isEqualToString:@"周六"] || [model.week isEqualToString:@"周日"]) {
        if ([[model.startTime componentsSeparatedByString:@":"][0] intValue] < [[model.endTime componentsSeparatedByString:@":"][0] intValue]) {
            _timeLabel.text = [NSString stringWithFormat:@"%@-当日%@",model.startTime,model.endTime];
        }else
        {
            _timeLabel.text = [NSString stringWithFormat:@"%@-次日%@",model.startTime,model.endTime];
        }


    }else
    {
        if ([[model.startTime componentsSeparatedByString:@":"][0] intValue] < [[model.endTime componentsSeparatedByString:@":"][0] intValue]) {
            _timeLabel.text = [NSString stringWithFormat:@"%@-当日%@",model.startTime,model.endTime];
        }else
        {
            _timeLabel.text = [NSString stringWithFormat:@"%@-次日%@",model.startTime,model.endTime];
        }
        
    }
}

- (UILabel *)createLabelWithTitle:(NSString *)str Color:(UIColor *)color WithFont:(CGFloat)font withBackGroundColor:(UIColor *)bgColor
{
    
    UILabel *label = [UILabel new];
    label.text = str;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.font = [UIFont systemFontOfSize:font];
    return label;
    
}

- (void)setStyle:(ChooseTimeViewStyle)style
{
    _style = style;
    if (style == ChooseTimeViewStyleSelect) {
        _weedLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.backgroundColor = KMAIN_COLOR;
        _dateLabel.layer.borderColor = KMAIN_COLOR.CGColor;
        _moneyLabel.textColor = KMAIN_COLOR;
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13];
        _dateLabel.font = [UIFont boldSystemFontOfSize:13];

        _timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        
        
    }else if (style == ChooseTimeViewStyleUnSelect){
        _weedLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        _dateLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        _dateLabel.backgroundColor = [UIColor whiteColor];
        _moneyLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.font = [UIFont systemFontOfSize:13];

        _dateLabel.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
        _moneyLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        _timeLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        
    }
}
@end
