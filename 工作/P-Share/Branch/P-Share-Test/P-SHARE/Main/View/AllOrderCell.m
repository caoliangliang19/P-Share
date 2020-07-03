//
//  OrderCell.m
//  P-Share
//
//  Created by 亮亮 on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "AllOrderCell.h"

@implementation AllOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancleBtn.layer.cornerRadius = 3;
    self.otherBtn.layer.cornerRadius = 3;
    self.cancleBtn.clipsToBounds = YES;
    self.otherBtn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(UIButton *)myBtn;{
    if ([self.delegate respondsToSelector:@selector(clickBtn:row:)]) {
        [self.delegate clickBtn:myBtn.tag row:self.row];
    }
}
- (void)upDataCell:(OrderModel *)model indexPathRow:(NSInteger)row{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.row = row;
    self.StopCarType.text = model.orderTypeName;
    self.paidMoney.text =[NSString stringWithFormat:@"¥%@",model.amountPaid];
    self.parkingName.text = model.parkingName;
    self.parkingTime.text = model.createDate;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self cellIsDataLoad:model];
}
- (void)cellIsDataLoad:(OrderModel *)model{
    if ([model.orderType integerValue] == 12) {
        if ([model.orderStatus integerValue] == 1) {
            self.orderState.text = @"已预约";
            
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = NO;
            [self.otherBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
        }else if ([model.orderStatus integerValue] == 2) {
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = YES;
            self.orderState.text = @"停车中";
            
        }else if ([model.orderStatus integerValue] == 4) {
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = NO;
            self.orderState.text = @"停车完毕";
            [self.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
            
        }else if ([model.orderStatus integerValue] == 14) {
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = NO;
            self.orderState.text = @"泊回中";
            [self.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
        }else if ([model.orderStatus integerValue] == 15) {
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = NO;
            self.orderState.text = @"已泊回";
            [self.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
        }else if ([model.orderStatus integerValue] == 8) {
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = YES;
            self.orderState.text = @"取车中";
        }else if ([model.orderStatus integerValue] == 9) {
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = YES;
            self.orderState.text = @"交车";
        }else if ([model.orderStatus integerValue] == 5) {
            self.orderState.text = @"已完成";
            
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = NO;
            if ([model.isComment integerValue] == 0) {
                [self.otherBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
            }else{
                [self.otherBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                [self.otherBtn setTitleColor:[UIColor colorWithHexString:@"39d5b8"] forState:UIControlStateNormal];
                [self.otherBtn setBackgroundColor:[UIColor clearColor]];
            }
        }else if ([model.orderStatus integerValue] == 12) {
            
        }
    }else{
        if ([model.orderStatus integerValue] == 10) {
            self.orderState.text = @"待付款";
            [self.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
            self.cancleBtn.hidden = NO;
            self.otherBtn.hidden = NO;
        }else if ([model.orderStatus integerValue] == 11){
            self.orderState.text = @"已完成";
            
            self.cancleBtn.hidden = YES;
            self.otherBtn.hidden = NO;
            if ([model.isComment integerValue] == 0) {
                [self.otherBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.otherBtn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
            }else{
                [self.otherBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                [self.otherBtn setTitleColor:[UIColor colorWithHexString:@"39d5b8"] forState:UIControlStateNormal];
                [self.otherBtn setBackgroundColor:[UIColor clearColor]];
            }
            
        }
    }
}
@end
