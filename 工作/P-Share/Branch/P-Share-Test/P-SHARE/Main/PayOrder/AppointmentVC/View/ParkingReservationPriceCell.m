//
//  ParkingReservationPriceCell.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ParkingReservationPriceCell.h"
#import "YuYueTimeModel.h"
@interface ParkingReservationPriceCell()
{
    UILabel *_priceL;
}
@end
@implementation ParkingReservationPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:@"停车价格" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:15] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    UILabel *priceL = [UtilTool createLabelFrame:CGRectZero title:@"¥10" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont boldSystemFontOfSize:18] textAlignment:0 numberOfLine:1];
    _priceL = priceL;
    [self.contentView addSubview:priceL];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(titleL);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
}
- (void)setYuYueTimeModel:(YuYueTimeModel *)yuYueTimeModel
{
    _yuYueTimeModel = yuYueTimeModel;
    if (yuYueTimeModel == nil) {
        _priceL.text = [NSString stringWithFormat:@"¥0"];

    }
    _priceL.text = [NSString stringWithFormat:@"¥%@",yuYueTimeModel.price];
    
}
@end
