//
//  CarErrorTableController.h
//  P-Share
//
//  Created by 亮亮 on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegulationResultModel.h"

@interface CarErrorTableController : UIViewController

@property (nonatomic,retain) NSArray *dataArray;

//接受从车辆违规界面传来的值
@property (nonatomic,retain)RegulationResultModel *resultModel;


@property (weak, nonatomic) IBOutlet UILabel *carNumber;

@property (weak, nonatomic) IBOutlet UITableView *carDetailTableView;

- (IBAction)backBtnClick:(UIButton *)sender;

@end
