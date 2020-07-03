//
//  OrderViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "OrderModel.h"
#import "UIImageView+WebCache.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import "JZAlbumViewController.h"
#import "NewDaiBoPayVC.h"

@interface OrderViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    int _currentState;
    
    NSString *_payTape;
    
    UIAlertView *_alert;
    
    NSInteger _currentSelectIndex;
    
    NSString *_orderID;
    
    NSTimer *_myTimer;
    NSTimer *_timeCountTimer;
    BOOL   _haveCount;
    
    //当前订单——模型
    OrderModel *_currentOrderModel;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}

@property (nonatomic,strong)NSMutableArray *imageArray;


@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ALLOC_MBPROGRESSHUD;
    
    [self setUI];
    
    _orderID = @"";
    _currentState = -1;//--------------------------------------------
    _currentOrderModel = [[OrderModel alloc] init];
    
    self.imageArray = [NSMutableArray array];
    
    [self cheakOrderState];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
}
- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//设置默认界面
- (void)setUI
{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    
    //-----支付相关
    self.grayBackView.hidden = YES;
    self.payBackView.hidden = YES;
    self.gotoPayBtn.layer.cornerRadius = 3;
    self.gotoPayBtn.layer.masksToBounds = YES;
    self.gotoPayBtn.backgroundColor = NEWMAIN_COLOR;
    _payTape = @"2";
    //---------
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.view1SureBtn.layer.cornerRadius = 4;
    self.view1SureBtn.layer.masksToBounds = YES;
    self.view1SureBtn.backgroundColor = NEWMAIN_COLOR;
    self.view1Label1.textColor = NEWMAIN_COLOR;
    self.view1Label2.textColor = NEWMAIN_COLOR;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"orderManImage1"],[UIImage imageNamed:@"orderManImage2"],[UIImage imageNamed:@"orderManImage3"],[UIImage imageNamed:@"orderManImage4"],nil];
    _aniImageView.animationImages = array; //动画图片数组
    _aniImageView.animationDuration = 2.0; //执行一次完整动画所需的时长
    _aniImageView.animationRepeatCount = 0;  //动画重复次数 0表示无限次，默认为0
//    [_aniImageView startAnimating];
    _aniImageView.hidden = YES;
    
    self.view2SureBtn.layer.cornerRadius = 4;
    self.view2SureBtn.layer.masksToBounds = YES;
    self.view2SureBtn.backgroundColor = NEWMAIN_COLOR;
    self.parkerHeaderImageView.layer.cornerRadius = 47;
    self.parkerHeaderImageView.layer.masksToBounds = YES;
    
    self.view3SureBtn.layer.cornerRadius = 4;
    self.view3SureBtn.layer.masksToBounds = YES;
    self.view3SureBtn.backgroundColor = NEWMAIN_COLOR;
    self.parkerHeaderImageView2.layer.cornerRadius = 47;
    self.parkerHeaderImageView2.layer.masksToBounds = YES;
    
    self.view2View.hidden = YES;
    self.view3View.hidden = YES;
    self.cancelView.hidden = YES;
    self.view1Label2.hidden = YES;
    
    //------评论相关
    self.reasonTextView.delegate = self;
    self.reasonTextView.layer.cornerRadius = 4;
    self.reasonTextView.layer.masksToBounds = YES;
    self.reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reasonTextView.layer.borderWidth = 1;
    self.commentBackView.hidden = YES;
    self.sureBtn.layer.cornerRadius = 2;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.backgroundColor = NEWMAIN_COLOR;
    self.commentBackView.layer.cornerRadius = 4;
    self.commentBackView.layer.masksToBounds = YES;
    //------
}

- (void)cheakOrderState
{
    //    没有开始计算停车时长————没有开定时器,让其具备开启的条件
    _haveCount = YES;

    if (!_myTimer) {
        _myTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(refreshMyOrder) userInfo:nil repeats:YES];

    }
    
    //---------------------------网路请求-----查看订单状态
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId};
    
    NSString *urlString = [STATE_FOR_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 int state;
                 if ([dict[@"datas"][@"orderInfo"] count] == 0) {
                     state = 0;
                 }else{
                     NSNumber *num = dict[@"datas"][@"orderInfo"][0][@"order_state"];
                     state = [num intValue];
                     _orderID = dict[@"datas"][@"orderInfo"][0][@"order_id"];
                     [_currentOrderModel setValuesForKeysWithDictionary:dict[@"datas"][@"orderInfo"][0]];
                     if (state == 1 || state == 2 || state == 3) {
                         //设置定时器，查看订单状态,被接单后关闭定时器
//                         [[NSRunLoop  currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
                         [[NSRunLoop  currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
                     }
                 }
                 
                 [self changeOrderStateWithState:state];
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"%@",error);
     }];
    //---------------------------网路请求
}

- (void)dealloc
{
    [_myTimer invalidate];
    _myTimer = nil;
    
    [_timeCountTimer invalidate];
    _timeCountTimer = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_myTimer invalidate];
    _myTimer = nil;
    
    [_timeCountTimer invalidate];
    _timeCountTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    

    [self cheakOrderState];

    
    if (!_myTimer) {
        _myTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(refreshMyOrder) userInfo:nil repeats:YES];
        
    }
    if (!_timeCountTimer) {
        _timeCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountRefresh) userInfo:nil repeats:YES];
        //不重复开启定时器
    }

    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"orderGetResult";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"orderGetResult" object:nil];//监听一个通知
}

//获取微信支付结果 通知
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {
        self.view1View.hidden = NO;
        self.view1Label1.text = @"您未预约";
        self.view1Label2.hidden = YES;
        self.cancelView.hidden = YES;
        _aniImageView.hidden = YES;
        [_aniImageView stopAnimating];
        self.view2View.hidden = YES;
        self.view3View.hidden = YES;
        
        self.payBackView.hidden = YES;
        self.grayBackView.hidden = YES;
        
        [_myTimer invalidate];
        _myTimer = nil;
        
        [_timeCountTimer invalidate];
        _timeCountTimer = nil;
        
        //调用评论
        [self performSelector:@selector(commentComment:) withObject:nil afterDelay:1.0f];
    }
    else
    {
        ALERT_VIEW(@"支付失败");
        _alert = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//定时器刷新，判断订单状态
- (void)refreshMyOrder
{
    //---------------------------网路请求---查看订单状态
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId};
    
    NSString *urlString = [STATE_FOR_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 NSNumber *stateNum;
                 if ([dict[@"datas"][@"orderInfo"] count] != 0) {
                     stateNum = dict[@"datas"][@"orderInfo"][0][@"order_state"];
                     [_currentOrderModel setValuesForKeysWithDictionary:dict[@"datas"][@"orderInfo"][0]];
                     [self changeOrderStateWithState:[stateNum intValue]];
                 }else
                 {
                     [self changeOrderStateWithState:0];
                     [_myTimer invalidate];
                     _myTimer = nil;
                 }
             }else{
                 MyLog(@"3333333%@",dict[@"msg"]);
                 [self changeOrderStateWithState:0];
                 [_myTimer invalidate];
                 _myTimer = nil;
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"333333请求失败");
     }];
    //---------------------------网路请求
    MyLog(@"order----2");
}

//查看代泊员上传图片
- (void)setCarImage
{
    self.carPictureScrollView.showsHorizontalScrollIndicator = NO;
    
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    NSInteger image_Y = (self.carPictureScrollView.frame.size.height - imageWidth_H)/2;
    
    NSArray *subviewsArray = self.carPictureScrollView.subviews;
    for (UIImageView *imageView in subviewsArray){
        [imageView removeFromSuperview];
    }
    
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageWidth_H+15)*i, image_Y, imageWidth_H, imageWidth_H)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]]];
        imageView.tag = i + 10;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.carPictureScrollView addSubview:imageView];
    }
    
    NSInteger content_W = self.imageArray.count * imageWidth_H + (self.imageArray.count-1)*15;
    self.carPictureScrollView.contentSize = CGSizeMake(content_W, self.carPictureScrollView.frame.size.height);
}

//点击图片放大
- (void)tapImageAction:(UITapGestureRecognizer *)sender
{
    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
    jzAlbumCtrl.imgArr = self.imageArray;
    jzAlbumCtrl.currentIndex = sender.view.tag-10;
    [self presentViewController:jzAlbumCtrl animated:YES completion:nil];
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --根据订单状态显示调整UI(在这里调整)
- (void)changeOrderStateWithState:(int)state
{
    
    NSLog(@"statestatestatestate %d",state);
    
    if (state == 3 || state == 4 || state == 8 || state == 9 || state == 11){
        
        if (state == 3) {
            self.view3SureBtn.hidden = YES;
        }else{
            self.view3SureBtn.hidden = NO;
            
        }
        
        if (state == 8 || state == 11) {
            [self.view3SureBtn setTitle:@"支付订单" forState:UIControlStateNormal];
            self.view3SureBtn.backgroundColor = [UIColor grayColor];
            self.view3SureBtn.userInteractionEnabled = NO;
            
        } else if (state == 9 ){
            [self.view3SureBtn setTitle:@"支付订单" forState:UIControlStateNormal];
            self.view3SureBtn.backgroundColor = NEWMAIN_COLOR;
            self.view3SureBtn.userInteractionEnabled = YES;
            [_myTimer invalidate];
             _myTimer = nil;
            
        }
        else{
            
            [self.view3SureBtn setTitle:@"我要取车" forState:UIControlStateNormal];
        }
        
        self.view1View.hidden = YES;
        self.view2View.hidden = YES;
        self.view3View.hidden = NO;
        
        if (_currentOrderModel.parking_img_count.length > 5) {
            [self.parkerHeaderImageView2 sd_setImageWithURL:[NSURL URLWithString:_currentOrderModel.parking_img_count]];
        }
        self.parkerNameLabel2.text = _currentOrderModel.parker_name;
        self.parkerTitleLabel2.text = [NSString stringWithFormat:@"职务:%@",_currentOrderModel.parker_level];
        self.parkerChargeLabel2.text = [NSString stringWithFormat:@"负责区域:%@",_currentOrderModel.parking_Name];//待调整
        self.parkerPhoneNumLabel2.text = _currentOrderModel.parker_mobile;
        self.orderTimeLabel2.text = _currentOrderModel.order_Plan_begin;
        self.getCarTimeLabel.text = _currentOrderModel.order_plan_end;
        self.carNumLabel.text = _currentOrderModel.car_Number;
        
        if (_haveCount) {
            _timeCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountRefresh) userInfo:nil repeats:YES];
            //不重复开启定时器
            _haveCount = NO;
        }
        
        [self.imageArray removeAllObjects];
        NSArray *modelImages = [_currentOrderModel.order_path componentsSeparatedByString:@","];
        [self.imageArray addObjectsFromArray:modelImages];
        [self.imageArray removeObject:@""];
        if (_currentOrderModel.parking_path.length > 5) {
            NSString *imageString = [_currentOrderModel.parking_path substringToIndex:[_currentOrderModel.parking_path length]-1];
            [self.imageArray addObject:imageString];
        }
        [self setCarImage];
    }else
    {
        [_timeCountTimer invalidate];
        _timeCountTimer = nil;
        _haveCount = YES;//关闭定时器，并让其具备开启的条件
        
        if (state == 0) {
            self.view1View.hidden = NO;
            self.view1Label1.text = @"您未预约";
            self.view1Label2.hidden = YES;
            self.cancelView.hidden = YES;
            _aniImageView.hidden = YES;
            [_aniImageView stopAnimating];
            self.view2View.hidden = YES;
            self.view3View.hidden = YES;
            
        }else if (state == 1){
            self.view1View.hidden = NO;
            self.view1Label1.text = @"请您稍等片刻";
            self.view1Label2.hidden = NO;
            self.cancelView.hidden = NO;
            _aniImageView.hidden = NO;
            [_aniImageView startAnimating];
            self.view2View.hidden = YES;
            self.view3View.hidden = YES;
            
        }else if (state == 2){
            self.view1View.hidden = YES;
            self.view2View.hidden = NO;
            self.view3View.hidden = YES;
            
            if (_currentOrderModel.parking_img_count.length > 5) {
                [self.parkerHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_currentOrderModel.parking_img_count]];
            }
            self.parkerNameLabel.text = _currentOrderModel.parker_name;
            self.parkerTitleLabel.text = [NSString stringWithFormat:@"职务:%@",_currentOrderModel.parker_level];
            self.parkerChargeLabel.text = [NSString stringWithFormat:@"负责区域:%@",_currentOrderModel.parking_Name];//待调整
            self.parkerPhoneNumLabel.text = _currentOrderModel.parker_mobile;
            self.orderTimeLabel.text = _currentOrderModel.order_Plan_begin;
            
        }
    }
    
    if (state != 1) {
        [_aniImageView stopAnimating];
    }
}
#pragma mark -停车计时刷新
- (void)timeCountRefresh
{
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *orderBeginDate = [formatter dateFromString:_currentOrderModel.order_actual_begin_start];
    NSInteger nowInterval = (NSInteger)[nowdate timeIntervalSinceDate:orderBeginDate];
    
    self.parkingCarTimeLabel.text = [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒",nowInterval/3600,(nowInterval%3600)/60,nowInterval%60];
    
    MyLog(@"order---1");
}

//取消预约
- (IBAction)view1SureBtnClick:(id)sender {
    MyLog(@"取消预约1");
    if (_orderID.length != 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView = nil;
    }
}
//取消预约
- (IBAction)view2SureBtnClick:(id)sender {
    MyLog(@"取消预约2");
    if (_orderID.length != 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView = nil;
    }
}

#pragma mark -UIAlertViewd代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            
        }else
        {
            BEGIN_MBPROGRESSHUD;
            //---------------------------网路
            AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
            tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
            tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *paramDic = @{order_id:_orderID,parking_id:_currentOrderModel.parking_Id};
            
            NSString *urlString = [GET_CAR stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 if ([result isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dict = result;
                     
                     if ([dict[@"code"] isEqualToString:@"000000"])
                     {
                         [_view3SureBtn setTitle:@"支付订单" forState:UIControlStateNormal];
                         _view3SureBtn.backgroundColor = [UIColor grayColor];
                         _view3SureBtn.userInteractionEnabled = NO;
                         
                         ALERT_VIEW(@"已为您告知代泊员");
                         
                         _alert = nil;
                     }else{
                         MyLog(@"%@",dict[@"msg"]);
                     }
                 }
                 END_MBPROGRESSHUD;
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 MyLog(@"1111111%@",error);
                 END_MBPROGRESSHUD;
             }];
            //---------------------------网路请求
        }
    }
    
    else
    {
        if(buttonIndex == 1) {
            [self cancelOrder1];
        }
    }
}

//取消订单
- (void)cancelOrder1
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求----取消订单
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paramDic = @{order_id:_orderID};
    
    NSString *urlString = [CANCEL_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 self.view1View.hidden = NO;
                 self.view1Label1.text = @"您未预约";
                 self.view1Label2.hidden = YES;
                 self.cancelView.hidden = YES;
                 _aniImageView.hidden = YES;
                 [_aniImageView stopAnimating];
                 self.view2View.hidden = YES;
                 self.view3View.hidden = YES;
                 MyLog(@"取消成功1111111");
                 OrderPointModel *orderPoint = [OrderPointModel shareOrderPoint];
                 if (orderPoint.paker>0) {

                     orderPoint.paker--;
                     
                 }
                 
                 
                 [_myTimer invalidate];
                 _myTimer = nil;
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

//拨打电话
- (IBAction)view2CallBtnClick:(id)sender {
    MyLog(@"拨打电话");
    if (self.parkerPhoneNumLabel.text.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.parkerPhoneNumLabel.text];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}
//拨打电话
- (IBAction)view3callBtnClick:(id)sender {
    if (self.parkerPhoneNumLabel2.text.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.parkerPhoneNumLabel2.text];
        //            NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark -- payBackView出现

#pragma mark -取车/付款
- (IBAction)view3SureBtnClick:(UIButton *)sender {
    if ([_view3SureBtn.titleLabel.text isEqualToString:@"我要取车"]) {
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否现在取车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertV.tag = 2;
        [alertV show];

    }else{
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{order_id:_orderID,parking_id:_currentOrderModel.parking_Id};
        
        NSString *urlString = [CALCULATE_PAY stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     self.payMoneyCountLabel.text = dict[@"datas"][@"totalPay"];
                     
                     NewDaiBoPayVC *payVC = [[NewDaiBoPayVC alloc]init];
                     payVC.orderModel = _currentOrderModel;
                     
                     payVC.price = self.payMoneyCountLabel.text;
                     [self.navigationController pushViewController:payVC animated:YES];
                     
                  }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"1111111%@",error);
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求
    }
}


//左右切换查看图片
- (IBAction)leftBtnClick:(id)sender {
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    
    CGPoint pictureContentSet = self.carPictureScrollView.contentOffset;
    if (self.carPictureScrollView.contentOffset.x < imageWidth_H+15) {
        pictureContentSet.x = 0;
    }else{
        pictureContentSet.x -= imageWidth_H+15;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.carPictureScrollView.contentOffset = pictureContentSet;
    }];
}
//左右切换查看图片
- (IBAction)rightBtnClick:(id)sender {
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    
    CGPoint pictureContentSet = self.carPictureScrollView.contentOffset;
    if (self.imageArray.count >= 4) {
        if (self.carPictureScrollView.contentOffset.x > (imageWidth_H+15)*(self.imageArray.count-4)) {
            pictureContentSet.x = (imageWidth_H+15)*(self.imageArray.count-3);
        }else{
            pictureContentSet.x += imageWidth_H+15;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.carPictureScrollView.contentOffset = pictureContentSet;
    }];
}

//取消订单支付
- (IBAction)cancelPayBtnClick:(id)sender {
    self.grayBackView.hidden = YES;
    self.payBackView.hidden = YES;
}


//点击评论按钮
- (void)commentComment:(id)sender
{
    //进行评论
    self.grayBackView.hidden = NO;
    self.commentBackView.hidden = NO;
    self.reasonTextView.text = @" 说说你的理由吧";
}

//评价选图片点击
- (IBAction)commentBtnClick:(UIButton *)sender {
    if (_currentSelectIndex == sender.tag - 2000) {
        return;
    }else{
        UIImageView *selectImageView = (UIImageView *)[self.view viewWithTag:sender.tag - 1000];
        selectImageView.image = [UIImage imageNamed:@"patients_evaluationchoose_hg"];
        
        UIImageView *lastImageView = (UIImageView *)[self.view viewWithTag:_currentSelectIndex + 1000];
        lastImageView.image = [UIImage imageNamed:@"patients_evaluationchoose"];
    }
    
    _currentSelectIndex = sender.tag - 2000;
}

//评论确定按钮点击
- (IBAction)sureBtnClick:(id)sender {
    [self.reasonTextView resignFirstResponder];
    
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路----订单评价
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *levelStr = [NSString stringWithFormat:@"%ld",_currentSelectIndex];
    NSDictionary *paramDic = @{order_id:_orderID,comment_level:levelStr,comment_content:self.reasonTextView.text,customer_id:userId};
    
    NSString *urlString = [ORDER_COMMENT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 ALERT_VIEW(@"评论成功");
                 _alert = nil;
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
    
    self.grayBackView.hidden = YES;
    self.commentBackView.hidden = YES;
}

#pragma mark --UITextView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@" 说说你的理由吧"]) {
        textView.text = @"";
    }
    self.reasonTextView.textColor = [UIColor blackColor];
    self.commentCenterY.constant = 50;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @" 说说你的理由吧";
        self.reasonTextView.textColor = [UIColor lightGrayColor];
    }
    self.commentCenterY.constant = 0;
}

@end




