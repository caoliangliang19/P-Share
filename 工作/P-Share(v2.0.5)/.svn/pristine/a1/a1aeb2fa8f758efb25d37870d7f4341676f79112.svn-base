//
//  CarBraneReusableView.m
//  P-Share
//
//  Created by fay on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarBraneReusableView.h"
@interface CarBraneReusableView()
{
    UILabel *_typeName;
    
}
@end

@implementation CarBraneReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UILabel *typeName = [UILabel new];
    _typeName = typeName;
    typeName.text = @"测试数据";
    [typeName sizeToFit];
    typeName.font = [UIFont systemFontOfSize:15];
    [self addSubview:typeName];
    
    
    [typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
}
- (void)setType:(CarBraneReusableViewType)type
{
    _type = type;
    if (type == CarBraneReusableViewNormal) {
        self.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
        _typeName.textColor = [MyUtil colorWithHexString:@"333333"];
    }else
    {
        self.backgroundColor = [UIColor whiteColor];
        _typeName.textColor = [MyUtil colorWithHexString:@"696969"];
    }
}
- (void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    _typeName.text = titleName;
}
@end
