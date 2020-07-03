//
//  MoneyBaoController.m
//  P-Share
//
//  Created by 亮亮 on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MoneyBaoController.h"
#import "MoneyBaoCell.h"
#import "MJRefresh.h"
#import "PurseTopUpController.h"

@interface MoneyBaoController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    
    UITableView *_topUpTableView;
    UITableView *_consumeTableView;
    
    BOOL _isTableView;
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}
@property (nonatomic,strong)NSMutableArray *topUpArray;
@property (nonatomic,strong)NSMutableArray *conmustArray;
@end

@implementation MoneyBaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createTwoTableView];
    [self setRefresh];
  
}
#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)topUpArray{
    if (_topUpArray == nil) {
        _topUpArray = [[NSMutableArray alloc]init];
    }
    return _topUpArray;
}
-(NSMutableArray *)conmustArray{
    if (_conmustArray == nil) {
        _conmustArray = [[NSMutableArray alloc]init];
    }
    return _conmustArray;
}
#pragma mark -
#pragma mark - 更新Ui
- (void)createUI{
    _isTableView = YES;
    [self.topUpHistory setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
    self.topUpView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
    self.historyScrollView.delegate = self;
    self.historyScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-104);
    self.historyScrollView.pagingEnabled = YES;
    self.historyScrollView.bounces = NO;
}

#pragma mark -
#pragma mark - 添加MJ刷新效果
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    if (_isTableView == YES) {
          _mjHeaderView.scrollView = _topUpTableView;
    }else if(_isTableView == NO){
         _mjHeaderView.scrollView = _topUpTableView;
    }
    
   _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
   
    if (_isTableView == YES) {
        _mjFooterView.scrollView = _topUpTableView;
    }else if(_isTableView == NO){
        _mjFooterView.scrollView = _topUpTableView;
    }
  
    _mjFooterView.delegate = self;
    
    [self downloadDataNoPayForWithBeginIndex:_curIndex];
    [self downloadDataPayForWithBeginIndex:_curIndex];
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
    [self downloadDataNoPayForWithBeginIndex:_curIndex];
    [self downloadDataPayForWithBeginIndex:_curIndex];
}

//加载历史订单数据
#pragma mark 未付款数据请求
- (void)downloadDataNoPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    NSString *summery = [[NSString stringWithFormat:@"%@%ld%@",userID,(long)beginIndex,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%ld/%@",rechargelist,userID,(long)beginIndex,summery];
    
    [RequestModel requstTopUpListAndConsumeListWithURL:url type:rechargelist Completion:^(NSMutableArray *resultArray) {
        _isLoading = NO;
        if (beginIndex == 1) {
             self.topUpArray = resultArray;
        }else{
            [self.topUpArray addObjectsFromArray:resultArray];
        }
       
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [_topUpTableView reloadData];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
       
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
//    [RequestModel requestMonthRentOrderListWithURL:beginIndex orderStare:@"10" orderType:self.orderType Completion:^{
//        _isLoading = NO;
//        
//        [_mjHeaderView endRefreshing];
//        [_mjFooterView endRefreshing];
//        [_tableView reloadData];
//        END_MBPROGRESSHUD;
//    } Fail:^(NSString *error) {
//        _isLoading = NO;
//        [_mjHeaderView endRefreshing];
//        [_mjFooterView endRefreshing];
//        END_MBPROGRESSHUD;
//    }];
    
}
#pragma mark 已经付款数据请求
- (void)downloadDataPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    
    BEGIN_MBPROGRESSHUD;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    NSString *summery = [[NSString stringWithFormat:@"%@%ld%@",userID,(long)beginIndex,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%ld/%@",consumlist,userID,(long)beginIndex,summery];
    [RequestModel requstTopUpListAndConsumeListWithURL:url type:consumlist Completion:^(NSMutableArray *resultArray) {
                _isLoading = NO;
        if (beginIndex == 1) {
            self.conmustArray = resultArray;
        }else{
            [self.conmustArray addObjectsFromArray:resultArray];
        }
              
                [_mjHeaderView endRefreshing];
                [_mjFooterView endRefreshing];
                [_consumeTableView reloadData];
                END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
    
    
//    [RequestModel requestMonthRentOrderListWithURL:beginIndex orderStare:@"11" orderType:self.orderType Completion:^{
//        _isLoading = NO;
//        
//        [_mjHeaderView endRefreshing];
//        [_mjFooterView endRefreshing];
//        [_tableView reloadData];
//        END_MBPROGRESSHUD;
//    } Fail:^(NSString *error) {
//        _isLoading = NO;
//        [_mjHeaderView endRefreshing];
//        [_mjFooterView endRefreshing];
//        END_MBPROGRESSHUD;
//    }];
    
    
    
}
- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
}
- (UIView *)createHeadView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4)];
    view.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    return view;
}

#pragma mark -
#pragma mark - 创建两个TableView
- (void)createTwoTableView{
   
        _topUpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
        
        _topUpTableView.delegate = self;
        _topUpTableView.dataSource = self;
        _topUpTableView.backgroundColor = [UIColor clearColor];
        _topUpTableView.tableHeaderView = [self createHeadView];
        _topUpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_topUpTableView registerNib:[UINib nibWithNibName:@"MoneyBaoCell" bundle:nil] forCellReuseIdentifier:@"callID"];
        [self.historyScrollView addSubview:_topUpTableView];
    
    _consumeTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    _consumeTableView.delegate = self;
    _consumeTableView.dataSource = self;
     _consumeTableView.tableHeaderView = [self createHeadView];
    _consumeTableView.backgroundColor = [UIColor clearColor];
    _consumeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_consumeTableView registerNib:[UINib nibWithNibName:@"MoneyBaoCell" bundle:nil] forCellReuseIdentifier:@"callId"];
    [self.historyScrollView addSubview:_consumeTableView];
    
  
}

#pragma mark -
#pragma mark - 点击事件 切换界面
- (IBAction)backBtnClick:(id)sender;{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)topUpBtnClick:(UIButton *)payBtn{
    
    [UIView animateWithDuration:.3 animations:^{
        CGPoint point = _topUpView.center;
        point.x = payBtn.center.x;
        _topUpView.center = point;
        
    }];
    
    if (payBtn.tag == 11) {
        [self.historyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _isTableView = YES;
    }else if(payBtn.tag == 12){
        

        _isTableView = NO;
        [self.historyScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        
    }
    
    [self isPayForSign];
}
- (void)isPayForSign{
    if (_isTableView == YES) {
        [_topUpTableView reloadData];
        
        _mjHeaderView.scrollView = _topUpTableView;
        _mjFooterView.scrollView = _topUpTableView;
    }else if (_isTableView == NO){
        [_consumeTableView reloadData];
        
        _mjHeaderView.scrollView = _consumeTableView;
        _mjFooterView.scrollView = _consumeTableView;
    }
}
#pragma mark -
#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    if (tableView == _topUpTableView) {
        return self.topUpArray.count;
    }else if (tableView == _consumeTableView){
        return self.conmustArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (tableView == _topUpTableView) {
    TemParkingListModel *model = self.topUpArray[indexPath.row];
    MoneyBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"callID"];
        
        cell.hourTimeL.text = model.payTimeForTime;
        cell.yearTimeL.text = model.payTimeForDate;
        if ([model.payType isEqualToString:@"00"]) {
            cell.payForTypeL.text = @"支付宝支付";
        }else if ([model.payType isEqualToString:@"01"]){
            cell.payForTypeL.text = @"微信支付";
        }
        
        cell.moneyL.text = [NSString stringWithFormat:@"+%@",model.amountPaid];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }

     TemParkingListModel *model = self.conmustArray[indexPath.row];
    MoneyBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"callId"];
    cell.hourTimeL.text = model.payTimeForTime;
    cell.yearTimeL.text = model.payTimeForDate;
    NSString *orderType = [NSString stringWithFormat:@"%@",model.orderType];
    if ([orderType isEqualToString:@"10"]) {
        cell.payForTypeL.text = @"专享临停缴费";
    }else if ([orderType isEqualToString:@"11"]){
        cell.payForTypeL.text = @"临停缴费";
    }else if ([orderType isEqualToString:@"1"]){
        cell.payForTypeL.text = @"代泊缴费";
    }else if ([orderType isEqualToString:@"13"]){
        cell.payForTypeL.text = @"月租缴费";
    }else if ([orderType isEqualToString:@"14"]){
        cell.payForTypeL.text = @"产权缴费";
    }else if ([orderType isEqualToString:@"15"]){
        cell.payForTypeL.text = @"加油卡缴费";
    }else if ([orderType isEqualToString:@"16"]){
        cell.payForTypeL.text = @"钱包缴费";
    }
    
    cell.moneyL.text = [NSString stringWithFormat:@"-%@",model.amountPaid];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}
#pragma mark -
#pragma mark - ScrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
   
    
    CGFloat float1 = self.historyScrollView.contentOffset.x;
    if (scrollView == self.historyScrollView) {
        if (float1 == 0) {

            [UIView animateWithDuration:.3 animations:^{
                CGPoint point = _topUpView.center;
                point.x = SCREEN_WIDTH/4;
                _topUpView.center = point;
                
            }];
            [self.historyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            _isTableView = YES;
            [self isPayForSign];
            
        }else if(float1 == SCREEN_WIDTH){
           

            [UIView animateWithDuration:.3 animations:^{
                CGPoint point = _topUpView.center;
                point.x = SCREEN_WIDTH/4*3;
                _topUpView.center = point;
                
            }];
            [self.historyScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
             _isTableView = NO;
            [self isPayForSign];
        }
    }
    
    
}
@end
