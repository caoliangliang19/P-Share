//
//  FayAlertView.h
//  P-Share
//
//  Created by fay on 16/8/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FayAlertView : UIView


- (instancetype)initWithNormalTitle:(NSString *)title
                   describute:(NSString *)describute
                 sureBtnTitle:(NSString *)sureBtnTitle
               cancelBtnTitle:(NSString *)cancelBtnTitle;

- (instancetype)initWithMutableAttributestrTitle:(NSString *)title
                         describute:(NSMutableAttributedString *)describute
                       sureBtnTitle:(NSString *)sureBtnTitle
                     cancelBtnTitle:(NSString *)cancelBtnTitle;

@property (nonatomic,copy)void (^cancelBlock)();
@property (nonatomic,copy)void (^sureBlock)();

@end
