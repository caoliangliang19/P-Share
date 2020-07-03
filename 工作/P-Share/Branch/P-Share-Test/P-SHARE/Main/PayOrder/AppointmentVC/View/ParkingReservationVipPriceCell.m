//
//  ParkingReservationVipPriceCell.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ParkingReservationVipPriceCell.h"
@interface ParkingReservationVipPriceCell()
{
    UIImageView *_imageV;
    UILabel     *_titleL;
    UILabel     *_priceL;
}
@end

@implementation ParkingReservationVipPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = KMAIN_COLOR;
    imageView.layer.cornerRadius = 8.5f;
    imageView.layer.masksToBounds = YES;
    _imageV = imageView;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(17, 17));
        
    }];
    
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:@"金卡会员专享价" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:1];
    _titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageV.mas_right).offset(10);
        make.centerY.mas_equalTo(_imageV.mas_centerY);
    }];
    
    UILabel *priceL = [UtilTool createLabelFrame:CGRectZero title:@"¥9" textColor:[UIColor colorWithHexString:@"fec438"] font:[UIFont systemFontOfSize:18] textAlignment:0 numberOfLine:1];
    _priceL = priceL;
    [self.contentView addSubview:priceL];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_imageV.mas_centerY);
    }];
}

@end
