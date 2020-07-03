//
//  MapParkingListVC.h
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapParkingListVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *parkingArray;
@property (nonatomic,assign)CGFloat nowLatitude;
@property (nonatomic,assign)CGFloat nowLongitude;
@property (nonatomic,retain)NSMutableArray *carArray;
@property (weak, nonatomic) IBOutlet UIView *grayView;

@end
