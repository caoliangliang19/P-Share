
//
//  AllParkingViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "AllParkingViewController.h"
#import "ParkingCell.h"
#import "MJRefresh.h"
#import "NewParkingdetailVC.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>

@interface AllParkingViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIActionSheetDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    UIActionSheet *_shareSheet;
    NSInteger _navigationIndex;
}

@property (nonatomic,strong)NSMutableArray *allDataArray;

@end

@implementation AllParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    self.allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allDataArray = [NSMutableArray array];
    
    ALLOC_MBPROGRESSHUD;
    
    _shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
    
    [self setRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.allTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.allTableView;
    _mjFooterView.delegate = self;
    
//    [_mjHeaderView beginRefreshing];
    [self downloadDataWithBeginIndex:_curIndex];
}

- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    if (_mjHeaderView == refreshView) {
        _curIndex = 1;
    }
    if (refreshView == _mjFooterView) {
        _curIndex += 1;
    }
    [self downloadDataWithBeginIndex:_curIndex];
}

- (void)downloadDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)beginIndex];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.homeLatitude,parking_latitude,self.homeLongitude,parking_longitude,indexStr,@"page_index", nil];
    
    NSString *urlString = [SEARCH_PARK_BY_PAEK stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *model = [RequestModel new];
    
    [model getRequestWithURL:urlString WithDic:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            
            if ([dict[@"code"] isEqualToString:@"000000"])
            {
                if (beginIndex == 1) {
                    [self.allDataArray removeAllObjects];
                }
                NSArray *dictArray = dict[@"datas"][@"parkingList"];
                if ([dictArray[0] isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *tmpDict in dictArray){
                        ParkingModel *model = [[ParkingModel alloc] init];
                        [model setValuesForKeysWithDictionary:tmpDict];
                        [self.allDataArray addObject:model];
                    }
                }
                [self.allTableView reloadData];
            }else{
                if (beginIndex == 1) {
                    ALERT_VIEW(@"周边尚无更多停车场，敬请期待。");
                    _alert = nil;
                }else{
                    ALERT_VIEW(@"已加载完毕");
                    _alert = nil;
                }
            }
        }
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    } error:^(NSString *error) {
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    } failure:^(NSString *fail) {
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
    
        //---------------------------网路请求
}

#pragma mark --   UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allDataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"parkingCellId";
    ParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ParkingCell" owner:self options:nil]lastObject];
    }
#pragma mark -- 在停车场cell上面添加颜色
    if (indexPath.row%4 == 0) {
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"8957a1"];
    }else if (indexPath.row%4 == 1){
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"00b7ee"];
    }else if (indexPath.row%4 == 2){
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"1cd8aa"];
    }else if (indexPath.row%4 == 3){
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"fac539"];
    }
    
    ParkingModel *model = self.allDataArray[indexPath.row];
    if (model.canUse == 1) {
        cell.parkIsParkLabel.hidden = YES;
    }else{
        cell.parkIsParkLabel.hidden = NO;
    }
    
    cell.parkingTitleLabel.text = model.parkingName;
    if (model.parkingPath.length > 10) {
        [cell.parkingImageVIew sd_setImageWithURL:[NSURL URLWithString:model.parkingPath] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    }
    cell.index = indexPath.row;
    //-----计算距离
    //1.将两个经纬度点转成投影点_mapView.userLocation.coordinate
    MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([self.homeLatitude floatValue], [self.homeLongitude floatValue]));
    MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MKMetersBetweenMapPoints(point1, point2);
    if (distance < 1000) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f米",distance];
    }else{
        distance = distance/1000;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f千米",distance];
    }
    
    if ([model.chargeType isEqualToString:@"1"]) {
        cell.priceLabel.text = [NSString stringWithFormat:@"价格:%.1f元/小时起",model.chargeNormMin];
    }else if([model.chargeType isEqualToString:@"2"]){
        cell.priceLabel.text = [NSString stringWithFormat:@"价格:%@元/次",model.priceTimes];
    }else{
        cell.priceLabel.text = @"价格未知";
    }
    
    
    
    cell.gotoNavBlock = ^(NSInteger index){
        _navigationIndex = index;
        [_shareSheet showInView:self.view];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel *model = self.allDataArray[indexPath.row];
    NewParkingdetailVC *parkingDetailVC = [[NewParkingdetailVC alloc] init];
    parkingDetailVC.parkingId = model.parkingId;
    [self.navigationController pushViewController:parkingDetailVC animated:YES];
}

#pragma mark -UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ParkingModel *model = self.allDataArray[_navigationIndex];
    
    switch (buttonIndex) {
        case 0:{
            //自带地图导航
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(self.nowLatitude , self.nowLongitude);
            
            CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]);
            
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord1 addressDictionary:nil]];
            
            currentLocation.name = @"当前位置";
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord2 addressDictionary:nil]];
            
            toLocation.name = model.parkingName;
            
            NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
            
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            [MKMapItem openMapsWithItems:items launchOptions:options];
        }
            break;
        case 1:{
            //百度地图导航
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
            {
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",self.nowLatitude , self.nowLongitude,[model.parkingLatitude floatValue], [model.parkingLongitude floatValue], model.parkingName];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else{
                ALERT_VIEW( @"您未安装百度地图或版本不支持");
                _alert = nil;
            }
        }
            break;
        case 2:{
            //高德地图导航  067c1d2281fc7f9141e3725058c9e240
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=wx0112a93a0974d61b&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=0",@"口袋停",model.parkingName, [model.parkingLatitude floatValue], [model.parkingLongitude floatValue]];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else{
                ALERT_VIEW( @"您未安装高德地图或版本不支持");
                _alert = nil;
            }
        }
            break;
        default:
            break;
    }
    
}


- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 跳转到地图显示接界面
- (IBAction)mapBtnClick:(id)sender {
//    MenuViewController *menuCtrl = [[MenuViewController alloc] init];
//    [self.navigationController pushViewController:menuCtrl animated:YES];
}

@end



