//
//  SearchVC.m
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "SearchVC.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ManagerModel.h"
#import "DBManager.h"
#import "SearchCell.h"
#import "ParkAndFavViewController.h"



@interface SearchVC ()<UITextFieldDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AMapSearchAPI *_search;
    AMapInputTipsSearchRequest *_tipsRequest;
    NSMutableArray *_array;
    NSMutableArray *_array1;
    BOOL _isSearchView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UILabel *_favoriteLable;

}
@property (nonatomic,strong)NSMutableArray *searchArray;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ALLOC_MBPROGRESSHUD
    [self getFavoriteParking];
    [self loadMapSearch];
}

- (void)loadMapSearch
{
    //配置用户Key
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapInputTipsSearchRequest对象，设置请求参数
    _tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    _tipsRequest.city = @"上海";
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    [self.searchArray removeAllObjects];
    for (AMapTip *p in response.tips) {
        ManagerModel *model = [[ManagerModel alloc] init];
        model.searchTitle = p.name;
        model.searchLatitude = [NSString stringWithFormat:@"%f",p.location.latitude];
        model.searchLongitude = [NSString stringWithFormat:@"%f",p.location.longitude];
        model.searchDistrict = p.district;
        [self.searchArray addObject:model];
    }
     _isSearchView = YES;
    [_tableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"地图搜索进入"];
    _isSearchView = NO;
    _array = [NSMutableArray arrayWithArray:[[DBManager sharedInstance] searchAllModel]];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"地图搜索退出"];
}
#pragma mark - 
#pragma mark - 查看收藏
- (void)getFavoriteParking{
    BEGIN_MBPROGRESSHUD
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"2.0.0",@"version",nil];
    NSString *url = [NSString stringWithFormat:@"%@",queryCollection];
    [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
         [self loadUI];
        _array1 = [[NSMutableArray alloc]initWithArray:array];
        [self.tableView reloadData];
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
    }];
}
#pragma mark -
#pragma mark - 加载页面
- (void)loadUI
{
    _searchArray = [NSMutableArray array];
   
    self.searchView.layer.cornerRadius = 5;
    self.searchView.clipsToBounds = YES;
    
    [self.familyParking setImage:[[UIImage imageNamed:@"searchHome_v2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if ([MyUtil isBlankString:self.parkingName] == YES) {
          [self.familyParking setTitle:@"设置家的地址" forState:UIControlStateNormal];
    }else{
          [self.familyParking setTitle:self.parkingName forState:UIControlStateNormal];
    }
    _searchBar.placeholder = @"请输入搜索内容";
    [_searchBar setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _searchBar.tintColor = NEWMAIN_COLOR;
    _searchBar.delegate = self;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [self footView];
    
    _favoriteLable = [[UILabel alloc]init];
    _favoriteLable.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _favoriteLable.bounds = CGRectMake(0, 0, 120, 38);
    _favoriteLable.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    _favoriteLable.text = @"收藏成功";
    _favoriteLable.layer.cornerRadius = 7;
    _favoriteLable.clipsToBounds = YES;
    _favoriteLable.font = [UIFont systemFontOfSize:16];
    _favoriteLable.textAlignment = NSTextAlignmentCenter;
    _favoriteLable.hidden = YES;
    [self.view addSubview:_favoriteLable];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
}
- (void)textFiledEditChanged:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[UITextField class]])
    {
         UITextField *textField = notification.object;
        if (textField == self.searchBar) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            _tipsRequest.keywords = textField.text;
            //发起输入提示搜索
            [_search AMapInputTipsSearch: _tipsRequest];
        }
        }
    }
}
#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isSearchView == NO) {
        return 2;
    }else{
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_isSearchView == NO) {
        
        if (section == 0) {
            return _array1.count;
        }else if (section == 1){
            return _array.count;
        }
        
    }else{
    return _searchArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.row = indexPath.row;
    cell.second = indexPath.section;
    cell.block = ^(NSInteger row,NSInteger second){
        [self createFavoriteParkingSecond:second row:row];
    };
    if (_isSearchView == NO) {
        if (indexPath.section == 0) {
            ManagerModel *model = [_array1 objectAtIndex:indexPath.row];
            
            cell.textLabel1.text = model.searchTitle;
            cell.detailTextLabel1.text = model.searchDistrict;
            
            return cell;
        }else if (indexPath.section == 1){
            
        ManagerModel *model = [_array objectAtIndex:indexPath.row];
        cell.textLabel1.text = model.searchTitle;
        cell.favoriteParking.image = [UIImage imageNamed:@"unCollection_v2"];
        cell.detailTextLabel1.text = model.searchDistrict;
        for (ManagerModel *obj in _array1) {
            if ([obj.searchTitle isEqualToString: model.searchTitle]) {
                cell.favoriteParking.image = [UIImage imageNamed:@"collection_v2"];
            }
        }
        
        return cell;
        }
      
    }else{
       ManagerModel *model = [_searchArray objectAtIndex:indexPath.row];
       cell.textLabel1.text = model.searchTitle;
       cell.favoriteParking.image = [UIImage imageNamed:@"unCollection_v2"];
       cell.detailTextLabel1.text = model.searchDistrict;
        for (ManagerModel *obj in _array1) {
            if ([obj.searchTitle isEqualToString: model.searchTitle]) {
                cell.favoriteParking.image = [UIImage imageNamed:@"collection_v2"];
            }
        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isSearchView == NO) {
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 15, SCREEN_WIDTH-14, 15)];
        headLabel.text = @"搜索历史";
        headLabel.font = [UIFont systemFontOfSize:14];
        headLabel.textColor = [MyUtil colorWithHexString:@"aaaaaa"];
        [view addSubview:headLabel];
        return view;
    }
    }else{
        return nil;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearchView == NO) {
        if (indexPath.section == 0) {
            ManagerModel *model = [_array1 objectAtIndex:indexPath.row];
            if (self.SearchVCBlock) {
                
                self.SearchVCBlock(model);
                
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        ManagerModel *model = [_array objectAtIndex:indexPath.row];
       
        if (self.SearchVCBlock) {
            
            self.SearchVCBlock(model);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        ManagerModel *model = [_searchArray objectAtIndex:indexPath.row];
        
        
        if (self.SearchVCBlock) {
            
            self.SearchVCBlock(model);
            
        }
        ManagerModel *dbModel = [[ManagerModel alloc]init];
        dbModel.searchDistrict = model.searchDistrict;
        dbModel.searchLongitude = model.searchLongitude;
        dbModel.searchLatitude = model.searchLatitude;
        dbModel.searchTitle = model.searchTitle;
        if (![[DBManager sharedInstance]isModelExists:dbModel]) {
            [[DBManager sharedInstance]addSearchtModel:dbModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - 
#pragma mark - 点击收藏 点击取消收藏
- (void)createFavoriteParkingSecond:(NSInteger)second row:(NSInteger)row{
    BOOL isNotFavorite = NO;
     NSString *title = nil;
    ManagerModel *model = nil;
    if (_isSearchView == NO) {
               if (second == 0) {
            model = _array1[row];
            title = model.searchTitle;
        }else{
           model = _array[row];
            title = model.searchTitle;
        }
    }else{
        model = _searchArray[row];
        title = model.searchTitle;
    }
    for (ManagerModel *obj in _array1) {
        if ([obj.searchTitle isEqualToString:title]) {
            isNotFavorite = YES;
        }
    }
    
    if (isNotFavorite == NO) {
     //去收藏
        [self goFaviriteParking:model];
    }else{
        //去取消收藏
        [self cancelFaviriteParking:model];
    }
    
}
- (void)goFaviriteParking:(ManagerModel *)model{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL visitorBool = [userDefaults boolForKey:@"visitorBOOL"];
    if (visitorBool == NO) {
        UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
            LoginViewController *login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }Fail:^{
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else{
    BEGIN_MBPROGRESSHUD

    static NSInteger count = 0;
    count++;
     [MobClick event:@"CollectListID" label:model.searchTitle acc:count+1];
     
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",model.searchTitle,@"addressName",model.searchDistrict,@"address",model.searchLatitude,@"latitude",model.searchLongitude,@"longitude",@"2.0.0",@"version",nil];
    NSString *url = [NSString stringWithFormat:@"%@",saveCollection];
    [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
        _array1 = [[NSMutableArray alloc]initWithArray:array];
       END_MBPROGRESSHUD
        [self.tableView reloadData];
        _favoriteLable.hidden = NO;
        [self performSelector:@selector(cancalLabel) withObject:self afterDelay:1];
        
    } Fail:^(NSString *error) {
     END_MBPROGRESSHUD
    }];
    
    }
}
- (void)cancalLabel{
    _favoriteLable.hidden = YES;
}
- (void)cancelFaviriteParking:(ManagerModel *)model{
    BEGIN_MBPROGRESSHUD
    
     NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",model.searchTitle,@"addressName",@"2.0.0",@"version",nil];
     NSString *url = [NSString stringWithFormat:@"%@",deleteCollection];
    [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
        _array1 = [[NSMutableArray alloc]initWithArray:array];
       
        [self.tableView reloadData];
       END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
       END_MBPROGRESSHUD
    }];
}
#pragma mark -
#pragma mark - 清除所有记录
- (UIView *)footView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[MyUtil colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    [button setTitle:@"清除全部记录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(onClernHistory) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)onClernHistory{
    [_array removeAllObjects];
    [[DBManager sharedInstance] deleteAllModel];
    [self.tableView reloadData];
}
//编辑文字改变的回调

#pragma mark -
#pragma mark - 取消按钮点击的回调
- (IBAction)cencleBtn:(UIButton *)sender {
    _isSearchView = NO;
    _searchBar.text = nil;
    [_searchArray removeAllObjects];
    [_tableView reloadData];
    [self.view endEditing:YES];
}

- (IBAction)familyParking:(UIButton *)sender {
    
//    SelectParkController *park = [[SelectParkController alloc]init];
//    [self.navigationController pushViewController:park animated:YES];
    ParkAndFavViewController *park = [[ParkAndFavViewController alloc]init];
    [self.navigationController pushViewController:park animated:YES];
}
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
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
