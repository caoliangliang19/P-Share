//
//  MapParkingView.h
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"
#import "NewParkingModel.h"

@interface MapParkingView : UIView
@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)UIView *grayView;
@property (nonatomic,copy)void (^positionParking)(NewParkingModel *parkingModel);

@end
