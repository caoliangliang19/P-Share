//
//  MapParkingCell.m
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "MapParkingCell.h"

@implementation MapParkingCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)daoHangbtnClick:(UIButton *)sender {
    
    if (self.daoHangBlock) {
        self.daoHangBlock();
    }
    
}

@end
