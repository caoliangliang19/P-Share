//
//  CarListCell.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "CarListCell.h"

@interface CarListCell()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *driveDistance;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *driveTime;
@property (weak, nonatomic) IBOutlet UILabel *carInfo;
@end
@implementation CarListCell

- (void)setCar:(Car *)car
{
    _car = car;
    
    self.carNameLabel.text = car.carName;
    self.carNumLabel.text = car.carNumber;
    if ([UtilTool isBlankString:car.travlledDistance] == NO&&[UtilTool isBlankString:car.carUseDate] == NO) {
        self.lineView.hidden = NO;
    }else{
        self.lineView.hidden = YES;
    }
    if ([UtilTool isBlankString:car.travlledDistance] == YES) {
        self.driveDistance.text = @"";
    }else{
        self.driveDistance.text =[NSString stringWithFormat:@"行驶里程 %@km",car.travlledDistance];
    }
    if ([UtilTool isBlankString:car.carUseDate] == YES) {
        self.driveTime.text =@"";
    }else{
        self.driveTime.text =[NSString stringWithFormat:@"上路时间 %@",car.carUseDate];
    }
    
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:car.brandIcon] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    if ([car.isAutoPay integerValue] == 1) {
        self.carInfo.text = @"已开启钱包自动支付";
        [self.carInfo setTextColor:[UIColor colorWithHexString:@"39D5B8"]];
        
    }else
    {
        self.carInfo.text = @"未开启钱包自动支付";
        [self.carInfo setTextColor:[UIColor colorWithHexString:@"A7A7A7"]];
        
    }

    
}
- (IBAction)editButtonClick:(id)sender {
    if (self.carListCellBlock) {
        self.carListCellBlock(self);
    }
}

@end
