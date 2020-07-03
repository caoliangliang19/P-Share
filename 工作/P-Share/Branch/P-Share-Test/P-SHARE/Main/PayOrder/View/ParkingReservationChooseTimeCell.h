//
//  ParkingReservationChooseTimeCell.h
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YuYueTimeModel;
@interface ParkingReservationChooseTimeCell : UITableViewCell
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,copy)void (^timeCallBackBlock)(ParkingReservationChooseTimeCell*cell,YuYueTimeModel *model);


@end
