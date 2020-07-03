//
//  AllOrderController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AllOrderController.h"
#import "SelectView.h"
#import "AllOrderCell.h"
#import "NoDataView.h"
#import "ShareOrderDetailVC.h"
#import "PayCenterViewController.h"
#import "CommentVC.h"
#import "ShowCommentVC.h"
#import "TimeLineVC.h"
@interface AllOrderController ()<SelectViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AllOrderCellDelegate>
{
    SelectView *_select;
    UIScrollView *_orderScrollView;
    UITableView *_leftTableView;
    UITableView *_centerTableView;
    UITableView *_rightTableView;
    NSMutableArray *_orderArray;
    
    
    BOOL _isLeft;
    BOOL _isCenter;
    BOOL _isRight;
}
@property (nonatomic,strong)NoDataView *dataView;
@property (nonatomic,copy)NSString *tab;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,assign)NSInteger leftPageIndex;
@property(nonatomic,assign)NSInteger centerPageIndex;
@property(nonatomic,assign)NSInteger rightPageIndex;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableArray *centerArray;
@property (nonatomic,strong)NSMutableArray *rightArray;

@end

@implementation AllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createNavigation];
    [self createRefresh];
    
    
}
#pragma mark - 
#pragma mark - 懒加载数组
- (NoDataView *)dataView{
    if (_dataView == nil) {
        _dataView = [[NoDataView alloc]init];
         [_orderScrollView addSubview:_dataView];
    }
    return _dataView;
}
- (NSMutableArray *)leftArray{
    if (_leftArray == nil) {
        _leftArray = [[NSMutableArray alloc]init];
    }
    return _leftArray;
}
- (NSMutableArray *)centerArray{
    if (_centerArray == nil) {
        _centerArray = [[NSMutableArray alloc]init];
    }
    return _centerArray;
}
- (NSMutableArray *)rightArray{
    if (_rightArray == nil) {
        _rightArray = [[NSMutableArray alloc]init];
    }
    return _rightArray;
}
- (void)createNavigation{
    _select = [[SelectView alloc]initWithController:self];
    _select.delegate = self;
    _select.selectArray = [[NSMutableArray alloc]initWithObjects:@"全部",@"待付款",@"待评价", nil];
    if (self.state == CLLOrderTypeStateAllOrder) {
        _tab = @"1";
        _isLeft = YES;
        self.tableView = _leftTableView;
        [_orderScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _select.selectIndex = 1;
    }else if(self.state == CLLOrderTypeStateNOPayFor){
        _tab = @"2";
        _isCenter = YES;
        self.tableView = _centerTableView;
         [_orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        _select.selectIndex = 2;
    }else if(self.state == CLLOrderTypeStateNOJudge){
        _tab = @"3";
        _isRight = YES;
        self.tableView = _rightTableView;
          [_orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:NO];
        _select.selectIndex = 3;
    }
    
}

#pragma mark - 
#pragma mark - 添加MJ刷新
- (void)createRefresh{
    if ([_tab integerValue] == 1) {
        self.leftPageIndex = 1;
    }else if ([_tab integerValue] == 2){
        self.centerPageIndex = 1;
    }else if ([_tab integerValue] == 3){
        self.rightPageIndex = 1;
    }
    
    self.isRefresh = NO;
    self.isLoading = NO;
    [self createMJRefresh];
}
- (void)createMJRefresh{
    __weak typeof (self)weakself = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isRefresh) {
            return ;
        }
        if ([weakself.tab integerValue] == 1) {
            weakself.leftPageIndex = 1;
        }else if ([weakself.tab integerValue] == 2){
            weakself.centerPageIndex = 1;
        }else if ([weakself.tab integerValue] == 3){
            weakself.rightPageIndex = 1;
        }
        weakself.isRefresh = YES;
        if ([weakself.tab integerValue] == 1) {
             [weakself createRequest:weakself.leftPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 2){
             [weakself createRequest:weakself.centerPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 3){
             [weakself createRequest:weakself.rightPageIndex tab:weakself.tab];
        }
       
        
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        if ([weakself.tab integerValue] == 1) {
            weakself.leftPageIndex++;
        }else if ([weakself.tab integerValue] == 2){
            weakself.centerPageIndex++;
        }else if ([weakself.tab integerValue] == 3){
            weakself.rightPageIndex++;
        }
        weakself.isLoading = YES;
        if ([weakself.tab integerValue] == 1) {
            [weakself createRequest:weakself.leftPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 2){
            [weakself createRequest:weakself.centerPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 3){
            [weakself createRequest:weakself.rightPageIndex tab:weakself.tab];
        }
    }];
    
}
- (void)createRequest:(NSInteger)index tab:(NSString *)tab{
     NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)index];
     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",tab,@"tab",pageIndex,@"pageIndex",@"10",@"pageSize",@"2.0.1",@"version", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryAllOrder) WithDic:dict needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        _orderArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject[@"data"]) {
            OrderModel *model = [OrderModel shareObjectWithDic:dict];
            [_orderArray addObject:model];
        }
        if ([tab integerValue] == 1) {
            if (index == 1) {
                self.leftArray =[NSMutableArray arrayWithArray:_orderArray];
            }else{
                [self.leftArray addObjectsFromArray:_orderArray];
            }
            self.dataView.frame = _leftTableView.frame;
           
            [_leftTableView reloadData];
             [self isEmPty:self.leftArray];
        }else if ([tab integerValue] == 2){
            if (index == 1) {
                self.centerArray =[NSMutableArray arrayWithArray:_orderArray];
            }else{
                [self.centerArray addObjectsFromArray:_orderArray];
            }
            [_centerTableView reloadData];
             self.dataView.frame = _centerTableView.frame;
             [self isEmPty:self.centerArray];
        }else if ([tab integerValue] == 3){
            if (index == 1) {
                self.rightArray =[NSMutableArray arrayWithArray:_orderArray];
            }else{
                [self.rightArray addObjectsFromArray:_orderArray];
            }
             [_rightTableView reloadData];
              self.dataView.frame = _rightTableView.frame;
            [self isEmPty:self.rightArray];
        }
        self.isLoading = NO;
        self.isRefresh = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } error:^(NSString *error) {
        self.isLoading = NO;
        self.isRefresh = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSString *fail) {
        self.isLoading = NO;
        self.isRefresh = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}
- (void)isEmPty:(NSMutableArray *)array{
    
    if (array.count == 0) {
        [self.dataView showView];
    }else{
        [self.dataView hideView];
    }
}
#pragma mark - 
#pragma mark - add三个tableView
- (void)createTableView{
    self.title = @"我的订单";
    _orderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    _orderScrollView.pagingEnabled = YES;
    _orderScrollView.delegate = self;
    _orderScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-104);
    _orderScrollView.bounces = NO;
    [self.view addSubview:_orderScrollView];
    
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    self.tableView = _leftTableView;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.tag = 2;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"leftID"];
    [_orderScrollView addSubview:_leftTableView];
    
   _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
    _centerTableView.tag = 3;
    _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_centerTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"centerID"];
    [_orderScrollView addSubview:_centerTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tag = 4;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rightTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"rightID"];
    [_orderScrollView addSubview:_rightTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRrfreshData) name:@"PING_JIA_CHENG_GONG" object:nil];
    
}
- (void)onRrfreshData{
    [self createRequest:1 tab:@"1"];
    [self createRequest:1 tab:@"2"];
    [self createRequest:1 tab:@"3"];
}
#pragma mark -
#pragma mark - 三个tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_leftTableView) {
        return  self.leftArray.count;
    }else if (tableView == _centerTableView){
        return self.centerArray.count;
    }else if (tableView == _rightTableView){
        return self.rightArray.count;
    }
    return 0;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
            AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftID" forIndexPath:indexPath];
            Order *model = self.leftArray[indexPath.row];
            cell.delegate = self;
            [cell upDataCell:model indexPathRow:indexPath.row];
            return cell;
    }else if (tableView == _centerTableView){
    
            AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerID" forIndexPath:indexPath];
            Order *model = self.centerArray[indexPath.row];
            cell.delegate = self;
            [cell upDataCell:model indexPathRow:indexPath.row];
            return cell;
    }else if (tableView == _rightTableView){
            AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightID" forIndexPath:indexPath];
            Order *model = self.rightArray[indexPath.row];
            cell.delegate = self;
            [cell upDataCell:model indexPathRow:indexPath.row];
            return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = nil;
    if (tableView == _leftTableView) {
        model = self.leftArray[indexPath.row];
    }else if (tableView == _centerTableView){
        model = self.centerArray[indexPath.row];
    }else if (tableView == _rightTableView){
        model = self.rightArray[indexPath.row];
    }
    
    
    if ([model.orderType integerValue] == 12) {
        
        TimeLineVC *timeLineVC = [[TimeLineVC alloc] init];
        timeLineVC.timeLineVCStyle = YES;
        timeLineVC.orderModel = model;
        [self.rt_navigationController pushViewController:timeLineVC animated:YES complete:nil];
        
        
    }else
    {
        if ([model.orderStatus integerValue] == 11) {
            if ([model.orderType integerValue] == 10 ||[model.orderType integerValue] == 11) {
                ShareOrderDetailVC *share = [[ShareOrderDetailVC alloc]init];
                if([model.orderType integerValue] == 10){
                    share.type = CLLOrderDetailControllerShare;
                }else{
                    share.type = CLLOrderDetailControllerLinT;
                }
                
                share.orderModel = model;
                [self.rt_navigationController pushViewController:share animated:YES complete:nil];
            }else if ([model.orderType integerValue] == 13 || [model.orderType integerValue] == 14){
                ShareOrderDetailVC *share = [[ShareOrderDetailVC alloc]init];
                share.type = CLLOrderDetailControllerYuZu;
                share.orderModel = model;
                [self.rt_navigationController pushViewController:share animated:YES complete:nil];
            }
        }

    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 未付款 已付款 和全部按钮
- (void)selectBtn:(UIButton *)button{
    
     [_orderScrollView setContentOffset:CGPointMake((button.tag-100)*SCREEN_WIDTH, 0) animated:NO];
        switch (button.tag) {
        case 100:
        {
            [_rightTableView.mj_header endRefreshing];
            [_rightTableView.mj_footer endRefreshing];
            [_centerTableView.mj_footer endRefreshing];
            [_centerTableView.mj_header endRefreshing];
            self.tableView = _leftTableView;
            self.dataView.frame = _leftTableView.frame;
            _tab = @"1";
            if (_isLeft == NO) {
                [self.dataView hideView];
                [self createRefresh];
                _isLeft = YES;
            }
            [self isEmPty:self.leftArray];
        }
            break;
        case 101:
        {
            [_rightTableView.mj_header endRefreshing];
            [_rightTableView.mj_footer endRefreshing];
            [_leftTableView.mj_footer endRefreshing];
            [_leftTableView.mj_header endRefreshing];
            self.tableView = _centerTableView;
             self.dataView.frame = _centerTableView.frame;
            _tab = @"2";
            if (_isCenter == NO) {
                [self.dataView hideView];
                [self createRefresh];
                _isCenter = YES;
                
            }else{
                [self isEmPty:self.centerArray];
            }
            
        }
            break;
        case 102:
        {
            [_centerTableView.mj_header endRefreshing];
            [_centerTableView.mj_footer endRefreshing];
            [_leftTableView.mj_footer endRefreshing];
            [_leftTableView.mj_header endRefreshing];
            self.tableView = _rightTableView;
            self.dataView.frame = _rightTableView.frame;
            _tab = @"3";
            if (_isRight == NO) {
                [self.dataView hideView];
                [self createRefresh];
                _isRight = YES;
            }else{
                [self isEmPty:self.rightArray];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark -
#pragma mark - 添加Cell代理方法
- (void)clickBtn:(NSInteger)tag row:(NSInteger)row{
    OrderModel *model = nil;
    if (tag == 4){
        if ([_tab integerValue] == 1) {
            model = self.leftArray[row];
        }else if ([_tab integerValue] == 2) {
            model = self.centerArray[row];
        }else if ([_tab integerValue] == 3) {
            model = self.rightArray[row];
        }
        if ([model.orderType integerValue] == 12){
            if ([model.orderStatus integerValue] == 14||[model.orderStatus integerValue] == 15||[model.orderStatus integerValue] == 4) {
                 NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.3.7",@"version",model.orderId,@"orderId", nil];
                [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(gettingCar) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                    OrderModel *model = [OrderModel shareObjectWithDic:responseObject[@"data"]];
                    PayCenterViewController *payCenter = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
                    payCenter.order = model;
                    payCenter.hasOrder = YES;
                    payCenter.orderKind = PayCenterViewControllerOrferTypeDaiBo;
                    [self.rt_navigationController pushViewController:payCenter animated:YES];
                    
                } error:^(NSString *error) {
                    
                } failure:^(NSString *fail) {
                    
                }];
            }else if ([model.orderStatus integerValue] == 1){
                [UtilTool creatAlertController:self title:@"提示" describute:@"是否确定取消订单" sureClick:^{
                    [self cancleOrder:row];
                } cancelClick:^{
                    
                }];
            }else if ([model.orderStatus integerValue] == 5){
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
            PayCenterViewController *payCenter = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
           
            payCenter.hasOrder = YES;
            payCenter.order = model;
            if ([model.orderType integerValue] == 10) {
                payCenter.orderKind = PayCenterViewControllerOrferTypeYuYue;
            }else if ([model.orderType integerValue] == 11){
                 payCenter.orderKind = PayCenterViewControllerOrferTypeLinTing;
            }else if ([model.orderType integerValue] == 13){
                 payCenter.orderKind = PayCenterViewControllerOrferTypeYueZu;
            }else if ([model.orderType integerValue] == 14){
                payCenter.orderKind = PayCenterViewControllerOrferTypeChanQuan;
            }
            
            [self.rt_navigationController pushViewController:payCenter animated:YES];
        }else{
            if ([model.isComment integerValue] == 0) {
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
    }else{
        [self cancleOrder:row];

    }
    
    
}
- (void)cancleOrder:(NSInteger)index
{
    OrderModel *model = nil;
    if ([_tab integerValue] == 1) {
        model = self.leftArray[index];
    }else if ([_tab integerValue] == 2){
        model = self.centerArray[index];
    }
    
    //---------------------------网路请求----取消订单
    
    
    NSString *summery = [[NSString stringWithFormat:@"%@%@",model.orderId,SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(cancelOrder),model.orderId,summery];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetWorkEngine getRequestUse:(self) WithURL:urlString WithDic:nil needAlert:NO showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([_tab integerValue] == 1) {
            [self.leftArray removeObjectAtIndex:index];
            [self deleteThisModel:model.orderId tableView:_centerTableView array:self.centerArray];
            [_leftTableView reloadData];
            [_centerTableView reloadData];
        }else if ([_tab integerValue] == 2){
            [self.centerArray removeObjectAtIndex:index];
            
              [self deleteThisModel:model.orderId tableView:_leftTableView array:self.leftArray];
           [_centerTableView reloadData];
           [_leftTableView reloadData];
            
        }

    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];

}
- (void)deleteThisModel:(NSString *)orderId tableView:(UITableView *)tableview array:(NSMutableArray *)array{
    [array enumerateObjectsUsingBlock:^(OrderModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orderId isEqualToString:orderId]) {
            [array removeObjectAtIndex:idx];
        }
    }];
}
#pragma mark -
#pragma mark - 添加ScrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat float1 = _orderScrollView.contentOffset.x;
    if (scrollView == _orderScrollView) {
        _select.selectIndex = float1/SCREEN_WIDTH+1;
    }
    if (float1/SCREEN_WIDTH == 0) {
        [_rightTableView.mj_header endRefreshing];
        [_rightTableView.mj_footer endRefreshing];
        [_centerTableView.mj_footer endRefreshing];
        [_centerTableView.mj_header endRefreshing];
        self.tableView = _leftTableView;
        self.dataView.frame = _leftTableView.frame;
        _tab = @"1";
        if (_isLeft == NO) {
            [self.dataView hideView];
            [self createRefresh];
        }
        [self isEmPty:self.leftArray];
    }else if (float1/SCREEN_WIDTH == 1){
        [_rightTableView.mj_header endRefreshing];
        [_rightTableView.mj_footer endRefreshing];
        [_leftTableView.mj_footer endRefreshing];
        [_leftTableView.mj_header endRefreshing];
        self.tableView = _centerTableView;
        self.dataView.frame = _centerTableView.frame;
        _tab = @"2";
        if (_isCenter == NO) {
            [self.dataView hideView];
            [self createRefresh];
            _isCenter = YES;
            
        }else{
            [self isEmPty:self.centerArray];
        }
    }else if (float1/SCREEN_WIDTH == 2){
        [_centerTableView.mj_header endRefreshing];
        [_centerTableView.mj_footer endRefreshing];
        [_leftTableView.mj_footer endRefreshing];
        [_leftTableView.mj_header endRefreshing];
        self.tableView = _rightTableView;
        self.dataView.frame = _rightTableView.frame;
        _tab = @"3";
        if (_isRight == NO) {
            [self.dataView hideView];
            [self createRefresh];
            _isRight = YES;
        }else{
            [self isEmPty:self.rightArray];
        }
    }
}
- (void)dealloc{
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
