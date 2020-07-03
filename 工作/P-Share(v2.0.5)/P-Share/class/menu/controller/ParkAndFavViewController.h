//
//  ParkAndFavViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeArray.h"

@interface ParkAndFavViewController : UIViewController

//用来判断这个停车场是否设为首页（家／公司）
@property (nonatomic,retain)HomeArray *homeArray;


@property (weak, nonatomic) IBOutlet UIView *headerView;




@property (weak, nonatomic) IBOutlet UITableView *parkAndFavTableView;
@property (nonatomic,assign) float nowLatitude;//当前经度
@property (nonatomic,assign) float nowLongitude;//当前纬度

- (IBAction)backBtnClick:(id)sender;
- (IBAction)gotoMapBtnClick:(id)sender;

- (IBAction)allParkBtnClick:(id)sender;
- (IBAction)favoriteBtnClick:(id)sender;


@end




