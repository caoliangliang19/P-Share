//
//  MainDaIBoVC.m
//  P-Share
//
//  Created by fay on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MainDaIBoVC.h"
#import "DaiBoInfoView.h"
#import "JZAlbumViewController.h"
#import "TemParkingListModel.h"
#import "NewDaiBoPayVC.h"
#import "CancelOrderVC.h"

#define PROGRESS                @"progress"
#define RefreshAll              @"RefreshAll"
#define RefreshSingle           @"RefreshSingle"
@interface MainDaIBoVC ()
{
    
    
    NSInteger _numControl;
    
    NSTimer *_timer;
    
    NSString *_refreshType;
    
    UIAlertView *_alert;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)DaiBoInfoView *infoView;
@property (nonatomic,strong)TemParkingListModel *currentOrderModel;


@end

@implementation MainDaIBoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];

    BEGIN_MBPROGRESSHUD
    
    [self creatInfoView];

}
- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- 创建infoView
- (void)creatInfoView
{
    _infoView = [[[NSBundle mainBundle] loadNibNamed:@"DaiBoInfoView" owner:nil options:nil] lastObject];

    _infoView.layer.cornerRadius = 4;
    _infoView.layer.masksToBounds = YES;
    _infoView.layer.borderColor = [MyUtil colorWithHexString:@"EEEEEE"].CGColor;
    _infoView.layer.borderWidth = 1;
    
    
    [_daiBoInfoView addSubview:_infoView];
    [_infoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(_infoView)weakInfoView = _infoView;
    
    _infoView.tapPictureGestureBlock = ^(UITapGestureRecognizer *tap)
    {
        UIImageView *temImg = (UIImageView *)tap.view;
        JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
        jzAlbumCtrl.imgArr = weakInfoView.imageArray;
        jzAlbumCtrl.currentIndex = temImg.tag;
        [weakSelf presentViewController:jzAlbumCtrl animated:YES completion:nil];
    };
    
    _infoView.cancelOrderBlock = ^(NSString *orderId){
//        取消订单
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2;

        [alert show];
        alert = nil;
    };
    
    _infoView.getCarBlock = ^(NSString *orderId)
    {
//        我要取车
//
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",orderId,@"orderId", nil];
        [RequestModel requestDaiBoOrder:gettingCar WithType:@"getCar" WithDic:dic Completion:^(NSArray *dataArray) {
            
            NewDaiBoPayVC *payVC = [[NewDaiBoPayVC alloc] init];
            payVC.temPayModel = dataArray[0];
            payVC.parkingId = weakSelf.currentOrderModel.parkingId;
            payVC.temPayModel.orderId = weakSelf.currentOrderModel.orderId;
            [weakSelf.navigationController pushViewController:payVC animated:YES];
            
        } Fail:^(NSString *error) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            alert = nil;
            
        }];
        
    };
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex==1) {
            [self cancelDaiBoOrder];
            
        }
    }
}

- (void)cancelDaiBoOrder
{
    
    NSString *summery = [[NSString stringWithFormat:@"%@%@",_currentOrderModel.orderId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",cancelOrder,_currentOrderModel.orderId,summery];
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *model = [RequestModel new];
    
    [model getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            [self.dataArray removeObject:self.currentOrderModel];
            if (self.dataArray.count>0) {
                
                [self.dataArray removeObject:self.currentOrderModel];
                if (self.dataArray.count > 0) {
                    self.currentOrderModel = self.dataArray[0];
                }
                
                OrderPointModel *orderPoint = [OrderPointModel shareOrderPoint];
                if (orderPoint.paker>0) {
                    orderPoint.paker--;
                }
                
                
                CancelOrderVC *cancelVC = [[CancelOrderVC alloc] init];
                [self.navigationController pushViewController:cancelVC animated:YES];
                return ;
                
            }
            OrderPointModel *orderPoint = [OrderPointModel shareOrderPoint];
            if (orderPoint.paker>0) {
                orderPoint.paker--;
            }
            
            CancelOrderVC *cancelVC = [[CancelOrderVC alloc] init];
            [self.navigationController pushViewController:cancelVC animated:YES];
            return;
        }

        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    


}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadDaiBoData];
    _infoView.orderModel = _currentOrderModel;
    

    BEGIN_MBPROGRESSHUD

    if (!_timer) {
        _timer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadDaiBoData) userInfo:nil repeats:YES];
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //关闭定时器
    [_timer invalidate];
    _timer = nil;
    [_infoView stopTimer];
}

-(void)dealloc
{
    [_timer invalidate];

    _timer = nil;
    
}
#pragma mark -- 定时器刷新数据
- (void)reloadDaiBoData
{
    MyLog(@"-------------------定时器执行%@------------------------",_currentOrderModel.carNumber);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",[MyUtil getCustomId],@"customerId",_carNum,@"carNumber", nil];
        _refreshType = RefreshAll;
        
        if (_currentOrderModel) {
            _refreshType = RefreshSingle;
            [dic setObject:_currentOrderModel.carNumber forKey:@"carNumber"];
        }
        [RequestModel requestDaiBoOrder:queryParkerById WithType:@"getOrder" WithDic:dic Completion:^(NSArray *dataArray) {
            
            if (dataArray.count == 0) {
                [_timer invalidate];
                _timer = nil;
                _daiBoInfoView.hidden = YES;
                _operationView.hidden = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    END_MBPROGRESSHUD
                    
                });
                return ;
            }
            
            if ([_refreshType isEqualToString:RefreshAll]) {
                _dataArray = (NSMutableArray*)dataArray;
            }
            TemParkingListModel *model = [dataArray objectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD
                _currentOrderModel = model;
                [_dataArray replaceObjectAtIndex:_numControl withObject:model];
                [self refreshDataWith:_numControl];
            });
        } Fail:^(NSString *error) {
            
            [_timer invalidate];
            _timer = nil;
            _daiBoInfoView.hidden = YES;
            _operationView.hidden = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD
               
            });
            
        }];
        
    });
    
}

#pragma mark -- 切换车辆
- (IBAction)changeCarClick:(UIButton *)sender {

    if (_dataArray.count < 2) {
        return;
    }
    
 
    if (sender.tag == 0) {
        //        上一辆
        if (_numControl>0) {

            _numControl--;
            [_infoView stopTimer];

            [self refreshDataWith:_numControl];
        }
        
    }else
    {
        //        下一辆
        if (_numControl <_dataArray.count-1) {
            _numControl ++;
            [_infoView stopTimer];

            [self refreshDataWith:_numControl];
        }
    }
}

#pragma mark -- 刷新数据
/**

 */
- (void)refreshDataWith:(NSInteger)num
{
    _currentOrderModel = _dataArray[num];
    _infoView.orderModel = _currentOrderModel;
    _carNumL.text = _currentOrderModel.carNumber;

}
- (IBAction)backVC:(id)sender {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[NewMapHomeVC class]]) {
//            NewMapHomeVC *new = [[NewMapHomeVC alloc] init];
//            [self.navigationController pushViewController:new animated:NO];

            [self.navigationController popToViewController:temp animated:YES];
        }
    }

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
