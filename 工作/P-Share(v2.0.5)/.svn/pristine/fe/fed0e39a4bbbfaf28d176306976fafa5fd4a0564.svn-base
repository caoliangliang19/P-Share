//
//  GoinAlertView.h
//  P-Share
//
//  Created by 亮亮 on 16/6/30.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoinAlertView : UIView


@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (nonatomic,strong) UIViewController *viewController;
- (instancetype)initWithController:(UIViewController *)viewController;
- (void)show;
- (void)hide;
- (void)tureBlock:(void(^)())tureBlock cancleBlock:(void(^)())cancleBlock;
//1取消按钮 2获取验证码 3登录 4口袋停用户协议 5微信 6QQ
- (IBAction)logInAlertView:(UIButton *)sender;
@end
