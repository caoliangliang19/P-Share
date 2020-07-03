//
//  NewYuYueTingChe.h
//  P-Share
//
//  Created by fay on 16/5/19.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
#import "MyPointAnnotation.h"

@interface NewYuYueTingChe : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)ParkingModel *parkModel;

@property (nonatomic,strong)MyPointAnnotation *annotationMode;
@property (nonatomic,strong)NewCarModel *carModel;
@property (nonatomic,assign)float nowLatitude;  //当前经度
@property (nonatomic,assign)float nowLongitude;   //当前纬度
@end
