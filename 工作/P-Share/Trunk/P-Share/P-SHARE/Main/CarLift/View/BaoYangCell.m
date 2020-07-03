//
//  BaoYangCell.m
//  P-Share
//
//  Created by fay on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "BaoYangCell.h"
@interface BaoYangCell()
{
    UILabel         *_titleL;
    UILabel         *_subTitleL;
    UIImageView     *_imageV;
}
@end

@implementation BaoYangCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubView];
        
    }
    return self;
}

- (void)setUpSubView
{
    UILabel *titleL = [UILabel new];
    _titleL = titleL;
    titleL.textColor = [UIColor colorWithHexString:@"3eb5f3"];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.text = @"";
    titleL.numberOfLines = 0;
    [self.contentView addSubview:titleL];
    
    UILabel *subTitleL = [UILabel new];
    _subTitleL = subTitleL;
    subTitleL.numberOfLines = 0;
    subTitleL.textColor = [UIColor colorWithHexString:@"999999"];
    subTitleL.font = [UIFont systemFontOfSize:13];
    subTitleL.text = @"";
    [self.contentView addSubview:subTitleL];
    
    UIImageView *imageV = [UIImageView new];
    _imageV = imageV;
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(76, 76));
        make.width.mas_equalTo(SCREEN_WIDTH*0.2);
        make.height.mas_equalTo(imageV.mas_width);
        make.right.mas_equalTo(-10);
    }];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(imageV.mas_left).offset(-10);
        
    }];
    
    [subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset(5);
        make.leading.mas_equalTo(titleL.mas_leading);
        make.trailing.mas_equalTo(titleL.mas_trailing);
        
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _titleL.text = dataDic[@"weekupTitle"];
    _subTitleL.text = dataDic[@"weekupContent"];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:dataDic[@"weekupIcon"]] placeholderImage:nil];
}
@end
