//
//  LoginViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LastVCStyleMainMap,
    LastVCStyleDaiBo,
    LastVCStyleYuYue,
    LastVCStyleMineCenter,
    LastVCStyleXiChe
}LastVCStyle;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loginBackView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *kuaiJieDengLuView;
@property (weak, nonatomic) IBOutlet UIView *weixinView;

@property (weak, nonatomic) IBOutlet UIView *qqView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLayOut;

@property (nonatomic,retain)TemParkingListModel *dataModel;
@property (nonatomic,assign)LastVCStyle lastVC;



- (IBAction)getCodeBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)forgetPswBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

- (IBAction)threeGoinClick:(id)sender;

@end
