//
//  TimeLineViewController.m
//  P-Share
//
//  Created by fay on 16/6/16.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TimeLineViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TimelineCell.h"
#import "CarModel.h"
#import "UIBarButtonItem+Extension.h"
#import "TimeLineView.h"
#define  Identifier     @"TimelineCell"
@interface TimeLineViewController ()
{
    
    MBProgressHUD           *_mbView;
    UIView                  *_clearBackView;
    UIAlertView             *_alert;
    
    NSArray                 *_temDataArray;
    TemParkingListModel     *_payModel;//用来保存代泊数据
    NSInteger               _state;//用来保存代泊订单状态
    
    NSInteger               _rowNum;//用来设置行数

    NSUInteger              _orderState;
    
    NSString                *_callNum;
    
}
@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ALLOC_MBPROGRESSHUD
    
    self.title = @"订单状态";
//    kefu_v2
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTargat:self action:@selector(callPhone) image:@"kefu_v2" highImage:@"kefu_v2" withSize:CGSizeMake(18, 24)];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"defaultBack"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backVC)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    
    _orderState = 0;
    self.tableView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];

    [self.tableView registerClass:[TimelineCell class] forCellReuseIdentifier:Identifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

   
}
- (void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFromStyle:(TimeLineFromStyle)fromStyle
{
    _fromStyle = fromStyle;
    if (_fromStyle == TimeLineFromMap) {
        [self loadData];
    }else
    {
        [self loadOrderData];
        
    }
    
}
- (void)callPhone
{
    
    if (_payType == 0) {
        
        if (_payModel.parkerBackMobile.length > 4) {
            _callNum = _payModel.parkerBackMobile;
        }else if (_payModel.parkerMobile.length > 4) {
            _callNum = _payModel.parkerMobile;
        }else
        {
            _callNum = @"4000062637";
        }
        
//     代泊
    }else
    {
//      预约
        _callNum = @"4000062637";

    }
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_callNum]]]];
    [self.view addSubview:callWebview];
}


- (void)loadOrderData
{

    //        刷新代泊数据
    BEGIN_MBPROGRESSHUD
    [self reloadOrderDataCompletion:^(TemParkingListModel *model) {
        END_MBPROGRESSHUD
        NSInteger state = [model.orderStatus integerValue];
        
        _payStaus = state;
        
        _state = state;
        if (state == 1) {
            _rowNum = 1;
            
        }else if ( state == 2 ) {
            
            if (model.validateImagePath.length >4 ) {
                
                _rowNum = 2;
                
            } else{
                
                _rowNum = 3;
            }
        }else if (state == 4 ){
            
            if (model.keyBox.length > 0) {
                
                _rowNum =  6;
                
            }else {
                
                _rowNum =  5;
            }
            
        }else if (state == 14 || state == 15) {
            
            _rowNum = 6;
            
        }else if (state == 8 || state == 9){
            
            if (model.keyBox.length > 0) {
                
                _rowNum =  7;
                
            }else {
                
                _rowNum =  6;
            }
            
        }else if (state == 5){
            if (model.keyBox.length > 0) {
                
                _rowNum =  8;
                
            }else {
                
                _rowNum =  7;
            }
            
        }
        
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_rowNum-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        

        
    } fail:^void (NSString *errorInfo) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(errorInfo);
        _alert = nil;
    }];
    
    
}

- (void)loadData
{
    if (_payType == 0) {
//        刷新代泊数据
        BEGIN_MBPROGRESSHUD
        [self reloadDaiBoDataCompletion:^(TemParkingListModel *model) {
            END_MBPROGRESSHUD
            NSInteger state = [model.orderStatus integerValue];
            
            _payStaus = state;
            
            _state = state;
            if (state == 1) {
                _rowNum = 1;
                
            }else if ( state == 2 ) {
                
                if (model.validateImagePath.length >4 ) {
                    
                    _rowNum = 2;
                    
                } else{
                    
                    _rowNum = 3;
                }
            }else if (state == 4 ){
                
                if (model.keyBox.length > 0) {
                    
                    _rowNum =  6;
                    
                }else {
                    
                    _rowNum =  5;
                }
                
            }else if (state == 14 || state == 15) {
                
                _rowNum = 6;
                
            }else if (state == 8 || state == 9){
                
                if (model.keyBox.length > 0) {
                    
                    _rowNum =  7;
                    
                }else {
                    
                    _rowNum =  6;
                }
                
            }else if (state == 5){
                if (model.keyBox.length > 0) {
                    
                    _rowNum =  8;
                    
                }else {
                    
                    _rowNum =  7;
                }

            }
            
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_rowNum-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
        } fail:^void (NSString *errorInfo) {
            END_MBPROGRESSHUD;
            ALERT_VIEW(errorInfo);
            _alert = nil;
        }];
        
    }else if (_payType == 1){
        
        _rowNum = 2;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"代泊时间轴进入"];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"代泊时间轴退出"];
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
   
    [cell layoutIfNeeded];
    if (_rowNum != 1) {
        [MyUtil drawDashLine:cell.lineView lineLength:3 lineSpacing:2 lineColor:[MyUtil colorWithHexString:@"6d7e8c"]];
    }
    
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TimelineCell *newCell = (TimelineCell *)cell;
    

    if (_payType == 0) {
        newCell.timeLineView.dataModel = _payModel;
    }else if(_payType == 1)
    {
        newCell.temModel = self.temModel;
    }
    
//    设置订单类型
    newCell.payTyle = _payType;
//    设置订单状态
        
    if ( _payModel.keyBox.length == 0 && indexPath.row >= 4) {
        newCell.payStatus =(int)indexPath.row + 1;

    }else
    {
        newCell.payStatus =(int)indexPath.row;

    }


    newCell.totalRowNum = _rowNum;
    
    if (indexPath.row == 0 ) {
        newCell.cellPosition = TimelineCellPositionTop;
    }else if (indexPath.row == _rowNum-1){
        newCell.cellPosition = TimelineCellPositionBottom;
    }else
    {
        newCell.cellPosition = TimelineCellPositionMiddle;
    }
    newCell.fd_enforceFrameLayout = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_payType == 0) {//代泊
        if (indexPath.row == 1 || indexPath.row == 3) {
            return 220;
        }else
        {
            return 120;
        }
    }else
    {//预约
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
            return 100;
        }else
        {
            return 120;
        }
        
    }
        
}

#pragma mark -- 刷新代泊数据
- (void)reloadDaiBoDataCompletion:(void (^)(TemParkingListModel *model))completion fail:(void (^)(NSString *errorInfo))fail
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",[MyUtil getCustomId],@"customerId",_carModel.carNumber,@"carNumber",_parkingModel.parkingId,@"parkingId", nil];
        
        [RequestModel requestDaiBoOrder:queryParkerById WithType:@"getOrder" WithDic:dic Completion:^(NSArray *dataArray) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (dataArray.count>0) {
                    TemParkingListModel *model = [dataArray objectAtIndex:0];
                    _payModel = model;
                    if (completion) {
                        
                        completion(model);
                        
                    }
                }else
                {
                    if (fail) {
                        fail(@"无订单数据");
                    }
                }
                
            });
            
            
            
        } Fail:^(NSString *error) {
            
            if (fail) {
                fail(error);
            }
            
        }];
        
    });
    
}


#pragma mark -- 刷新订单数据
- (void)reloadOrderDataCompletion:(void (^)(TemParkingListModel *model))completion fail:(void (^)(NSString *errorInfo))fail
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",_orderId,@"orderId",_orderType,@"orderType", nil];
        
        [RequestModel requestDaiBoOrder:queryOrderDetail WithType:@"getCar" WithDic:dic Completion:^(NSArray *dataArray) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if (dataArray.count>0) {
                    TemParkingListModel *model = [dataArray objectAtIndex:0];
                    _payModel = model;
                    if (completion) {
                        completion(model);
                    }
                }else
                {
                    if (fail) {
                        fail(@"无订单数据");
                    }
                }

            });
            
            
            
        } Fail:^(NSString *error) {
            
            if (fail) {
                fail(error);
            }
            
        }];
        
    });
    
}




@end
