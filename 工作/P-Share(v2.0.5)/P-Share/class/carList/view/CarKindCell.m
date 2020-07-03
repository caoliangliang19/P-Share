//
//  CarKindCell.m
//  P-Share
//
//  Created by fay on 16/4/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarKindCell.h"

@implementation CarKindCell
{
    UILabel *_nameL;
    UIImageView *_imageV;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *nameL = [UILabel new];
        nameL.font = [UIFont systemFontOfSize:15];
        nameL.textColor = [MyUtil colorWithHexString:@"333333"];
        _nameL = nameL;
        
        UIImageView *imageV = [UIImageView new];
        _imageV = imageV;
        
        
        [self.contentView sd_addSubviews:@[nameL,imageV]];
        
        [self layoutSubviews];
        
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    _nameL.text = _carName;
    
    [_nameL makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(14);
    }];
    
    
    [_imageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameL);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(-14);
        
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.left.mas_equalTo(14);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        
    }];
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
