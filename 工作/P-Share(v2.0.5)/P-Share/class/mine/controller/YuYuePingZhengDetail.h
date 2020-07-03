//
//  YuYuePingZhengDetail.h
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemParkingListModel.h"

@interface YuYuePingZhengDetail : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOut1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOut2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOut3;

@property (weak, nonatomic) IBOutlet UILabel *weekdayL1;
@property (weak, nonatomic) IBOutlet UILabel *weekdayL2;
@property (weak, nonatomic) IBOutlet UILabel *weekdayL3;
@property (weak, nonatomic) IBOutlet UILabel *TimerL1;
@property (weak, nonatomic) IBOutlet UILabel *TimeL2;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *hourOneL;
@property (weak, nonatomic) IBOutlet UILabel *hourTwoL;
@property (weak, nonatomic) IBOutlet UILabel *dateOneL;
@property (weak, nonatomic) IBOutlet UILabel *dateTwoL;
@property (weak, nonatomic) IBOutlet UILabel *stopCarNumberL;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameL;
@property (weak, nonatomic) IBOutlet UIImageView *twoCodeImageV;
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageV;
@property (weak, nonatomic) IBOutlet UILabel *explainL;
@property (weak, nonatomic) IBOutlet UILabel *explaintL;


@property (nonatomic,strong)TemParkingListModel *pingZhengModel;
@property (nonatomic,copy)NSString *type;
@end
