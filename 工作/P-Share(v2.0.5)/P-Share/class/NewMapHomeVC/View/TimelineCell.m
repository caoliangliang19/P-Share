//
//  TimelineCell.m
//  P-Share
//
//  Created by fay on 16/6/16.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TimelineCell.h"
#import "TimeLineView.h"
#import "UITableView+FDIndexPathHeightCache.h"
@interface TimelineCell ()
{
    TimeLineView    *_timeLineView;
    UIImageView     *_dotImageV;
}
@end
@implementation TimelineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.layer.masksToBounds = YES;
    _lineView = lineView;
    [self.contentView addSubview:_lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    UIImageView *dotImageV = [UIImageView new];
    _dotImageV = dotImageV;
    dotImageV.backgroundColor = [MyUtil colorWithHexString:@"6c7e8d"];
    dotImageV.layer.cornerRadius = 4.5;
    dotImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:dotImageV];
    [dotImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.centerX.mas_equalTo(_lineView);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];

    
    TimeLineView *timeLineView = [[TimeLineView alloc]init];
    _timeLineView = timeLineView;
    [self.contentView addSubview:timeLineView];
    
}
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [_timeLineView sizeThatFits:size].height;
    MyLog(@"%f",totalHeight);
    return CGSizeMake(size.width, totalHeight);
    
}

#pragma mark --- 先给出类型  再给出状态
- (void)setPayStatus:(int)payStatus
{
    _payStatus = payStatus;
    if (_timeLineView.timeLinePayStyle == TimeLineViewPayTypeDaiBo) {
        _timeLineView.timeLineDaiBoSatus = payStatus;
    }else if (_timeLineView.timeLinePayStyle == TimeLineViewPayTypeYuYueParking)
    {
        _timeLineView.parkCode = self.temModel.parkingCode;
        _timeLineView.timeLineYuYueSatus = payStatus;
    }
    
    [_timeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
    }];
    [_timeLineView layoutIfNeeded];
    MyLog(@"===========%f",_timeLineView.bgImageV.frame.size.height);

    [self layoutSubviews];
    
    
}
/*
 timeString;
 daiBoPerson
 mageArray;
 phone;
 */

- (void)setPayTyle:(int)payTyle
{
    _payTyle = payTyle;
    if (payTyle == 0) {
        _timeLineView.timeLinePayStyle = TimeLineViewPayTypeDaiBo;
    }else if (payTyle == 1){
        _timeLineView.timeLinePayStyle = TimeLineViewPayTypeYuYueParking;
    }
}



- (void)setCellPosition:(TimelineCellPosition)cellPosition
{
    
    _cellPosition = cellPosition;
    _dotImageV.image = nil;
    _dotImageV.backgroundColor = [MyUtil colorWithHexString:@"6c7e8d"];
    
    if (_payTyle == 0) {
        [_dotImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(55);
            make.centerX.mas_equalTo(_lineView);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
    }else if (_payTyle == 1){
        [_dotImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.centerY).offset(0);
            make.centerX.mas_equalTo(_lineView);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
    }

    switch (cellPosition) {
        case TimelineCellPositionTop:
        {
            
            if (_totalRowNum==1) {
                [_dotImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(55);
                    make.size.mas_equalTo(CGSizeMake(18, 18));
                }];
                _dotImageV.backgroundColor = [UIColor clearColor];

                _dotImageV.image = [UIImage imageNamed:@"TimeLineDot_v2"];
            }else
            {
                [_dotImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(54);
                    make.size.mas_equalTo(CGSizeMake(9, 9));
                }];
            }

            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.top.mas_equalTo(_dotImageV.mas_top);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(1);
            }];
        }
            break;
            
        case TimelineCellPositionMiddle:
        {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(1);
            }];
            [_dotImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(57);
                make.size.mas_equalTo(CGSizeMake(9, 9));
            }];
        }
            break;
            
        case TimelineCellPositionBottom:
        {
            [_dotImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(55);

                make.size.mas_equalTo(CGSizeMake(18, 18));
            }];
            _dotImageV.backgroundColor = [UIColor clearColor];
            
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(_dotImageV.mas_bottom);
                make.width.mas_equalTo(1);
            }];
            _dotImageV.image = [UIImage imageNamed:@"TimeLineDot_v2"];
            
        }
            break;
        default:
            break;
    }
}
- (void)awakeFromNib
{
    //     Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}


@end
