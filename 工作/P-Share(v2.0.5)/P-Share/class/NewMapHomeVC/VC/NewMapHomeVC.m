//
//  NewMapHomeVC.m
//  P-Share
//
//  Created by fay on 16/6/13.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewMapHomeVC.h"
#import "MapSearchView.h"
#import "MapView.h"
#import "CarDetailAlert.h"
#import "MapActivityView.h"
#import "UserViewController.h"
#import "selfAlertView.h"
#import "NewMonthlyRentSearchVC.h"
#import "ActivityModel.h"
#import "ParkAndFavViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>
#import "FayPointAnnotation.h"
#import "FayAnnotationView.h"
#import "MapBottomView.h"
#import "NewParkingdetailVC.h"
#import "NotificationView.h"
#import "PayKindView.h"
#import "WebViewController.h"
#import "MapBottomSecondView.h"
#import "SearchVC.h"
#import "TimeLineViewController.h"
#import "CarListViewController.h"
#import "SelfAlertViewTwo.h"
#import "NewMonthlyRentPayVC.h"
#import "NewTemParkingVC.h"
#import "MapParkingView.h"
#import "NewYuYueTingChe.h"
#import "TemParkingListModel.h"
#import "faySheetVC.h"
#import "JZAlbumViewController.h"
#import "OtherStopAlert.h"
#import "BusyAlert.h"
#import "NewDaiBoPayVC.h"
#import "JPUSHService.h"
#import "YuYuePingZhengDetail.h"
#import "CancelOrderVC.h"
#import "AddCarInfoViewController.h"
#import "ChooseCheXing.h"
#import "ADView.h"
#import "PayStatusView.h"
#import "ClearCarVC.h"
#import "ClearCarPay.h"
#import "LoginViewController.h"
#import "GoinAlertView.h"
#import "DaiBoInfoV.h"
#import "YuYueView.h"
#import "DaoHangView.h"
#import "UIButton+WebCache.h"
#import "NewTemParkingPayVC.h"
#import "DaiBoOrderVC.h"
#import "SelectParkController.h"
#import "DiscountActController.h"
#import "UseCarFeelController.h"
#import "WeChatController.h"
#import "CarLiftModel.h"
#import "CarLifeView.h"


const static NSString *APIKey = @"b3dd200e6f1e3c78c0fdb3dac452ecae";
#define kCalloutViewMargin          -8
#define Khidden                      @"hidden"

typedef enum {
    NETWORKERRORNONETWORK,//没有网络
    NETWORKERRORNORMAL,//正常
    
}NETWORKERROR;

typedef enum {
    ERRORNUMNOLOCATION,//没有定位
    ERRORNUMNORMAL,//正常
    
}ERRORNUM;

@interface NewMapHomeVC ()<MAMapViewDelegate,AMapSearchDelegate,CarDetailAlertDelegate,AMapLocationManagerDelegate,selectParkingDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    UIAlertView *_alert;
    
    MapSearchView           *_mapSearchView;
    MapActivityView         *_mapActivityView;
    NotificationView        *_notificationView;
    MapBottomView           *_bottomView;
    PayKindView             *_payKindView;
    MapBottomSecondView     *_mapBottomSecondView;
    /**
     * 代泊、预约、导航
     */
    PayStatusView           *_payStatusView;
    
    faySheetVC              *_faySheet;//导航View

    UIButton                *_carBtn;
    UIButton                *_homeBtn;
    UIButton                *_collectionBtn;
    UIButton                *_locationBtn;
    
    NSMutableArray          *_parkingArray;//用来存放停车场
    
    NSMutableArray          *_totalArray;//用来存放月租、产权、临停
    NSMutableArray          *_LinTingArray;//用来存放月租
    NSMutableArray          *_yuZuChanQuanArray;//用来存放月租
    HomeArray               *_homeArray;//用来保存家停车场
    
    NSMutableArray          *_favDataArray;//用来保存收藏车场
    
    MapParkingView          *_parkingV;//收藏车场View
    
    SelfAlertViewTwo        *_selfViewTwo;//屏幕中间红色的大头针

    UIImageView             *_bomeImage;
    
    CarDetailAlert          *_carDetailAlert;//立即代泊view
    
    NSMutableDictionary     *_temDic;//代泊服务满时，保存数据
    
    NSMutableArray          *_locationArray;//保存大头针
    
    UIImageView             *_guideImageView;
    
    UIButton                *_nilBtn;
    
    UIWindow                *_window;
    
    NSInteger               _againIndex;
    
    BOOL                    _isMove;
    
    BOOL                    _isComeFormSearch;
    ERRORNUM                _errorNum;
    
    NETWORKERROR            _netWorkError;
    
    MBProgressHUD            *_hud;
    
}
@property (nonatomic, strong)   AMapLocationManager     *locationManager;
@property (nonatomic,strong)    LocationTool            *locationTool;

@property (nonatomic,strong)    MAMapView               *mapview;
@property (nonatomic,strong)    AMapSearchAPI           *search;
@property (nonatomic,assign)    float                   nowLatitude,  //保存用户的位置坐标
                                                        nowLongitude;
@property (nonatomic,strong)    NewCarModel             *globalCarModel;//保存选中车辆
@property (nonatomic,strong)    ParkingModel            *globalParkModel;//保存选中车场
@property (nonatomic,strong)    ParkingModel            *nearbyParkModel;//保存最近车场

@property (nonatomic,strong)    TemParkingListModel     *payModel;//保存代泊订单
//获取用户车辆
@property (nonatomic,strong)    selfAlertView           *selfView;
@property (nonatomic,strong)    phoneView               *phoneV;
@property (nonatomic,strong)    UIView                  *grayView;//全局阴影View
@property (nonatomic,strong)    UILabel                 *carNameL;

@end

@implementation NewMapHomeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWorkStatus];

    _againIndex = 0;
    _nowLatitude = 0;
    _nowLongitude = 0;
    [AMapServices sharedServices].apiKey = GAODEAPPKEY;
    
    //    首先判断用户身份
    if ([MyUtil getCustomId].length > 0) {
        _isVisitor = YES;
    }else
    {
        _isVisitor =  NO;
    }
//    [self loadRoodData];
    [self loadUI];
    [self setGuideImage];
}


- (void)refreshParking
{
    
}
- (void)netWorkStatus
{
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
       
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                MyLog(@"未知网络状态");
                MBPROGRESS_TITLE(@"未知网络状态");
                
                _netWorkError = NETWORKERRORNONETWORK;
                _notificationView.hidden = NO;

                break;
            case AFNetworkReachabilityStatusNotReachable:
                MyLog(@"无网络");
                MBPROGRESS_TITLE(@"无网络");

                _netWorkError = NETWORKERRORNONETWORK;
                _notificationView.hidden = NO;

                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                MyLog(@"蜂窝数据网");
                MBPROGRESS_TITLE(@"蜂窝数据网");

                _notificationView.hidden = YES;
                if (_netWorkError == NETWORKERRORNONETWORK) {
                    _netWorkError = NETWORKERRORNORMAL;
                    [self refrashData];
                    [self loadRoodData];
                    [self getParkDataWith:_nowLatitude With:_nowLongitude];

                }

                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                MyLog(@"WiFi网络");
                MBPROGRESS_TITLE(@"WiFi网络");

                _notificationView.hidden = YES;
                if (_netWorkError == NETWORKERRORNONETWORK) {
                    _netWorkError = NETWORKERRORNORMAL;
                    [self refrashData];
                    [self loadRoodData];
                    [self getParkDataWith:_nowLatitude With:_nowLongitude];

                }
                break;
                
            default:
                break;
        }
        
    }] ;
    [manager startMonitoring];

}

- (void)alertShouldAddCarLiftPark
{
    UIAlertController *alert = [MyUtil alertController:@"请先选择车场" Completion:^{
        
        SelectParkController *select = [[SelectParkController alloc]init];
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];

    } Fail:^{
        
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadRoodData
{
    [self hiddenActivityView];

    //    获取家停车场
    [self getHomePark];
    [self loadData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView setAnimationsEnabled:YES];

    
    self.navigationController.navigationBarHidden = YES;
    [self refrashData];
    
}
- (void)refrashData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRoodData) name:KLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YuYueCallBack:) name:KYuYuePaySuccess object:nil];
        //支付成功后刷新代泊预约订单数据
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDaiBoYuYueStatus) name:@"PaySuccess" object:nil];
        //支付成功后刷新临停月租产权订单数据
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLinTingOrderWith:) name:KPaySuccess object:nil];
        //监听预约停车支付结果
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCarArray) name:@"UserCarChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHomeModel) name:@"ChangeHomeModel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExit) name:@"KUserExit" object:nil];
        [[DataSource shareInstance] addObserver:self forKeyPath:@"carModel" options:NSKeyValueObservingOptionNew context:nil];

    });
    
    [MobClick beginLogPageView:@"地图首页进入"];
    [self reloadDaiBoYuYueStatus];
    //    首先判断用户身份
    if ([MyUtil getCustomId].length > 0) {
        _isVisitor = YES;
    }else
    {
        _isVisitor =  NO;
        _mapBottomSecondView.dataArray = @[@""].mutableCopy;
        _carNameL.text = @"－－";
    }
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //   设置用户头像
    NSString *imageString = [[NSUserDefaults standardUserDefaults] objectForKey:customer_head];
    [_mapSearchView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageString] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"head_v2"]];

}
#pragma mark --游客退出登录
- (void)userExit
{
    
    
}
- (void)YuYueCallBack:(NSNotification *)notifi
{
    NSString *parkId = notifi.object;
    
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",parkId,[MyUtil getCustomId],[MyUtil getVersion],MD5_SECRETKEY] MD5];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",GETLIST,parkId,[MyUtil getCustomId],[MyUtil getVersion],summary];
        [RequestModel requestGetParkingListWithURL:urlStr WithTag:@"5" Completion:^(NSMutableArray *resultArray) {
            ParkingModel *aParkModel = resultArray[0];
            for (int i=0; i<_parkingArray.count; i++) {
                ParkingModel *model = _parkingArray[i];
                if ([model.parkingId isEqualToString:aParkModel.parkingId]) {

                    model.parkingCanUse = [NSString stringWithFormat:@"%@",aParkModel.parkingCanUse];
                    _globalParkModel = model;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MyLog(@"addAnnotationWithCooordinate   ---预约停车支付回调");
                        [self addAnnotationWithCooordinate];
                    });
                    
                    return ;
                }
            }
         
            
        } Fail:^(NSString *error) {
            END_MBPROGRESSHUD;
            
        }];
        

    
    
    MyLog(@"%@",parkId);
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
#pragma mark -- 改变homeModel
- (void)changeHomeModel
{
    NSLog(@"--------");
    
    ParkingModel *homeModel = _homeArray.dataArray[0];
    for (ParkingModel *model in _parkingArray) {
        if ([model.parkingId isEqualToString:homeModel.parkingId]) {
            [DataSource shareInstance].model = model;
            [_homeArray.dataArray replaceObjectAtIndex:0 withObject:model];
        }
    }

    MyLog(@"addAnnotationWithCooordinate   ----changeHomeModel");
    
    [self addAnnotationWithCooordinate];
}

//刷新代泊预约订单数据

- (void)reloadDaiBoYuYueStatus
{
    [self setPayStatusViewModel:_globalParkModel];

}

#pragma mark -- 极光推送回调方法
-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    MyLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark -- 获取数据
- (void)loadData
{
    //设置推送标签与别名
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    [JPUSHService setTags:[NSSet setWithObject:@"customer"] alias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    //     友盟统计用户登录
//    if ([SERVER_ID isEqualToString:@"139.196.12.103"]) {
        [MobClick profileSignInWithPUID:userId];
//    }
    
    if (!_parkingArray) {
        _parkingArray = [NSMutableArray array];
        _yuZuChanQuanArray = [NSMutableArray array];
        _totalArray = [NSMutableArray array];
        _LinTingArray = [NSMutableArray array];
    }
//    获取用户车辆
    _collectionBtn.userInteractionEnabled = YES;
    [self loadCarArray];
}

#pragma mark --- 提醒用户打开定位权限
- (void)alertUserAllowLocation
{
    UIAlertController *alertC = [MyUtil alertController:@"请去设置页面找到口袋停,打开位置服务权限" Completion:^{
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        if([[UIApplication sharedApplication] canOpenURL:url]) {
             NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];[[UIApplication sharedApplication] openURL:url];
        }
        
    } Fail:^{
        
    }];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark -
#pragma mark -- 加载_payStatusView：代泊、预约、停车
#pragma mark -- 点击大圆圈按钮
- (void)loadPayStatusView
{
    _payStatusView = [PayStatusView new];
    [self.view addSubview:_payStatusView];
    [_payStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_mapBottomSecondView.mas_top);
        make.bottom.mas_equalTo(_payStatusView.bgView.mas_bottom);
    }];
//    绿色按钮点击block
    __weak typeof(self)ws = self;
    _payStatusView.greenBtnClickBlock = ^(PayStatusViewKind status,YuYueView *yuYueView,DaoHangView *daoHangV,DaiBoInfoV *daiBoV){
       if (status == PayKindDaoHang){
           
           if (_errorNum == ERRORNUMNOLOCATION) {
               
               [ws alertUserAllowLocation];

               return ;
            }
           
            //            直接导航
            [ws myAnnotationTapForNavigationWithModel:daoHangV.dataModel];
        }else
        {
            if (!ws.isVisitor) {
                [ws alertShouldLogin];
                return ;
            }
            if (_globalCarModel.carNumber.length < 7) {
                [ws alertAddCar];
                return;
            }
            
            if (CUSTOMERMOBILE(customer_mobile).length == 0) {
                [ws alertNeedPhone];
                return;
            }
            
            if (status == PayKindDaiBo) {
                
                if (daiBoV.status == DaiBoInfoVStatusNoCheWei || daiBoV.status ==DaiBoInfoVStatusHomeNoCheWei) {
                    //                开始代泊
                    [ws startDaiBoServer];
                    
                }else if (daiBoV.status == DaiBoInfoVStatusGetOrder){
                    //                取消订单
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单" delegate:ws cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 2;
                    [alert show];
                    alert = nil;
                    
                }else if (daiBoV.status == DaiBoInfoVStatusParkEnd || daiBoV.status == DaiBoInfoVStatusSaveKey || daiBoV.status == DaiBoInfoVStatusTimeNotification){
                    //                去支付
                    NewDaiBoPayVC *payVC = [[NewDaiBoPayVC alloc] init];
                    payVC.temPayModel = daiBoV.temModel;
                    payVC.parkingId = daiBoV.dataModel.parkingId;
                    [ws.navigationController pushViewController:payVC animated:YES];
                    
                }else if (daiBoV.status == DaiBoInfoVStatusShowCarPhoto){
                    //                查看照片
                    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
                    NSMutableArray *imageArray = [NSMutableArray array];
                    NSString *totalImagePath = [NSString stringWithFormat:@"%@,%@",daiBoV.temModel.validateImagePath,daiBoV.temModel.parkingImagePath];
                    
                    [imageArray addObjectsFromArray:[totalImagePath componentsSeparatedByString:@","]];
                    [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                            [imageArray removeObject:imagePath];
                        }
                        
                    }];
                    
                    jzAlbumCtrl.imgArr = imageArray;
                    jzAlbumCtrl.currentIndex = 0;
                    [ws presentViewController:jzAlbumCtrl animated:YES completion:nil];
                } else if (daiBoV.status == DaiBoInfoVStatusParking || daiBoV.status == DaiBoInfoVStatusGetCaring){
                    //                查看
                    [ws gotoTimeLineVC:0];
                    
                }
                
            }else if(status == PayKindYuYue){
                if(yuYueView.status == YuYueViewStatusNoOrder)
                {
                    
                    if ([ws.globalParkModel.parkingCanUse intValue] == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该车场可用车位数为空" delegate:ws cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                        alert = nil;
                        return;
                        
                    }
                    
                    //                预约停车
                    [MobClick event:@"Appointment"];
                    NewYuYueTingChe *tingCheVC = [[NewYuYueTingChe alloc] init];
                    tingCheVC.parkModel = ws.globalParkModel;
                    tingCheVC.carModel = ws.globalCarModel;
                    tingCheVC.nowLatitude = ws.nowLatitude;
                    tingCheVC.nowLongitude = ws.nowLongitude;
                    [ws.navigationController pushViewController:tingCheVC animated:YES];
                    
                }else if(yuYueView.status == YuYueViewStatusSuccess)
                {
                    //                查看凭证
                    YuYuePingZhengDetail *detailVC = [[YuYuePingZhengDetail alloc] init];
                    detailVC.pingZhengModel = yuYueView.temModel;
                    detailVC.type = @"left";
                    [ws.navigationController pushViewController:detailVC animated:YES];
                }else if(yuYueView.status == YuYueViewStatusNoParking)
                {
                    //                导航
                    [ws myAnnotationTapForNavigationWithModel:yuYueView.dataModel];

                }
                
            }

        }
    };
    
    _payStatusView.tapGestureBlock = ^(PayStatusViewKind status,YuYueView *yuYueView,DaoHangView *daoHangV,DaiBoInfoV *daiBoV)
    {
       
        if (status == PayKindDaiBo) {
            if (daiBoV.status == DaiBoInfoVStatusNoCheWei) {
//                     状态为代泊时无点击效果
            }else
            {
                [ws gotoTimeLineVC:0];
            }
        }
        
        else if(status == PayKindYuYue){
            
            if(yuYueView.status == YuYueViewStatusNoOrder)
            {
//               状态为预约停车时无点击效果
                
            }else if(yuYueView.status == YuYueViewStatusSuccess)
                
            {
                [ws gotoTimeLineVC:1];

            }

            
        }else if (status == PayKindDaoHang){
        //            导航时无点击效果
        }

    };

}
#pragma mark --前往时间轴
- (void)gotoTimeLineVC:(int)payType
{
    TimeLineViewController *timeLineVC = [[TimeLineViewController alloc] init];
    timeLineVC.payType = payType;
    timeLineVC.fromStyle = TimeLineFromMap;
    
    if (payType ==1) {
        timeLineVC.temModel = _payStatusView.yuYueView.temModel;
    }
    timeLineVC.carModel = _globalCarModel;
    timeLineVC.parkingModel = _globalParkModel;
    [self.navigationController pushViewController:timeLineVC animated:YES];
}

#pragma mark -- 设置UI界面
- (void)loadUI
{
    ALLOC_MBPROGRESSHUD;

    [self loadMapView];

    [self.view insertSubview:self.mapview atIndex:0];

    [self loadCenterAnnotation];//加载红色大头针
    
    [self loadMapSearchView];
    
    [self loadNotificationView];
    
//    [self loadBottomView];
    
    [self LoadMapBottomSecondView];
    
    [self loadPayStatusView];
    
    [self loadMapActivityView];
    
    [self loadRightBtn];
    
    _grayView = [UIView new];
    _grayView.backgroundColor = [UIColor blackColor];
    _grayView.alpha = 0.5;
    _grayView.hidden = YES;
    [self.view addSubview:_grayView];
    [_grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadADView];
    });
}
#pragma mark -- 加载广告页面
- (void)loadADView
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *summary = [[NSString stringWithFormat:@"%@%@",[MyUtil getVersion],MD5_SECRETKEY] MD5];
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@",adverList,[MyUtil getVersion],summary];
        [RequestModel requestOrderPointWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
            MyLog(@"%@",dic);
            
            SDWebImageManager *manage = [SDWebImageManager sharedManager];
            UIImage *image = [manage.imageCache imageFromDiskCacheForKey:dic[@"refuelCard"][@"imagePath"]];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ADView *adView = [ADView new];
                    adView.image = image;
                    [self.view addSubview:adView];
                    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:0 animations:^{
                        adView.adImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                    [adView makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.mas_equalTo(0);
                        make.top.mas_equalTo(0);
                    }];
                    __weak typeof(adView)weakADView = adView;
                    adView.ImageTapBlock = ^()
                    {
                        NSString *url = dic[@"refuelCard"][@"imageLink"];
                        
                        if (url.length>0) {
                            WebViewController *webVC = [[WebViewController alloc] init];
                            webVC.url = url;
                            webVC.titleStr = dic[@"refuelCard"][@"name"];
                            [self.navigationController pushViewController:webVC animated:YES];
                            [weakADView removeFromSuperview];
                        }else
                        {
                            [weakADView removeFromSuperview];
                        }
                        
                    };
                    
                });
                
            }else
            {
                __weak typeof(manage)weakManage = manage;
                [manage downloadImageWithURL:[NSURL URLWithString:dic[@"refuelCard"][@"imagePath"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [weakManage.imageCache storeImage:image forKey:dic[@"refuelCard"][@"imagePath"] toDisk:YES];
                }];
                
            }
            
        } Fail:^(NSString *errror) {
            
        }];
        
    });
}

//点击调出导航
- (void)myAnnotationTapForNavigationWithModel:(ParkingModel *)model
{
    [MobClick event:@"Daohang"];
    _faySheet = [[faySheetVC alloc] init];
    _faySheet.nowLatitude = _nowLatitude;
    _faySheet.nowLongitude = _nowLongitude;
    _faySheet.modelLatitude = model.parkingLatitude;
    _faySheet.modelLongitude = model.parkingLongitude;
    _faySheet.modelParkingName = model.parkingName;
    [self.view addSubview:_faySheet.view];
    [self addChildViewController:_faySheet];
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
    NSString *summery = [[NSString stringWithFormat:@"%@%@",_payStatusView.daiBoInfoV.temModel.orderId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",cancelOrder,_payStatusView.daiBoInfoV.temModel.orderId,summery];
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *model = [RequestModel new];
    
    [model getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            CancelOrderVC *cancelVC = [[CancelOrderVC alloc] init];
            [self.navigationController pushViewController:cancelVC animated:YES];
            
        }else
        {
            ALERT_VIEW(responseObject[@"errorInfo"]);
            _alert = nil;
            
        }
        
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];

}

- (void)addCarClick
{
    MyLog(@"********");
}
#pragma mark -- 提醒绑定手机号
- (void)alertNeedPhone
{
 
    __weak typeof(self)ws = self;
    phoneView *phoneV = [[phoneView alloc]init];
    __weak typeof (phoneView *)weakPhoneV = phoneV;
    phoneV.nextVC = ^(){
        [ws loadCarArray];
        [weakPhoneV hide];
        
    };
    [phoneV show];
    
}
#pragma mark -- 提醒绑定车辆
-(void)alertAddCar
{
    UIAlertController *alert = [MyUtil alertController:@"请先添加车辆" Completion:^{
        
         [MobClick event:@"CarManage_addCar1ID"];
        AddCarInfoViewController *addCarVC = [[AddCarInfoViewController alloc]init];
        [self.navigationController pushViewController:addCarVC animated:YES];
        
    }Fail:^{
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 提醒去登陆
- (void)alertShouldLogin
{
    UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        
    }Fail:^{
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark -- 初始化添加车辆、月租、产权、临停
- (void)LoadMapBottomSecondView
{

    if (!_mapBottomSecondView) {
        _mapBottomSecondView = [MapBottomSecondView new];
        [self.view addSubview:_mapBottomSecondView];
    }
    [_mapBottomSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-49);
        
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];

    __weak typeof(self)ws = self;
    _mapBottomSecondView.payKindViewClick = ^(NewParkingModel *model,PayKindView *payKindView){
        if (!ws.isVisitor) {
            [ws alertShouldLogin];
            return ;
        }
         [MobClick event:@"AtOnceGetMoneyID"];
        if (payKindView.payKind == PayKindNoCar) {
            [MobClick event:@"CarManage_addCar2ID"];
//
            //前往车辆管理界面
            CarListViewController *carListVC = [[CarListViewController alloc]init];
            [ws.navigationController pushViewController:carListVC animated:YES];
            
        }else if (payKindView.payKind == PayKindYueZu){
            [MobClick event:@"AtOnceGetMoneyID_Monthly"];
            NewMonthlyRentPayVC *month = [[NewMonthlyRentPayVC alloc]init];
            month.model = model;
            month.orderType = @"13";
            [ws.navigationController pushViewController:month animated:YES];

            
        }else if (payKindView.payKind == PayKindLinTing){
            [MobClick event:@"AtOnceGetMoneyID_Temp"];
            NewTemParkingPayVC *shareTemParkingVC = [[NewTemParkingPayVC alloc] init];
            TemParkingListModel *temModel = [[TemParkingListModel alloc] init];
            temModel.parkingName = model.parkingName;
            temModel.parkingTime = model.parkingTime;
            temModel.amountPayable = model.amountPayable;
            temModel.carNumber = model.carNumber;
            temModel.parkingId = model.parkingId;
            temModel.beginDate = model.beginDate;
            shareTemParkingVC.temPayModel = temModel;
            [ws.navigationController pushViewController:shareTemParkingVC animated:YES];
            
        }else if (payKindView.payKind == PayKindChanQuan){
            [MobClick event:@"AtOnceGetMoneyID_Chanquan"];
            NewMonthlyRentPayVC *month = [[NewMonthlyRentPayVC alloc]init];
            month.model = model;
            month.orderType = @"14";
            [ws.navigationController pushViewController:month animated:YES];
        }
    };
}
#pragma  mark -- 初始化NotificationView
- (void)loadNotificationView
{
    if (!_notificationView) {
        _notificationView = [NotificationView new];
        [self.view addSubview:_notificationView];
        [_notificationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mapSearchView.mas_bottom).offset(10);
            make.right.mas_equalTo(-8);
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(22);
        }];
        __weak typeof(self)weakself = self;
        _notificationView.hidden = YES;
        [_notificationView addObserver:self forKeyPath:Khidden options:NSKeyValueObservingOptionNew context:nil];
        _notificationView.removeNotificationViewBlock = ^(){
            [weakself removeNotificationView];
        };
        
    }
    
}
- (void)dealloc
{
    [_notificationView removeObserver:self forKeyPath:Khidden];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _nowLatitude = 0;
    _nowLongitude = 0;
    _mapview = nil;
}
#pragma mark -- 监听_notificationView的状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    
    if ([keyPath isEqualToString:@"carModel"]) {
        _globalCarModel = [DataSource shareInstance].carModel;
        [self changeCarShow];
        
    }
    
    if ([keyPath isEqualToString:Khidden]) {
        MyLog(@"_notificationView隐藏了");
        if (_notificationView.hidden) {
            
            [UIView animateWithDuration:0.4 animations:^{
                [_carBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_mapSearchView.mas_bottom).offset(14);
                }];
                [self.view layoutIfNeeded];
            }];
            
        }else
        {
            [UIView animateWithDuration:0.4 animations:^{
                [_carBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_mapSearchView.mas_bottom).offset(42);
                }];
                [self.view layoutIfNeeded];
            }];
        }
    }
}

- (void)removeNotificationView
{
    _notificationView.hidden = YES;
  
}


#pragma mark -- 初始化搜索View
- (void)loadMapSearchView
{
    if (!_mapSearchView) {
        MapSearchView *mapSearchView = [MapSearchView new];
        _mapSearchView = mapSearchView;
        [self.view addSubview:mapSearchView];
        [mapSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(6);
            make.right.mas_equalTo(self.view).offset(-6);
            make.top.mas_equalTo(self.view).offset(22);
            make.height.mas_equalTo(42);
        }];
        mapSearchView.layer.cornerRadius = 21;
        mapSearchView.layer.masksToBounds = YES;
        
        mapSearchView.gotoSearchVC = ^(){
            [MobClick event:@"SearchID"];

            SearchVC *searchVC = [[SearchVC alloc]init];
            if (_homeArray.dataArray.count>0) {
                ParkingModel *model = [_homeArray.dataArray objectAtIndex:0];
                searchVC.parkingName = model.parkingName;
            }
            searchVC.SearchVCBlock = ^(ManagerModel *model){
                
                _isComeFormSearch = YES;
                
                MACoordinateRegion region;
                region.span = MACoordinateSpanMake(0.01, 0.01);
                region.center.latitude = [model.searchLatitude floatValue];
                region.center.longitude = [model.searchLongitude floatValue];
                _mapview.region = region;
            };
            [self.navigationController pushViewController:searchVC animated:YES];
            
        };
        
        mapSearchView.goToUserCenter = ^(){
            

          
            
#pragma mark ---------前往个人中心
            
          
           
            
            UserViewController *userCtrl = [[UserViewController alloc] init];
            [self.navigationController pushViewController:userCtrl animated:YES];
            
        };
        
            }
    _mapSearchView.title = @"恒积大厦";

}
#pragma mark -- 右边按钮点击事件 1:车辆 2:家 3:收藏
- (void)rightBtnClick:(UIButton *)btn
{
    
    if (btn.tag == 1) {
        
        if (!self.isVisitor) {//游客
            [self alertShouldLogin];
            return;
        }
        if (CUSTOMERMOBILE(customer_mobile).length == 0) {
            [self alertNeedPhone];
            return;
        }
        
        [MobClick event:@"CarManagerID"];
        CarListViewController *CarList = [[CarListViewController alloc]init];
        CarList.goInType = GoInControllerTypeWashCar;
#pragma mark -- 进入车辆列表  设置新车辆
        CarList.passOnCarNumber = ^(NewCarModel *carModel){
            
            
            [DataSource shareInstance].carModel = carModel;
            _globalCarModel = [DataSource shareInstance].carModel;
            [self changeCarShow];
            

        };
        [self.navigationController pushViewController:CarList animated:YES];

    }else if (btn.tag == 2){
        [self hiddenActivityView];

        ParkingModel *model = [_homeArray.dataArray objectAtIndex:0];
        if (model.parkingId == nil) {
            ParkAndFavViewController *login = [[ParkAndFavViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }else
        {
//            [_mapview removeAnnotations:_mapview.annotations];
//            先赋值
            [MobClick event:@"LocationFamilyID"];
            _mapSearchView.title = model.parkingName;
            _globalParkModel = model;
            [self setPayStatusViewModel:model];
            _isMove = NO;
            
//            再移动
            MACoordinateRegion region;
            region.span = MACoordinateSpanMake(0.01, 0.01);
            region.center =  CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]);
            _mapview.centerCoordinate = region.center;
            [_mapview setRegion:region animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isMove = YES;
            });
        }
        
    }else if (btn.tag == 3){//收藏
        if (!self.isVisitor) {//游客
            [self alertShouldLogin];
            return;
        }
        [MobClick event:@"CollectListID"];
        [self downloadFavoriteParking];
    }
}

#pragma mark -- 展示收藏车场
- (void)showCollectionPark
{
    if (_favDataArray.count == 0) {
        ALERT_VIEW(@"您暂未收藏停车场");
        _alert = nil;
        return;
    }
    MapParkingView *parkingV = [[MapParkingView alloc]init];
    parkingV.grayView = _grayView;
    parkingV.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    parkingV.backgroundColor = [UIColor whiteColor];
    parkingV.layer.anchorPoint = CGPointMake(1, 0);
    [self.view addSubview:parkingV];
    
    _selfView.hidden = YES;
    parkingV.hidden = NO;
    _grayView.hidden = NO;
    
    parkingV.dataArray = _favDataArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [parkingV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(220);
            make.width.mas_equalTo(SCREEN_WIDTH-108);
            make.centerY.mas_equalTo(self.view).offset(46);
            make.centerX.mas_equalTo(self.view).offset(SCREEN_WIDTH/2-50);
        }];
    });
    
    parkingV.positionParking = ^(NewParkingModel *model){
        MACoordinateRegion region;
        region.span = MACoordinateSpanMake(0.01, 0.01);
        region.center =  CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]);
        [self.mapview setRegion:region animated:YES];
        
    };
    
    [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
        parkingV.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion: nil];
    
}
#pragma mark -- 初始化右上方三个btn和定位按钮
- (void)loadRightBtn
{
    if (!_carBtn) {
        _carBtn = [UIButton new];
        [_carBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _carBtn.tag = 1;
        [_carBtn setImage:[UIImage imageNamed:@"car_v2"] forState:(UIControlStateNormal)];
        [self.view addSubview:_carBtn];
        [_carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mapSearchView.mas_bottom).offset(14);
            make.right.mas_equalTo(self.view).offset(-14);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        _carNameL = [UILabel new];
        _carNameL.textColor = [MyUtil colorWithHexString:@"6d7e8c"];
        _carNameL.font = [UIFont systemFontOfSize:10];
        _carNameL.textAlignment = 1;
        _carNameL.text = @"－－";
        [self.view addSubview:_carNameL];
        [_carNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_carBtn.mas_bottom).offset(-4);
            make.width.mas_lessThanOrEqualTo(36);
            make.centerX.mas_equalTo(_carBtn);
        }];
    }
    if (!_homeBtn) {
        _homeBtn = [UIButton new];
        _homeBtn.userInteractionEnabled = NO;
        [_homeBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _homeBtn.tag = 2;
        [_homeBtn setImage:[UIImage imageNamed:@"home_v2"] forState:(UIControlStateNormal)];
        [self.view addSubview:_homeBtn];
        [_homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_carBtn.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(38, 38));
            make.centerX.mas_equalTo(_carBtn);
        }];
    }
    
    if (!_collectionBtn) {
        _collectionBtn = [UIButton new];
//        _collectionBtn.userInteractionEnabled = NO;
        [_collectionBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _collectionBtn.tag = 3;
        [_collectionBtn setImage:[UIImage imageNamed:@"shouCang_v2"] forState:(UIControlStateNormal)];
        [self.view addSubview:_collectionBtn];
        [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_homeBtn.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(38, 38));
            make.centerX.mas_equalTo(_carBtn);
        }];
    }
    
    if (!_locationBtn) {
        _locationBtn = [UIButton new];
        [_locationBtn setImage:[UIImage imageNamed:@"navigation_v2"] forState:(UIControlStateNormal)];
        [_locationBtn addTarget:self action:@selector(getUserLocation) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_locationBtn];
        [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(8);
            make.size.mas_equalTo(CGSizeMake(38, 38));
            make.bottom.mas_equalTo(_payStatusView.mas_top);
        }];
    }
}

#pragma mark -- 定位
- (void)getUserLocation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hiddenActivityView];
//        [_mapview removeAnnotations:_mapview.annotations];
        MACoordinateRegion region;
        region.span = MACoordinateSpanMake(0.01, 0.01);
        region.center = _mapview.userLocation.location.coordinate;
        [_mapview setRegion:region animated:YES];
        
//        [self addAnnotationWithCooordinate];
        
    });
}

#pragma mark -- 初始化activityView
- (void)loadMapActivityView
{
    if (!_mapActivityView) {
        _mapActivityView = [MapActivityView new];
        [self.view addSubview:_mapActivityView];
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (int i=0; i<1; i++) {
            ActivityModel *model = [[ActivityModel alloc] init];
            model.imageName = [NSString stringWithFormat:@"clearCarbanner_v2"];
            model.viewControllerName = [NSString stringWithFormat:@"ClearCarVC"];
            [dataArray addObject:model];
        }
        
        _mapActivityView.activityArray = dataArray;
        [_mapActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(SCREEN_WIDTH * 0.57);

            make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.57);
        }];
        __weak typeof(self)weakself = self;
        
        _mapActivityView.hiddenActivtyView = ^()
        {
            [weakself hiddenActivityView];
            
        };
        _mapActivityView.washCarBlock = ^(){
            [weakself hiddenActivityView];
            if (!weakself.isVisitor) {//游客
                [weakself alertShouldLogin];
                return;
                
            }
            if (CUSTOMERMOBILE(customer_mobile).length == 0) {
                [weakself alertNeedPhone1];
                return;
            }
//            ParkingModel *model = weakself.globalParkModel;
//            if ([MyUtil isBlankString:model.parkingName] == YES) {
//                
//            }else{
//            }
                [weakself performSelector:@selector(onClock) withObject:weakself afterDelay:0];
                

        };
        
    }
}

- (void)onClock{
    
    if (_netWorkError == NETWORKERRORNONETWORK){
   
       //检查是否有网
        ALERT_VIEW(@"网络异常,请检查网络设置。")
        _alert = nil;
        
    }else if (_errorNum == ERRORNUMNOLOCATION){
       //检查是否定位
      
        [self alertUserAllowLocation];
        
        
    }else{
            ChooseCheXing *chooseVC = [[ChooseCheXing alloc]initWithController:self];
            __weak ChooseCheXing *weakChooseVC = chooseVC;
            if ([self.carNameL.text isEqualToString:@"－－"]) {
                chooseVC.carNumT.text = @" ";
            }else{
                chooseVC.carNumT.text = _globalCarModel.carNumber;
            }
//           chooseVC.parkingName.text = self.globalParkModel.parkingName;
//            chooseVC.carNumT.text = self.carNumber;
            chooseVC.chooseCarBlock = ^(){
                CarListViewController *CarList = [[CarListViewController alloc]init];
                
                CarList.goInType = GoInControllerTypeWashCar;
                CarList.passOnCarNumber = ^(NewCarModel *carModel){
                    weakChooseVC.carNumT.text = carModel.carNumber;
                    
                };
                [self.navigationController pushViewController:CarList animated:YES];
            };
            chooseVC.sureChooserCarBlocl = ^(NSString *parkId,NSDictionary *dict){
                ClearCarPay *clearCarPay = [[ClearCarPay alloc] init];
                clearCarPay.parkingId = parkId;
                clearCarPay.pamaDict = dict;
                [self.navigationController pushViewController:clearCarPay animated:YES];
                [weakChooseVC animatedOut];
            };
            [chooseVC animatedIn];
   }

}

- (void)alertNeedPhone1{
    
    __weak typeof(self)ws = self;
    phoneView *phoneV = [[phoneView alloc]init];
    __weak typeof (phoneView *)weakPhoneV = phoneV;
    phoneV.nextVC = ^(){
       [ws loadCarArray1];
        [weakPhoneV hide];
        
    };
    [phoneV show];
}
- (void)loadCarArray1{
   [self performSelector:@selector(onClock) withObject:self afterDelay:1];
}

#pragma mark --展示ActivityView
- (void)showActivityView
{
    _bottomView.hidden = NO;
    _payStatusView.hidden = NO;
    
    _mapBottomSecondView.hidden = NO;

  
}

#pragma mark --隐藏ActivityView
- (void)hiddenActivityView
{
    _bottomView.hidden = NO;
    _payStatusView.hidden = NO;
    _mapBottomSecondView.hidden = NO;

}

#pragma mark -- MAMapView定位成功
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    //定位成功
    
//    [self.locationManager startUpdatingLocation];  // 定位成功，停止定位，因为继续定位比较耗电，具体的你懂得
    _errorNum = ERRORNUMNORMAL;
    self.locationTool.locationStatus = LocationStatusLocationSuccess;
    

//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}




#pragma mark --MAMapView代理方法
/*!
 @brief 定位失败后调用此接口
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
    static int num = 1;
    
    _errorNum = ERRORNUMNOLOCATION;
    self.locationTool.locationStatus = LocationStatusNoLocation;

    switch([error code]) {
        case kCLErrorDenied:
            
            if (num == 1) {
               
                [self alertUserAllowLocation];

                num = 0;
                
            }
            break;
            
            
            
        case kCLErrorLocationUnknown:
            
            break;
            
        default:
            ALERT_VIEW(@"发生未知错误");
            break;
    }
}

#pragma mark --设置mapView的set方法
- (void)loadMapView
{
    
    if (!_mapview) {
        _mapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _search = [[AMapSearchAPI alloc] init];
        _mapview.delegate = self;
        [self.view addSubview:_mapview];
        self.locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];//开始定位

    }
    _mapview.rotateCameraEnabled = NO;
    _mapview.skyModelEnable = NO;
    _mapview.showsCompass = NO;
    _mapview.showsScale = NO;
    _mapview.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    _mapview.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _mapview.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    
    MACoordinateRegion region;
    region.span = MACoordinateSpanMake(0.01, 0.01);
    region.center =  CLLocationCoordinate2DMake(31.225701,121.481342);
    [_mapview setRegion:region animated:YES];
    
    [_mapview setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    [_mapview mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    _mapview.customizeUserLocationAccuracyCircleRepresentation = YES;

}
#pragma mark --设置蓝色圈样式
//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
//        // 自定义定位精度对应的MACircleView
//        if (overlay == mapView.userLocationAccuracyCircle)
//        {
//            MAOverlayPathRenderer *accuracyCircleView = [[MAOverlayPathRenderer alloc] initWithOverlay:overlay];
//    
//            accuracyCircleView.lineWidth    = 2.f;
//            accuracyCircleView.strokeColor  = [UIColor lightGrayColor];
//            accuracyCircleView.fillColor    = [UIColor redColor];
//    
//            return accuracyCircleView;
//        }
//        return nil;
//}

#pragma mark --当用户坐标发生改变时，重新获取停车场数组
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{

    float horizontalSpace = _nowLatitude - userLocation.coordinate.latitude;
    float verticalSpace = _nowLongitude - userLocation.coordinate.longitude;
    
    
    if (horizontalSpace >= 0.01 || horizontalSpace <= -0.01 || verticalSpace >= 0.01 || verticalSpace <= -0.01)
    {

        MyLog(@"当用户坐标发生改变时，重新获取停车场数组 坐标：%f %f %d",userLocation.coordinate.latitude,userLocation.coordinate.longitude,updatingLocation);

        _nowLongitude = userLocation.coordinate.longitude;
        _nowLatitude = userLocation.coordinate.latitude;
        _isMove = YES;
        [self getParkDataWith:_nowLatitude With:_nowLongitude];
        
        MACoordinateRegion region;
        region.span = MACoordinateSpanMake(0.01, 0.01);
        region.center =  CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [_mapview setRegion:region animated:YES];
        
    }


}
#pragma mark -- 获取停车场数据
- (void)getParkDataWith:(float)latitude With:(float)Longitude
{
    BEGIN_MBPROGRESSHUD
    NSString *summary = [[NSString stringWithFormat:@"%f%f%@%@",latitude,Longitude,[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%f/%f/%@/%@",SEARCH_PARK_BY_LL,latitude,Longitude,[MyUtil getVersion],summary];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [RequestModel requestGetPhoneNumWithURL:url WithDic:nil Completion:^(NSDictionary *dict) {
            END_MBPROGRESSHUD
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                [_mapview removeAnnotations:_mapview.annotations];
                NSArray *listArray = dict[@"list"];
                
                [_parkingArray removeAllObjects];
                
                for (NSDictionary *tmpDict in listArray)
                {
                    ParkingModel *model = [[ParkingModel alloc] init];
                    [model setValuesForKeysWithDictionary:tmpDict];
                    [_parkingArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    MyLog(@"addAnnotationWithCooordinate   ---->获取停车场数据");
                    [self addAnnotationWithCooordinate];
                    
                });
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    ALERT_VIEW(SERVERERROR);
                    _alert = nil;
                });
                
            }

            
        } Fail:^(NSString *error) {
            END_MBPROGRESSHUD
          
            
            
        }];
        

    });
    
}
#pragma mark -- 添加大头针
- (void)addAnnotationWithCooordinate
{
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }
    
    [_locationArray removeAllObjects];
    for (ParkingModel *model in _parkingArray) {
        FayPointAnnotation *annotation = [[FayPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]);
        annotation.model = model;
        annotation.title = model.parkingId;
        if (![_locationArray containsObject:annotation]) {
            [_locationArray addObject:annotation];
        }
    }

    [self.mapview removeOverlays:self.mapview.overlays];
    [self.mapview removeAnnotations:self.mapview.annotations];
    [self.mapview addAnnotations:_locationArray];
    
}


#pragma mark - MAMapViewDelegate

- (FayAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    // 返回nil就会按照系统的默认做法
    if (![annotation isKindOfClass:[MAPointAnnotation class]]) return nil;
    
    // 1.获得大头针控件
    FayAnnotationView *annoView = [FayAnnotationView annotationViewWithMapView:mapView];
    annoView.needAnimation = YES;
    // 2.传递模型
    annoView.annotation = annotation;
    [self setAnnotationView:annoView];
    return annoView;


}
#pragma mark -- 设置大头针样式
- (void)setAnnotationView:(FayAnnotationView *)fayView
{
    FayPointAnnotation *annotation = fayView.annotation;
    
    if (annotation) {
        ParkingModel *model =_homeArray.dataArray[0];
        
        if ([annotation.model.isCooperate intValue] == 2) {
            
            fayView.portrait = [UIImage imageNamed:@"blueAnnotationLittle_v2"];
            
        }else
        {
            fayView.portrait = [UIImage imageNamed:@"greenAnnotation_v2"];
        }
        
        if ([annotation.model.parkingId isEqualToString:model.parkingId]) {
            
            fayView.portrait = [UIImage imageNamed:@"homeAnnotation_v2"];
            
        }
    
        fayView.goToParkDetail = ^()
        {
            
            [MobClick event:@"GoInCarDetailID"];
            NewParkingdetailVC *parkingDetailVC = [[NewParkingdetailVC alloc] init];
            parkingDetailVC.parkingId = _globalParkModel.parkingId;
            [self.navigationController pushViewController:parkingDetailVC animated:YES];
        };

    }

}



#pragma mark -- 获取气泡内容
- (void)getBubbleInfoWith:(ParkingModel *)parkModel Completion:(void (^)(ParkingModel*newParkModel))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:parkModel.parkingId,@"parkingId",@"2.0.0",@"version", nil];
        NSString *url = [NSString stringWithFormat:@"%@",getParkingStatus];
        [RequestModel requestGetParkingStatusWith:url WithDic:dict Completion:^(ParkingModel *model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(model);
                }
            });
            
        } Fail:^(NSString *error) {
            
        }];
    });
    
    
}
#pragma  mark -- 获取临停订单
- (void)loadLinTingOrderWith:(NewCarModel *)carModel
{
    [_mapBottomSecondView ActivityViewShow];
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@",[MyUtil getCustomId],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",TemParkingOrderList,[MyUtil getCustomId],summary];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [RequestModel requestTemParkingOrderWithURL:url WithTag:@"cars" Completion:^(NSArray *resultArray) {
            [_mapBottomSecondView ActivityViewHidden];

            [_totalArray removeAllObjects];
            [_LinTingArray removeAllObjects];
            if (resultArray.count>0) {
                
                for ( TemParkingListModel *temModel in resultArray) {
                    ParkingModel *model = [[ParkingModel alloc] init];
                    model.parkingName = temModel.parkingName;
                    model.parkingTime = temModel.parkingTime;
                    model.amountPayable = temModel.amountPayable;
                    model.carNumber = temModel.carNumber;
                    model.parkingId = temModel.parkingId;
                    model.beginDate = temModel.beginDate;
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model,@"temporary", nil];
                    if (![_LinTingArray containsObject:dic]) {
                        [_LinTingArray addObject:dic];
                    }
                }
            }
            [self loadMonthlyEquityWith:carModel];

        } Fail:^(NSString *error) {
            [_mapBottomSecondView ActivityViewHidden];

            [_totalArray removeAllObjects];
            [_LinTingArray removeAllObjects];
            [self loadMonthlyEquityWith:carModel];

        }];

    });
}
#pragma mark -- 获取月租产权
- (void)loadMonthlyEquityWith:(NewCarModel *)carModel
{
    
    if (_isVisitor) {//不是游客
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2.0.0",@"version",[MyUtil getCustomId],@"customerId", nil];

        
            [_mapBottomSecondView ActivityViewShow];

            [RequestModel requestGetMonthlyEquityWith:getMonthlyEquity WithDic:dic Completion:^(NSMutableArray *array) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    END_MBPROGRESSHUD;
                    [_mapBottomSecondView ActivityViewHidden];

                    [_yuZuChanQuanArray removeAllObjects];
                    [_totalArray removeAllObjects];
                    [_yuZuChanQuanArray addObjectsFromArray:array];
                    [_totalArray addObjectsFromArray:_LinTingArray];
                    [_totalArray addObjectsFromArray:_yuZuChanQuanArray];
                    _mapBottomSecondView.dataArray = _totalArray;
                });

                
            } Fail:^(NSString *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    END_MBPROGRESSHUD
                    [_mapBottomSecondView ActivityViewHidden];

                    [_totalArray removeAllObjects];
                    [_totalArray addObjectsFromArray:_LinTingArray];
                    [_totalArray addObjectsFromArray:_yuZuChanQuanArray];
                    _mapBottomSecondView.dataArray = _totalArray;
                    
                });
                
            }];
            
        
    }else
    {
      
        
    }
    
}

#pragma mark -- 改变地图车辆图标展示
- (void)changeCarShow
{
    if (_globalCarModel == nil) {
        _carNameL.text = @"－－";
        NSMutableArray *aArr = [NSMutableArray arrayWithObjects:@"noCar", nil];
        _mapBottomSecondView.dataArray = aArr;
    }else
    {
        NSString *str = [_globalCarModel.carNumber substringFromIndex:4];
        _carNameL.text = [NSString stringWithFormat:@"*%@",str];
        //    只有对车辆进行增删  才调用loadLinTingOrderWith
        [self loadLinTingOrderWith:_globalCarModel];
    }
    

}

#pragma mark --获取用户默认车辆
- (void)loadCarArray
{
    
    NSString *summary = [NSString stringWithFormat:@"%@%@%@",[MyUtil getCustomId],@"2.0.2",MD5_SECRETKEY];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",gaindefaultcar,[MyUtil getCustomId],@"2.0.2",[summary MD5]];
    MyLog(@"%@",url);
    BEGIN_MBPROGRESSHUD
    [RequestModel getDicWithUrl:url Completion:^(NSDictionary *dataDic) {
        NewCarModel *carModel;
        
        END_MBPROGRESSHUD
        if ([dataDic[@"data"] allKeys].count >0) {
            carModel = [NewCarModel shareNewModelWithDic:dataDic[@"data"]];
        }else
        {
            carModel = nil;
        }
        [DataSource shareInstance].carModel = carModel;
        _globalCarModel = carModel;
        
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        _globalCarModel = nil;
        [DataSource shareInstance].carModel = nil;

    }];
    
    
    
//    if (!_selfView) {
//        selfAlertView *selectCarView = [[selfAlertView alloc]init];
//        _selfView = selectCarView;
//        selectCarView.backgroundColor = [UIColor whiteColor];
//    }
////    BEGIN_MBPROGRESSHUD;
//    [_selfView getUserCarArrayWhenCompetion:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            
//            
//            MyLog(@"获取用户车辆－－－－－－－－");
//            NSString *carNumber = [userDefaults objectForKey:@"carNumber"];
//            if (_selfView.dataArray.count==0 || _selfView.dataArray == nil) {
//                _globalCarModel = nil;
//                _carNameL.text = @"－－";
//                _mapBottomSecondView.dataArray = @[@""].mutableCopy;
//
//            }else{
//                BOOL carNumIsexit = NO;
//                for (CarModel *model in _selfView.dataArray) {
//                    if ([model.carNumber isEqualToString:carNumber]) {
//                        _globalCarModel = model;
//                        NSString *str = [carNumber substringFromIndex:4];
//                        _carNameL.text = [NSString stringWithFormat:@"*%@",str];
//                        carNumIsexit = YES;
//                    }
//                }
//                
//                if (!carNumIsexit) {
//                    CarModel *model = [_selfView.dataArray objectAtIndex:0];
//                    _globalCarModel = model;
//                    NSString *str = [model.carNumber substringFromIndex:4];
//                    _carNameL.text = [NSString stringWithFormat:@"*%@",str];
//                    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
//                    [use setObject:model.carNumber forKey:@"carNumber"];
//                    [use synchronize];
//                }
//                
//            }
//            [self loadLinTingOrderWith:_globalCarModel];
////            END_MBPROGRESSHUD;
//        });
//        
//    } Failure:^{
//        _carNameL.text = @"－－";
//        _globalCarModel = nil;
//        //如果是用户未绑定车辆，mapBottomSecondView显示为添加车辆（点击跳入添加车辆）
//        _mapBottomSecondView.dataArray = @[@""].mutableCopy;
////        END_MBPROGRESSHUD;
//    }];
}
#pragma mark -- 获取收藏车场
- (void)downloadFavoriteParking
{
    BEGIN_MBPROGRESSHUD
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"2.0.0",@"version",nil];
    NSString *url = [NSString stringWithFormat:@"%@",queryCollection];
    [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
        _favDataArray = [NSMutableArray arrayWithArray:array];
        
        
        [self setCllection:array];
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
    }];
    
    
    return;

    
    
}
- (void)setCllection:(NSMutableArray *)array{
    if (array.count == 0) {
        ALERT_VIEW(@"您暂未收藏停车场");
        _alert = nil;
        return;
    }
    
    
    _parkingV = [[MapParkingView alloc]init];
    _parkingV.grayView = _grayView;
    _parkingV.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    _parkingV.backgroundColor = [UIColor whiteColor];
    //            _parkingV.layer.anchorPoint = CGPointMake(1, 0);
    [self.view addSubview:_parkingV];
    
    
    _parkingV.hidden = NO;
    _grayView.hidden = NO;
    _parkingV.dataArray = array;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_parkingV mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(220);
            make.width.mas_equalTo(SCREEN_WIDTH-108);
            
            make.top.mas_equalTo(_collectionBtn.mas_top);
            
            make.centerX.mas_equalTo(self.view);
            
        }];
    });
    __weak typeof(self)ws = self;
    __weak MapSearchView *weakSearchView = _mapSearchView;
    _parkingV.positionParking = ^(NewParkingModel *model){
        [ws hiddenActivityView];
        weakSearchView.title = model.parkingName;
        MACoordinateRegion region;
        region.span = MACoordinateSpanMake(0.01, 0.01);
        region.center =  CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]);
        [ws.mapview setRegion:region animated:YES];

        
    };
    
    [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
        _parkingV.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion: nil];
}



#pragma mark -- 获取家停车场
- (void)getHomePark
{
    static int num = 1;
    num ++ ;
    MyLog(@"%d  获取家停车场",num);
    if (!_homeArray) {
        HomeArray *homeArray = [HomeArray shareHomeArray];
        _homeArray = homeArray;
    }
    _homeArray.dataArray = [NSMutableArray array];
    if (_homeArray.dataArray.count == 0) {
        ParkingModel *model = [[ParkingModel alloc] init];
        [_homeArray.dataArray addObject:model];
    }
   
    
    NSString *homeSummary = [[NSString stringWithFormat:@"%@%@%@",[MyUtil getCustomId],[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *homeURL = [NSString stringWithFormat:@"%@/%@/%@/%@",indexShow,[MyUtil getCustomId],[MyUtil getVersion],homeSummary];
    [RequestModel requestGetParkingListWithURL:homeURL WithTag:@"4" Completion:^(NSMutableArray *resultArray) {
        for (ParkingModel *model in resultArray) {
            
            if ([model.indexParkingType isEqualToString:@"1"]) {
                
#pragma mark -- 将家停车场赋值给_carLiftV
                ParkingModel *aModel = [_homeArray.dataArray objectAtIndex:0];
                if (![aModel.parkingId isEqualToString:model.parkingId]) {
                    [_homeArray.dataArray replaceObjectAtIndex:0 withObject:model];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MyLog(@"addAnnotationWithCooordinate ----获取家停车场");
                        [self addAnnotationWithCooordinate];
                    });
                }
                
                
            }else if ([model.indexParkingType isEqualToString:@"2"]){
//                公司暂不处理
            }
        }
        _homeBtn.userInteractionEnabled = YES;
       
        
    } Fail:^(NSString *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addAnnotationWithCooordinate];

        });
        
    }];

}
#pragma mark --
#pragma mark -- 给payStatusView赋值
- (void)setPayStatusViewModel:(ParkingModel *)model
{
    _payStatusView.distance = [self getDistanceWithParkModel:model];
    _payStatusView.dataModel = model;
}

#pragma mark - 点击大头针

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if ([view isKindOfClass:[FayAnnotationView class]]) {
        _payStatusView.hidden = NO;
        FayAnnotationView *cusView = (FayAnnotationView *)view;
        FayPointAnnotation *annotation = view.annotation;
        
        for (ParkingModel *model in _parkingArray) {
            if ([model.parkingId isEqualToString:annotation.model.parkingId]) {
                annotation.model.parkingCanUse = model.parkingCanUse;
            }
        }
        
//        给_globalParkModel赋值
        _globalParkModel = annotation.model;
        if ([annotation.model.isCooperate intValue]== 1) {//非合作
            cusView.isHomePark = NO;
            cusView.parkModel = annotation.model;
            [MobClick event:@"ClickRedAnnotationID"];
        }else
        {
            
            ParkingModel *aParkModel = _homeArray.dataArray[0];
            
            if ([annotation.model.canUse intValue]==2 || [annotation.model.parkingId isEqualToString:aParkModel.parkingId]) {
                [self getBubbleInfoWith: annotation.model Completion:^(ParkingModel *newParkModel) {
                    [MobClick event:@"ClickBlueAnnotationID"];
                    cusView.calloutViewStyle = CalloutViewStyleNervous;
                    cusView.isHomePark = YES;
                    cusView.parkModel = newParkModel;
                }];
            }else{
                
                //预约停车        获取气泡内容 资源停车场
                [MobClick event:@"ClickBlueAnnotationID"];
                cusView.isHomePark = NO;
                cusView.parkModel = annotation.model;
            }

        }
            
        _mapSearchView.title = annotation.model.parkingName;
        //最上满的绿色圆的图标
        [self setPayStatusViewModel:annotation.model];

    }
}
#pragma mark -- 加载中间红色的大头针
- (void)loadCenterAnnotation
{
    if (!_selfViewTwo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *bomeImage=[[UIImageView alloc]init];
            bomeImage.center = _mapview.center;
            bomeImage.bounds = CGRectMake(0, 0, 44, 44);
            _bomeImage = bomeImage;
            bomeImage.image=[UIImage imageNamed:@"MapNavigation"];
            [self.view addSubview:bomeImage];
            
            _selfViewTwo = [[SelfAlertViewTwo alloc]init];
            _selfViewTwo.mainL.text = @"口袋停服务暂未覆盖到当前位置";
            _selfViewTwo.layer.anchorPoint = CGPointMake(0.5, 1);
            _selfViewTwo.subL.text = @"敬请期待";
            _selfViewTwo.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
            [self.view addSubview:_selfViewTwo];
            [_selfViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_mapview.mas_centerX);
                make.centerY.mas_equalTo(self.view.centerY).offset(-24);
                make.size.mas_equalTo(CGSizeMake(200, 52));
            }];
            
            [self.view bringSubviewToFront:_clearBackView];
            [self.view bringSubviewToFront:_hud];
#pragma mark --设置登陆界面
//            [self setLoginVC];

        });
    }
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    MyLog(@"地图被点击");
    
}
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    MyLog(@"地图将要移动");
    _selfViewTwo.transform = CGAffineTransformMakeScale(0.0000001, 0.0000001);

}
#pragma mark -
#pragma mark - 地图滑动调用此方法
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    if (!_isMove) {
        return;
    }
   
    //中间的红色大头针
    [UIView animateWithDuration:0.2 animations:^{
        
        _bomeImage.center = CGPointMake(self.view.center.x , self.view.center.y-15);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{

            _bomeImage.center = CGPointMake(self.view.center.x, self.view.center.y);
            
        }];
    }];
    
    //    屏幕坐标转化为地图经纬度
    CLLocationCoordinate2D MapCoordinate = [_mapview convertPoint:_mapview.center toCoordinateFromView:_mapview];

    NSString *summary = [[NSString stringWithFormat:@"%f%f%@",MapCoordinate.latitude,MapCoordinate.longitude,MD5_SECRETKEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%f/%f/%@",getIsParking,MapCoordinate.latitude,MapCoordinate.longitude,summary];

    
    [RequestModel IsExitParkingWithURL:url Completion:^(NSMutableArray *array) {
        
        if ([[array objectAtIndex:0] isEqualToString:@"1"]) {
            //            附近没有停车场
            [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
                if (_isComeFormSearch) {
                    //从搜索页进入
                    _mapSearchView.title = @"口袋停";

                }else
                {
                    _mapSearchView.title = _globalParkModel.parkingName;

                }
                
                [self setPayStatusViewModel:_globalParkModel];
                _payStatusView.hidden = YES;
                _selfViewTwo.transform = CGAffineTransformMakeScale(1.0, 1.0);
                _isComeFormSearch = NO;
            } completion: nil];

        }else{
            _isComeFormSearch = NO;

            _selfViewTwo.transform = CGAffineTransformMakeScale(0.0000001, 0.0000001);
            _payStatusView.hidden = NO;
            ParkingModel *model = [array objectAtIndex:1];
            _globalParkModel = model;
            _mapSearchView.title = model.parkingName;
            
            for (ParkingModel *aModel in _parkingArray) {
                if ([aModel.parkingId isEqualToString:model.parkingId]) {
                    aModel.parkingCanUse = model.parkingCanUse;
                }
            }
                [self setPayStatusViewModel:model];
        }
        
    } Fail:^(NSString *str) {
        _isComeFormSearch = NO;

    }];
    
    
}

#pragma mark -- 计算出用户与停车场之间的距离
- (NSString *)getDistanceWithParkModel:(ParkingModel *)model
{
    MAMapPoint Point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.nowLatitude , self.nowLongitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.parkingLatitude floatValue], [model.parkingLongitude floatValue]));
    CLLocationDistance distances = MAMetersBetweenMapPoints(Point, point2);
    NSString *distance = [NSString stringWithFormat:@"%lf",distances];
    NSString *temDistance = [distance componentsSeparatedByString:@"."].firstObject;
    MyLog(@"------------------%f",[distance floatValue]);
    if (temDistance.length >3) {
        
        NSString *distance = [self backFrom:temDistance];
        
        return [NSString stringWithFormat:@"%@千米",distance];
        
    }else
    {
        return [NSString stringWithFormat:@"%@米",temDistance];
    }
    
    MyLog(@"------------------%f",[distance floatValue]);
}

- (NSString *)backFrom:(NSString *)myMile{
    NSInteger tag = [myMile integerValue]/1000;
    NSInteger tag1 = [myMile integerValue]%1000;
    NSInteger tag2 =  tag1/10;
    NSString *str = [NSString stringWithFormat:@"%ld.%ld",(long)tag,(long)tag2];
    return str;
}
#pragma mark -- 开启代泊
- (void)startDaiBoServer
{
    [MobClick event:@"StopACarID"];
    [self showDaiBoDetailInfo:_globalCarModel];
}
#pragma mark -- 弹出代泊界面
- (void)showDaiBoDetailInfo:(NewCarModel *)carModel
{
    NSString *temStr = [NSString stringWithFormat:@"说明: %@",_globalParkModel.parkPriceComment];
    _carDetailAlert = [[CarDetailAlert alloc] initWithInfo:temStr];
    
    if ([_globalParkModel.rule isEqualToString:@"1"]) {
        _carDetailAlert.ruleType = RULETYPEONE;
    }else if ([_globalParkModel.rule isEqualToString:@"2"]){
        _carDetailAlert.ruleType = RULETYPETWO;
        
    }
    _carDetailAlert.carModel = carModel;
    _carDetailAlert.delegate = self;
    _carDetailAlert.parkingModel = _globalParkModel;
    _carDetailAlert.infoL.text = temStr;
    [_carDetailAlert show];
}
#pragma mark -
#pragma mark --CarDetailAlert代理 选择取车时间
- (void)dataPickerView:(NSString *)startTime hourString:(NSString *)endTime miunteString:(NSString *)carNum
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",carNum,@"carNumber",[MyUtil getCustomId],@"customerId",@"12",@"orderType",_globalParkModel.parkingId,@"parkingId",startTime,@"startTime",endTime,@"endTime",@"0",@"isContinue",@"2.0.0",@"version", nil];
    _temDic = dataDic;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startDaiBoWithDic:_temDic];
        
    });
    
}
#pragma mark -- 刷新预约停车数据
- (void)reloadYuYueTingChe:(ParkingModel *)model Completion:(void (^)(int resultNum,TemParkingListModel *model))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",[MyUtil getCustomId],@"customerId",_globalCarModel.carNumber,@"carNumber",_globalParkModel.parkingId,@"parkingId",@"0",@"voucherStatus",@"1",@"pageIndex", nil];
        
        [RequestModel requestDaiBoOrder:queryVoucherPage WithType:@"getPingZheng" WithDic:dic Completion:^(NSArray *dataArray) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                END_MBPROGRESSHUD
                TemParkingListModel *model = dataArray[0];

                if (completion) {
                    completion(0,model);
                }
                
            });
            
            
            
        } Fail:^(NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD
                if (completion) {
                    completion(1,nil);
                }
            });
        }];
        
    });

}
#pragma mark -
#pragma mark -- 开启代泊
- (void)startDaiBoWithDic:(NSMutableDictionary *)dic
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BEGIN_MBPROGRESSHUD;
        [_carDetailAlert hide];
        
    });
    [RequestModel requestCreateTemparkingOrderWithURL:orderc WithType:@"1" WithDic:dic Completion:^(TemParkingListModel *model) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showDaiBoSuccessWith:model];
            END_MBPROGRESSHUD;
        });
        
    } Fail:^(NSString *error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            END_MBPROGRESSHUD;
            ALERT_VIEW(error);
            _alert = nil;
        });
    }];
}
#pragma mark -
#pragma mark---弹出代泊成功view
- (void)showDaiBoSuccessWith:(TemParkingListModel *)model
{
    __weak typeof(self)WS = self;
    
    if ([model.waitCarCount intValue] > 0) {
        BusyAlert *busyView = [[BusyAlert alloc] init];
        busyView.carQuantityL.text = [NSString stringWithFormat:@"前面等待%@辆车",model.waitCarCount];
        NSMutableAttributedString *string = [MyUtil getLableText:busyView.carQuantityL.text changeText:model.waitCarCount Color:[UIColor orangeColor] font:25];
        [busyView.carQuantityL setAttributedText:string];
        NSArray *timeArray = [model.startTime componentsSeparatedByString:@" "];
        NSInteger compareNum = [MyUtil compareOneDay:[NSDate date] withAnotherDay:[MyUtil StringChangeDate:[timeArray firstObject]]];
        
        NSString *temDay;
        
        if (compareNum == 0) {
            temDay = @"今天 ";
        }else if (compareNum == -1){
            temDay = @"明天 ";
        }else
        {
            temDay = @"";
        }
        
        
        busyView.AppointmentL.text = [NSString stringWithFormat:@"预计代泊时间为:%@%@",temDay,timeArray[1]];
        [busyView show];
        __weak typeof(busyView)weakBusy = busyView;
        busyView.tureBlock = ^(){
            
            [_temDic setValue:@"1" forKey:@"isContinue"];
            [_temDic setValue:model.startTime forKey:@"startTime"];
            [_temDic removeObjectForKey:@"summary"];
            
            [WS startDaiBoWithDic:_temDic];
            [weakBusy hide];
            
        };
        
        busyView.cancleBlock = ^(){
            [weakBusy hide];
#pragma mark --- 前往地图界面

        };
        
    }else
    {
        OtherStopAlert *successView = [[OtherStopAlert alloc] init];
                successView.getCarTimeL.text = model.endTime;
        
        NSArray *temArrar = [model.orderEndDate componentsSeparatedByString:@" "];
        
        NSInteger compareNum = [MyUtil compareOneDay:[NSDate date] withAnotherDay:[MyUtil StringChangeDate:[temArrar firstObject]]];
        
        NSString *temDay;
        
        if (compareNum == 0) {
            temDay = @"今天 ";
        }else if (compareNum == -1){
            temDay = @"明天 ";
        }else
        {
            temDay = @"";
            
        }
        
        successView.getCarTimeL.text = [NSString stringWithFormat:@"%@%@",temDay,[temArrar lastObject]];
        
        successView.carMasterPhone.text = model.parkerMobile;
        successView.reckonMoneyL.text = [NSString stringWithFormat:@"%@元",model.amountPaid];
        __weak typeof(successView)weakSuccess = successView;
        [successView show];
        successView.tureBlock = ^()
        {
#pragma mark -- 跳到时间轴
            TimeLineViewController *timeLineVC = [[TimeLineViewController alloc] init];
            timeLineVC.payType = 0;
            timeLineVC.fromStyle = TimeLineFromMap;
            [self.navigationController pushViewController:timeLineVC animated:YES];
            
        };
        
        successView.cancleBlock = ^()
        {
            [weakSuccess hide];
        };
        
    }
    
    
    
}

#pragma mark --设置引导页
- (void)setGuideImage
{
    NSFileManager *manager=[NSFileManager defaultManager];
    //判断 我是否创建了文件，如果没创建 就创建这个文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![manager fileExistsAtPath:[path stringByAppendingPathComponent:@"b.txt"]]){
        
        _guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        _guideImageView.image = [UIImage imageNamed:@"step1"];
        _window = [UIApplication sharedApplication].keyWindow;
        
        [_window addSubview:_guideImageView];
        
        _nilBtn = [MyUtil createBtnFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) title:nil bgImageName:nil target:self action:@selector(cancelGuideImage)];
        
        [_window addSubview:_nilBtn];
        
        //第一次运行后创建文件，以后就不再运行
        [manager createFileAtPath:[path stringByAppendingPathComponent:@"b.txt"] contents:nil attributes:nil];
    }
}

- (void)cancelGuideImage
{
    static NSInteger i = 0;
    i++;
    if (i==1) {
        _guideImageView.image = [UIImage imageNamed:@"step2"];
    }else if (i == 2){
        _guideImageView.image = [UIImage imageNamed:@"step3"];
    }else if (i == 3){
        _guideImageView.image = [UIImage imageNamed:@"step4"];
    }else if (i == 4){
        _guideImageView.image = [UIImage imageNamed:@"step5"];
    }else if (i == 5){
        _guideImageView.image = [UIImage imageNamed:@"step6"];
    }else if (i == 6){
        _guideImageView.image = [UIImage imageNamed:@"step7"];
    }else{
        _guideImageView.hidden = YES;
        _guideImageView = nil;
        [_window removeFromSuperview];
        _nilBtn.hidden = YES;
        _nilBtn = nil;
    }
}


- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 设置登陆界面
- (void)setLoginVC
{
    if (!_isVisitor) {
//        如果是游客设置登陆界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self addChildViewController:loginVC];
        [self.view addSubview:loginVC.view];
        [self.view bringSubviewToFront:loginVC.view];
        [loginVC.view removeFromSuperview];
        
        
    }
}

- (LocationTool *)locationTool
{
    _locationTool = [LocationTool shareLocationTool];
    return _locationTool;
    
}

@end
