//
//  AddCarInfoViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewCarModel;
@interface AddCarInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *carScrollView;
@property (weak, nonatomic) IBOutlet UIButton *carTypeBtn;
@property (weak, nonatomic) IBOutlet UIView *carNumView;
//行驶里程
@property (weak, nonatomic) IBOutlet UITextField *kiloTextField;
//车架号
@property (weak, nonatomic) IBOutlet UITextField *carFrameTextField;
//发动机号
@property (weak, nonatomic) IBOutlet UITextField *enginTextField;
@property (weak, nonatomic) IBOutlet UIButton *driveTime;
@property (weak, nonatomic) IBOutlet UIButton *isPayMoney;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightLayOut;
@property (weak, nonatomic) IBOutlet UISwitch *paySwitch;

@property (nonatomic,strong) NewCarModel *model;
- (IBAction)photoBtn:(UIButton *)sender;
- (IBAction)driveTime:(UIButton *)sender;
- (IBAction)drivePhoto:(UIButton *)sender;
- (IBAction)moneyBaoPay:(UISwitch *)sender;

- (IBAction)backBtnClick:(id)sender;

- (IBAction)sureBtnClick:(id)sender;

@end
