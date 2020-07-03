//
//  NewMonthlyRentAuthCodeCell.m
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewMonthlyRentAuthCodeCell.h"

@implementation NewMonthlyRentAuthCodeCell



- (void)awakeFromNib {
   
    _commitBtn.layer.cornerRadius = 4;
    _commitBtn.layer.masksToBounds = YES;
    
    _getAuthCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39D5B8"].CGColor;
    _getAuthCodeBtn.layer.borderWidth = 1.5;
    _getAuthCodeBtn.layer.cornerRadius = 5;
    _getAuthCodeBtn.layer.masksToBounds = YES;
    
    
    
}
- (IBAction)getAuthCodeBtnClick:(UIButton *)sender {
    
    if (self.delegate && [_delegate respondsToSelector:@selector(getAuthCodeWith:)]) {
        [_delegate getAuthCodeWith:sender];
        
    }
    
}
- (IBAction)commitBtnClick:(UIButton *)sender {
    
    if (self.delegate && [_delegate respondsToSelector:@selector(sureCommitAuthCode:)]) {
        [_delegate sureCommitAuthCode:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
