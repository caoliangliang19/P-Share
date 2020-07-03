//
//  NewTemParkingPayVC.h
//  P-Share
//
//  Created by fay on 16/2/17.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemParkingListModel.h"

@interface NewTemParkingPayVC : UIViewController

@property (nonatomic,retain)TemParkingListModel *temPayModel;
@property (nonatomic,retain)TemParkingListModel *temParkModel;

@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (weak, nonatomic) IBOutlet UILabel *yingFuPrice;
@property (weak, nonatomic) IBOutlet UILabel *zheKouPrice;
@property (weak, nonatomic) IBOutlet UILabel *shiFuPrice;

@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIImageView *selectWechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAlipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectSelfpayImageView;
@end
