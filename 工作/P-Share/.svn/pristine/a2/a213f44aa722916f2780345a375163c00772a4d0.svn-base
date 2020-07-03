//
//  DistanceCell.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "DistanceCell.h"

@implementation DistanceCell
+(instancetype)instanceTableView:(UITableView *)tableView;{
    DistanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[DistanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UILabel *distanceL = [UtilTool createLabelFrame:CGRectZero title:@"优惠停车" textColor:[UIColor colorWithHexString:@"39d5b8"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft numberOfLine:0];
        self.distanceTypeL = distanceL;
        [bgView addSubview:distanceL];
        
        UILabel *parkingNameL = [UtilTool createLabelFrame:CGRectZero title:@"恒积大厦" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft numberOfLine:0];
        self.parkingNameL = parkingNameL;
        [bgView addSubview:parkingNameL];
        
        UILabel *payTimeL = [UtilTool createLabelFrame:CGRectZero title:@"支付时间" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter numberOfLine:0];
        self.payTimeL = payTimeL;
        [bgView addSubview:payTimeL];
        
        UILabel *carNumber = [UtilTool createLabelFrame:CGRectZero title:@"沪A12345" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight numberOfLine:0];
        [bgView addSubview:carNumber];
        self.carNumberL = carNumber;
        UIButton *distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        distanceBtn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
        [distanceBtn setTitle:@"查看凭证" forState:UIControlStateNormal];
        [distanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        distanceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.lookUpBtn = distanceBtn;
        [distanceBtn addTarget:self action:@selector(lookUpClick) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:distanceBtn];
        [self createFrame];
    }
    return self;
}
- (void)createFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.distanceTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(6);
        make.width.mas_equalTo(100);
    }];
    [self.payTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(6);
    }];
    [self.parkingNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.distanceTypeL.mas_bottom).offset(7);
        make.bottom.mas_equalTo(self.payTimeL.mas_top).offset(-9);
        make.left.mas_equalTo(6);
    }];
    [self.carNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-6);
        make.width.mas_equalTo(100);
    }];
    [self.lookUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(82);
    }];
    
}
- (void)upDataModel:(OrderModel *)model{
    if ([UtilTool isBlankString:model.parkingName] == NO) {
        self.parkingNameL.text =[NSString stringWithFormat:@"%@", model.parkingName];
    }
    if ([UtilTool isBlankString:model.payTime] == NO) {
        self.payTimeL.text =[NSString stringWithFormat:@"支付时间:%@", model.payTime];
    }
    if ([UtilTool isBlankString:model.carNumber] == NO) {
        self.carNumberL.text =[NSString stringWithFormat:@"%@", model.carNumber];
    }
  
    
}
- (void)lookUpClick{
    if (self.lookUpPingZ) {
        self.lookUpPingZ(self.index);
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
