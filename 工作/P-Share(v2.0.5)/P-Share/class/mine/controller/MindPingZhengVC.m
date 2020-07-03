//
//  MindPingZhengVC.m
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "MindPingZhengVC.h"
#import "PingZhengCell.h"
#import "MJRefresh.h"
#import "YuYuePingZhengDetail.h"
#import "TemParkingListModel.h"


@interface MindPingZhengVC ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate,PingZhengCellDelegate>
{
    NSMutableArray *_dataArray;
    UIAlertView *_alert;
    
//    NSInteger _selectIndexNow;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    UITableView *_leftTableView;
    UITableView *_centerTableView;
    UITableView *_rightTableView;
    
}
@property (nonatomic, strong)NSMutableArray *leftArray;
@property (nonatomic, strong)NSMutableArray *centerArray;
@property (nonatomic, strong)NSMutableArray *rightArray;

@end

@implementation MindPingZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createThreeTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRefresh];

}
#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)leftArray{
    if (!_leftArray) {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}
- (NSMutableArray *)centerArray{
    if (!_centerArray) {
        _centerArray = [NSMutableArray array];
    }
    return _centerArray;
}
- (NSMutableArray *)rightArray{
    if (!_rightArray) {
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
}
#pragma mark -
#pragma mark - 页面出现更新UI
- (void)createUI{
    //三个按钮最初状态
    [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
    [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
    self.selectedLayout.constant = 0;
    self.proveScrollView.delegate = self;
    
    self.proveScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-104);
    self.proveScrollView.pagingEnabled = YES;
    self.proveScrollView.bounces = NO;

}
#pragma mark -
#pragma mark - 创建3个TableView
- (void)createThreeTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    }
    
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = [UIColor clearColor];
//    _leftTableView.tableHeaderView = [self createHeadView];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerNib:[UINib nibWithNibName:@"PingZhengCell" bundle:nil] forCellReuseIdentifier:@"leftTableView"];
    [self.proveScrollView addSubview:_leftTableView];
    if (!_centerTableView) {
         _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    }
   
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
//    _centerTableView.tableHeaderView = [self createHeadView];
    _centerTableView.backgroundColor = [UIColor clearColor];
    _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_centerTableView registerNib:[UINib nibWithNibName:@"PingZhengCell" bundle:nil] forCellReuseIdentifier:@"centerTableView"];
    [self.proveScrollView addSubview:_centerTableView];
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    }
    
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    //    _centerTableView.tableHeaderView = [self createHeadView];
    _rightTableView.backgroundColor = [UIColor clearColor];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rightTableView registerNib:[UINib nibWithNibName:@"PingZhengCell" bundle:nil] forCellReuseIdentifier:@"rightTableView"];
    [self.proveScrollView addSubview:_rightTableView];
    
   
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
    [self downloadCenterPayForWithBeginIndex:_curIndex];
    [self downloadRightPayForWithBeginIndex:_curIndex];
   
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

- (void)dealloc
{
    
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
    
}
#pragma mark - 
#pragma mark - 三个协议请求 0未付款 1已付款 2已取消
- (void)downloadLeftPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    
    BEGIN_MBPROGRESSHUD;
   
    NSString *summary = [[NSString stringWithFormat:@"%@%@%ld%@",CUSTOMERMOBILE(customer_id),@"0",(long)beginIndex,MD5_SECRETKEY] MD5];
    //queryVoucherPage
    
    NSString *urlString = [[NSString stringWithFormat:@"%@/%@/%@/%ld/%@",queryVoucherPage,CUSTOMERMOBILE(customer_id),@"0",(long)beginIndex,summary] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RequestModel requstQueryVoucherPageWithURL:urlString type:@"0" Completion:^(NSMutableArray *resultArray) {
        _isLoading = NO;
        if (beginIndex == 1) {
            self.leftArray = resultArray;
        }else{
            [self.leftArray addObjectsFromArray:resultArray];
        }
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [_leftTableView reloadData];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
}
- (void)downloadCenterPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    
    BEGIN_MBPROGRESSHUD;
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%ld%@",CUSTOMERMOBILE(customer_id),@"1",(long)beginIndex,MD5_SECRETKEY] MD5];
    //queryVoucherPage
    
    NSString *urlString = [[NSString stringWithFormat:@"%@/%@/%@/%ld/%@",queryVoucherPage,CUSTOMERMOBILE(customer_id),@"1",(long)beginIndex,summary] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RequestModel requstQueryVoucherPageWithURL:urlString type:@"1" Completion:^(NSMutableArray *resultArray) {
        _isLoading = NO;
        if (beginIndex == 1) {
            self.centerArray = resultArray;
        }else{
            [self.centerArray addObjectsFromArray:resultArray];
        }
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [_centerTableView reloadData];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
}
- (void)downloadRightPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    
    BEGIN_MBPROGRESSHUD;
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%ld%@",CUSTOMERMOBILE(customer_id),@"2",(long)beginIndex,MD5_SECRETKEY] MD5];
    //queryVoucherPage
    
    NSString *urlString = [[NSString stringWithFormat:@"%@/%@/%@/%ld/%@",queryVoucherPage,CUSTOMERMOBILE(customer_id),@"2",(long)beginIndex,summary] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RequestModel requstQueryVoucherPageWithURL:urlString type:@"2" Completion:^(NSMutableArray *resultArray) {
        _isLoading = NO;
        if (beginIndex == 1) {
            self.rightArray = resultArray;
        }else{
            [self.rightArray addObjectsFromArray:resultArray];
        }
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [_rightTableView reloadData];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
}




#pragma mark -
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return self.leftArray.count;
    }else if (tableView == _centerTableView){
        return self.centerArray.count;
    }else{
        return self.rightArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _leftTableView) {
        PingZhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTableView"];
            cell.tableViewType = @"left";
        TemParkingListModel *model = self.leftArray[indexPath.row];
       
        cell.carNumL.text = model.carNumber;
        cell.timeL.text =[NSString stringWithFormat:@"支付时间:%@",model.payTime];
        cell.parkingNameL.text = model.parkingName;
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;
    }else if (tableView == _centerTableView){
        PingZhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerTableView"];
        cell.tableViewType  = @"center";
        TemParkingListModel *model = self.centerArray[indexPath.row];
        
        cell.carNumL.text = model.carNumber;
       cell.timeL.text =[NSString stringWithFormat:@"支付时间:%@",model.payTime];
        cell.parkingNameL.text = model.parkingName;
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;
    }
        PingZhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightTableView"];
        cell.tableViewType = @"right";
    TemParkingListModel *model = self.rightArray[indexPath.row];
    
    cell.carNumL.text = model.carNumber;
    cell.timeL.text =[NSString stringWithFormat:@"支付时间:%@",model.payTime];
    cell.parkingNameL.text = model.parkingName;
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;
   

    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backVC:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -
#pragma mark - 3个按钮点击状态
- (IBAction)stopCarProveBtn:(UIButton *)sender {
    CGFloat btnWidth = SCREEN_WIDTH/3;
    switch (sender.tag) {
        case 1:
        {
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            _mjHeaderView.scrollView = _leftTableView;
            _mjFooterView.scrollView = _leftTableView;
            [self.proveScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 2:
        {
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            _mjHeaderView.scrollView = _centerTableView;
            _mjFooterView.scrollView = _centerTableView;
            [self.proveScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        }
            break;
        case 3:
        {
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth*2;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
             _mjHeaderView.scrollView = _rightTableView;
             _mjFooterView.scrollView = _rightTableView;
            [self.proveScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - MingZhengCell代理
- (void)clickPingBtn:(NSInteger)index tableView:(NSString *)type{
    
    TemParkingListModel *model = nil;
    if ([type isEqualToString:@"left"]) {
        model = self.leftArray[index];
    }else if ([type isEqualToString:@"center"]){
        model = self.centerArray[index];
    }else if ([type isEqualToString:@"right"]){
        model = self.rightArray[index];
    }
    YuYuePingZhengDetail *detail = [[YuYuePingZhengDetail alloc]init];
    detail.pingZhengModel = model;
    detail.type = type;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - 
#pragma mark - UIScrollView的代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    CGFloat btnWidth = SCREEN_WIDTH/3;
    CGFloat float1 = self.proveScrollView.contentOffset.x;
    if (scrollView == self.proveScrollView) {
        if (float1 == 0) {
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = 0;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
                
            }];
            _mjHeaderView.scrollView = _leftTableView;
            _mjFooterView.scrollView = _leftTableView;
            [self.proveScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

            
        }else if(float1 == SCREEN_WIDTH){
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
                
            }];
            _mjHeaderView.scrollView = _centerTableView;
            _mjFooterView.scrollView = _centerTableView;
            [self.proveScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
          
        }else if(float1 == SCREEN_WIDTH*2){
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
            [self.noUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.yesUserBtn setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            [self.noHaveBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.selectedLayout.constant = btnWidth*2;
            [UIView animateWithDuration:.3 animations:^{
                [self.view layoutIfNeeded];
                
            }];
            _mjHeaderView.scrollView = _rightTableView;
            _mjFooterView.scrollView = _rightTableView;
            [self.proveScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        }
    }
    
    
}
@end
