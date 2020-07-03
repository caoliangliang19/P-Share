//
//  CarListViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger , GoInControllerType){
    GoInControllerTypeNumber   =     0,
    GoInControllerTypeWashCar  =     1,
    
};

@interface CarListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *carListTableView;
@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (assign ,nonatomic) GoInControllerType goInType;
@property (nonatomic,copy) void(^passOnCarNumber)(NewCarModel *carModel);
//用来表示上个界面 1:NewTemParkingVC
@property (nonatomic,assign)int markForm;
@property (nonatomic,copy)NSString *pushType;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)editingBtnClick:(id)sender;

@end
