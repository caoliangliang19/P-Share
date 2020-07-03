//
//  AllOrderController.m
//  P-Share
//
//  Created by 亮亮 on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "AllOrderController.h"
#import "AllOrderCell.h"
#import "MJRefresh.h"
#import "DataSource.h"
#import "CommentVC.h"
#import "RendPayForController.h"
#import "ShareTemParkingViewController.h"
#import "NewTemParkingPayVC.h"
#import "ShowCommentVC.h"
#import "NewDaiBoPayVC.h"
#import "CardPayViewController.h"
#import "ClearCarPay.h"
#import "ShareHistoryDetailController.h"
#import "NewParkingdetailVC.h"
#import "AllHistoryDetailViewController.h"
#import "TimeLineViewController.h"
@interface AllOrderController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AllOrderCellDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _orderIndex;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UITableView *_leftTableView;
    UITableView *_centerTableView;
    UITableView *_rightTableView;
}
@property (nonatomic,strong)UIImageView *orderImageView;
@property (nonatomic,strong)UIButton *noOrderBtn;
@property (nonatomic, strong)NSMutableArray *leftArray;
@property (nonatomic, strong)NSMutableArray *centerArray;
@property (nonatomic, strong)NSMutableArray *rightArray;

@property (nonatomic , strong)UIView *backView1;
@property (nonatomic , strong)UIView *backView2;
@property (nonatomic , strong)UIView *backView3;

@end

@implementation AllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTableView];
    [self createUI];
    [self setRefresh];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRefresh];
}

#pragma mark - 
#pragma mark - 没有订单时的页面
- (void)createUI{
   ALLOC_MBPROGRESSHUD
    _orderIndex = 1;
    [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
    [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
    self.selectedLayout.constant = 0;
    self.orderScrollView.delegate = self;
    self.orderScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-104);
    self.orderScrollView.pagingEnabled = YES;
    self.orderScrollView.bounces = NO;

    
    
}
- (UIView *)createBackView{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    UIImageView *imageView = [MyUtil createImageViewFrame:CGRectMake(0, 0, 168, 144) imageName:@"noOrderImage"];
    imageView.center = CGPointMake((SCREEN_WIDTH)/2, 110);
    self.orderImageView = imageView;
    [backgroundView addSubview:imageView];
    UIButton *noOrderBtn = [MyUtil createBtnFrame:CGRectMake(100, 220, SCREEN_WIDTH-200, 40) title:@"先去首页看看吧" bgImageName:nil target:self action:@selector(goFirstPage)];
    noOrderBtn.layer.cornerRadius = 5;
    noOrderBtn.layer.borderWidth = 1.5;
    noOrderBtn.layer.borderColor = [MyUtil colorWithHexString:@"39d5b8"].CGColor;
    noOrderBtn.clipsToBounds = YES;
    
    noOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [noOrderBtn setTitleColor:[MyUtil colorWithHexString:@"39d5b8"] forState:UIControlStateNormal];
    self.noOrderBtn = noOrderBtn;
    [backgroundView addSubview:noOrderBtn];
   
    return backgroundView;
}
- (void)goFirstPage{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[NewMapHomeVC class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
}
#pragma mark -
#pragma mark - 明杰刷新效果
- (void)setRefresh
{
    
    _curIndex = 1;
    _isLoading = NO;
    if (!_mjHeaderView) {
        _mjHeaderView = [MJRefreshHeaderView header];
    }
    
    _mjHeaderView.scrollView = _leftTableView;
    _mjHeaderView.delegate = self;
    if (!_mjFooterView) {
        _mjFooterView = [MJRefreshFooterView footer];
    }
    
    
    _mjFooterView.scrollView = _leftTableView;
    _mjFooterView.delegate = self;
    
    [self downloadLeftPayForWithBeginIndex:_curIndex];
  
    
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
    [self downloadLeftPayForWithBeginIndex:_curIndex];
    [self downloadCenterPayForWithBeginIndex:_curIndex];
    [self downloadRightPayForWithBeginIndex:_curIndex];
}
- (void)downloadLeftPayForWithBeginIndex:(NSInteger)index{
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)index];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"1",@"tab",pageIndex,@"pageIndex",@"10",@"pageSize",@"2.0.1",@"version", nil];
    NSString *url = [NSString stringWithFormat:@"%@",queryAllOrder];
    [RequestModel requestDaiBoOrder:url WithType:@"getOrder1" WithDic:dict Completion:^(NSArray *dataArray) {
        if (index == 1) {
            self.leftArray =[NSMutableArray arrayWithArray:dataArray];
        }else{
            [self.leftArray addObjectsFromArray:dataArray];
        }
       
        [_leftTableView reloadData];
        [self hideCancle];
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [self downloadCenterPayForWithBeginIndex:_curIndex];
        [self downloadRightPayForWithBeginIndex:_curIndex];
    } Fail:^(NSString *error) {
        _isLoading = NO;
        [self hideCancle];
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    }];
}
- (void)downloadCenterPayForWithBeginIndex:(NSInteger)index{
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)index];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"2",@"tab",pageIndex,@"pageIndex",@"10",@"pageSize",@"2.0.1",@"version", nil];
    NSString *url = [NSString stringWithFormat:@"%@",queryAllOrder];
    [RequestModel requestDaiBoOrder:url WithType:@"getOrder1" WithDic:dict Completion:^(NSArray *dataArray) {
        if (index == 1) {
            self.centerArray =[NSMutableArray arrayWithArray:dataArray];
        }else{
            [self.centerArray addObjectsFromArray:dataArray];
        }
       
        [_centerTableView reloadData];
       [self hideCancle];
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    } Fail:^(NSString *error) {
        _isLoading = NO;
        [self hideCancle];
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    }];
}
- (void)downloadRightPayForWithBeginIndex:(NSInteger)index{
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)index];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"3",@"tab",pageIndex,@"pageIndex",@"10",@"pageSize",@"2.0.1",@"version", nil];
    NSString *url = [NSString stringWithFormat:@"%@",queryAllOrder];
    [RequestModel requestDaiBoOrder:url WithType:@"getOrder1" WithDic:dict Completion:^(NSArray *dataArray) {
        if (index == 1) {
            self.rightArray =[NSMutableArray arrayWithArray:dataArray];
        }else{
            [self.rightArray addObjectsFromArray:dataArray];
        }
       
        [_rightTableView reloadData];
       [self hideCancle];
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    } Fail:^(NSString *error) {
        _isLoading = NO;
       [self hideCancle];
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    }];
}
- (void)hideCancle{
    if (_orderIndex == 1) {
        if (_leftArray.count == 0) {
            self.backView1.hidden = NO;
        }else{
           self.backView1.hidden = YES;
        }
    }else if (_orderIndex == 2){
        if (_centerArray.count == 0) {
           self.backView2.hidden = NO;
        }else{
            self.backView2.hidden = YES;
        }
    }else if (_orderIndex == 3){
        if (_rightArray.count == 0) {
            self.backView3.hidden = NO;
        }else{
           self.backView3.hidden = YES;
        }
    }
    
}
- (void)dealloc
{
    
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
    
}
#pragma mark -
#pragma mark - 加载TableView页面
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = YES;
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    }
    self.backView1 = [self createBackView];
    self.backView1.hidden = YES;
    _leftTableView.backgroundView = self.backView1;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;

    
    
    [_leftTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"leftTableView"];
    [self.orderScrollView addSubview:_leftTableView];
    if (!_centerTableView) {
        _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    }
    self.backView2 = [self createBackView];;
    
    self.backView2.hidden = YES;
    _centerTableView.backgroundView = self.backView2;
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
 
   
    [_centerTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"centerTableView"];
    [self.orderScrollView addSubview:_centerTableView];
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    }
    self.backView3 = [self createBackView];;
    self.backView3.hidden = YES;
    _rightTableView.backgroundView = self.backView3;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;

    
    [_rightTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"rightTableView"];
    [self.orderScrollView addSubview:_rightTableView];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return self.leftArray.count;
    }else if (tableView == _centerTableView){
        return self.centerArray.count;
    }else{
        return self.rightArray.count;
    }
}

- (void)cellIsDataLoad:(TemParkingListModel *)model cell:(AllOrderCell *)cell{
    if ([model.orderType integerValue] == 12) {
        if ([model.orderStatus integerValue] == 1) {
            cell.orderState.text = @"已预约";
            
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = NO;
            [cell.otherBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.otherBtn setTitleColor:[MyUtil colorWithHexString:@"999999"] forState:UIControlStateNormal];
            [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"eeeeee"]];
        }else if ([model.orderStatus integerValue] == 2) {
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = YES;
            cell.orderState.text = @"停车中";
            
        }else if ([model.orderStatus integerValue] == 4) {
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = NO;
            cell.orderState.text = @"停车完毕";
            [cell.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"39d5b8"]];
            
        }else if ([model.orderStatus integerValue] == 14) {
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = NO;
            cell.orderState.text = @"泊回中";
            [cell.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"39d5b8"]];
        }else if ([model.orderStatus integerValue] == 15) {
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = NO;
            cell.orderState.text = @"已泊回";
            [cell.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"39d5b8"]];
        }else if ([model.orderStatus integerValue] == 8) {
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = YES;
            cell.orderState.text = @"取车中";
        }else if ([model.orderStatus integerValue] == 9) {
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = YES;
            cell.orderState.text = @"交车";
        }else if ([model.orderStatus integerValue] == 5) {
            cell.orderState.text = @"已完成";
            
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = NO;
            if ([model.isComment integerValue] == 0) {
                [cell.otherBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [cell.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"39d5b8"]];
            }else{
                [cell.otherBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                [cell.otherBtn setTitleColor:[MyUtil colorWithHexString:@"39d5b8"] forState:UIControlStateNormal];
                [cell.otherBtn setBackgroundColor:[UIColor clearColor]];
            }
        }else if ([model.orderStatus integerValue] == 12) {
            
        }
    }else{
        if ([model.orderStatus integerValue] == 10) {
            cell.orderState.text = @"待付款";
            [cell.otherBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"39d5b8"]];
            cell.cancleBtn.hidden = NO;
            cell.otherBtn.hidden = NO;
        }else if ([model.orderStatus integerValue] == 11){
            cell.orderState.text = @"已完成";
            
            cell.cancleBtn.hidden = YES;
            cell.otherBtn.hidden = NO;
            if ([model.isComment integerValue] == 0) {
                [cell.otherBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [cell.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.otherBtn setBackgroundColor:[MyUtil colorWithHexString:@"39d5b8"]];
            }else{
                [cell.otherBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                [cell.otherBtn setTitleColor:[MyUtil colorWithHexString:@"39d5b8"] forState:UIControlStateNormal];
                [cell.otherBtn setBackgroundColor:[UIColor clearColor]];
            }
            
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTableView) {
       
        
      
        TemParkingListModel *model = self.leftArray[indexPath.row];
        AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTableView"];
        cell.row = indexPath.row;
        cell.delegate = self;
        [self cellIsDataLoad:model cell:cell];
        cell.StopCarType.text = model.orderTypeName;
        cell.paidMoney.text =[NSString stringWithFormat:@"¥%@",model.amountPaid];
        cell.parkingName.text = model.parkingName;
        cell.parkingTime.text = model.createDate;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
        return cell;
    }else if (tableView == _centerTableView){
        TemParkingListModel *model = self.centerArray[indexPath.row];
        AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerTableView"];
        cell.row = indexPath.row;
        cell.delegate = self;
        [self cellIsDataLoad:model cell:cell];
        cell.StopCarType.text = model.orderTypeName;
        cell.paidMoney.text =[NSString stringWithFormat:@"¥%@",model.amountPaid];
        cell.parkingName.text = model.parkingName;
        cell.parkingTime.text = model.createDate;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        TemParkingListModel *model = self.rightArray[indexPath.row];
        AllOrderCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"rightTableView"];
        cell.row = indexPath.row;
        cell.delegate = self;
        [self cellIsDataLoad:model cell:cell];
        cell.StopCarType.text = model.orderTypeName;
        cell.paidMoney.text =[NSString stringWithFormat:@"¥%@",model.amountPaid];
        cell.parkingName.text = model.parkingName;
        cell.parkingTime.text = model.createDate;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }
   
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TemParkingListModel *model = nil;
    if (tableView == _leftTableView) {
        model = self.leftArray[indexPath.row];
    }else if (tableView == _centerTableView){
        model = self.centerArray[indexPath.row];
    }else if (tableView == _rightTableView){
        model = self.rightArray[indexPath.row];
    }
    //月租详情页  任何时候都能进
    if ([model.orderType integerValue] == 12) {
        if([model.orderStatus integerValue] == 5){
            TimeLineViewController *timeLineVC = [[TimeLineViewController alloc] init];
            timeLineVC.orderId = model.orderId;
            timeLineVC.orderType = model.orderType;
            timeLineVC.fromStyle = TimeLineFromOrder;
            [self.navigationController pushViewController:timeLineVC animated:YES];
        }else{
              TimeLineViewController *timeLineVC = [[TimeLineViewController alloc] init];
              timeLineVC.payType = 0;
              CarModel *carmodel = [[CarModel alloc]init];
              carmodel.carNumber = model.carNumber;
              timeLineVC.carModel = carmodel;
          
              ParkingModel *parkModel = [[ParkingModel alloc]init];
              parkModel.parkingId = model.parkingId;
              timeLineVC.parkingModel = parkModel;
              timeLineVC.fromStyle =TimeLineFromMap;
              [self.navigationController pushViewController:timeLineVC animated:YES];
        }
    }else{
     if ([model.orderStatus integerValue] == 11) {
            
    
           if ([model.orderType integerValue] == 10) {
                ShareHistoryDetailController *detailCtrl = [[ShareHistoryDetailController alloc] init];
                NewOrderModel *newModel = [[NewOrderModel alloc]init];
                newModel.orderId = model.orderId;
                newModel.orderType = model.orderType;
                detailCtrl.model = newModel;
                detailCtrl.passOnState = @"从历史订单";
       
        
               [self.navigationController pushViewController:detailCtrl animated:YES];
            }else if ([model.orderType integerValue] == 11) {
                 ShareHistoryDetailController *detailCtrl = [[ShareHistoryDetailController alloc] init];
                 NewOrderModel *newModel = [[NewOrderModel alloc]init];
                 newModel.orderId = model.orderId;
                 newModel.orderType = model.orderType;
                 detailCtrl.model = newModel;
                 detailCtrl.passOnState = @"从历史订单";
                 [self.navigationController pushViewController:detailCtrl animated:YES];
            }else if ([model.orderType integerValue] == 13) {
       
                AllHistoryDetailViewController *allHistory = [[AllHistoryDetailViewController alloc]init];
                 allHistory.temParkModel = model;
                   allHistory.monthRent =@"monthRent";
                if ([model.orderType isEqualToString:@"14"]) {
                   allHistory.historyType = @"chanQuan";
                }else if ([model.orderType isEqualToString:@"13"]){
                   allHistory.historyType = @"yueZu";
                }
                [self.navigationController pushViewController:allHistory animated:YES];
    
           }else if ([model.orderType integerValue] == 14) {
                AllHistoryDetailViewController *allHistory = [[AllHistoryDetailViewController alloc]init];
                allHistory.temParkModel = model;
                allHistory.monthRent =@"monthRent";
               if ([model.orderType isEqualToString:@"14"]) {
                allHistory.historyType = @"chanQuan";
               }else if ([model.orderType isEqualToString:@"13"]){
                allHistory.historyType = @"yueZu";
               }
             [self.navigationController pushViewController:allHistory animated:YES];
          }
       }
    }
 }
#pragma mark -
#pragma mark - Cell的代理方法
- (void)clickBtn:(NSInteger)tag row:(NSInteger)row{
    if (tag == 4) {
       
        switch (_orderIndex) {
            case 1:
            {
                TemParkingListModel *model = self.leftArray[row];
               
                if ([model.orderType integerValue] == 12) {
                    if ([model.orderStatus integerValue] == 4||[model.orderStatus integerValue] == 14||[model.orderStatus integerValue] == 15){
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",model.orderId,@"orderId", nil];
                         BEGIN_MBPROGRESSHUD
                        [RequestModel requestDaiBoOrder:gettingCar WithType:@"getCar" WithDic:dic Completion:^(NSArray *dataArray) {
                            END_MBPROGRESSHUD
                            NewDaiBoPayVC *payVC = [[NewDaiBoPayVC alloc] init];
                            payVC.temPayModel = dataArray[0];
                            payVC.parkingId = model.parkingId;
                           
                            payVC.temPayModel.orderId = model.orderId;
                            [self.navigationController pushViewController:payVC animated:YES];
                            
                        } Fail:^(NSString *error) {
                            END_MBPROGRESSHUD
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alert show];
                            alert = nil;
                            
                        }];

                    }else if([model.orderStatus integerValue] == 1){
                        [MyUtil alertController:@"是否确定取消订单" viewController:self Completion:^{
                            //确定
                            [self cancleOrder:row];
                        } Fail:^{
                            //取消
                            
                        }];
                    }else if ([model.orderStatus integerValue] == 5){
                        //已完成
                        if ([model.isComment integerValue] == 0){
                            CommentVC *commentVC = [[CommentVC alloc] init];
                            commentVC.style = CommentVCStyleOne;
                            commentVC.model = model;
                            [self.navigationController pushViewController:commentVC animated:YES];
                        }else{
                            ShowCommentVC *commentVC = [[ShowCommentVC alloc] init];
                            commentVC.model = model;
                            
                            [self.navigationController pushViewController:commentVC animated:YES];
                        }
                    }
                   
                }else{
                if ([model.orderStatus integerValue] == 10) {
                  //未付款
                    if ([model.orderType integerValue] == 11) {
                        NewTemParkingPayVC *shareTemParkingVC = [[NewTemParkingPayVC alloc] init];
                        shareTemParkingVC.temParkModel = model;
                        
                        [self.navigationController pushViewController:shareTemParkingVC animated:YES];
                    }else if ([model.orderType integerValue] == 13) {
                        RendPayForController *rend = [[RendPayForController alloc]init];
                        rend.index = row;
                        rend.temParkingModel = model;
                        rend.parkingId = model.parkingId;
                        [self.navigationController pushViewController:rend animated:YES];
                    }else if ([model.orderType integerValue] == 14) {
                        RendPayForController *rend = [[RendPayForController alloc]init];
                        rend.index = row;
                        rend.temParkingModel = model;
                        rend.parkingId = model.parkingId;
                        [self.navigationController pushViewController:rend animated:YES];
                        
                    }else if ([model.orderType integerValue] == 15) {
                        CardPayViewController *cardPay = [[CardPayViewController alloc]init];
                        cardPay.temModel1 = model;
                        [self.navigationController pushViewController:cardPay animated:YES];
                    }else if ([model.orderType integerValue] == 16) {
                        
                    }else if ([model.orderType integerValue] == 17) {
                        ClearCarPay *rend = [[ClearCarPay alloc]init];
                        
                        rend.temParkingModel = model;
                        rend.parkingId = model.parkingId;
                        [self.navigationController pushViewController:rend animated:YES];
                    }else if ([model.orderType integerValue] == 10) {
                        ShareTemParkingViewController *share = [[ShareTemParkingViewController alloc]init];
                        share.temModel = model;
                        [self.navigationController pushViewController:share animated:YES];
                    }
                }else if ([model.orderStatus integerValue] == 11){
                  //已完成
                    if ([model.isComment integerValue] == 0){
                        CommentVC *commentVC = [[CommentVC alloc] init];
                        commentVC.model = model;
                        [self.navigationController pushViewController:commentVC animated:YES];
                    }else{
                        ShowCommentVC *commentVC = [[ShowCommentVC alloc] init];
                        commentVC.model = model;
                        [self.navigationController pushViewController:commentVC animated:YES];
                    }
                }
                }
                
               
            }
                break;
            case 2:
            {
                TemParkingListModel *model = self.centerArray[row];
                
                if ([model.orderType integerValue] == 12) {
                    if ([model.orderStatus integerValue] == 4||[model.orderStatus integerValue] == 14||[model.orderStatus integerValue] == 15){
                        BEGIN_MBPROGRESSHUD
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",model.orderId,@"orderId", nil];
                        [RequestModel requestDaiBoOrder:gettingCar WithType:@"getCar" WithDic:dic Completion:^(NSArray *dataArray) {
                            END_MBPROGRESSHUD
                            NewDaiBoPayVC *payVC = [[NewDaiBoPayVC alloc] init];
                            payVC.temPayModel = dataArray[0];
                            payVC.parkingId = model.parkingId;
                            
                            payVC.temPayModel.orderId = model.orderId;
                            [self.navigationController pushViewController:payVC animated:YES];
                           
                        } Fail:^(NSString *error) {
                            END_MBPROGRESSHUD
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alert show];
                            alert = nil;
                            
                        }];
                        
                    }else if([model.orderStatus integerValue] == 1){
                        [MyUtil alertController:@"是否确定取消订单" viewController:self Completion:^{
                            //确定
                            [self cancleOrder:row];
                        } Fail:^{
                            //取消
                            
                        }];
                    }
                    
                }else{
                    if ([model.orderStatus integerValue] == 10) {
                        //未付款
                        if ([model.orderType integerValue] == 11) {
                            NewTemParkingPayVC *shareTemParkingVC = [[NewTemParkingPayVC alloc] init];
                            shareTemParkingVC.temParkModel = model;
                            
                            [self.navigationController pushViewController:shareTemParkingVC animated:YES];
                        }else if ([model.orderType integerValue] == 13) {
                            RendPayForController *rend = [[RendPayForController alloc]init];
                            rend.index = row;
                            rend.temParkingModel = model;
                            rend.parkingId = model.parkingId;
                            [self.navigationController pushViewController:rend animated:YES];
                        }else if ([model.orderType integerValue] == 14) {
                            RendPayForController *rend = [[RendPayForController alloc]init];
                            rend.index = row;
                            rend.temParkingModel = model;
                            rend.parkingId = model.parkingId;
                            [self.navigationController pushViewController:rend animated:YES];
                            
                        }else if ([model.orderType integerValue] == 15) {
                            CardPayViewController *cardPay = [[CardPayViewController alloc]init];
                            cardPay.temModel1 = model;
                            [self.navigationController pushViewController:cardPay animated:YES];
                        }else if ([model.orderType integerValue] == 16) {
                            
                        }else if ([model.orderType integerValue] == 17) {
                            ClearCarPay *rend = [[ClearCarPay alloc]init];
                            
                            rend.temParkingModel = model;
                            rend.parkingId = model.parkingId;
                            [self.navigationController pushViewController:rend animated:YES];
                        }else if ([model.orderType integerValue] == 10) {
                            ShareTemParkingViewController *share = [[ShareTemParkingViewController alloc]init];
                            share.temModel = model;
                            [self.navigationController pushViewController:share animated:YES];
                        }
                    }else if ([model.orderStatus integerValue] == 11){
                        //已完成
                        if ([model.isComment integerValue] == 0){
                            CommentVC *commentVC = [[CommentVC alloc] init];
                            commentVC.style = CommentVCStyleOne;
                                             commentVC.model = model;
                            [self.navigationController pushViewController:commentVC animated:YES];
                        }else{
                            ShowCommentVC *commentVC = [[ShowCommentVC alloc] init];
                                             commentVC.model = model;
                            
                            [self.navigationController pushViewController:commentVC animated:YES];
                        }
                    }
                }
            }
                break;
            case 3:
            {
                 TemParkingListModel *model = self.rightArray[row];
                 CommentVC *commentVC = [[CommentVC alloc] init];
                 commentVC.style = CommentVCStyleOne;
                 commentVC.model = model;
                 [self.navigationController pushViewController:commentVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (tag == 5){
       [MyUtil alertController:@"是否确定取消订单" viewController:self Completion:^{
           //确定
           [self cancleOrder:row];
       } Fail:^{
           //取消
          
       }];
    }
}
- (void)cancleOrder:(NSInteger)index
{
    TemParkingListModel *model = nil;
    if (_orderIndex == 1) {
        model = self.leftArray[index];
    }else if (_orderIndex == 2){
        model = self.centerArray[index];
    }
  
    //---------------------------网路请求----取消订单
    
   
    NSString *summery = [[NSString stringWithFormat:@"%@%@",model.orderId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",cancelOrder,model.orderId,summery];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *requestModel = [RequestModel new];
    [requestModel getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            if ([dict[@"errorNum"] isEqualToString:@"0"]) {
              
                END_MBPROGRESSHUD
                if (_orderIndex == 1) {
                    [self.leftArray removeObjectAtIndex:index];
                     [_leftTableView reloadData];
                   [self downloadCenterPayForWithBeginIndex:_curIndex];
                  
                }else if (_orderIndex == 2){
                    [self.centerArray removeObjectAtIndex:index];
                    [_centerTableView reloadData];
                    [self downloadLeftPayForWithBeginIndex:_curIndex];
                   
                }
            }
        }
       
        
    } error:^(NSString *error) {
        END_MBPROGRESSHUD
        
    } failure:^(NSString *fail) {
        
        END_MBPROGRESSHUD;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backFome:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)stopCarProveBtn:(UIButton *)sender{
    CGFloat btnWidth = SCREEN_WIDTH/3;
    switch (sender.tag) {
        case 1:
        {
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            _orderIndex = 1;
            if (_leftArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.backView1.hidden = NO;
                });
            }else{
                self.backView1.hidden = YES;
            }
            [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            _mjHeaderView.scrollView = _leftTableView;
            _mjFooterView.scrollView = _leftTableView;
            [self.orderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 2:
        {
            if (_centerArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.backView2.hidden = NO;
                });
            }else{
                self.backView2.hidden = YES;
            }
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            _orderIndex = 2;
            [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            _mjHeaderView.scrollView = _centerTableView;
            _mjFooterView.scrollView = _centerTableView;
            [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        }
            break;
        case 3:
        {
            if (_rightArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.backView3.hidden = NO;
                });
            }else{
                self.backView3.hidden = YES;
            }
            _orderIndex = 3;
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth*2;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            _mjHeaderView.scrollView = _rightTableView;
            _mjFooterView.scrollView = _rightTableView;
            [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UIScrollView的代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat btnWidth = SCREEN_WIDTH/3;
    CGFloat float1 = self.orderScrollView.contentOffset.x;
    if (scrollView == self.orderScrollView) {
        if (float1 == 0) {
            if (_leftArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   self.backView1.hidden = NO;
                });
              
            }else{
               self.backView1.hidden = YES;
            }
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            _orderIndex = 1;
            [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = 0;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
                
            }];
            _mjHeaderView.scrollView = _leftTableView;
            _mjFooterView.scrollView = _leftTableView;
            [self.orderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            
        }else if(float1 == SCREEN_WIDTH){
            if (_centerArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   self.backView2.hidden = NO;
                });
            }else{
                self.backView2.hidden = YES;
            }
            _orderIndex = 2;
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
                
            }];
            _mjHeaderView.scrollView = _centerTableView;
            _mjFooterView.scrollView = _centerTableView;
            [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            
        }else if(float1 == SCREEN_WIDTH*2){
            if (_rightArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   self.backView3.hidden = NO;
                });
            }else{
               self.backView3.hidden = YES;
            }
            _orderIndex = 3;
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.allOrderBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noPayForBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noAssessBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth*2;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
                
            }];
            _mjHeaderView.scrollView = _rightTableView;
            _mjFooterView.scrollView = _rightTableView;
            [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        }
    }
}


@end
