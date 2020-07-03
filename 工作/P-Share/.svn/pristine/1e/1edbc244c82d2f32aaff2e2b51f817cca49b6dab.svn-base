//
//  BaseViewController.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+Swizzling.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setup];
    [self setLeftBarButtonItemWithImage:@""];

}

- (void)setLeftBarButtonItemWithImage:(NSString *)imageName
{
    imageName = imageName.length > 0 ? imageName : @"return";
    
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(leftBarButtonClick:)];
    
}
/**
 *  默认返回上个界面,实现其他功能时需重写
 */
- (void)leftBarButtonClick:(UIBarButtonItem *)item
{
    [self.rt_navigationController popViewControllerAnimated:YES];
}

- (void)setIsHiddenNavigationBar:(BOOL)isHiddenNavigationBar
{
    self.navigationController.navigationBarHidden = isHiddenNavigationBar;
}

- (void)setup {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.width                                = [UIScreen mainScreen].bounds.size.width;
    self.height                               = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor                 = KBG_COLOR;
}

- (void)useInteractivePopGestureRecognizer {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)popViewControllerAnimated:(BOOL)animated {
    
    [self.rt_navigationController popViewControllerAnimated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    
    [self.rt_navigationController popToRootViewControllerAnimated:animated];
}

- (void)dealloc
{
    [self cancelRequest];
    MyLog(@"%@ release",NSStringFromClass(self.class));
    
}


#pragma mark - Overwrite setter & getter.

@synthesize enableInteractivePopGestureRecognizer = _enableInteractivePopGestureRecognizer;

- (void)setEnableInteractivePopGestureRecognizer:(BOOL)enableInteractivePopGestureRecognizer {
    
    _enableInteractivePopGestureRecognizer                            = enableInteractivePopGestureRecognizer;
    self.navigationController.interactivePopGestureRecognizer.enabled = enableInteractivePopGestureRecognizer;
}

- (BOOL)enableInteractivePopGestureRecognizer {
    
    return _enableInteractivePopGestureRecognizer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
