//
//  ReservationParkingTimeCell.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ReservationParkingTimeCell.h"
@interface ReservationParkingTimeCell()
{
    UIImageView     *_leftImageView;
    UILabel         *_titleL;
    UILabel         *_timeL;

}
@end
@implementation ReservationParkingTimeCell

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
    _leftImageView = imageView;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(17, 17));
        
    }];
    
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:1];
    _titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(_leftImageView.mas_centerY);
    }];
    
    UILabel *timeL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:1];
    _timeL = timeL;
    [self.contentView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleL.mas_right).offset(10);
        make.centerY.mas_equalTo(_leftImageView.mas_centerY);
    }];
}
- (void)setReservationParkingTimeCellStyle:(ReservationParkingTimeCellStyle)reservationParkingTimeCellStyle
{
    _reservationParkingTimeCellStyle = reservationParkingTimeCellStyle;
    if (reservationParkingTimeCellStyle == ReservationParkingTimeCellStyleIn) {
        _titleL.text = @"入场时间";
        _leftImageView.image = [UIImage imageNamed:@"item_arrow_left"];
    }else
    {
        _titleL.text = @"出场时间";
        _leftImageView.image = [UIImage imageNamed:@"item_arrow_right"];

    }
}

@end
