//
//  NewMonthlyRentSearchCell.m
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewMonthlyRentSearchCell.h"

@implementation NewMonthlyRentSearchCell

- (void)awakeFromNib {
    // Initialization code
    _feeBtn.layer.cornerRadius = 4;
    _feeBtn.layer.masksToBounds = YES;
    _carNumBtn.layer.cornerRadius = 4;
    _carNumBtn.layer.masksToBounds = YES;
    
    _bgView.layer.borderColor = [MyUtil colorWithHexString:@"dddddd"].CGColor;
    _bgView.layer.borderWidth = 0.75;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)xuFeeBtnClick:(UIButton *)sender {
    
    
    self.postParameter(sender);
    
    
}

@end
