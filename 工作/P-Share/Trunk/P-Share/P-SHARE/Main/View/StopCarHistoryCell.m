//
//  StopCarHistoryCell.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "StopCarHistoryCell.h"

@implementation StopCarHistoryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellUI];
    }
    return self;
}
- (void)createCellUI{
    UILabel *parkNameL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    self.parkNameL = parkNameL;
    [self addSubview:parkNameL];
    UILabel *orderstyleL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"39d5b8"] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight numberOfLine:0];
    self.orderstyleL = orderstyleL;
    [self addSubview:orderstyleL];
    UILabel *carNumberL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"aaaaaa"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    self.carNumberL = carNumberL;
    [self addSubview:carNumberL];
    UILabel *orderTimeL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"aaaaaa"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    self.ordertimeL = orderTimeL;
    [self addSubview:orderTimeL];
    UILabel *payMoneyL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"aaaaaa"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    self.PayMoneyL = payMoneyL;
    [self addSubview:payMoneyL];
    
}
- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 10);
    CGContextSetGrayStrokeColor(ctx, 0.9, 1.0);
    CGPoint points[] = {CGPointMake(0, 0), CGPointMake(SCREEN_WIDTH, 0)};
    CGContextStrokeLineSegments(ctx, points, 2);
}
- (void)setTableViewCellSize:(NSInteger)style passOn:(OrderModel *)model{
    [self.parkNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-SCREEN_WIDTH/3);
    }];
    [self.orderstyleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(self.parkNameL).offset(0);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [self.carNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.parkNameL.mas_bottom).offset(1);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];
    [self.ordertimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.carNumberL.mas_bottom).offset(1);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(150);
    }];
    [self.PayMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ordertimeL);
        make.right.mas_equalTo(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    self.parkNameL.text = model.parkingName;
    self.carNumberL.text = model.carNumber;
    if (style == 0) {
         self.orderstyleL.text = @"已付款";
    }else{
         self.orderstyleL.text = @"已完成";
    }
   
    self.ordertimeL.text = model.payTime;
    self.PayMoneyL.text = [NSString stringWithFormat:@"已付款:%@元",model.amountPaid];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
