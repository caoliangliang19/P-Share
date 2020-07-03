//
//  NewParkingdetailVC.m
//  P-Share
//
//  Created by fay on 16/4/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewParkingdetailVC.h"
#import "NewParkingModel.h"
#import "UIImageView+WebCache.h"
#import "CarDetailAlert.h"
#import "carMasterViewController.h"
#import "faySheetVC.h"
#import "CarListViewController.h"
#import "selfAlertView.h"
#import "OtherStopAlert.h"
#import "BusyAlert.h"
#import "TimeLineViewController.h"
#import "MainDaIBoVC.h"
#import "WXApi.h"
#import "HomeArray.h"
#import "WeiboSDK.h"
#import "ManagerModel.h"

#define orderType           @"12"//代泊订单类型

@interface NewParkingdetailVC ()<CarDetailAlertDelegate,UITextFieldDelegate>
{
    NewParkingModel *_parkingModel;
    faySheetVC *_faySheet;
    UIAlertView *_alert;
    NSArray *_orderArray;
    CarDetailAlert *_carDetailAlert;
    NSMutableDictionary *_temDic;
    
    CarModel *_carModel;
    UIView *_clearBackView;
    MBProgressHUD *_mbView;
    __weak phoneView *_phoneV;

    
}
@property (nonatomic,strong)LocationTool *tool;

@property (nonatomic,strong)selfAlertView *chooseCarView;

@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shouCangImage;
@property (weak, nonatomic) IBOutlet UIView *chooseHomeView;
@property (weak, nonatomic) IBOutlet UIButton *officBtn;

@end

@implementation NewParkingdetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setHeight];
    [self loadUI];
    ALLOC_MBPROGRESSHUD

    BEGIN_MBPROGRESSHUD

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",_parkingId,[MyUtil getCustomId],[MyUtil getVersion],MD5_SECRETKEY] MD5];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",GETLIST,_parkingId,[MyUtil getCustomId],[MyUtil getVersion],summary];
        [RequestModel requestGetParkingListWithURL:urlStr WithTag:@"1" Completion:^(NSMutableArray *resultArray) {
            
            _parkingModel = resultArray[0];
            
            [self loadData];
            [self createFavorite];
            END_MBPROGRESSHUD
                       
        } Fail:^(NSString *error) {
            END_MBPROGRESSHUD;
            
        }];
                
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];    
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"停车场详情进入"];
    if (_chooseCarView) {
        BEGIN_MBPROGRESSHUD
        [_chooseCarView getUserCarArrayWhenCompetion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD
                
            });
            
        } Failure:^{
            END_MBPROGRESSHUD
        }];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"停车场详情退出"];
}
- (void)createFavorite{
    _parkingModel.isCollection = @"0";
    _shouCangImage.image = [UIImage imageNamed:@"starh"];
    BEGIN_MBPROGRESSHUD
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"2.0.0",@"version",nil];
    NSString *url = [NSString stringWithFormat:@"%@",queryCollection];
    [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
        [self loadUI];
        for (ManagerModel *model in array) {
            if ([model.searchTitle isEqualToString:_parkingModel.parkingName]) {
                _parkingModel.isCollection = @"1";
                _shouCangImage.image = [UIImage imageNamed:@"favoriteParking_select"];
            }
        }
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
    }];
}

#pragma mark -- 立即代泊
- (IBAction)daiBoBtnClick:(UIButton *)sender {
//    判断是否登录
    if([CUSTOMERMOBILE(visitorBOOL) integerValue] == 0){
        UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
            LoginViewController *login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }Fail:^{
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //    首先判断是否有手机号
    
    if (CUSTOMERMOBILE(customer_mobile).length == 0) {
        phoneView *phoneV = [[phoneView alloc]init];
        __weak typeof (phoneView *)weakPhoneV = phoneV;
        phoneV.nextVC = ^(){
            BEGIN_MBPROGRESSHUD
            [_chooseCarView getUserCarArrayWhenCompetion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    END_MBPROGRESSHUD
                    
                });
                
            } Failure:^{
                END_MBPROGRESSHUD
            }];
            [weakPhoneV hide];
        };
        [phoneV show];
        return;
    }

    
    if (_chooseCarView.dataArray.count>1) {
        __weak typeof(self)weakself = self;
        _chooseCarView.hidden = NO;
//        _chooseCarView.isHiddenGrayView = NO;
        _chooseCarView.grayView.hidden = NO;
        [_chooseCarView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(220);
            
            make.width.mas_equalTo(SCREEN_WIDTH-108);
            
            make.centerY.mas_equalTo(weakself.view);
            
            make.centerX.mas_equalTo(weakself.view);
            
        }];
        
        [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
            _chooseCarView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        } completion: nil];
        
        return;
        
    }else if (_chooseCarView.dataArray.count==1)
    {
//        CarModel *model = [[CarModel alloc] init];
//        
//        
//        NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
//        NSString *carNum = [use objectForKey:@"carNumber"];
//        model.carNumber = carNum;
        
        CarModel *model = [_chooseCarView.dataArray objectAtIndex:0];
        _carModel = model;
        
        [self showDaiBoDetailInfo:model];
        
        
    }else
    {
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未添加车辆,是否立即添加车辆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertV.tag = 2;
        [alertV show];
    }

    
}


#pragma mark -- 弹出代泊界面
- (void)showDaiBoDetailInfo:(CarModel *)carModel
{
    NSString *temStr = [NSString stringWithFormat:@"说明: %@",_parkingModel.parkPriceComment];
    _carDetailAlert = [[CarDetailAlert alloc] initWithInfo:temStr];
    
    if ([_parkingModel.rule isEqualToString:@"1"]) {
        _carDetailAlert.ruleType = RULETYPEONE;
    }else if ([_parkingModel.rule isEqualToString:@"2"]){
        _carDetailAlert.ruleType = RULETYPETWO;
        
    }
    _carDetailAlert.carModel = carModel;
    _carDetailAlert.delegate = self;
    ParkingModel *model = [[ParkingModel alloc] init];
    model.parkingId = _parkingId;
    model.parkingName = _parkName.text;
    _carDetailAlert.parkingModel = model;
    _carDetailAlert.infoL.text = temStr;
    [_carDetailAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            CarListViewController *carListVC = [[CarListViewController alloc]init];
            [self.navigationController pushViewController:carListVC animated:YES];
        }
    }
}
- (void)loadUI
{
    self.greenLable.hidden = YES;
    _chooseHomeView.hidden = YES;
    _chooseHomeView.layer.cornerRadius = 6;
    self.daiBoBtn.layer.cornerRadius = 6;
    _homeBtn.layer.cornerRadius = 4;
    _officBtn.layer.cornerRadius = 4;
    _grayView.hidden = YES;
    
}

#pragma mark -- 创建选择车辆view
- (void)creataChooseCarView
{
    if (!_chooseCarView) {
        _chooseCarView = [[selfAlertView alloc]init];
        _chooseCarView.grayView  =_grayView;
        _chooseCarView.isHiddenGrayView = YES;
        _chooseCarView.titleStr = @"选择您的车辆";
        _chooseCarView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        _chooseCarView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self)weakSelf = self;
        
        _chooseCarView.nextStep = ^(CarModel *model){
            MyLog(@"%@",model.carNumber);
            if (model == nil) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择车辆" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;
                return ;
            }
            _carModel = model;
            
            [weakSelf showDaiBoDetailInfo:model];
            
        };
        
        [self.view addSubview:_chooseCarView];
        _chooseCarView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        BEGIN_MBPROGRESSHUD
        [_chooseCarView getUserCarArrayWhenCompetion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD;
                
            });
            
        } Failure:^{
            END_MBPROGRESSHUD; 
        }];
    }
}

- (BOOL)compareTime:(NSString *)str withType:(NSString *)type
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;

    NSDate *date = [NSDate date];
    
    [inputFormatter setDateFormat:@"HH:mm"];
    
    NSString *temTime = [inputFormatter stringFromDate:date];
//    当前时间
    NSArray *currentTimeArr;
    if ([temTime rangeOfString:@":"].location != NSNotFound) {
        currentTimeArr = [temTime componentsSeparatedByString:@":"];
    }else if ([temTime rangeOfString:@"："].location != NSNotFound){
        currentTimeArr = [temTime componentsSeparatedByString:@"："];

    }
//    输入的时间
    NSMutableArray *temTimeArr;
    if ([str rangeOfString:@":"].location != NSNotFound) {
        temTimeArr = (NSMutableArray*)[str componentsSeparatedByString:@":"];
    }else if ([str rangeOfString:@"："].location != NSNotFound){
        temTimeArr = (NSMutableArray*)[str componentsSeparatedByString:@"："];
    }
    
    if (temTimeArr.count<2) {
        return NO;
    }
//    0:开始时间  1:结束时间
    if ([type isEqualToString:@"1"]) {
        
        NSArray *endTimeArr;
        if ([_parkingModel.parkBeginTime rangeOfString:@":"].location != NSNotFound) {
            endTimeArr = (NSMutableArray*)[_parkingModel.parkBeginTime componentsSeparatedByString:@":"];
        }else if ([_parkingModel.parkBeginTime rangeOfString:@"："].location != NSNotFound){
            endTimeArr = (NSMutableArray*)[_parkingModel.parkBeginTime componentsSeparatedByString:@"："];
        }
        
//        结束时间小于或等于开始时间
        if ([temTimeArr[0] integerValue]<=[endTimeArr[0] integerValue]) {
            NSString *endTime = [NSString stringWithFormat:@"%d",[temTimeArr[0] integerValue]+24];
            [temTimeArr replaceObjectAtIndex:0 withObject:endTime];
        }
    }
    
    if ([currentTimeArr[0] integerValue] >= [temTimeArr[0] integerValue]) {
        
        if ([currentTimeArr[1] integerValue] >= [temTimeArr[1] integerValue]) {
            return YES;
        }else
        {
            return NO;
        }
    }else
    {
        return NO;
    }
}

#pragma mark -- 获取停车场详情 完成赋值
- (void)loadData
{
   
    if ([_parkingModel.canUse isEqualToString:@"2"]) {
        if ([self compareTime:_parkingModel.parkBeginTime withType:@"0"] && ![self compareTime:_parkingModel.parkEndTime withType:@"1"]){
            //       满足代泊时间
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version", _parkingModel.parkingId,@"parkingId",nil];
            [self DaiBoReuqest:isCanPark WithDic:dic];
            
        }else
        {
            //        不满足代泊时间
            _daiBoBtn.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
            self.greenLable.hidden = NO;
            self.greenLable.text = @"当前未在该停车场服务时间内";
            _daiBoBtn.userInteractionEnabled = NO;
            
        }
        
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version", _parkingModel.parkingId,@"parkingId",nil];
    [self DaiBoReuqest:isCanPark WithDic:dic];
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       END_MBPROGRESSHUD
        _parkName.text = _parkingModel.parkingName ;
        
        _parkAddress.text = _parkingModel.parkingAddress;
        _linShiInfoL.text = [_parkingModel.peacetimePrice isEqualToString:@""] ? @"  ":_parkingModel.peacetimePrice;
        _youHuiInfoL.text = [_parkingModel.sharePriceComment isEqualToString:@""] ? @"  ":_parkingModel.sharePriceComment;
        _daiBoInfoL.text = [_parkingModel.maximumHour isEqualToString:@""] ? @"  ":_parkingModel.parkPriceComment;
       
        _shengYuCheWei.text = [NSString stringWithFormat:@"剩余车位: %@",_parkingModel.parkingCanUse];

        [_parkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",SERVER_ID,_parkingModel.parkingPath]] placeholderImage:[UIImage imageNamed:@"homeParkingBackimage"]];
        
        if ([_parkingModel.isCharge isEqualToString:@"0"]&&![_parkingModel.canUse isEqualToString:@"2"]) {
            self.parkingStyle = PARKINGSTYLENONE;
        }else if ([_parkingModel.isCharge isEqualToString:@"1"]&&![_parkingModel.canUse isEqualToString:@"2"]){
            self.parkingStyle = PARKINGSTYLECHONGDIAN;

        }else if ([_parkingModel.isCharge isEqualToString:@"0"]&&[_parkingModel.canUse isEqualToString:@"2"]){
            self.parkingStyle = PARKINGSTYLEDAIBO;
            
        }else
        {
            self.parkingStyle = PARKINGSTYLEDAIBOCHONGDIAN;
        }
//        if ([_parkingModel.isCollection isEqualToString:@"0"]) {
//            _shouCangImage.image = [UIImage imageNamed:@"starh"];
//        }else
//        {
//            _shouCangImage.image = [UIImage imageNamed:@"favoriteParking_select"];
//        }
        [self setHeight];
    }];
}

- (IBAction)shareBtnClick:(id)sender {
    
    [self shareViewAniamtionIn];
    
}
- (IBAction)grayViewTapGesture:(id)sender {
    
    [self shareViewAniamtionOut];
    [_chooseCarView removeView];
    _chooseHomeView.hidden = YES;
    
}

- (void)shareViewAniamtionIn
{
    [UIView animateWithDuration:0.3 animations:^{
        _shareViewBottom1.priority = 751;
        
        _shareViewBottom0.priority = 750;
        [self.view layoutIfNeeded];
        
        _grayView.hidden = NO;
    }];
}
- (void)shareViewAniamtionOut
{
    [UIView animateWithDuration:0.3 animations:^{
        _shareViewBottom1.priority = 750;
        
        _shareViewBottom0.priority = 751;
        [self.view layoutIfNeeded];
        
        _grayView.hidden = YES;
    }];
}


- (void)setHeight
{
    _infoViewHeight.constant = [self getStringHeightWithString:_linShiInfoL.text Font:15 MaxWitdth:SCREEN_WIDTH-89-28] + [self getStringHeightWithString:_youHuiInfoL.text Font:15 MaxWitdth:SCREEN_WIDTH-89-28] + [self getStringHeightWithString:_daiBoInfoL.text Font:18 MaxWitdth:SCREEN_WIDTH-89-28] + 20*3 + 26;
    
    _containtViewHeight.constant = _infoViewHeight.constant + 340;
    
    
}
- (CGFloat)getStringHeightWithString:(NSString *)string Font:(CGFloat )font MaxWitdth:(CGFloat )maxWidth
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
    
}

#pragma mark -- 设置家 收藏 导航
- (IBAction)setButtonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
             HomeArray *homeArray = [HomeArray shareHomeArray];
            if([CUSTOMERMOBILE(visitorBOOL) integerValue] == 0){
                //        未登录状态
                _chooseHomeView.hidden = YES;
                _grayView.hidden = YES;
                ParkingModel *model = [[ParkingModel alloc]init];
                model.parkingName = _parkingModel.parkingName;
                model.parkingId = _parkingModel.parkingId;
                model.parkingLatitude = _parkingModel.parkingLatitude;
                model.parkingLongitude = _parkingModel.parkingLongitude;
                model.parkingAddress = _parkingModel.parkingAddress;
                model.peacetimePrice = _parkingModel.peacetimePrice;
                model.canUse = _parkingModel.canUse;
                model.isCooperate = _parkingModel.isCooperate;
                [homeArray.dataArray replaceObjectAtIndex:0 withObject:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHomeModel" object:nil];

                ALERT_VIEW(@"设置成功");
                _alert = nil;
                return;
            }
           
            
            NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@%@",[MyUtil getCustomId],_parkingId,@(1),[MyUtil getVersion],MD5_SECRETKEY] MD5];
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",setDefaultScan,[MyUtil getCustomId],_parkingId,@(1),[MyUtil getVersion],summary];
             BEGIN_MBPROGRESSHUD;
            
            [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
                ParkingModel *model = [[ParkingModel alloc]init];
                model.parkingName = _parkingModel.parkingName;
                model.parkingId = _parkingModel.parkingId;
                model.parkingLatitude = _parkingModel.parkingLatitude;
                model.parkingLongitude = _parkingModel.parkingLongitude;
                model.parkingAddress = _parkingModel.parkingAddress;
                model.peacetimePrice = _parkingModel.peacetimePrice;
                model.canUse = _parkingModel.canUse;
                model.isCooperate = _parkingModel.isCooperate;
                [homeArray.dataArray replaceObjectAtIndex:0 withObject:model];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHomeModel" object:nil];

                 ALERT_VIEW(@"设置成功");
                 _alert = nil;
                END_MBPROGRESSHUD;
                
            } Fail:^(NSString *errror) {
                ALERT_VIEW(errror);
                _alert = nil;
                END_MBPROGRESSHUD;
            }];


        }
            break;
            
        case 1:
        {
//            收藏
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL visitorBool = [userDefaults boolForKey:@"visitorBOOL"];
            if (visitorBool == NO) {
                UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
                    LoginViewController *login = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }Fail:^{
                    
                }];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }else{
            
            BOOL isShouCang = [_parkingModel.isCollection isEqualToString:@"1"]? YES : NO;
            
            if (isShouCang) {
                 BEGIN_MBPROGRESSHUD;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",_parkingModel.parkingName,@"addressName",@"2.0.0",@"version",nil];
                NSString *url = [NSString stringWithFormat:@"%@",deleteCollection];
                [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
                    
                    _parkingModel.isCollection = @"0";
                    _shouCangImage.image = [UIImage imageNamed:@"starh"];
                   
                    END_MBPROGRESSHUD
                    
                } Fail:^(NSString *error) {
                    END_MBPROGRESSHUD
                }];

            }else
            {
                 BEGIN_MBPROGRESSHUD;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",_parkingModel.parkingName,@"addressName",_parkingModel.parkingAddress,@"address",_parkingModel.parkingLatitude,@"latitude",_parkingModel.parkingLongitude,@"longitude",@"2.0.0",@"version",nil];
                NSString *url = [NSString stringWithFormat:@"%@",saveCollection];
                [RequestModel requestCollectionWith:url WithDic:dic Completion:^(NSMutableArray *array) {
                    _parkingModel.isCollection = @"1";
                    _shouCangImage.image = [UIImage imageNamed:@"favoriteParking_select"];
                    ALERT_VIEW(@"收藏成功");
                    _alert = nil;
                    END_MBPROGRESSHUD
                    
                    
                    
                } Fail:^(NSString *error) {
                    END_MBPROGRESSHUD
                }];

          
            }
            
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectCarChange" object:nil];
            
            
        }
            break;
            
        case 2:
        {
//            导航
            
            
            if (self.tool.locationStatus == LocationStatusNoLocation) {
                [self alertUserAllowLocation];
                return;
            }
            
            _faySheet = [[faySheetVC alloc] init];
            CoordinateModel *coordinated = [CoordinateModel shareCoodinateModel];
            
            _faySheet.nowLatitude = coordinated.latitude;
            _faySheet.nowLongitude = coordinated.longitude;
            _faySheet.modelLatitude = _parkingModel.parkingLatitude;
            _faySheet.modelLongitude = _parkingModel.parkingLongitude;
            _faySheet.modelParkingName = _parkingModel.parkingName;
            [self.view addSubview:_faySheet.view];
            [self addChildViewController:_faySheet];
        }
            break;
            
//        case 3:
//        {
////            车管家
//            carMasterViewController *carStewardCtrl = [[carMasterViewController alloc]init];
//            
//            carStewardCtrl.parkingModel = _parkingModel;
//            [self.navigationController pushViewController:carStewardCtrl animated:YES];
//            
//        }
//            break;
            
        default:
            break;
    }
}
- (IBAction)backVC:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)thirdlyShare:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
//            微信好友
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.text = [NSString stringWithFormat:@"%@还有%@个停车位,赶紧下载<口袋停APP https://itunes.apple.com/cn/app/kou-dai-ting/id1049233050?mt=8>预约车位,让你从此停车不烦恼！",_parkingModel.parkingName,_parkingModel.parkingCanUse];
                req.bText = YES;
                req.scene = WXSceneSession; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
                [WXApi sendReq:req];
            }else{
                ALERT_VIEW( @"您未安装微信或版本不支持");
                _alert = nil;
            }
        }
            break;
            
        case 1:
        {
//            朋友圈
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.text = [NSString stringWithFormat:@"%@还有%@个停车位,赶紧下载<口袋停APP https://itunes.apple.com/cn/app/kou-dai-ting/id1049233050?mt=8>预约车位,让你从此停车不烦恼！",_parkingModel.parkingName,_parkingModel.parkingCanUse];
                req.bText = YES;
                req.scene = WXSceneTimeline; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
                [WXApi sendReq:req];
            }else{
                ALERT_VIEW( @"您未安装微信或版本不支持");
                _alert = nil;
            }
        }
            break;
            
        case 2:
        {
//            新浪微博
            if ([WeiboSDK isCanShareInWeiboAPP]) {
                //新浪分享
                WBMessageObject *message = [WBMessageObject message];
                message.text = [NSString stringWithFormat:@"%@还有%@个停车位,赶紧下载<口袋停APP https://itunes.apple.com/cn/app/kou-dai-ting/id1049233050?mt=8>预约车位,让你从此停车不烦恼！",_parkingModel.parkingName,_parkingModel.parkingCanUse];
                
                WBSendMessageToWeiboRequest *wbRequest = [WBSendMessageToWeiboRequest requestWithMessage:message];
                wbRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                [WeiboSDK sendRequest:wbRequest];
            }else{
                ALERT_VIEW( @"您未安装新浪微博或版本不支持");
                _alert = nil;
            }
        }
            break;
            
        default:
            break;
    }
    
    [self shareViewAniamtionOut];
    
}


- (void)setParkingStyle:(PARKINGSTYLE)parkingStyle
{
    _parkingStyle = parkingStyle;
    
    switch (parkingStyle) {
        case PARKINGSTYLENONE:
        {
            _chouDianL.hidden = YES;
            _daiBoL.hidden = YES;
            _view3.hidden = YES;
            _infoViewLayout1.priority = 750;
            _infoViewLayout2.priority = 800;
            
            if ([_parkingModel.isAutoPayOrder isEqualToString:@"0"]) {
                _autoPayL.hidden = YES;
            }else
            {
                _autoPayRight2.priority = 900;
                _autoPayRight0.priority = 800;
                _autoPayRight1.priority = 700;

            }
            
        }
            break;
            
        case PARKINGSTYLEDAIBO:
        {
            _chouDianL.hidden = YES;
            

            if ([_parkingModel.isAutoPayOrder isEqualToString:@"0"]) {
                _autoPayL.hidden = YES;
            }else
            {
                _autoPayRight0.priority = 800;
                _autoPayRight1.priority = 900;
            }
            
        }
            break;
            
        case PARKINGSTYLECHONGDIAN:
        {
            _chouDianL.hidden = YES;
            _daiBoL.text = @"充电车位";
            _daiBoL.backgroundColor = NEWMAIN_COLOR;
            _infoViewLayout1.priority = 750;
            _infoViewLayout2.priority = 800;
            _view3.hidden = YES;

            if ([_parkingModel.isAutoPayOrder isEqualToString:@"0"]) {
                _autoPayL.hidden = YES;
            }else
            {
                _autoPayRight0.priority = 800;
                _autoPayRight1.priority = 900;
            }

            
        }
            break;
            
        case PARKINGSTYLEDAIBOCHONGDIAN:
        {
            if ([_parkingModel.isAutoPayOrder isEqualToString:@"0"]) {
                _autoPayL.hidden = YES;
            }else
            {
                _autoPayRight0.priority = 900;
                _autoPayRight1.priority = 800;
            }
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark -- 弹框  查看订单
- (void)queryOrder
{
    NSString *summary = [[NSString stringWithFormat:@"%@%@",[MyUtil getCustomId],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",queryParkerById,[MyUtil getCustomId],summary];
    [RequestModel requestTemParkingOrderWithURL:url WithTag:@"parkerList" Completion:^(NSArray *resultArray) {
        
        _orderArray = resultArray;
        
        
    } Fail:^(NSString *error) {
        
    }];
    
    
}

#pragma mark -- chooseHomeParking相关
#pragma mark -- 设置家或者公司
- (IBAction)setHomeOrOffic:(UIButton *)sender {
    NSString *type;
    
    if(sender.tag == 0){
//        家
        type = @"1";
    }else{
//        公司
        type = @"2";
        
    }
    HomeArray *homeArray = [HomeArray shareHomeArray];

    if([CUSTOMERMOBILE(visitorBOOL) integerValue] == 0){
//        未登录状态
        _chooseHomeView.hidden = YES;
        _grayView.hidden = YES;
        [homeArray.dataArray replaceObjectAtIndex:sender.tag withObject:_parkingModel];
        ALERT_VIEW(@"设置成功");
        _alert = nil;
        return;
    }
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@%@",[MyUtil getCustomId],_parkingId,type,[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",setDefaultScan,[MyUtil getCustomId],_parkingId,type,[MyUtil getVersion],summary];
    
    [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
        
        NewParkingModel *temModel = [homeArray.dataArray objectAtIndex:1-sender.tag];
        if ([temModel.parkingId isEqualToString:_parkingModel.parkingId]) {
            NewParkingModel *temParkModel = [NewParkingModel new];
            [homeArray.dataArray replaceObjectAtIndex:1-sender.tag withObject:temParkModel];
            
        }
        [homeArray.dataArray replaceObjectAtIndex:sender.tag withObject:_parkingModel];
        ALERT_VIEW(dic[@"errorInfo"]);
        _alert = nil;
        
    } Fail:^(NSString *errror) {
        ALERT_VIEW(errror);
        _alert = nil;
    }];
    
    _chooseHomeView.hidden = YES;
    _grayView.hidden = YES;
    
}

- (IBAction)cancelBtnClick:(id)sender {
    _chooseHomeView.hidden = YES;
    _grayView.hidden = YES;
}



#pragma mark --- 立即代泊相关
/**
 *  判断是否有代泊员可以接单
 *
 targetParkingCanUseCount 关联的目标车场总的车位数
 parkServiceIsFull  代泊服务是否已满 0:未满 1:已满
 parkerCount 当班的代泊员数量
 */
- (void)DaiBoReuqest:(NSString *)url WithDic:(NSDictionary *)dic
{

    [RequestModel requestDaiBoWithURL:url
                              WithDic:dic Completion:^(NSDictionary *dic) {
                                  
                                  if ([dic[@"data"][@"parkerCount"] integerValue] > 0 && [dic[@"data"][@"targetParkingCanUseCount"] integerValue]>0 && [dic[@"data"][@"parkServiceIsFull"] integerValue]==0) {
//                                      满足代泊条件
                                      [self creataChooseCarView];
                                      
                                  }else
                                  {
//                                      不满足代泊条件
                                      _daiBoBtn.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
                                      if (_daiBoBtn.userInteractionEnabled) {
                                          self.greenLable.hidden = NO;
                                          self.greenLable.text = @"今日代泊服务已满";
                                          _daiBoBtn.userInteractionEnabled = NO;

                                      }
                                     
                                  }
                                  

                                  
                              } Fail:^(NSString *error) {
                                  
                                  
                              }];
    
}


#pragma mark --CarDetailAlertDelegate
- (void)dataPickerView:(NSString *)startTime hourString:(NSString *)endTime miunteString:(NSString *)carNum
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[MyUtil getVersion],@"version",carNum,@"carNumber",[MyUtil getCustomId],@"customerId",orderType,@"orderType",_parkingModel.parkingId,@"parkingId",startTime,@"startTime",endTime,@"endTime",@"0",@"isContinue", nil];
    _temDic = dataDic;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startDaiBoWithDic:_temDic];

    });
    
}

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
            for (UIViewController *vc in self.childViewControllers) {
                if ([vc isKindOfClass:[NewMapHomeVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
            }

        };
        
    }else
    {
        OtherStopAlert *successView = [[OtherStopAlert alloc] init];
//        successView.getCarTimeL.text = model.endTime;
        
        NSArray *temArrar = [model.endTime componentsSeparatedByString:@" "];
        
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
        successView.reckonMoneyL.text = [NSString stringWithFormat:@"%@元",model.price];
        __weak typeof(successView)weakSuccess = successView;
        [successView show];
        successView.tureBlock = ^()
        {
            TimeLineViewController *timeLineVC = [[TimeLineViewController alloc] init];
            timeLineVC.payType = 0;
            timeLineVC.carModel = _carModel;
            ParkingModel *model = [[ParkingModel alloc] init];
            model.parkingId = _parkingId;
            timeLineVC.parkingModel = model;
            [self.navigationController pushViewController:timeLineVC animated:YES];
//            requestTemParkingOrderWithURL
//            MainDaIBoVC *mainDaiBoVC = [[MainDaIBoVC alloc] init];
//            [self.navigationController pushViewController:mainDaiBoVC animated:YES];
            
        };
        
        successView.cancleBlock = ^()
        {
            [weakSuccess hide];
            
//            返回首页
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[NewMapHomeVC class]]) {
                    
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
            
            
        };
        
    }
    
    
    
}

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

- (LocationTool *)tool
{
    
    _tool = [LocationTool shareLocationTool];
    return _tool;
    
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
