//
//  CarLifeVC.m
//  P-SHARE
//
//  Created by fay on 16/10/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CarLifeVC.h"
#import "CarLifeView.h"
#import "SelectParkController.h"
#import "DiscountActController.h"
#import "UseCarFeelController.h"
#import "WebViewController.h"
#import "CarLiftModel.h"
#import "WeChatController.h"
@interface CarLifeVC ()<selectParkingDelegate>
{
    UIAlertView *_alert;
}
@property (nonatomic,strong)CarLifeView *carLifeView;
@property (nonatomic,strong)NewCarModel *carModel;
@property (nonatomic,strong)ParkingModel *parkingModel;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic,strong)HomeArray *aHomeArray;;

@end

@implementation CarLifeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCarLifeView];
    _aHomeArray = [HomeArray shareHomeArray];
    self.carModel = [DataSource shareInstance].carModel;
    self.parkingModel = [DataSource shareInstance].model;
    [ [DataSource shareInstance] addObserver:self forKeyPath:@"carModel" options:NSKeyValueObservingOptionNew context:nil];
    [ [DataSource shareInstance] addObserver:self forKeyPath:@"model" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExit) name:KUserExit object:nil];


}

- (void)dealloc
{
    [[DataSource shareInstance] removeObserver:self forKeyPath:@"carModel"];
    [[DataSource shareInstance] removeObserver:self forKeyPath:@"model"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)userExit
{
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"carModel"]) {
        self.carModel =[DataSource shareInstance].carModel;
        
    }else if([keyPath isEqualToString:@"model"]){
        self.parkingModel = [DataSource shareInstance].model;
    }
}
- (void)setParkingModel:(ParkingModel *)parkingModel
{
    _parkingModel = parkingModel;
    if(![MyUtil isBlankString:parkingModel.parkingId]){
        self.titleL.text = parkingModel.parkingName;
    }else
    {
        self.titleL.text = @"社区服务";
    }
    
}
- (void)setCarModel:(NewCarModel *)carModel
{
    _carModel = carModel;
    
    self.carLifeView.carModel = carModel;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.carLifeView.collectionView setContentOffset:CGPointMake(0, 0)];

    if ([MyUtil getCustomId].length <= 0)
    {
        [DataSource shareInstance].carModel = nil;
        
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![MyUtil isBlankString:[userDefault objectForKey:KCarLiftModelID]]) {
        ParkingModel *aModel = [[ParkingModel alloc] init];
        aModel.parkingId = [userDefault objectForKey:KCarLiftModelID];
        aModel.parkingName = [userDefault objectForKey:KCarLiftModelName];
        [DataSource shareInstance].model = aModel;
        self.carLifeView.parkModel = aModel;
        
    }else
    {
        ParkingModel *homeModel = _aHomeArray.dataArray[0];
        if ([MyUtil isBlankString:homeModel.parkingId]) {
            //            没有设置家停车场
            [DataSource shareInstance].model = homeModel;
            self.carLifeView.parkModel = homeModel;
            
        }else
        {
            ParkingModel *temModel = [DataSource shareInstance].model;
            if ([MyUtil isBlankString:temModel.parkingId]) {
                //                单例model为空
                [DataSource shareInstance].model = homeModel;
                self.carLifeView.parkModel = homeModel;
                
            }else
            {
                self.carLifeView.parkModel = temModel;
            }
        }
        
        
    }
    
    if ([MyUtil getCustomId].length <= 0)
    {
        [DataSource shareInstance].carModel = nil;
        
    }

    self.navigationController.navigationBarHidden = YES;

}
- (void)loadCarLifeView
{
    if (!_carLifeView) {
        _carLifeView = [CarLifeView instaceCarLifeView];
        [self.view addSubview:_carLifeView];
        [_carLifeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(64);
            make.bottom.mas_equalTo(0);
        }];
        
    }
        
    
    __weak typeof(self)ws = self;
    //    前往微信社群
    _carLifeView.weChatAssociateBlock = ^(CarLifeView *carLiftView)
    {
        if ([MyUtil isBlankString:carLiftView.parkModel.parkingId]) {
            [ws alertShouldAddCarLiftPark];
            
            return ;
        }
        
        [ws getMapViewWeChat2Dbarcode:carLiftView.parkModel];
        
    };
    
    __weak typeof (self)weakself = self;
   
    _carLifeView.carLifeBlock = ^(NSInteger index,NSMutableArray *array,ParkingModel *model){
        
        
        if (index == 0) {
            DiscountActController *select = [[DiscountActController alloc]init];
            select.model = model;
            [weakself.navigationController pushViewController:select animated:YES];
        }else if (index == 1){
            UseCarFeelController *select = [[UseCarFeelController alloc]init];
            select.model = model;
            [weakself.navigationController pushViewController:select animated:YES];
        }
    };
    
    _carLifeView.showActivityDetail = ^(CarLiftModel *model )
    {
        
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.type = WebViewControllerTypeNeedShare;
        webVC.titleStr = model.title;
        webVC.url = model.url;
        webVC.imagePath = model.imagePath;
        [weakself.navigationController pushViewController:webVC animated:YES];
    };
    
    _carLifeView.carMasterBlock = ^(CarLifeView *carLiftView)
    {
        QYSessionViewController *sessionVC = [[QYSDK sharedSDK] sessionViewController];
        sessionVC.sessionTitle = @"口袋停客服";
        
        sessionVC.groupId = [[DataSource shareInstance].qiyuId intValue];
        
        QYCustomUIConfig *custom = [[QYSDK sharedSDK] customUIConfig];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *imageString = [userDefaults objectForKey:customer_head];
        UIImageView *temImgV = [[UIImageView alloc] init];
        [temImgV sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultHeaderImage"]];
        custom.customerHeadImage = temImgV.image;
        custom.serviceHeadImage = [UIImage imageNamed:@"logoPshare"];
        [weakself.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        sessionVC.navigationItem.hidesBackButton = YES;
        custom.rightBarButtonItemColorBlackOrWhite = NO;
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(5, 34, 35, 40);
        [btn setImage:[UIImage imageNamed:@"defaultBack"] forState:UIControlStateNormal];
        [btn addTarget:weakself action:@selector(goBackAction)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];[btn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 20)];sessionVC.navigationItem.leftBarButtonItem=back;
        QYUserInfo *user = [[QYUserInfo alloc] init];
        user.userId = [MyUtil getCustomId];
        [[QYSDK sharedSDK] setUserInfo:user];
        [weakself.navigationController pushViewController:sessionVC animated:YES];
        weakself.navigationController.navigationBarHidden = NO;
    };
    
}
- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
- (void)getMapViewWeChat2Dbarcode:(ParkingModel *)model
{
    
    [_carLifeView hubShow];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model.parkingId,@"parkingId",@"2.0.2",@"version", nil];
    [RequestModel requestPostInvoiceInfoWithURL:getCarlovQRCode WithDic:mutableDic Completion:^(NSDictionary *dic) {
        [_carLifeView hubHiden];
        
        if([dic[@"errorNum"] isEqualToString:@"0"]) {
            
            WeChatController *weChatView = [[WeChatController alloc] init];
            [self.navigationController pushViewController:weChatView animated:YES];
            
        }else{
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
        }
        
    } Fail:^(NSString *errror) {
        
        ALERT_VIEW(errror);
        _alert = nil;
        [_carLifeView hubHiden];
    }];
}
- (void)refreshParking{
    if (_carLifeView) {
        _carLifeView.parkModel = [DataSource shareInstance].model;
    }
    
    
}
- (IBAction)gotoChangeParking {
    
    SelectParkController *select = [[SelectParkController alloc]init];
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
