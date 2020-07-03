//
//  TimeLineDaiBoCell.m
//  P-SHARE
//
//  Created by fay on 16/10/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TimeLineDaiBoCell.h"
@interface TimeLineDaiBoCell()

@end

@implementation TimeLineDaiBoCell

- (void)setUI
{
    [super setUI];
    self.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *mainLabel = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont boldSystemFontOfSize:15] textAlignment:0 numberOfLine:1];
    _mainLabel = mainLabel;
    
    UILabel *subLabel = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:13] textAlignment:0 numberOfLine:0];
    _subLabel = subLabel;
    
    UIImageView *parkImageView = [UIImageView new];
    parkImageView.layer.cornerRadius = 4;
//    parkImageView.layer.masksToBounds = YES;
    parkImageView.backgroundColor = [UIColor grayColor];
    _parkImageView = parkImageView;
    
    
    [self.contentView addSubview:_mainLabel];
    [self.contentView addSubview:_subLabel];
    [self.contentView addSubview:_parkImageView];

}
- (void)setDaiBoCellStyle:(TimeLineDaiBoCellStyle)daiBoCellStyle
{
    _daiBoCellStyle = daiBoCellStyle;
    _subLabel.hidden = YES;
    _parkImageView.hidden = YES;
    _mainLabel.hidden = NO;
    switch (daiBoCellStyle) {
        case TimeLineDaiBoCellStyleOneLine:
        {
            _mainLabel.mas_key = @"oneLine mainLabel";
            [_mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(28);
                make.height.mas_equalTo(20);
                make.bottom.mas_equalTo(-28);
                make.right.mas_equalTo(-20);
                make.left.mas_equalTo(self.bubbleImageV.mas_left).offset(20);
            }];
            [_mainLabel layoutIfNeeded];
            MyLog(@"_mainLabel %@",NSStringFromCGRect(_mainLabel.bounds));
            [self layoutSubviews];
            
        }
            break;
            
        case TimeLineDaiBoCellStyleTwoLine:
        {
            _subLabel.hidden = NO;
            _parkImageView.hidden = YES;
            _mainLabel.mas_key = @"TwoLine _mainLabel";
            [_mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(28);
                make.height.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.left.mas_equalTo(self.bubbleImageV.mas_left).offset(20);
            }];
            [_mainLabel layoutIfNeeded];
//            MyLog(@"_mainLabel %@",NSStringFromCGRect(_mainLabel.bounds));
            _subLabel.mas_key = @"TwoLine _subLabel";

            [_subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_mainLabel.mas_bottom).offset(14);
                make.height.mas_equalTo(20);
                make.bottom.mas_equalTo(-28);
                make.leading.mas_equalTo(_mainLabel.mas_leading);
                make.trailing.mas_equalTo(_mainLabel.mas_trailing);
            }];
            [self layoutSubviews];
        }
            break;
            
        case TimeLineDaiBoCellStyleTwoLineAddImage:
        {
            _subLabel.hidden = NO;
            _parkImageView.hidden = NO;
          
            _mainLabel.mas_key = @"ADDIMG _mainLabel";
            _subLabel.mas_key = @"ADDIMG _subLabel";
            _parkImageView.mas_key = @"ADDIMG _parkImageView";
            [_mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(28);
                make.height.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.left.mas_equalTo(self.bubbleImageV.mas_left).offset(20);
            }];
            [_mainLabel layoutIfNeeded];
            MyLog(@"ADDIMG_mainLabel %@",NSStringFromCGRect(_mainLabel.bounds));
            
            [_parkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_mainLabel.mas_bottom).offset(10);
                make.leading.mas_equalTo(_mainLabel.mas_leading);
                make.trailing.mas_equalTo(_mainLabel.mas_trailing);
                make.height.mas_equalTo(SCREEN_WIDTH*0.42);
            }];
            [_parkImageView layoutIfNeeded];
            MyLog(@"_parkImageView %@",NSStringFromCGRect(_parkImageView.bounds));
//
            [_subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_parkImageView.mas_bottom).offset(10);
                make.height.mas_equalTo(20);
                make.bottom.mas_equalTo(-28);
                make.leading.mas_equalTo(_mainLabel.mas_leading);
                make.trailing.mas_equalTo(_mainLabel.mas_trailing);
            }];
            [self layoutSubviews];
            
            
        }
            break;
            
        default:
            break;
    }
}
//- (CGSize)sizeThatFits:(CGSize)size
//{
//    MyLog(@"size--%@",NSStringFromCGSize(size));
//    
//
//    CGFloat totalHeight = 0;
//    if (self.daiBoCellStyle == TimeLineDaiBoCellStyleOneLine) {
//        totalHeight += [_mainLabel sizeThatFits:size].height;
//        
//    }else if (self.daiBoCellStyle == TimeLineDaiBoCellStyleTwoLine) {
//        totalHeight += [_mainLabel sizeThatFits:size].height;
//        totalHeight += [_subLabel sizeThatFits:size].height;
//    }else if (self.daiBoCellStyle == TimeLineDaiBoCellStyleTwoLineAddImage){
//        totalHeight += [_mainLabel sizeThatFits:size].height;
//        totalHeight += [_parkImageView sizeThatFits:size].height;
//        totalHeight += [_subLabel sizeThatFits:size].height;
//    }
//    MyLog(@"%f",totalHeight);
//    return CGSizeMake(size.width, totalHeight);
//}




@end
