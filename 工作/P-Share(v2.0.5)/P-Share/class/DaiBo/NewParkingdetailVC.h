//
//  NewParkingdetailVC.h
//  P-Share
//
//  Created by fay on 16/4/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    PARKINGSTYLENONE,
    PARKINGSTYLEDAIBO,
    PARKINGSTYLECHONGDIAN,
    PARKINGSTYLEDAIBOCHONGDIAN
}PARKINGSTYLE;
@interface NewParkingdetailVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoPayRight2;
@property (weak, nonatomic) IBOutlet UILabel *greenLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoPayRight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoPayRight0;
@property (weak, nonatomic) IBOutlet UILabel *shengYuCheWei;
@property (weak, nonatomic) IBOutlet UILabel *linShiInfoL;
@property (weak, nonatomic) IBOutlet UILabel *youHuiInfoL;
@property (weak, nonatomic) IBOutlet UILabel *daiBoInfoL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containtViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *parkImage;
@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UILabel *parkAddress;
@property (weak, nonatomic) IBOutlet UILabel *chouDianL;
@property (weak, nonatomic) IBOutlet UILabel *daiBoL;
@property (weak, nonatomic) IBOutlet UIButton *daiBoBtn;
@property (weak, nonatomic) IBOutlet UILabel *autoPayL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewBottom0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewBottom1;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewLayout2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (nonatomic,assign)PARKINGSTYLE parkingStyle;

@property (nonatomic,copy)NSString *parkingId;

@end
