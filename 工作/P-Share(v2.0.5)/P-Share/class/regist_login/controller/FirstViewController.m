//
//  FirstViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "FirstNavController.h"
#import "MainViewController.h"

@interface FirstViewController ()<UIScrollViewDelegate>
{
    
    UIPageControl *_pageControll;
    
}


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFileManager *manager=[NSFileManager defaultManager];
    
    //判断 我是否创建了文件，如果没创建 就创建这个文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if ([manager fileExistsAtPath:[path stringByAppendingPathComponent:@"a.txt"]]){
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        MainViewController *mainVC = [[MainViewController alloc] init];
        window.rootViewController = mainVC;
        
    }else
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.bottomSpaceConstraint.constant *= RATIO;
        self.guideBackView.hidden = YES;
        //引导页相关
        [self setGuidePage];
    }
    
}

- (void)setGuidePage
{
    NSFileManager *manager=[NSFileManager defaultManager];
   
    //判断 我是否创建了文件，如果没创建 就创建这个文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![manager fileExistsAtPath:[path stringByAppendingPathComponent:@"a.txt"]]){
    
        self.guideBackView.hidden = NO;
        self.guideBottomView.hidden = YES;
        
        for (int i=1; i<=3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(i-1), 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"goinApp%d.png",i]];
            [self.guideScrollView addSubview:imageView];
        }
        
        self.guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
        self.guideScrollView.pagingEnabled = YES;
        self.guideScrollView.showsHorizontalScrollIndicator = NO;
        
        self.guideScrollView.showsVerticalScrollIndicator = NO;

        _pageControll = [[UIPageControl alloc]init];
        _pageControll.numberOfPages = 3;
        _pageControll.currentPageIndicatorTintColor = NEWMAIN_COLOR;
        _pageControll.pageIndicatorTintColor = [UIColor whiteColor];
        
        [self.view addSubview:_pageControll];
        __weak typeof(self)weakSelf = self;
        [_pageControll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.view);
            make.size.mas_equalTo(CGSizeMake(200, 80));
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            
        }];

        
        //第一次运行后创建文件，以后就不再运行
        [manager createFileAtPath:[path stringByAppendingPathComponent:@"a.txt"] contents:nil attributes:nil];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    _pageControll.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    
//    引导界面的图片的数量写为了确定值
    if (scrollView.contentOffset.x == SCREEN_WIDTH*2) {
        self.guideBottomView.hidden = NO;
        _pageControll.hidden = YES;
    }else{
        self.guideBottomView.hidden = YES;
        _pageControll.hidden = NO;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)guideBtnClick:(id)sender {
    self.guideBackView.hidden = YES;

    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MainViewController *mainVC = [[MainViewController alloc] init];
    window.rootViewController = mainVC;


}

- (IBAction)touristGoIn:(id)sender {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"visitorBOOL"];
    [userDefaults setObject:nil forKey:customer_id];
    [userDefaults setObject:nil forKey:customer_mobile];
    [userDefaults setObject:nil forKey:customer_nickname];
    [userDefaults synchronize];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MainViewController *mainVC = [[MainViewController alloc] init];
    window.rootViewController = mainVC;
}

- (IBAction)registBtnClick:(id)sender {
    //跳转注册页面
    RegistViewController *registVCtrl = [[RegistViewController alloc] init];
    
    [self.navigationController pushViewController:registVCtrl animated:YES];
    
}

- (IBAction)loginBtnClick:(id)sender {
    //跳转登陆页面
    LoginViewController *loginVCtrl = [[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVCtrl animated:YES];
}
@end




