//
//  AddressCell.m
//  P-SHARE
//
//  Created by fay on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AddressCell.h"
@interface AddressCell()
{
    UIImageView *_leftImageView;
    UILabel     *_titleL;
}
@end
@implementation AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    _leftImageView = [UIImageView new];
    _leftImageView.image = [UIImage imageNamed:@"location_collection"];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    _titleL = [UILabel new];
    _titleL.textColor = [UIColor colorWithHexString:@"696969"];
    _titleL.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(8);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-14);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightTextColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_leftImageView.mas_leading);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    
}

- (void)setModel:(MapSearchModel *)model
{
    _model = model;
    _titleL.text = model.searchTitle;
}
@end
