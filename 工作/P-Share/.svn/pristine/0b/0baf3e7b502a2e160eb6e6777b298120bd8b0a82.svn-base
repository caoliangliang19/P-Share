//
//  CollectionController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/15.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CollectionController.h"
#import "CollectionCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DaoHangVC.h"

@interface CollectionController ()
<
     UITableViewDelegate,
     UITableViewDataSource,
     CLLocationManagerDelegate,//定位
     UIActionSheetDelegate
>

{
    float _myLatitude;
    float _myLongitude;
    CLLocationManager *_cllManager;
    
    UIActionSheet *_shareSheet;
    NSInteger _navigationIndex;
}
@property (nonatomic , assign)BOOL isRefresh;
@property (nonatomic , assign)BOOL isDataload;
@property (nonatomic , assign)NSInteger indexPage;

@property (nonatomic , strong)UITableView *collectionTableView;

@property (nonatomic , strong)NSMutableArray *collectionArray;

@end

@implementation CollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
    [self createTableView];
    [self createRefresh];
   
    
}
- (void)getLocation{
    self.title = @"我的收藏";
    _cllManager = [[CLLocationManager alloc] init];
    _cllManager.distanceFilter = kCLDistanceFilterNone;
    _cllManager.desiredAccuracy = kCLLocationAccuracyBest;
    _cllManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [_cllManager requestWhenInUseAuthorization];
    }
    [_cllManager startUpdatingLocation];
    
    _shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    _myLatitude = location.coordinate.latitude;
    _myLongitude = location.coordinate.longitude;
    
    [_cllManager stopUpdatingLocation];
    
    [self.collectionTableView reloadData];
}
- (void)createRefresh{
    self.isDataload = NO;
    self.isRefresh = NO;
    self.indexPage = 1;
    [self goInRefresh];
}
- (void)goInRefresh{
    __weak typeof (self)weakSelf = self;
    self.collectionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isDataload == YES) {
            return ;
        }
        weakSelf.isDataload = YES;
        weakSelf.indexPage++;
        [weakSelf createCollectionRequest];
    }];
    [self.collectionTableView.mj_header beginRefreshing];
    self.collectionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isRefresh == YES) {
            return ;
        }
        weakSelf.isRefresh = YES;
        weakSelf.indexPage++;
        [weakSelf createCollectionRequest];
    }];
}
- (void)createCollectionRequest{
     NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.0",@"version",nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryCollection) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionArray removeAllObjects];
         NSArray *array = responseObject[@"collectionList"];
        for (NSDictionary *tmpDict in array) {
            MapSearchModel *model = [MapSearchModel shareObjectWithDic:tmpDict];
           
            [self.collectionArray addObject:model];
        }
       
        [self.collectionTableView reloadData];
        self.isRefresh = NO;
        self.isDataload = NO;
        [self.collectionTableView.mj_footer endRefreshing];
        [self.collectionTableView.mj_header endRefreshing];
        
    } error:^(NSString *error) {
        self.isRefresh = NO;
        self.isDataload = NO;
        [self.collectionTableView.mj_footer endRefreshing];
        [self.collectionTableView.mj_header endRefreshing];
    } failure:^(NSString *fail) {
        self.isRefresh = NO;
        self.isDataload = NO;
        [self.collectionTableView.mj_footer endRefreshing];
        [self.collectionTableView.mj_header endRefreshing];
    }];
}
- (void)createTableView{
    [self.view addSubview:self.collectionTableView];
}

- (NSMutableArray *)collectionArray{
    if (_collectionArray == nil) {
        _collectionArray = [[NSMutableArray alloc] init];
        
    }
    return _collectionArray;
}
- (UITableView *)collectionTableView{
    if (_collectionTableView == nil) {
        _collectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _collectionTableView.delegate = self;
        _collectionTableView.dataSource = self;
        _collectionTableView.backgroundColor =  [UIColor colorWithHexString:@"eeeeee"];
        _collectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _collectionTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = [CollectionCell intranceDataCollectionCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ; 
    cell.index = indexPath.row;
    cell.indexPath = indexPath;
    MapSearchModel *parkModel = self.collectionArray[indexPath.row];
    if (![UtilTool isBlankString:parkModel.searchTitle]) {
        cell.parkNameL.text = parkModel.searchTitle;
    }
    if (![UtilTool isBlankString:parkModel.searchDistrict]) {
        cell.addressL.text = parkModel.searchDistrict;
    }
    MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(_myLatitude, _myLongitude));
    MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([parkModel.searchLatitude floatValue], [parkModel.searchLongitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MKMetersBetweenMapPoints(point1, point2);
    if (distance < 1000) {
        cell.distanceL.text = [NSString stringWithFormat:@"%.1f米",distance];
    }else{
        distance = distance/1000;
        cell.distanceL.text = [NSString stringWithFormat:@"%.1f千米",distance];
    }
    cell.parkImageV.image = [UIImage imageNamed:@"parkingDefaultImage"];
    __weak typeof(self)weakself = self;
    cell.ClickBtnClick = ^(NSInteger index){
        [weakself navigation:index];
    };
    return cell;
}
- (void)navigation:(NSInteger)index{
    
    MapSearchModel *newModel = self.collectionArray[index];
    Parking *park = [[Parking alloc] init];
    park.parkingName = newModel.searchTitle;
    park.parkingLongitude = newModel.searchLongitude;
    park.parkingLatitude = newModel.searchLatitude;
    DaoHangVC *daoHangVC = [[DaoHangVC alloc] initWithParking:park];
    [self.view addSubview:daoHangVC.view];
    [self addChildViewController:daoHangVC];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MapSearchModel *newModel = self.collectionArray[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",newModel.searchTitle,@"addressName",@"2.0.0",@"version",nil];
        [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(deleteCollection) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
             [self.collectionArray removeObjectAtIndex:indexPath.row];
            [self.collectionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        } error:^(NSString *error) {
            
        } failure:^(NSString *fail) {
            
        }];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删掉";
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

@end
