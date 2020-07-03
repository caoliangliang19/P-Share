//
//  ClearCarVC.h
//  P-Share
//
//  Created by fay on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewParkingModel.h"

@interface ClearCarVC : UIViewController

//@property (nonatomic,strong)ParkingModel *parkingModel;
@property (nonatomic,strong)ParkingModel *parkingModel;

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,strong)NSString *carNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCenterLayOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCenterLayOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayOut;

@property (weak, nonatomic) IBOutlet UIImageView *parkerHead1;
@property (weak, nonatomic) IBOutlet UIImageView *parkerHead2;
@property (weak, nonatomic) IBOutlet UIImageView *parkerHead3;
@property (weak, nonatomic) IBOutlet UILabel *parkName1;
@property (weak, nonatomic) IBOutlet UILabel *parkName2;
@property (weak, nonatomic) IBOutlet UILabel *parkName3;

@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UILabel *shoufei1;
@property (weak, nonatomic) IBOutlet UILabel *shoufei2;
@property (weak, nonatomic) IBOutlet UILabel *srvPrice1;
@property (weak, nonatomic) IBOutlet UILabel *srvPrice2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianJieHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containtViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *serverInfoL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverInfoViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)washCarBtn:(id)sender;

@end
