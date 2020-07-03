//
//  RadioCell.m
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RadioCell.h"

@implementation RadioCell

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
    imageView.image = [UIImage imageNamed:@"unselect"];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius = 8.5f;
    imageView.layer.masksToBounds = YES;
    _leftImageV = imageView;
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
        make.left.mas_equalTo(_leftImageV.mas_right).offset(10);
        make.centerY.mas_equalTo(_leftImageV.mas_centerY);
    }];
}
- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (isSelect) {
        _leftImageV.image = [UIImage imageNamed:@"selected"];
    }else
    {
        _leftImageV.image = [UIImage imageNamed:@"unselect"];

    }
    
}
@end
