//
//  HistoryViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/10.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    
}

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *btnView;
@property (strong, nonatomic) UIButton *parkBtn;
@property (strong, nonatomic) UIButton *temParkBtn;
//@property (strong, nonatomic) UIButton *rentBtn;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBar.hidden = YES;
    
    [self createViewControllers];
    
    [self createMyTabBar];
}

- (void)createMyTabBar
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.headerView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
    
    UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(50, 64-30, SCREEN_WIDTH-100, 20) title:@"停车记录" textColor:[MyUtil colorWithHexString:@"fcfcfc"] font:[UIFont systemFontOfSize:19] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [self.headerView addSubview:titleLabel];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 34, 15, 20)];
    backImageView.image = [UIImage imageNamed:@"defaultBack"];
    [self.headerView addSubview:backImageView];
    
    UIButton *backBtn = [MyUtil createBtnFrame:CGRectMake(0, 20, 60, 44) title:nil bgImageName:nil target:self action:@selector(backBtnClick:)];
    [self.headerView addSubview:backBtn];
    
    [self.view addSubview:self.headerView];
    
    //-------------------
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 35)];
    self.btnView.backgroundColor = [MyUtil colorWithHexString:@"fcfcfc"];
    
    self.parkBtn = [MyUtil createBtnFrame:CGRectMake(6, 0, (SCREEN_WIDTH-24)/2, 35) title:@"自驾停车" bgImageName:nil target:self action:@selector(parkBtnClick:)];
    self.parkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnView addSubview:self.parkBtn];
    self.temParkBtn = [MyUtil createBtnFrame:CGRectMake(12+(SCREEN_WIDTH-24)/2, 0, (SCREEN_WIDTH-24)/2, 35) title:@"代客泊车" bgImageName:nil target:self action:@selector(temParkBtnClick:)];
    self.temParkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnView addSubview:self.temParkBtn];
    [self.parkBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];

    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(9+(SCREEN_WIDTH-24)/2, 3, 1, 35-6)];
    lineView1.backgroundColor = [MyUtil colorWithHexString:@"cccccc"];
    [self.btnView addSubview:lineView1];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35-2, SCREEN_WIDTH/2-2, 2)];
    self.lineView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
    [self.btnView addSubview:self.lineView];
    
    [self.view addSubview:self.btnView];
}

//创建视图控制器
- (void)createViewControllers
{
    NSArray *ctrlArray = @[@"TemHistoryViewController",@"HistoryOrderViewController"];
    NSMutableArray *array = [NSMutableArray array];
    
    //循环创建视图控制器
    for (int i=0; i<ctrlArray.count; i++) {
        NSString *className = ctrlArray[i];
        
        Class cls = NSClassFromString(className);
        
        UIViewController *ctrl = [[cls alloc] init];
        
        [array addObject:ctrl];
    }
    self.viewControllers = array;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)parkBtnClick:(id)sender {
    self.selectedIndex = 0;
    [self.parkBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame =CGRectMake(0, 35-2, SCREEN_WIDTH/2-2, 2);
    }];
}

- (void)temParkBtnClick:(id)sender {
    self.selectedIndex = 1;
    [self.parkBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
         self.lineView.frame =CGRectMake(SCREEN_WIDTH/2, 35-2, SCREEN_WIDTH/2, 2);
    }];
}


@end


