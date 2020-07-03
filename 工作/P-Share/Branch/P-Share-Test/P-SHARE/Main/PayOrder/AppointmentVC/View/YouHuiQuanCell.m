//
//  YouHuiQuanCell.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YouHuiQuanCell.h"

@implementation YouHuiQuanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UILabel *topLeftL = [UtilTool createLabelFrame:CGRectZero title:@"优惠券" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:15] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:topLeftL];
    [topLeftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12.5);
    }];
    
    UILabel *bottomLeftL = [UtilTool createLabelFrame:CGRectZero title:@"请在提交订单后使用" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:bottomLeftL];
    [bottomLeftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(topLeftL.mas_leading);
        make.top.mas_equalTo(topLeftL.mas_bottom).offset(10);
    }];
    
    UILabel *topRightL = [UtilTool createLabelFrame:CGRectZero title:@"3张" textColor:KMAIN_COLOR font:[UIFont systemFontOfSize:15] textAlignment:0 numberOfLine:1];
    [self.contentView addSubview:topRightL];
    [topRightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLeftL.mas_top);
        make.right.mas_equalTo(-15);
    }];
    
}
@end
