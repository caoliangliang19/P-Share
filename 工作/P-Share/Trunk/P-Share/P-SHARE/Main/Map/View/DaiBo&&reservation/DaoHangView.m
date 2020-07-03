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
    
    UILabel *topLeftL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont boldSystemFontOfSize:16] textAlignment:1 numberOfLine:1];
    _topLeftL = topLeftL;
    
    UILabel *topRightL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _topRightL = topRightL;
    
    UILabel *centerL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _centerL = centerL;
    
    UILabel *bottomL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _bottomL = bottomL;
    [_containV addSubview:topRightL];
    [_containV addSubview:topLeftL];
    [_containV addSubview:centerL];
    [_containV addSubview:bottomL];
    [self layoutViews];
}

- (void)layoutViews
{
    _topLeftL.mas_key = @"daHangV.topLeftL";
    [_topLeftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(6);
        make.right.mas_lessThanOrEqualTo(_containV.mas_right).offset(40);
    }];
    _topRightL.mas_key = @"daHangV.topRightL";

    [_topRightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topLeftL.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(-4);
        make.top.mas_equalTo(_topLeftL.mas_top);
        
    }];
    _centerL.mas_key = @"daHangV.centerL";

    [_centerL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topLeftL.mas_leading);
        make.width.mas_lessThanOrEqualTo(_containV.mas_width);
        make.top.mas_equalTo(_topLeftL.mas_bottom).offset(6);
    }];
    _bottomL.mas_key = @"daHangV.bottomL";

    [_bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_topLeftL.mas_leading);
        make.top.mas_equalTo(_centerL.mas_bottom).offset(6);
        make.width.mas_lessThanOrEqualTo(_containV.mas_width);
    }];
    _containV.mas_key = @"daHangV.containV";

    [_containV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bottomL.mas_bottom);
        make.right.left.top.mas_equalTo(0);
    }];

}
- (void)setDataModel:(Parking *)dataModel
{
    if (dataModel == nil) {
        return;
    }
    _dataModel = dataModel;
    _topLeftL.text = _dataModel.parkingName;
    _topLeftL.textAlignment = 0;
    _topRightL.text = _dataModel.distance;
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
    
    
}

@end
