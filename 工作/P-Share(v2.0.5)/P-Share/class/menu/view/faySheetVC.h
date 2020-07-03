//
//  faySheetVC.h
//  P-Share
//
//  Created by fay on 16/1/13.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"
#import "OrderModel.h"
@interface faySheetVC : UIViewController

@property (nonatomic,assign) float nowLatitude;
@property (nonatomic,assign) float nowLongitude;

@property (nonatomic,copy) NSString *modelLatitude;
@property (nonatomic,copy) NSString *modelLongitude;
@property (nonatomic,copy) NSString *modelParkingName;
@end
