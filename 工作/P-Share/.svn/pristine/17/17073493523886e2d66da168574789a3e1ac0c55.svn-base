//
//  GrowthValueListCell.m
//  P-Share
//
//  Created by fay on 16/8/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "GrowthValueListCell.h"

@implementation GrowthValueListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubView];
    }
    return self;
}
- (void)setSubView
{
//    比例 4:4:3:2
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    NSArray *temArr = @[@"16-03-02 07:00",@"京A12345",@"回家",@"+100"];
    for (int i=0; i<4; i++) {
        UILabel *label = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:0];
        label.textAlignment = 1;
        label.backgroundColor = [UIColor whiteColor];
        label.text = temArr[i];
        label.tag = 100 + i;
        [self.contentView addSubview:label];
    }
    UILabel *label1 = [self.contentView viewWithTag:100];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(1);
        make.bottom.mas_equalTo(-0.5);
        make.width.mas_equalTo(SCREEN_WIDTH*4/13 - 0.5);
    }];
    UILabel *label2 = [self.contentView viewWithTag:101];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).offset(0.5);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
        make.width.mas_equalTo(SCREEN_WIDTH*4/13 - 0.5);
    }];
    UILabel *label3 = [self.contentView viewWithTag:102];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).offset(0.5);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
        make.width.mas_equalTo(SCREEN_WIDTH*3/13 - 0.5);
    }];
    UILabel *label4 = [self.contentView viewWithTag:103];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right).offset(0.5);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-1);
        make.width.mas_equalTo(SCREEN_WIDTH*2/13 - 0.5);
    }];
    
    
}

- (void)setColorStyle:(GrowthValueListCellColorStyle)colorStyle
{
    _colorStyle = colorStyle;
    for (UIView *subLable in self.contentView.subviews) {
        if ([subLable isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subLable;
            
            if (colorStyle == GrowthValueListCellColorStyleGray) {
                label.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
                label.textColor = [UIColor colorWithHexString:@"959595"];
            }else
            {
                label.backgroundColor = [UIColor whiteColor];
                label.textColor = [UIColor colorWithHexString:@"959595"];
                if (label.tag == 103) {
                    label.textColor = [UIColor colorWithHexString:@"ffc51f"];

                }
            }
        }
    }

}

@end
