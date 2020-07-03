//
//  YuYueTingCheVC.h
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"
#import "CarModel.h"


@interface YuYueTingCheVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic,retain)ParkingModel *parkingModel;
@property (nonatomic,retain)CarModel *carModel;
@property (nonatomic,copy)NSMutableArray *carArray;
@property (nonatomic,assign)float nowLatitude;  //当前经度
@property (nonatomic,assign)float nowLongitude;   //当前纬度
@end
