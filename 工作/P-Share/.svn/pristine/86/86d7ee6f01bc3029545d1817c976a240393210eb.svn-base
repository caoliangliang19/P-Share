//
//  ViewController.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"
#import "FirstViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ViewController";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL first = [defaults boolForKey:@"first"];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    __weak typeof (window)weakWindew = window;
    if (first == NO) {
        FirstViewController *new = [[FirstViewController alloc] init];
//        RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:[[MapViewController alloc]init]];
        new.myBlock = ^(){
            MainViewController *mainVC = [[MainViewController alloc] init];
            weakWindew.rootViewController = mainVC;
        };
        window.rootViewController = new;
    }else{
        
        MainViewController *mainVC = [[MainViewController alloc] init];
        
        window.rootViewController = mainVC;


//         RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:[[MapViewController alloc]init]];
//         window.rootViewController = nav;
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
