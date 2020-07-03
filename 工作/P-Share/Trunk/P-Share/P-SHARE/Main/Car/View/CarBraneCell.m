//
//  CarBraneCell.m
//  P-Share
//
//  Created by fay on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarBraneCell.h"
@interface CarBraneCell()
{
    UIImageView     *_braneHeadImg;
    UILabel         *_braneNameL;
    UIView          *_lineV;
}
@end

@implementation CarBraneCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUpSubView];
    }
    
    return self;
}

- (void)setUpSubView
{
    UIImageView *braneHeadImg = [UIImageView new];
    braneHeadImg.image = [UIImage imageNamed:@"carImg"];

    _braneHeadImg = braneHeadImg;
    [self.contentView addSubview:braneHeadImg];
    
    UILabel *braneNameL = [UILabel new];
    braneNameL.text = @"奥迪A4";
    braneNameL.textColor = [UIColor colorWithHexString:@"333333"];
    _braneNameL = braneNameL;
    [self.contentView addSubview:braneNameL];
    
    UIView *lineV = [UIView new];
    _lineV = lineV;
    lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)setType:(CarBraneCellType)type
{
    _type = type;
    if (type == CarBraneCellTypeNormal) {
        _braneNameL.font = [UIFont systemFontOfSize:15];
        [_braneHeadImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.mas_equalTo(14);
            make.centerY.mas_equalTo(self);
            
        }];
        
        [_braneNameL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_braneHeadImg.mas_centerY);
            make.left.mas_equalTo(_braneHeadImg.mas_right).offset(8);
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 90);
        }];

        
    }else
    {
        _braneNameL.font = [UIFont systemFontOfSize:14];
        [_braneHeadImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(-4);
            
        }];
        
        [_braneNameL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo((SCREEN_WIDTH-28)/5);
            make.centerX.mas_equalTo(_braneHeadImg.mas_centerX);
            make.top.mas_equalTo(_braneHeadImg.mas_bottom).offset(4);
        }];
    }
}
- (void)setDataDic:(NSDictionary *)dataDic
{

    _dataDic = dataDic;
    
    [_braneHeadImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"brandIcon"]] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    
    _braneNameL.text = dataDic[@"brandName"];
    
}
- (void)setNeedLine:(BOOL)needLine
{
    _needLine = needLine;
    if (needLine) {
        _lineV.hidden = NO;
    }else
    {
        _lineV.hidden = YES;

    }
}
@end
