//
//  DaoHangView.m
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaoHangView.h"
@interface DaoHangView()
{
    UILabel *_topLeftL;
    UILabel *_topRightL;
    UILabel *_centerL;
    UILabel *_bottomL;
}
@end
@implementation DaoHangView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UIView *conatinV = [UIView new];
    _containV = conatinV;
    [self addSubview:conatinV];
    
    UILabel *topLeftL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"333333"] font:[UIFont boldSystemFontOfSize:16] textAlignment:1 numberOfLine:1];
//    topLeftL.backgroundColor = [UIColor yellowColor];
    _topLeftL = topLeftL;
    
    UILabel *topRightL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
//    topRightL.backgroundColor = [UIColor redColor];
    
    _topRightL = topRightL;
    
    UILabel *centerL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
//    centerL.backgroundColor = [UIColor greenColor];
    _centerL = centerL;
    
    UILabel *bottomL = [MyUtil createLabelFrame:CGRectZero title:@"" textColor:[MyUtil colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
//    bottomL.backgroundColor = [UIColor blueColor];
    _bottomL = bottomL;
//    _containV.backgroundColor = [UIColor purpleColor];
    [_containV sd_addSubviews:@[topRightL,topLeftL,centerL,bottomL]];
    
    [self layoutViews];
}

- (void)layoutViews
{
    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
    }];
    
    [_topLeftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/2.5);
    }];
    
    [_topRightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topLeftL.mas_right).offset(4);
        make.right.mas_offset(-4);
        make.top.mas_equalTo(_topLeftL.mas_top);
        
    }];
    
    [_centerL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topLeftL.mas_leading);
        make.width.mas_lessThanOrEqualTo(_containV.mas_width);
        make.top.mas_equalTo(_topLeftL.mas_bottom).offset(10);
    }];
    
    [_bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topLeftL.mas_leading);
        make.top.mas_equalTo(_centerL.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo(_containV.mas_width);
    }];
}
- (void)setDataModel:(ParkingModel *)dataModel
{
    if (dataModel == nil) {
        [self layoutSubviews];

        return;
    }
    _dataModel = dataModel;
    _topLeftL.text = _dataModel.parkingName;
    _topLeftL.textAlignment = 2;
    _topRightL.text = _distance;
    _centerL.numberOfLines = 0;
    _bottomL.numberOfLines = 0;
    if (dataModel.parkingAddress == NULL) {
        dataModel.parkingAddress = @"";
    }
    
    if (dataModel.peacetimePrice == NULL) {
        dataModel.peacetimePrice = @"";
    }
    
  
    _centerL.textAlignment = 0;
    _centerL.text = [NSString stringWithFormat:@"地址:%@ ", dataModel.parkingAddress];
    _bottomL.textAlignment = 0;
    _bottomL.text = [NSString stringWithFormat:@"价格:%@",dataModel.peacetimePrice];
    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bottomL.mas_bottom);
    }];
    [self layoutSubviews];
    
}

@end
