//
//  MapParkingCell.h
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapParkingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *colorImageV;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *parkingName;
@property (weak, nonatomic) IBOutlet UILabel *pinShiL;
@property (weak, nonatomic) IBOutlet UILabel *shareL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UIButton *daoHangBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic,copy)void (^daoHangBlock)();

@end
