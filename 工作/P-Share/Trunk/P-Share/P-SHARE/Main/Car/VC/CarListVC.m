//
//  CarListVC.m
//  P-SHARE
//
//  Created by fay on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CarListVC.h"
#import "CarListCell.h"
#import "AddCarInfoViewController.h"
#import "UserCenterController.h"

@interface CarListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray  *_dataArray;
}
@property (nonatomic,assign)NSInteger page;

@end

@implementation CarListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆管理";
    [self loadTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KUSER_CAR_CHANGE object:nil];
    
    
}

- (void)loadTableView
{
    _dataArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.rowHeight = 103.0f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [tableView registerNib:[UINib nibWithNibName:@"CarListCell" bundle:nil] forCellReuseIdentifier:@"CarListCell"];
    
    WS(ws)
    _page = 1;
    tableView.tableFooterView = [self createTableViewFooterView];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.page = 1;
        [ws loadDataWithPage:ws.page];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.page ++;
        [ws loadDataWithPage:ws.page];
    }];
    
    [_tableView.mj_header beginRefreshing];

}
#pragma mark - 添加脚视图
- (UIView *)createTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = KBG_COLOR;
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH, 45);
    [addBtn setTitle:@"+  添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [footerView addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addNewCar) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 20)];
    addLabel.text = @"点击添加车辆信息";
    addLabel.textColor = [UIColor lightGrayColor];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:addLabel];
    
    return footerView;
    
}
#pragma mark -- 添加新的车辆
- (void)addNewCar
{
    MyLog(@"添加新的车辆");
    AddCarInfoViewController *addCarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCarInfoViewController"];
    [self.rt_navigationController pushViewController:addCarVC animated:YES complete:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.car = _dataArray[indexPath.row];
    WS(ws)
    cell.carListCellBlock = ^(CarListCell *carListCell){
        [ws editCarWithCar:carListCell.car];
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ((RTContainerController *)controller).contentViewController;
   
    
    if (!self.viewVC) {
       
          [self setDefaultCar:_dataArray[indexPath.row]];
    }
  
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car *car = _dataArray[indexPath.row];
        NSString *summary = [[NSString stringWithFormat:@"%@%@",car.carId,SECRET_KEY] MD5];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(deleteCar),car.carId,summary];
        [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:KUSER_CAR_CHANGE object:nil];
        } error:^(NSString *error) {
            
        } failure:^(NSString *fail) {
            
        }];
        
    }
    
}
/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)editCarWithCar:(Car *)car
{
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",[UtilTool getCustomId],car.carId,@"2.0.2",SECRET_KEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",APP_URL(gainbindingcar),[UtilTool getCustomId],car.carId,@"2.0.2",summary];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        car.carBrand = responseObject[@"data"][@"carModel"][@"carBrand"];
        car.carSeries = responseObject[@"data"][@"carModel"][@"carSeries"];
        car.displacement = responseObject[@"data"][@"carModel"][@"displacement"];
        car.displacementShow = responseObject[@"data"][@"carModel"][@"displacementShow"];
        car.intakeType = responseObject[@"data"][@"carModel"][@"intakeType"];
        car.styleYear = responseObject[@"data"][@"carModel"][@"styleYear"];
        car.tradeName = responseObject[@"data"][@"carModel"][@"tradeName"];
        car.engineNum = responseObject[@"data"][@"engineNum"];
        car.frameNum = responseObject[@"data"][@"frameNum"];

        AddCarInfoViewController *addCarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCarInfoViewController"];
        addCarVC.car = car;

        [self.rt_navigationController pushViewController:addCarVC animated:YES complete:^(BOOL finished) {
        }];
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
    
    
  
    
}
- (void)refreshData
{
    _page = 1;
    [self loadDataWithPage:_page];
}
- (void)loadDataWithPage:(NSInteger)page
{
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",[UtilTool getCustomId],@"2.0.2",SECRET_KEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(parkinglist),[UtilTool getCustomId],@"2.0.2",summary];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil
                           needAlert:YES
                             showHud:NO
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 MyLog(@"%@",responseObject);
                                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                     [_dataArray removeAllObjects];
                                     for (NSDictionary *dic in responseObject[@"data"]) {
                                         Car *car = [Car shareObjectWithDic:dic];
                                         [_dataArray addObject:car];
                                     }
                                     
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self endRefresh];
                                         [_tableView reloadData];
                                     });
                                     
                                 });
                                 
                                 
                             } error:^(NSString *error) {
                                 [self endRefresh];
                                 MyLog(@"%@",error);

                             } failure:^(NSString *fail) {
                                 [self endRefresh];
                                 MyLog(@"%@",fail);

                             }];
    
}

#pragma mark - 设置默认车辆
- (void)setDefaultCar:(Car *)car{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",car.carId,@"carId",@"2.0.2",@"version",[UtilTool getTimeStamp],@"timestamp", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(defaultcar) WithDic:dict needEncryption:YES needAlert:YES showHud:YES  success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        [GroupManage shareGroupManages].car = car;
        [self.rt_navigationController popToRootViewControllerAnimated:YES complete:nil];
    } error:^(NSString *error) {
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
    
}

- (void)endRefresh
{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
