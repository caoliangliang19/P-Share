//
//  CarListViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "CarListViewController.h"
#import "CarListCell.h"
#import "AddCarInfoViewController.h"
#import "CarModel.h"
#import "MJRefresh.h"
#import "CarSetVC.h"
#import "UIImageView+WebCache.h"


@interface CarListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _isEditing;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}

@property (nonatomic,strong)NSMutableArray *carArray;
@property (nonatomic,strong)NewCarModel *model;

@end

@implementation CarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    self.carArray = [NSMutableArray array];
    
    [self setRefresh];
    
    self.carListTableView.tableFooterView = [self createTableViewFooterView];
    
    ALLOC_MBPROGRESSHUD;
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"车辆列表进入"];
//    _curIndex = 1;
//    [self loadCarArrayDataWithBeginIndex:_curIndex];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCarData:) name:@"CarSetVCNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCarData:) name:@"UserCarChange" object:nil];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"车辆列表退出"];
  
    
}

- (void)refreshCarData:(NSNotification *)notifocation
{
    [self loadCarArrayDataWithBeginIndex:1];

}

- (void)setUI
{
    _isEditing = NO;
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.carListTableView.backgroundColor = BACKGROUND_COLOR;
    self.carListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.carListTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.carListTableView;
    _mjFooterView.delegate = self;
    
    [_mjHeaderView beginRefreshing];
}

- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self loadCarArrayDataWithBeginIndex:_curIndex];
}

#pragma mark -
#pragma mark - 请求数据
- (void)loadCarArrayDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----查看车列表
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];

    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",userId,@"2.0.2",MD5_SECRETKEY] MD5];

    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",NewCarList,userId,@"2.0.2",summary];
    
    [RequestModel requestGetCarListWithURL:url WithPage:beginIndex Completion:^(NSArray *dataArray) {

        self.carArray = [[NSMutableArray alloc]initWithArray:dataArray];
        
        [self.carListTableView reloadData];
        
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD

    } Fail:^(NSString *error) {
        
    
        if (error.length > 0) {
            ALERT_VIEW(error);
            _alert = nil;
        }
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
        
    }];
    
    
}
#pragma mark -
#pragma mark - 添加脚试图
- (UIView *)createTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH, 45);
    [addBtn setTitle:@"+  添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [footerView addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addNewCar:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 20)];
    addLabel.text = @"点击添加车辆信息";
    addLabel.textColor = [UIColor lightGrayColor];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:addLabel];
   
    return footerView;
   
}

#pragma mark -
#pragma mark - 添加新的车辆
- (void)addNewCar:(UIButton *)btn
{
    AddCarInfoViewController *addCarCtrl = [[AddCarInfoViewController alloc] init];
    [self.navigationController pushViewController:addCarCtrl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.carArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"carListCellId";
    CarListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarListCell" owner:self options:nil]lastObject];
    }
    cell.second = indexPath.section;
    NewCarModel *model = self.carArray[indexPath.section];
    cell.carNameLabel.text = model.carName;
    cell.carNumLabel.text = model.carNumber;
    if ([MyUtil isBlankString:model.travlledDistance] == NO&&[MyUtil isBlankString:model.carUseDate] == NO) {
        cell.lineView.hidden = NO;
    }else{
        cell.lineView.hidden = YES;
    }
    if ([MyUtil isBlankString:model.travlledDistance] == YES) {
        cell.driveDistance.text = @"";
    }else{
        cell.driveDistance.text =[NSString stringWithFormat:@"行驶里程 %@km",model.travlledDistance];
    }
    if ([MyUtil isBlankString:model.carUseDate] == YES) {
       cell.driveTime.text =@"";
    }else{
        cell.driveTime.text =[NSString stringWithFormat:@"上路时间 %@",model.carUseDate];
    }
    
    [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:model.brandIcon] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    if ([model.carIsAutoPay integerValue] == 1) {
        cell.carInfo.text = @"已开启钱包自动支付";
        [cell.carInfo setTextColor:[MyUtil colorWithHexString:@"39D5B8"]];
        
    }else
    {
        cell.carInfo.text = @"未开启钱包自动支付";
        [cell.carInfo setTextColor:[MyUtil colorWithHexString:@"A7A7A7"]];

    }
    __weak typeof(self) weakself = self;
    cell.myBlock = ^(NSInteger second){
        [weakself clickMoreCarInfo:second];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_carListTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.goInType == GoInControllerTypeWashCar) {
         NewCarModel *model = self.carArray[indexPath.section];
        [self setDefaultCar:model];
       
       
    }else{
    if (_markForm == 1) {
//        从停车缴费界面进入 将所选的车牌号  传递给停车缴费界面
        NewCarModel *model = self.carArray[indexPath.section];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CarListViewController" object:model.carNumber];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
//        点击事件
//        NewCarModel *model = self.carArray[indexPath.row];
//        CarSetVC *setVC = [[CarSetVC alloc] init];
//        setVC.carModel = model;
//        [self.navigationController pushViewController:setVC animated:YES];
        
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEGIN_MBPROGRESSHUD;
    NewCarModel *model = self.carArray[indexPath.section];

    NSString *summary = [[NSString stringWithFormat:@"%@%@",model.carId,MD5_SECRETKEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",delete,model.carId,summary];
    
    [RequestModel validatePurseBaoCodeWithURL:url WithDic:nil Completion:^(NSString *result) {
        
        END_MBPROGRESSHUD
        if ([result isEqualToString:@"0"])
        {
            [self.carArray removeObjectAtIndex:indexPath.section];
            [self.carListTableView reloadData];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCarChange" object:nil];

            
        }
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
    }];
    
}
#pragma mark -
#pragma mark - 点击进入编辑
- (void)clickMoreCarInfo:(NSInteger)second{
    __weak typeof(self) weakself = self;
    NewCarModel *model = weakself.carArray[second];
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",CUSTOMERMOBILE(customer_id),model.carId,@"2.0.2",MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",gainBindingCar,CUSTOMERMOBILE(customer_id),model.carId,@"2.0.2",summary];
    BEGIN_MBPROGRESSHUD
    [RequestModel requstTopUpListAndConsumeListWithURL:url type:@"gainBindingCar" Completion:^(NSMutableArray *resultArray) {
        weakself.model = resultArray.firstObject;
        AddCarInfoViewController *addCarInFor = [[AddCarInfoViewController alloc]init];
        addCarInFor.model = weakself.model;
        [weakself.navigationController pushViewController:addCarInFor animated:YES];
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
    }];
    
}
#pragma mark - 
#pragma mark - 设置默认车辆
- (void)setDefaultCar:(NewCarModel *)model{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",model.carId,@"carId",@"2.0.2",@"version",[MyUtil getTimeStamp],@"timestamp", nil];
    BEGIN_MBPROGRESSHUD
    [RequestModel postGetDiction:defaultcar WithDic:dict Completion:^(NSDictionary *dataDic) {
        if (self.passOnCarNumber) {
            self.passOnCarNumber(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        ALERT_VIEW(error)
        _alert = nil;
        END_MBPROGRESSHUD
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editingBtnClick:(id)sender {
    _isEditing = !_isEditing;
    
    if (_isEditing) { 
        //----------换图片
        self.imageWidthConstraint.constant = 17;
        self.imageHeightConstraint.constant = 12;
        self.editingImageView.image = [UIImage imageNamed:@"tick"];
        self.carListTableView.editing = YES;
    }else{
        //----------换图片
        self.imageWidthConstraint.constant = 17;
        self.imageHeightConstraint.constant = 17;
        self.editingImageView.image = [UIImage imageNamed:@"deleteEditing"];
        self.carListTableView.editing = NO;
    }
}

@end



