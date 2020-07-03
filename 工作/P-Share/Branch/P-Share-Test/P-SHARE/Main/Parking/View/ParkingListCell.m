//
//  ParkingListCell.m
//  P-SHARE
//
//  Created by fay on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ParkingListCell.h"
@interface ParkingListCell()
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *parkingNameL;
@property (weak, nonatomic) IBOutlet UILabel *parkingAddressL;
@property (weak, nonatomic) IBOutlet UIImageView *parkImageV;
@end
@implementation ParkingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _rightButton.layer.borderWidth = 1.0f;
    _rightButton.layer.borderColor = KMAIN_COLOR.CGColor;
    self.parkingListCellStyle = ParkingListCellStyleUnSelect;
    
}
- (IBAction)rightBtnClick:(id)sender {
    if (self.parkingListCellBlock) {
        
        self.parkingListCellBlock(self);
        
    }
}
- (void)setParking:(Parking *)parking
{
    _parking = parking;
    [_parkImageV sd_setImageWithURL:[NSURL URLWithString:parking.parkingPath] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    _parkingNameL.text = parking.parkingName;
    _parkingAddressL.text = parking.parkingAddress;
    
}
- (void)setParkingListCellStyle:(ParkingListCellStyle)parkingListCellStyle
{
    _parkingListCellStyle = parkingListCellStyle;
    if (parkingListCellStyle == ParkingListCellStyleUnSelect) {
        _rightButton.backgroundColor = [UIColor whiteColor];
        [_rightButton setTitleColor:KMAIN_COLOR forState:(UIControlStateNormal)];
    }else
    {
        _rightButton.backgroundColor = KMAIN_COLOR;
        [_rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
