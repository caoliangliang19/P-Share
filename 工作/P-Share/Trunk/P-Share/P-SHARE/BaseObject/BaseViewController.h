//
//  BaseViewController.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/**
 *  Screen's width.
 */
@property (nonatomic) CGFloat  width;

/**
 *  Screen's height.
 */
@property (nonatomic) CGFloat  height;

/**
 *  NavigationBar is hidden , YES:hidden  NO:show,  default is show.
 */
@property (nonatomic,assign)    BOOL isHiddenNavigationBar;

/**
 *  Base config.
 */
- (void)setup;

/**
 *  You can only use this method when the current controller is an UINavigationController's rootViewController.
 */
- (void)useInteractivePopGestureRecognizer;

/**
 *  You can use this property when this controller is pushed by an UINavigationController.
 */
@property (nonatomic)  BOOL  enableInteractivePopGestureRecognizer;

/**
 *  If this controller is managed by an UINavigationController, you can use this method to pop.
 *
 *  @param animated Animated or not.
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  If this controller is managed by an UINavigationController, you can use this method to pop to the rootViewController.
 *
 *  @param animated Animated or not.
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  set left barButtonItem
 *
 *  @param imageName imageName
 */
- (void)setLeftBarButtonItemWithImage:(NSString *)imageName;
/**
 *  left barButtonItem Click
 *
 *  @param item left barButtonItem
 */
- (void)leftBarButtonClick:(UIBarButtonItem *)item;



@end
