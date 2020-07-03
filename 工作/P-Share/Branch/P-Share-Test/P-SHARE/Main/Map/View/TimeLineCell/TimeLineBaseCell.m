//
//  TimeLineBaseCell.m
//  P-SHARE
//
//  Created by fay on 16/10/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TimeLineBaseCell.h"
@interface TimeLineBaseCell()
@property (nonatomic,strong)UIImageView              *dotImageV;


@end
@implementation TimeLineBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
}
- (void)setUI
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.layer.masksToBounds = YES;
    _lineView = lineView;
    [self.contentView addSubview:_lineView];
    
    
    UIImageView *dotImageV = [UIImageView new];
    _dotImageV = dotImageV;
    dotImageV.backgroundColor = [UIColor colorWithHexString:@"6c7e8d"];
    dotImageV.layer.cornerRadius = 9;
    dotImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:dotImageV];
    
    
    UIImageView *bubbleImageV = [UIImageView new];
    bubbleImageV.image = [UIImage imageNamed:@"prompt_timeLine"];
    _bubbleImageV = bubbleImageV;
    [self.contentView addSubview:bubbleImageV];
}
- (void)setPositionStyle:(TimeLineBaseCellPositionStyle)positionStyle
{
    _positionStyle = positionStyle;
    switch (positionStyle) {
            
        case TimeLineBaseCellPositionStyleSingleTop:
        {
            _dotImageV.layer.cornerRadius = 9;
            _dotImageV.image = [UIImage imageNamed:@"TimeLineDot_v2"];
            _lineView.hidden = YES;
            [_dotImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_top).offset(34);
                make.centerX.mas_equalTo(self.contentView.mas_left).offset(22);
                make.size.mas_equalTo(CGSizeMake(18, 18));
            }];
            [_bubbleImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_dotImageV.mas_centerX).offset(14);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.right.mas_equalTo(-14);
            }];
            MyLog(@"image size :%@",NSStringFromCGSize(_bubbleImageV.image.size));
            
            _bubbleImageV.image = [[UIImage imageNamed:@"prompt_timeLine"] stretchableImageWithLeftCapWidth:80 topCapHeight:40];
            
            
        }
            break;
            
            
        case TimeLineBaseCellPositionStyleTop:
        {
            _dotImageV.image = nil;
            _dotImageV.layer.cornerRadius = 4.5;
            _lineView.hidden = NO;
            [_dotImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_top).offset(34);

                make.centerX.mas_equalTo(self.contentView.mas_left).offset(22);
                make.size.mas_equalTo(CGSizeMake(9, 9));
            }];
            
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_dotImageV);
                make.top.mas_equalTo(_dotImageV.mas_bottom);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(1);
            }];
            [_bubbleImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_dotImageV.mas_centerX).offset(14);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.right.mas_equalTo(-15);
            }];
            _bubbleImageV.image = [[UIImage imageNamed:@"prompt_timeLine"] stretchableImageWithLeftCapWidth:80 topCapHeight:40];
            

        }
            break;
        case TimeLineBaseCellPositionStyleMiddle:
        {
            _dotImageV.image = nil;
            _dotImageV.layer.cornerRadius = 4.5;
            _lineView.hidden = NO;
            [_dotImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_top).offset(34);
                make.centerX.mas_equalTo(self.contentView.mas_left).offset(22);
                make.size.mas_equalTo(CGSizeMake(9, 9));
            }];
            
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_dotImageV);
                make.top.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView);
                make.width.mas_equalTo(1);
            }];
            [_bubbleImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_dotImageV.mas_centerX).offset(14);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.right.mas_equalTo(-15);
            }];
            _bubbleImageV.image = [[UIImage imageNamed:@"prompt_timeLine"] stretchableImageWithLeftCapWidth:80 topCapHeight:40];
            
        }
            break;
        case TimeLineBaseCellPositionStyleBottom:
        {
            _dotImageV.image = [UIImage imageNamed:@"TimeLineDot_v2"];
            _dotImageV.layer.cornerRadius = 9;
            _lineView.hidden = NO;
            [_dotImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_top).offset(34);
                
                make.centerX.mas_equalTo(self.contentView.mas_left).offset(22);
                make.size.mas_equalTo(CGSizeMake(18, 18));
            }];
            
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_dotImageV);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(_dotImageV.mas_top);
                make.width.mas_equalTo(1);
            }];
            [_bubbleImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_dotImageV.mas_centerX).offset(14);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.right.mas_equalTo(-15);
            }];

            _bubbleImageV.image = [[UIImage imageNamed:@"prompt_timeLine"] stretchableImageWithLeftCapWidth:80 topCapHeight:40];
            

        }
            break;
            
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
