//
//  TagCollectionViewCell.m
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TagCollectionViewCell.h"
#import "TagModel.h"
@interface TagCollectionViewCell()
{
    UILabel         *_tagL;
    UIImageView     *_imageV;


}
@end
@implementation TagCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setSubViews];
        
    }
    return self;
}

- (void)setSubViews
{

    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"696969"];
    _tagL = label;
    UIImageView *imageV = [UIImageView new];
    _imageV = imageV;
    [self addSubview:label];
    [self addSubview:imageV];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-20);
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label.mas_centerY);
        make.left.mas_equalTo(label.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}
- (void)setSelect:(TagCollectionViewCellSelect)select
{
    _select = select;
    if (select == TagCollectionViewCellSelected) {
        
        self.layer.borderColor = [UIColor colorWithHexString:@"39d5b8"].CGColor;
        _tagL.textColor = [UIColor colorWithHexString:@"39d5b8"];
        
        if (_style == TagCollectionViewCellZan) {
            
            _imageV.image = [UIImage imageNamed:@"selectedZan_v2.01"];
            
        }else
        {
            _imageV.image = [UIImage imageNamed:@"selectedCai_v2.01"];

        }
        
    }else
    {
        self.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        _tagL.textColor = [UIColor colorWithHexString:@"696969"];
        if (_style == TagCollectionViewCellZan) {
            _imageV.image = [UIImage imageNamed:@"unselectSmallZan_v2.0.1"];

        }else
        {
            _imageV.image = [UIImage imageNamed:@"unselectCai_v2.0.1"];

        }
    }
}

- (void)setModel:(TagModel *)model
{
    _model = model;
    if (model.isZan) {
        self.style = TagCollectionViewCellZan;
    }else
    {
        self.style = TagCollectionViewCellCai;
    }
    
    if (model.isSelect) {
        self.select = TagCollectionViewCellSelected;
    }else
    {
        self.select = TagCollectionViewCellUnSelect;

    }
    _tagL.text = model.info;
    [self layoutIfNeeded];
    
}
@end
