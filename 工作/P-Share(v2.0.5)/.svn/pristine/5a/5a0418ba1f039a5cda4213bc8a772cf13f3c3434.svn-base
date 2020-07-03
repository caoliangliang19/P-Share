//
//  ParkAndFavViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ParkAndFavViewController.h"
#import "SetParkingCell.h"
#import "MJRefresh.h"
#import "SearchParkingViewController.h"
#import "UIImageView+WebCache.h"
#import "NewParkingModel.h"
#import <objc/runtime.h>
#import "WZLSerializeKit.h"
#import "NewParkingdetailVC.h"

@interface ParkAndFavViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    UIAlertView *_alert;
    
    UIView *_lineView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _isFavorite;
    
    NSInteger _curIndex;
    NSInteger _curFavIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    UIButton *_temHomeBtn;
    UIButton *_temOfficeBtn;
    BOOL _visiterBool;

}

@property (nonatomic,strong)NSMutableArray *parkDataArray;
@property (nonatomic,strong)NSMutableArray *favDataArray;

@end

@implementation ParkAndFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _homeArray = [HomeArray shareHomeArray];
    
    [self setDefaultUI];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _visiterBool = [userDefaults boolForKey:@"visitorBOOL"];

    
    _isFavorite = NO;
    self.parkAndFavTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.parkDataArray = [NSMutableArray array];
    self.favDataArray = [NSMutableArray array];
    
    ALLOC_MBPROGRESSHUD;
    
    [self setRefresh];
}

- (void)setDefaultUI
{
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershFavoriteData) name:@"CollectCarChange" object:nil];
    
}
- (void)refershFavoriteData
{
    
//    [self downloadFavoriteDataWithBeginIndex:1];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [_parkAndFavTableView reloadData];
    [super viewDidAppear:animated];
}

- (void)setRefresh
{
    _curIndex = 1;
    _curFavIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.parkAndFavTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.parkAndFavTableView;
    _mjFooterView.delegate = self;
    
    [self downloadDataWithBeginIndex:_curIndex];
}



- (void)dealloc
{
    [_mjHeaderView free];
    [_mjFooterView free];
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    
    if (_isFavorite) {
//        if (_mjHeaderView == refreshView) {
//            _curFavIndex = 1;
//        }
//        if (refreshView == _mjFooterView) {
//            _curFavIndex += 1;
//        }
//        [self downloadFavoriteDataWithBeginIndex:_curFavIndex];
    }else{
        if (_mjHeaderView == refreshView) {
            _curIndex = 1;
        }
        if (refreshView == _mjFooterView) {
            _curIndex += 1;
        }
        [self downloadDataWithBeginIndex:_curIndex];
    }
}

- (void)downloadDataWithBeginIndex:(NSInteger)beginIndex
{
    
    _isLoading = YES;
    NSString *summary = [[NSString stringWithFormat:@"%@%ld%@%@",[MyUtil getCustomId],(long)beginIndex,[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%ld/%@/%@",cusFindAllParking,[MyUtil getCustomId],(long)beginIndex,[MyUtil getVersion],summary];
    BEGIN_MBPROGRESSHUD
    [RequestModel requestGetParkingListWithURL:url WithTag:@"3" Completion:^(NSMutableArray *resultArray) {
        
        if (beginIndex == 1) {
            
            [self.parkDataArray removeAllObjects];
        }
        [self.parkDataArray addObjectsFromArray:resultArray];
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
         [self.parkAndFavTableView reloadData];
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD
}];
    
}

- (void)downloadFavoriteDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%ld%@%@",[MyUtil getCustomId],@"1",(long)beginIndex,[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%ld/%@/%@",searchParkingCollection,[MyUtil getCustomId],@"1",(long)beginIndex,[MyUtil getVersion],summary];
    
    [RequestModel requestGetParkingListWithURL:url WithTag:@"2" Completion:^(NSMutableArray *resultArray) {
        
        if (beginIndex == 1) {
            [self.favDataArray removeAllObjects];
        }
        [self.favDataArray addObjectsFromArray:resultArray];
        
        [self.parkAndFavTableView reloadData];
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        _isLoading = NO;
//        ALERT_VIEW(error);
//        _alert = nil;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD
        
    }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --   UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.parkDataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"setParkingCellId";
    __weak SetParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetParkingCell" owner:self options:nil]lastObject];
    }
    ParkingModel *newModel;
    
    
    newModel = self.parkDataArray[indexPath.row];

    
    ParkingModel *homeModel = [_homeArray.dataArray objectAtIndex:0];
   
    
    cell.homeBtn.backgroundColor = [UIColor whiteColor];
    [cell.homeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    
    cell.officeBtn.backgroundColor = [UIColor whiteColor];
    [cell.officeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    
//    设置  如果车场已经被设置为首页
    if ([newModel.parkingId isEqualToString:homeModel.parkingId]) {
        cell.homeBtn.backgroundColor = NEWMAIN_COLOR;
        [cell.homeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
 
    
    cell.homeBtn.tag = indexPath.row;
    cell.officeBtn.tag = indexPath.row;
    cell.index = indexPath.row;
    
    cell.parkingTitleLabel.text = newModel.parkingName;
    cell.parkingPriceLabel.text = newModel.parkingAddress;

    if (newModel.parkingPath.length > 10) {
        [cell.parkingImageView sd_setImageWithURL:[NSURL URLWithString:newModel.parkingPath] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    }
    
    ParkAndFavViewController *weakSelf = self;
    cell.setHomeParkingBlock = ^(UIButton *btn){
        [weakSelf setHomeParkingWithIndex:cell.homeBtn];
    };

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewParkingModel *newModel;
//    if (_isFavorite) {
//        newModel = self.favDataArray[indexPath.row];
//    }else{
//        newModel = self.parkDataArray[indexPath.row];
//    }
//    NewParkingdetailVC *parkingDetailVC = [[NewParkingdetailVC alloc] init];
//    parkingDetailVC.parkingId = newModel.parkingId;
//    [self.navigationController pushViewController:parkingDetailVC animated:YES];

}




#pragma mark -- 设置家停车场

- (void)setHomeParkingWithIndex:(UIButton *)btn
{
    
    _temHomeBtn.backgroundColor = [UIColor whiteColor];
    [_temHomeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    _temHomeBtn = btn;
    _temHomeBtn.backgroundColor = NEWMAIN_COLOR;
    [_temHomeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    ParkingModel *model;
    if (_isFavorite) {
        model = self.favDataArray[btn.tag];
    }else{
        model = self.parkDataArray[btn.tag];
    }
    
    if (_visiterBool == NO) {
        [_homeArray.dataArray replaceObjectAtIndex:0 withObject:model];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHomeModel" object:nil];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[NewMapHomeVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        return;
    }
    
    BEGIN_MBPROGRESSHUD;

    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@%@",[MyUtil getCustomId],model.parkingId,@(1),[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",setDefaultScan,[MyUtil getCustomId],model.parkingId,@(1),[MyUtil getVersion],summary];
    
    
    [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
       
        [_homeArray.dataArray replaceObjectAtIndex:0 withObject:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHomeModel" object:nil];
        
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[NewMapHomeVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }

         END_MBPROGRESSHUD;
        
    } Fail:^(NSString *errror) {
        ALERT_VIEW(errror);
        _alert = nil;
         END_MBPROGRESSHUD;
    }];


    
}
- (NSString *)filePath
{
    NSString *archiverFilePath = [NSString stringWithFormat:@"%@/archiver", NSHomeDirectory()];
    return archiverFilePath;
}

#pragma mark -- 返回上一个界面
- (IBAction)backBtnClick:(id)sender {
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    
    if (_parkDataArray.count != 0) {
        [_mjFooterView free];
        [_mjHeaderView free];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoMapBtnClick:(id)sender {
    
    if (_visiterBool == NO) {
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        return;
        
    }
    
    SearchParkingViewController *searchCtrl = [[SearchParkingViewController alloc] init];
    searchCtrl.nowLatitude = self.nowLatitude;
    searchCtrl.nowLongitude = self.nowLongitude;
    [self.navigationController pushViewController:searchCtrl animated:YES];
}






@end


