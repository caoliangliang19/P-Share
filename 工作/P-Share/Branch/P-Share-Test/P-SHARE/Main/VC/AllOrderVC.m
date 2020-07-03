//
//  AllOrderVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/12/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AllOrderVC.h"
#import "NoDataView.h"
#import "ShareOrderDetailVC.h"
#import "PayCenterViewController.h"
#import "CommentVC.h"
#import "ShowCommentVC.h"
#import "TimeLineVC.h"

@interface AllOrderVC ()

@property (nonatomic , strong)NoDataView *dataView1;
@property (nonatomic , strong)NoDataView *dataView2;
@property (nonatomic , strong)NoDataView *dataView3;

@end

@implementation AllOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    _select.selectArray =[[NSMutableArray alloc]initWithArray:@[@"全部",@"待付款",@"待评价"]];
    [self createTableView];
    [self firstRefresh];
}
- (NoDataView *)dataView1{
    if (_dataView1 == nil) {
        _dataView1 = [[NoDataView alloc]init];
        _dataView1.hidden = YES;
    }
    return _dataView1;
}
- (NoDataView *)dataView2{
    if (_dataView2 == nil) {
        _dataView2 = [[NoDataView alloc]init];
        _dataView2.hidden = YES;
    }
    return _dataView2;
}
- (NoDataView *)dataView3{
    if (_dataView3 == nil) {
        _dataView3 = [[NoDataView alloc]init];
        _dataView3.hidden = YES;
    }
    return _dataView3;
}
- (void)createTableView{
   _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundView = self.dataView1;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_leftTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"leftID"];
    [_scrollView addSubview:_leftTableView];
    
    _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
    _centerTableView.backgroundView = self.dataView2;
    _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _centerTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_centerTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"centerID"];
    [_scrollView addSubview:_centerTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.backgroundView = self.dataView3;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_rightTableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"rightID"];
    [_scrollView addSubview:_rightTableView];
    self.tableView = _leftTableView;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRrfreshData) name:@"PING_JIA_CHENG_GONG" object:nil];
}
- (void)onRrfreshData{
    _isLeft = NO;
    _isCenter = NO;
    _isRight = NO;
    [self firstRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView){
        return self.leftArray.count;
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
        Order *model = nil;
        if (self.leftArray.count !=0) {
            model = self.leftArray[indexPath.row];
            cell.delegate = self;
            [cell upDataCell:model indexPathRow:indexPath.row];
        }
       
        return cell;
    }else if (tableView == _centerTableView){
        
        AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerID" forIndexPath:indexPath];
        Order *model = nil;
        if (self.centerArray.count !=0) {
            model = self.centerArray[indexPath.row];
            cell.delegate = self;
            [cell upDataCell:model indexPathRow:indexPath.row];
        }
       
        return cell;
    }else if (tableView == _rightTableView){
        AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightID" forIndexPath:indexPath];
         Order *model = nil;
        if (self.rightArray.count !=0) {
            model = self.rightArray[indexPath.row];
            cell.delegate = self;
            [cell upDataCell:model indexPathRow:indexPath.row];
        }
       
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
    }else{
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
#pragma mark -
#pragma mark - 添加Cell代理方法
- (void)clickBtn:(NSInteger)tag row:(NSInteger)row{
    OrderModel *model = nil;
    if (tag == 4){
        if ([self.tab integerValue] == 0) {
            model = self.leftArray[row];
        }else if ([self.tab integerValue] == 1) {
            model = self.centerArray[row];
        }else if ([self.tab integerValue] == 2) {
            model = self.rightArray[row];
        }
        if ([model.orderType integerValue] == 12){
            if ([model.orderStatus integerValue] == 14||[model.orderStatus integerValue] == 15||[model.orderStatus integerValue] == 4) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.3.7",@"version",model.orderId,@"orderId", nil];
                [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(gettingCar) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                    OrderModel *model = [OrderModel shareObjectWithDic:responseObject[@"data"]];
                    model.orderType = @"12";
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
#pragma mark - 
#pragma mark - 取消订单
- (void)cancleOrder:(NSInteger)index
{
    OrderModel *model = nil;
    if ([self.tab integerValue] == 0) {
        model = self.leftArray[index];
    }else if ([self.tab integerValue] == 1){
        model = self.centerArray[index];
    }
    NSString *summery = [[NSString stringWithFormat:@"%@%@",model.orderId,SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(cancelOrder),model.orderId,summery];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetWorkEngine getRequestUse:(self) WithURL:urlString WithDic:nil needAlert:NO showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.tab integerValue] == 0) {
            [self.leftArray removeObjectAtIndex:index];
            [_leftTableView reloadData];
            
            [self.centerArray enumerateObjectsUsingBlock:^(OrderModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.orderId isEqualToString:model.orderId]) {
                    [self.centerArray removeObjectAtIndex:idx];
                    [_centerTableView reloadData];
                }
            }];
            
           
            
        }else if ([self.tab integerValue] == 1){
            [self.centerArray removeObjectAtIndex:index];
            [_centerTableView reloadData];
            
            [self.leftArray enumerateObjectsUsingBlock:^(OrderModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.orderId isEqualToString:model.orderId]) {
                    [self.leftArray removeObjectAtIndex:idx];
                    [_leftTableView reloadData];
                }
            }];

        }
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
}

#pragma mark -
#pragma mark - 父类的方法
- (void)selectBtn:(UIButton *)button;{
    [super selectBtn:button];
    WS(wf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [wf hideDataView];
    });
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    [super scrollViewDidEndDecelerating:scrollView];
    WS(wf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wf hideDataView];
    });
   
}
- (void)createTableData:(NSString *)tab{
    [super createTableData:tab];
    [self hideDataView];
}
#pragma mark -
#pragma mark - 有无订单状态的出现
- (void)hideDataView{
    if ([self.tab integerValue] == 0) {
        if (self.leftArray.count > 0) {
            self.dataView1.hidden = YES;
            _leftTableView.scrollEnabled = YES;
        }else{
            self.dataView1.hidden = NO;
            _leftTableView.scrollEnabled = NO;
        }
    }else if ([self.tab integerValue] == 1){
        if (self.centerArray.count > 0) {
            self.dataView2.hidden = YES;
            _centerTableView.scrollEnabled = YES;
        }else{
            self.dataView2.hidden = NO;
            _centerTableView.scrollEnabled = NO;
        }
    }else if ([self.tab integerValue] == 2){
        if (self.rightArray.count > 0) {
            self.dataView3.hidden = YES;
            _rightTableView.scrollEnabled = YES;
        }else{
            self.dataView3.hidden = NO;
            _rightTableView.scrollEnabled = NO;
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
