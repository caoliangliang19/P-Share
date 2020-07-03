//
//  ShareTemParkingViewController.h
//  P-Share
//
//  Created by fay on 15/12/31.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"
#import "CarModel.h"
#import "MyPointAnnotation.h"
@interface ShareTemParkingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *yingFuPrice;
@property (weak, nonatomic) IBOutlet UILabel *zheKouPrice;
@property (weak, nonatomic) IBOutlet UILabel *shiFuPrice;
@property (weak, nonatomic) IBOutlet UILabel *tingCheMaL;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;
@property (nonatomic,strong)MyPointAnnotation *annotationMode;
@property (nonatomic,copy)NSString *parkingNum; //预约次数
@property (nonatomic,copy)NSString *appointmentDate;//预约时间
@property (nonatomic,copy)NSString *parkingId;
@property (nonatomic,copy)NSString *packageId; //套餐ID

@property (nonatomic,assign)float nowLatitude;  //当前经度
@property (nonatomic,assign)float nowLongitude;   //当前纬度

@property (nonatomic,retain)ParkingModel *pModel;
@property (nonatomic,retain)NewCarModel *carModel;
@property (nonatomic,retain)TemParkingListModel *temModel;


@property (weak, nonatomic) IBOutlet UIImageView *selectWechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAlipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectSelfImageView;



@end
