//
//  DaiBoOrderPriceCell.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaiBoOrderPriceCell.h"

@implementation DaiBoOrderPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UILabel *leftL = [UtilTool createLabelFrame:CGRectZero title:@"订单¥20 优惠¥5" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:15] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:leftL];
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    UILabel *priceL = [UtilTool createLabelFrame:CGRectZero title:@"¥15" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont boldSystemFontOfSize:18] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:priceL];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-15);
    }];
    
    
    UILabel *centerL = [UtilTool createLabelFrame:CGRectZero title:@"预计支付费用" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:15] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:centerL];
    [centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(priceL.mas_left).offset(-10);
    }];

}

@end
