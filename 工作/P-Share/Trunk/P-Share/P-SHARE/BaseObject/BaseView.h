//
//  BaseView.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
@property (nonatomic,strong)UIActivityIndicatorView *activityView;

/**
 *  初始化子控件
 */
- (void)setUpSubView;
/**
 *  显示指示器
 */
- (void)activityViewShow;
/**
 *  隐藏指示器
 */
- (void)activityViewHidden;

/**
 *  MBProgressHUD
 */
@property (nonatomic,strong)MBProgressHUD *hub;

/**
 *  grayView
 */
@property (nonatomic,strong)UIView  *grayView;

@end
