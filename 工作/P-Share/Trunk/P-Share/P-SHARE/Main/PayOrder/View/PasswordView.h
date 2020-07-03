//
//  PasswordView.h
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@interface PasswordView : BaseView
@property (nonatomic,copy)void (^passwordViewBlock)(PasswordView *passwordView,NSString *password);
@property (nonatomic,copy)void (^cancelWalletPay)(PasswordView *passwordView);

+ (instancetype)createPasswordViewWithPrice:(NSString *)price;
- (id)initWithPrice:(NSString *)price;
- (void)passwordViewShow;
- (void)passwordViewHidden;

@end
