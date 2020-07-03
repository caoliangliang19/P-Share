//
//  MonHeadView.m
//  P-Share
//
//  Created by 亮亮 on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MonHeadView.h"

@interface MonHeadView ()
{
    UILabel *_parkingNameL;
    UILabel *_carNumL;
    UILabel *_lastTimeL;
    UILabel *_singlePriceL;


}
@end

@implementation MonHeadView
- (instancetype)initWithView:(UIView *)View;{
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 155);
        self.backgroundColor = KBG_COLOR;
        [self createUI];
        [View addSubview:self];
    }
    return self;
}
- (void)createUI{
    UIView *greenView = [[UIView alloc]init];
    greenView.backgroundColor = KMAIN_COLOR;
    [self addSubview:greenView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"monthly_bg"]];
    [self addSubview:imageView];
    
    _parkingNameL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont boldSystemFontOfSize:18] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [imageView addSubview:_parkingNameL];
    
    CGFloat width = (SCREEN_WIDTH-34)/3;
    CGFloat height = 50;
    for (NSInteger i = 0; i < 3; i++) {
        UIView *otherView = [self addViewLable:CGRectMake(width*i, 80, width, height) line:i];
        [imageView addSubview:otherView];
    }
    
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(95);
        
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(greenView.mas_top).offset(0);
        make.bottom.mas_equalTo(-12);
    }];
    [_parkingNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(36);
    }];
    
}
- (UIView *)addViewLable:(CGRect)frame line:(NSInteger)index{
    UIView *lableView = [[UIView alloc]initWithFrame:frame];
    UILabel *topLable = [UtilTool createLabelFrame:CGRectZero title:nil textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [lableView addSubview:topLable];
    UILabel *bottom = [UtilTool createLabelFrame:CGRectZero title:nil textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [lableView addSubview:bottom];
    if (index == 0) {
       topLable.text = @"车牌号";
       bottom.text = @"";
        _carNumL = bottom;
    }else if (index == 1){
       topLable.text = @"剩余到期天数";
        bottom.text = @"";
        _lastTimeL = bottom;

    }else if (index == 2){
       topLable.text = @"月租单价";
         bottom.text = @"";
        _singlePriceL = bottom;
    }
    [topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    return lableView;
}
- (void)setParkingModel:(OrderModel *)parkingModel
{
    _parkingModel       = parkingModel;
    _parkingNameL.text  = parkingModel.parkingName;
    _carNumL.text       = parkingModel.carNumber;
    _singlePriceL.text  = [NSString stringWithFormat:@"%@元/月",parkingModel.price];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    MyLog(@"%@    %@",[formatter dateFromString:_parkingModel.beginDate],[formatter dateFromString:_parkingModel.endDate]);
    
    _lastTimeL.text = [UtilTool mathTimeDifferenceWith:[formatter dateFromString:_parkingModel.beginDate] otherTime:[formatter dateFromString:_parkingModel.endDate]];
}


@end
