//
//  NewMonthlyRentSearchCell.h
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMonthlyRentSearchCell : UITableViewCell

@property (nonatomic,copy)void (^postParameter)(UIButton *btn);

@property (weak, nonatomic) IBOutlet UIButton *carNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameL;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIButton *feeBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
