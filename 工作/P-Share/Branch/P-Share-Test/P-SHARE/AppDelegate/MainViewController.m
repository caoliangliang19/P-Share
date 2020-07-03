//
//  MainViewController.m
//  P-SHARE
//
//  Created by fay on 16/10/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Extension.h"
@interface MainViewController ()

@end


@implementation MainViewController
NSString *const KClass          = @"class";
NSString *const KTitle          = @"title";
NSString *const KImageName      = @"imageName";
NSString *const KSelectedImage  = @"selectedImage";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *dataArray = @[
                           @{
                               KClass : @"MapViewController",
                               KTitle : @"首页",
                               KImageName : @"tabbar_map",
                               KSelectedImage : @"tabbar_map_selected",
                               },
                           @{
                               KClass : @"CarLifeVC",
                               KTitle : @"社区服务",
                               KImageName : @"tabbar_community",
                               KSelectedImage : @"tabbar_community_selected",
                               },
                           @{
                               KClass : @"UserCenterController",
                               KTitle : @"个人中心",
                               KImageName : @"tabbar_profile",
                               KSelectedImage : @"tabbar_profile_selected",
                               },
                           ];
    for (NSInteger i=0; i<dataArray.count; i++) {
        [self addChildViewController:[NSClassFromString(dataArray[i][KClass]) new] title:dataArray[i][KTitle] image:dataArray[i][KImageName] selectedImage:dataArray[i][KSelectedImage]];
    }
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] insertSubview:whiteView atIndex:0];
    self.tabBar.opaque = YES;
 
    

}

//- (void)viewWillLayoutSubviews{
//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = 40;
//    tabFrame.origin.y = self.view.frame.size.height - 40;
//    self.tabBar.frame = tabFrame;
//}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childController.title = title;
    
    // 设置子控制器的tabBarItem图片
    childController.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : KMAIN_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
     RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
