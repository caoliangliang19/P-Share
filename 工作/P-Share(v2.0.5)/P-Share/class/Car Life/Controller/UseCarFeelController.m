//
//  UseCarFeelController.m
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "UseCarFeelController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UseCarFeelCell.h"
#import "DiscountActController.h"
#import "WeChatController.h"
#import "CarLiftModel.h"
#import "WebViewController.h"

@interface UseCarFeelController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    UITableView *_carTableView;
    NSMutableArray *_carDataArray;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UIAlertView *_alert;
}

@property (nonatomic,strong)UIView *headerView;
@end

@implementation UseCarFeelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeadView];
    [self createTableView];
    [self setRefresh];
}
#pragma mark - 
#pragma mark - 创建 UINavigationController 自定义
- (void)createHeadView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.headerView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
    
    UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(50, 64-30, SCREEN_WIDTH-100, 20) title:@"用车心得" textColor:[MyUtil colorWithHexString:@"fcfcfc"] font:[UIFont systemFontOfSize:19] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [self.headerView addSubview:titleLabel];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 34, 15, 20)];
    backImageView.image = [UIImage imageNamed:@"defaultBack"];
    [self.headerView addSubview:backImageView];
    UIButton *backBtn = [MyUtil createBtnFrame:CGRectMake(0, 20, 60, 44) title:nil bgImageName:nil target:self action:@selector(backBtnClick:)];
    [self.headerView addSubview:backBtn];
    UIImageView *backImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 34, 20, 20)];
    backImageView1.image = [UIImage imageNamed:@"whiteCarMarster"];
    [self.headerView addSubview:backImageView1];
    UIButton *backBtn1 = [MyUtil createBtnFrame:CGRectMake(SCREEN_WIDTH-44, 20, 60, 44) title:nil bgImageName:nil target:self action:@selector(backBtnClick1:)];
    [self.headerView addSubview:backBtn1];
    [self.view addSubview:self.headerView];
}
- (void)backBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)backBtnClick1:(UIButton *)button{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"口袋停客服";
    
    
    QYSessionViewController *sessionVC = [[QYSDK sharedSDK] sessionViewController];
    sessionVC.sessionTitle = @"口袋停客服";
    sessionVC.groupId = [[DataSource shareInstance].qiyuId integerValue];
   
    QYCustomUIConfig *custom = [[QYSDK sharedSDK] customUIConfig];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageString = [userDefaults objectForKey:customer_head];
    UIImageView *temImgV = [[UIImageView alloc] init];
    [temImgV sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultHeaderImage"]];
    custom.customerHeadImage = temImgV.image;
    custom.serviceHeadImage = [UIImage imageNamed:@"logoPshare"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    sessionVC.navigationItem.hidesBackButton = YES;
    custom.rightBarButtonItemColorBlackOrWhite = NO;
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(5, 34, 35, 40);
    [btn setImage:[UIImage imageNamed:@"defaultBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];[btn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 20)];sessionVC.navigationItem.leftBarButtonItem=back;
    QYUserInfo *user = [[QYUserInfo alloc] init];user.userId = @"1234";
    user.data = @"fay";
    [[QYSDK sharedSDK] setUserInfo:user];
    [self.navigationController pushViewController:sessionVC animated:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -
#pragma mark - 添加MJ刷新效果
- (void)setRefresh
{
    ALLOC_MBPROGRESSHUD
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = _carTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = _carTableView;
    _mjFooterView.delegate = self;
    
    [self createDataSource];
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
    [self createDataSource];
}
-(void)dealloc{
    _mjHeaderView.scrollView = nil;
    _mjFooterView.scrollView = nil;
}
- (void)createDataSource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.parkingId,@"parkingId",@"2.0.2",@"version", nil];
    BEGIN_MBPROGRESSHUD
    [RequestModel requestGetCarLiftWith:queryActivity withDic:dic Completion:^(NSDictionary *dic) {
        _carDataArray = dic[@"type2"];
        [_carTableView reloadData];
        [_mjFooterView endRefreshing];
        [_mjHeaderView endRefreshing];
        _isLoading = NO;
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        [_mjFooterView endRefreshing];
        [_mjHeaderView endRefreshing];
        _isLoading = NO;
        END_MBPROGRESSHUD
    }];
}
#pragma mark -
#pragma mark - 创建 tableView
- (void)createTableView{
    _carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
    _carTableView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    _carTableView.delegate = self;
    _carTableView.dataSource = self;
    [_carTableView registerNib:[UINib nibWithNibName:@"UseCarFeelCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    _carTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_carTableView];
}

#pragma mark -
#pragma mark - 创建TableView数据源
- (void)setDataArray:(NSMutableArray *)dataArray{
    if (dataArray.count == 0) {
        ALERT_VIEW(@"暂无优惠活动");
        _alert = nil;
    }else{
    _carDataArray = dataArray;
    [_carTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _carDataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UseCarFeelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
     CarLiftModel *model = _carDataArray[indexPath.row];
    [cell.useCarImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"index_ch_head_313"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH*100/173+10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarLiftModel *model = [_carDataArray objectAtIndex:indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.type = WebViewControllerTypeNeedShare;
    webVC.titleStr = model.title;
    webVC.url = model.url;
    webVC.imagePath = model.imagePath;
    [self.navigationController pushViewController:webVC animated:YES];
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
