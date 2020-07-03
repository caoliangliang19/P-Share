//
//  SetParkingCell.m
//  P-Share
//
//  Created by VinceLee on 15/11/23.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "SetParkingCell.h"

@implementation SetParkingCell

- (void)awakeFromNib {
    
    _homeBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    _homeBtn.layer.borderWidth = 1;
    _officeBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    _officeBtn.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setOfficeParkingBtnClick:(UIButton *)sender {

//    MyLog(@"***********");
//    if (self.setOfficeParkingBlock) {
//        self.setOfficeParkingBlock(self.homeBtn);
//        
//    }
}

- (IBAction)setHomeParkingBtnClick:(id)sender {
    if (self.setHomeParkingBlock) {
        self.setHomeParkingBlock(self.officeBtn);
    }
    if (self.setOfficeParkingBlock) {
        self.setOfficeParkingBlock(self.index);
    }
}
@end
