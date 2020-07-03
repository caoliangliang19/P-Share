//
//  TimeLineViewController.h
//  P-Share
//
//  Created by fay on 16/6/16.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TimeLineFromMap,
    TimeLineFromOrder
}TimeLineFromStyle;
@class CarModel;
@interface TimeLineViewController : UITableViewController
@property (nonatomic,assign) int payType;//订单类型0:代泊  1:预约
@property (nonatomic,strong)ParkingModel *parkingModel;
@property (nonatomic,strong) NewCarModel *carModel;
@property (nonatomic,strong)TemParkingListModel *temModel;
@property (nonatomic,assign)NSInteger payStaus;

//从订单界面
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *orderType;
@property (nonatomic,assign)TimeLineFromStyle fromStyle;


@end
