//
//  DisfferentController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "DisfferentController.h"

@interface DisfferentController ()

@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isLoading;



@end

@implementation DisfferentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}
- (void)setType:(DisfferentVCType)type{
    _type = type;
}
- (void)createUI{
    _tab = @"0";
    _select = [[SelectView alloc]initWithController:self];
    _select.delegate = self;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    if (_type == DisfferentVCTypePing || _type == DisfferentVCTypeOrder) {
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-104);
    }else if(_type == DisfferentVCTypeJiLu){
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-104);
    }else if (_type == DisfferentVCTypeStop){
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-104);
    }
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.right.bottom.left.mas_equalTo(0);
    }];
}
- (void)firstRefresh{
    if ([_tab integerValue] == 0) {
        self.leftPageIndex = 1;
    }else if ([_tab integerValue] == 1){
        self.centerPageIndex = 1;
    }else if ([_tab integerValue] == 2){
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
        if ([weakself.tab integerValue] == 0) {
            weakself.leftPageIndex = 1;
        }else if ([weakself.tab integerValue] == 1){
            weakself.centerPageIndex = 1;
        }else if ([weakself.tab integerValue] == 2){
            weakself.rightPageIndex = 1;
        }
        weakself.isRefresh = YES;
        if ([weakself.tab integerValue] == 0) {
            [weakself createRequest:weakself.leftPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 1){
            [weakself createRequest:weakself.centerPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 2){
            [weakself createRequest:weakself.rightPageIndex tab:weakself.tab];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        if ([weakself.tab integerValue] == 0) {
            weakself.leftPageIndex++;
        }else if ([weakself.tab integerValue] == 1){
            weakself.centerPageIndex++;
        }else if ([weakself.tab integerValue] == 2){
            weakself.rightPageIndex++;
        }
        weakself.isLoading = YES;
        if ([weakself.tab integerValue] == 0) {
            [weakself createRequest:weakself.leftPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 1){
            [weakself createRequest:weakself.centerPageIndex tab:weakself.tab];
        }else if ([weakself.tab integerValue] == 2){
            [weakself createRequest:weakself.rightPageIndex tab:weakself.tab];
        }
    }];
    
}
- (void)createRequest:(NSInteger)index tab:(NSString *)tab{
    if([tab integerValue] == 0){
        _isLeft = YES;
    }
    if([tab integerValue] == 1){
        _isCenter = YES;
    }
    if([tab integerValue] == 2){
        _isRight = YES;
    }
    if (_type == DisfferentVCTypeJiLu) {
        NSString *url = nil;
        if ([tab integerValue] == 0) {
            NSString *summery = [[NSString stringWithFormat:@"%@%ld%@",[UtilTool getCustomId],(long)index,SECRET_KEY] MD5];
           url = [NSString stringWithFormat:@"%@/%@/%ld/%@",APP_URL(rechargelist),[UtilTool getCustomId],(long)index,summery];
        }else if ([tab integerValue] == 1){
            NSString *summery = [[NSString stringWithFormat:@"%@%ld%@",[UtilTool getCustomId],(long)index,SECRET_KEY] MD5];
            url = [NSString stringWithFormat:@"%@/%@/%ld/%@",APP_URL(consumlist),[UtilTool getCustomId],(long)index,summery];
        }
        [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *orderArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in responseObject[@"order"]) {
                OrderModel *model = [OrderModel shareObjectWithDic:dict];
                [orderArray addObject:model];
            }
            if ([tab integerValue] == 0) {
                if (index == 1) {
                    self.leftArray =[NSMutableArray arrayWithArray:orderArray];
                }else{
                    [self.leftArray addObjectsFromArray:orderArray];
                }
                [_leftTableView reloadData];
                
            }else if ([tab integerValue] == 1){
                if (index == 1) {
                    self.centerArray =[NSMutableArray arrayWithArray:orderArray];
                }else{
                    [self.centerArray addObjectsFromArray:orderArray];
                }
                [_centerTableView reloadData];
            }
            [self viewEndRefresh];
        } error:^(NSString *error) {
             [self viewEndRefresh];
        } failure:^(NSString *fail) {
           [self viewEndRefresh];
        }];
        
    }else if (_type == DisfferentVCTypePing){
        NSString *summary = [[NSString stringWithFormat:@"%@%@%ld%@",[UtilTool getCustomId],tab,(long)index,SECRET_KEY] MD5];
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%ld/%@",APP_URL(queryVoucherPage),[UtilTool getCustomId],tab,(long)index,summary];
        [NetWorkEngine getRequestUse:(self) WithURL:urlString WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
       NSMutableArray *orderArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject[@"carwashList"]) {
            OrderModel *model = [OrderModel shareObjectWithDic:dict];
            [orderArray addObject:model];
            }
        if ([tab integerValue] == 0) {
            if (index == 1) {
                self.leftArray =[NSMutableArray arrayWithArray:orderArray];
            }else{
                [self.leftArray addObjectsFromArray:orderArray];
            }
            [_leftTableView reloadData];
          
        }else if ([tab integerValue] == 1){
            if (index == 1) {
                self.centerArray =[NSMutableArray arrayWithArray:orderArray];
            }else{
                [self.centerArray addObjectsFromArray:orderArray];
            }
            [_centerTableView reloadData];
          
        }else if ([tab integerValue] == 2){
            if (index == 1) {
                self.rightArray =[NSMutableArray arrayWithArray:orderArray];
            }else{
                [self.rightArray addObjectsFromArray:orderArray];
            }
            [_rightTableView reloadData];
        }
        [self viewEndRefresh];
    } error:^(NSString *error) {
         [self viewEndRefresh];
    } failure:^(NSString *fail) {
         [self viewEndRefresh];
    }];
        
    }else if (_type == DisfferentVCTypeStop){
        
        if ([tab integerValue] == 0) {
            NSString *summary = [[NSString stringWithFormat:@"%@%@%ld%@",[UtilTool getCustomId],@"1",(long)index,SECRET_KEY] MD5];
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%ld/%@",APP_URL(orderlist),[UtilTool getCustomId],@"1",(long)index,summary];
            [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSMutableArray *orderArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in responseObject[@"order"]) {
                    OrderModel *model = [OrderModel shareObjectWithDic:dict];
                    [orderArray addObject:model];
                }
                if ([tab integerValue] == 0) {
                    if (index == 1) {
                        self.leftArray =[NSMutableArray arrayWithArray:orderArray];
                    }else{
                        [self.leftArray addObjectsFromArray:orderArray];
                    }
                    [_leftTableView reloadData];
                }
                 [self viewEndRefresh];
            } error:^(NSString *error) {
                 [self viewEndRefresh];
            } failure:^(NSString *fail) {
                [self viewEndRefresh];
            }];
        }else if ([tab integerValue] == 1){
            NSString *bage = [NSString stringWithFormat:@"%ld",(long)index];
            NSMutableDictionary *daiBoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"1.3.7",@"version",bage,@"pageIndex", nil];
           [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryFinishParkOrder) WithDic:daiBoDic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
               NSMutableArray *orderArray = [[NSMutableArray alloc]init];
               for (NSDictionary *dict in responseObject[@"list"]) {
                   OrderModel *model = [OrderModel shareObjectWithDic:dict];
                   [orderArray addObject:model];
               }
               if ([tab integerValue] == 1){
                   if (index == 1) {
                       self.centerArray =[NSMutableArray arrayWithArray:orderArray];
                   }else{
                       [self.centerArray addObjectsFromArray:orderArray];
                   }
                   [_centerTableView reloadData];
               }
               [self viewEndRefresh];
           } error:^(NSString *error) {
               [self viewEndRefresh];
           } failure:^(NSString *fail) {
               [self viewEndRefresh];
           }];
        }
    }else if (_type == DisfferentVCTypeOrder){
        
        NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)index];
        NSString *tab1 = [NSString stringWithFormat:@"%ld",[tab integerValue]+1];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",tab1,@"tab",pageIndex,@"pageIndex",@"10",@"pageSize",@"2.0.1",@"version", nil];
        [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryAllOrder) WithDic:dict needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *orderArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in responseObject[@"data"]) {
                OrderModel *model = [OrderModel shareObjectWithDic:dict];
                [orderArray addObject:model];
            }
            if ([tab integerValue] == 0) {
                if (index == 1) {
                    self.leftArray =[NSMutableArray arrayWithArray:orderArray];
                }else{
                    [self.leftArray addObjectsFromArray:orderArray];
                }
            }else if ([tab integerValue] == 1){
                if (index == 1) {
                    self.centerArray =[NSMutableArray arrayWithArray:orderArray];
                }else{
                    [self.centerArray addObjectsFromArray:orderArray];
                }
            }else if ([tab integerValue] == 2){
                if (index == 1) {
                    self.rightArray =[NSMutableArray arrayWithArray:orderArray];
                }else{
                    [self.rightArray addObjectsFromArray:orderArray];
                }
            }
            [self createTableData:tab];
            [self viewEndRefresh];
        } error:^(NSString *error) {
            [self createTableData:tab];
            [self viewEndRefresh];
        } failure:^(NSString *fail) {
            [self createTableData:tab];
             [self viewEndRefresh];
        }];
    }
}
- (void)createTableData:(NSString *)tab{
    switch ([tab integerValue]) {
        case 0:
             [_leftTableView reloadData];
            break;
        case 1:
            [_centerTableView reloadData];
            break;
        case 2:
            [_rightTableView reloadData];
            break;
            
        default:
            break;
    }
}
- (void)viewEndRefresh{
    self.isLoading = NO;
    self.isRefresh = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark -
#pragma mark - 未付款 已付款 和全部按钮
- (void)selectBtn:(UIButton *)button{
    [_scrollView setContentOffset:CGPointMake((button.tag-100)*SCREEN_WIDTH, 0) animated:NO];
    switch (button.tag) {
        case 100:
        {
            [_rightTableView.mj_header endRefreshing];
            [_rightTableView.mj_footer endRefreshing];
            [_centerTableView.mj_footer endRefreshing];
            [_centerTableView.mj_header endRefreshing];
            self.tableView = _leftTableView;
            _tab = @"0";
            if (_isLeft == NO) {
                [self firstRefresh];
            }
        }
            break;
        case 101:
        {
            [_rightTableView.mj_header endRefreshing];
            [_rightTableView.mj_footer endRefreshing];
            [_leftTableView.mj_footer endRefreshing];
            [_leftTableView.mj_header endRefreshing];
            self.tableView = _centerTableView;
            _tab = @"1";
            if (_isCenter == NO) {
                [self firstRefresh];
                _isCenter = YES;
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
            _tab = @"2";
            if (_isRight == NO) {
                [self firstRefresh];
                _isRight = YES;
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat float1 = _scrollView.contentOffset.x;
    if (scrollView == _scrollView) {
        _select.selectIndex = float1/SCREEN_WIDTH+1;
    }
    if (float1/SCREEN_WIDTH == 0) {
        [_rightTableView.mj_header endRefreshing];
        [_rightTableView.mj_footer endRefreshing];
        [_centerTableView.mj_footer endRefreshing];
        [_centerTableView.mj_header endRefreshing];
        self.tableView = _leftTableView;
        _tab = @"0";
        if (_isLeft == NO) {
            [self firstRefresh];
        }
    }else if (float1/SCREEN_WIDTH == 1){
        [_rightTableView.mj_header endRefreshing];
        [_rightTableView.mj_footer endRefreshing];
        [_leftTableView.mj_footer endRefreshing];
        [_leftTableView.mj_header endRefreshing];
        self.tableView = _centerTableView;
        _tab = @"1";
        if (_isCenter == NO) {
            [self firstRefresh];
            _isCenter = YES;
        }
    }else if (float1/SCREEN_WIDTH == 2){
        [_centerTableView.mj_header endRefreshing];
        [_centerTableView.mj_footer endRefreshing];
        [_leftTableView.mj_footer endRefreshing];
        [_leftTableView.mj_header endRefreshing];
        self.tableView = _rightTableView;
        _tab = @"2";
        if (_isRight == NO) {
            [self firstRefresh];
            _isRight = YES;
        }
    }
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
