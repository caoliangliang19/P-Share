//
//  TimeLineYuYueCell.m
//  P-SHARE
//
//  Created by fay on 16/10/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TimeLineYuYueCell.h"
#import "UITableView+FDIndexPathHeightCache.h"
@interface TimeLineYuYueCell()
@property (nonatomic,strong)UILabel *mainLabel,*subLabel;

@end
@implementation TimeLineYuYueCell


- (void)setUI
{
    [super setUI];
    UILabel *mainLabel = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont boldSystemFontOfSize:15] textAlignment:0 numberOfLine:1];
    _mainLabel = mainLabel;
    
    UILabel *subLabel = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:0];
    _subLabel = subLabel;
    
    [self.contentView addSubview:_mainLabel];
    [self.contentView addSubview:_subLabel];

    
    
    
}
//- (CGSize)sizeThatFits:(CGSize)size
//{
//    CGFloat totalHeight = 0;
//    totalHeight += [_mainLabel sizeThatFits:size].height;
//    if (self.yuYueCellStyle == TimeLineYuYueCellStyleLineTwo) {
//        totalHeight += [_subLabel sizeThatFits:size].height;
//    }
//    MyLog(@"%f",totalHeight);
//    return CGSizeMake(size.width, totalHeight);
//    
//}
- (void)setYuYueCellStyle:(TimeLineYuYueCellStyle)yuYueCellStyle
{
    _yuYueCellStyle = yuYueCellStyle;
    if (yuYueCellStyle == TimeLineYuYueCellStyleLineOne) {
        _subLabel.hidden = YES;
        [_mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(28);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(-28);
            make.right.mas_equalTo(-14);
            make.left.mas_equalTo(self.bubbleImageV.mas_left).offset(20);
        }];
        [_mainLabel layoutIfNeeded];
        MyLog(@"_mainLabel %@",NSStringFromCGRect(_mainLabel.bounds));
        _mainLabel.text = [NSString stringWithFormat:@"预约%@车位",self.orderModel.parkingName];
        _subLabel.text = @"";
        [self layoutSubviews];
    }else
    {
        _subLabel.hidden = NO;

        _mainLabel.text = @"预约车位成功";
        if (![UtilTool isBlankString:self.orderModel.parkingCode]) {
            NSMutableString *code = [NSMutableString stringWithString:self.orderModel.parkingCode];
            [code insertString:@"-" atIndex:4];
            [code insertString:@"-" atIndex:2];
            _subLabel.text =  [NSString stringWithFormat:@"停车码:%@",code];
        }
        [_mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(28);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-14);
            make.left.mas_equalTo(self.bubbleImageV.mas_left).offset(20);
        }];
        [_mainLabel layoutIfNeeded];
        MyLog(@"_mainLabel %@",NSStringFromCGRect(_mainLabel.bounds));
        [_subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mainLabel.mas_bottom).offset(14);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(-28);
            make.leading.mas_equalTo(_mainLabel.mas_leading);
            make.trailing.mas_equalTo(_mainLabel.mas_trailing);
        }];
        [self layoutSubviews];

    }
}

@end
