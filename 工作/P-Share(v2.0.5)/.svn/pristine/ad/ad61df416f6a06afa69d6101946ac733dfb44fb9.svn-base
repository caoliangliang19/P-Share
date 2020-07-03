//
//  ClearCarVC.m
//  P-Share
//
//  Created by fay on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ClearCarVC.h"
#import "ChooseCheXing.h"
#import "MHDatePicker.h"
#import "UILabel+Block.h"
#import "ClearCarPay.h"
#import "WashCarOrderController.h"
#import "CarModel.h"
#import "CarListViewController.h"
#import "selfAlertView.h"
#import "SDImageCache.h"
@interface ClearCarVC ()
{
    UIView *_bgView;
    CarModel *_temCarModel;
    
    NSString *_carType;
    NSString *_srvFee1;
    NSString *_srvFee2;
    NSString *_nowPrice1;
    NSString *_nowPrice2;
    NSString *_srvPriceS1;
    NSString *_srvPriceS2;
    NSString *_reserveDate;
    UIAlertView *_alert;
    UIView *_subView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    selfAlertView *_selfView;
    
}
@property (strong, nonatomic) MHDatePicker *selectDatePicker;


@end

@implementation ClearCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self washCarRequest];
    [self dataHeadImage];
    
}
#pragma mark -
#pragma mark - 加载头像
- (void)dataHeadImage{
    self.parkerHead1.layer.cornerRadius = (SCREEN_WIDTH - 90)/3/2;
    self.parkerHead1.clipsToBounds = YES;
    self.parkerHead2.layer.cornerRadius = (SCREEN_WIDTH - 90)/3/2;
    self.parkerHead2.clipsToBounds = YES;
    self.parkerHead3.layer.cornerRadius = (SCREEN_WIDTH - 90)/3/2;
    self.parkerHead3.clipsToBounds = YES;
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@",self.parkingModel.parkingId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",queryImage,self.parkingModel.parkingId,summary];
     BEGIN_MBPROGRESSHUD;
    [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
        END_MBPROGRESSHUD;
        NSArray *array = dic[@"parkerList"];
        [self dataImageHead:array];
    } Fail:^(NSString *errror) {
        self.parkerHead2.hidden = NO;
        self.parkerHead1.hidden = NO;
        self.parkerHead3.hidden = NO;
        END_MBPROGRESSHUD;
//        ALERT_VIEW(errror);        
    }];
}
- (void)dataImageHead:(NSArray *)array{
   
   
    for (NSInteger i = 0; i < array.count; i++) {
        
    
//        __block UIImage *image = [[UIImage alloc] init];
//        //图片下载链接
//        NSURL *imageDownloadURL = [NSURL URLWithString:array[i][@"parkerHead"]];
//        
//        //将图片下载在异步线程进行
//        //创建异步线程执行队列
//        dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue", NULL);
//        //创建异步线程
//        dispatch_async(asynchronousQueue, ^{
//            //网络下载图片  NSData格式
//            NSError *error;
//            NSData *imageData = [NSData dataWithContentsOfURL:imageDownloadURL options:NSDataReadingMappedIfSafe error:&error];
//            if (imageData) {
//                image = [UIImage imageWithData:imageData];
//            }
//            //回到主线程更新UI
//            dispatch_async(dispatch_get_main_queue(), ^{
                if (array.count == 0) {
                    self.parkerHead2.hidden = NO;
                    self.parkerHead1.hidden = NO;
                    self.parkerHead3.hidden = NO;
                }
                if (array.count == 1) {
                    self.leftLayOut.constant = 30;
                    self.leftCenterLayOut.constant = 15;
                    self.rightCenterLayOut.constant = 15;
                    self.rightLayOut.constant = 30;
                    self.parkerHead2.hidden = NO;
                    self.parkerHead1.hidden = YES;
                    self.parkerHead3.hidden = YES;
                    if (i == 0) {
                        [self.parkerHead2 sd_setImageWithURL:[NSURL URLWithString:array[i][@"parkerHead"]] placeholderImage:[UIImage imageNamed:@"user"]];
                        self.parkName2.text = array[i][@"parkerName"];
                       
                    }
                }
                if (array.count == 2) {
                    self.leftLayOut.constant = 60;
                    self.leftCenterLayOut.constant = -15;
                    self.rightCenterLayOut.constant = -15;
                    self.rightLayOut.constant = 60;
                     self.parkerHead2.hidden = YES;
                    self.parkerHead1.hidden = NO;
                    self.parkerHead3.hidden = NO;
                    if (i == 0) {
                        [self.parkerHead1 sd_setImageWithURL:[NSURL URLWithString:array[i][@"parkerHead"]] placeholderImage:[UIImage imageNamed:@"user"]];
                        self.parkName1.text = array[i][@"parkerName"];
                    }
                    if (i == 1) {
                        [self.parkerHead3 sd_setImageWithURL:[NSURL URLWithString:array[i][@"parkerHead"]] placeholderImage:[UIImage imageNamed:@"user"]];
                        self.parkName3.text = array[i][@"parkerName"];
                    }
                   
                    
                }
                if (array.count >= 3) {
                    self.leftLayOut.constant = 30;
                    self.leftCenterLayOut.constant = 15;
                    self.rightCenterLayOut.constant = 15;
                    self.rightLayOut.constant = 30;
                    self.parkerHead2.hidden = NO;
                    self.parkerHead1.hidden = NO;
                    self.parkerHead3.hidden = NO;
                    if (i == 0) {
                    [self.parkerHead1 sd_setImageWithURL:[NSURL URLWithString:array[i][@"parkerHead"]] placeholderImage:[UIImage imageNamed:@"user"]];
                    self.parkName1.text = array[0][@"parkerName"];
                }
                    if (i == 1) {
                    [self.parkerHead2 sd_setImageWithURL:[NSURL URLWithString:array[i][@"parkerHead"]] placeholderImage:[UIImage imageNamed:@"user"]];
                    self.parkName2.text = array[1][@"parkerName"];
                }
                    if (i == 2) {
                    [self.parkerHead3 sd_setImageWithURL:[NSURL URLWithString:array[i][@"parkerHead"]] placeholderImage:[UIImage imageNamed:@"user"]];
                    self.parkName3.text = array[2][@"parkerName"];
                }
                }
//            });
//        });
    }
    
}
- (void)loadUI
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        _bgView.hidden = YES;
        [self.view addSubview:_bgView];
    }
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  SCREEN_HEIGHT - 70, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
    
    _subView = [[UIView alloc]initWithFrame:self.view.frame];
    _subView.alpha = .4;
    _subView.backgroundColor = [UIColor blackColor];
    _subView.hidden = YES;
    _selfView = [[selfAlertView alloc]init];
    _selfView.grayView  =_bgView;
    _selfView.titleStr = @"选择您的车辆";
    _selfView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    _selfView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakself = self;
    [self.view addSubview:_selfView];
    [_selfView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(220);
        
        make.width.mas_equalTo(SCREEN_WIDTH-108);
        
        make.centerY.mas_equalTo(weakself.view);
        
        make.centerX.mas_equalTo(weakself.view);
        
    }];
    _selfView.nextStep = ^(CarModel *model){
        MyLog(@"%@",model.carNumber);
        
        if (model == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择车辆" delegate:weakself cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            return ;
        }
       
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
   

    self.navigationController.navigationBarHidden = YES;
    
    
    
}
- (void)washCarRequest{
    
    [self loadUI:self.dict];

}
- (void)loadUI:(NSDictionary *)dict
{
    _payBtn.layer.cornerRadius = 6;
    NSArray *array = dict[@"srvList"];
    
    if (array.count < 2) {
        return;
    }
    
    self.infoL.text = array[0][@"intro"];
    self.serverInfoL.text = array[0][@"description"];
    
    if (array.count == 1) {
            NSDictionary *dic = array[0];
            if ([dic[@"carType"] integerValue] == 1) {
                
                self.shoufei1.text = [NSString stringWithFormat:@"轿车:    服务费  %@  元,现价%@元",dic[@"srvFee"],dic[@"nowPrice"]];
                _srvFee1 = [NSString stringWithFormat:@"%@",dic[@"srvFee"]];
                _nowPrice1 = [NSString stringWithFormat:@"%@",dic[@"nowPrice"]];
                _srvPriceS1 = [NSString stringWithFormat:@"%@",dic[@"srvPrice"]];
               
            }else{
               self.shoufei1.text = [NSString stringWithFormat:@"商务车:服务费  %@  元,现价%@元",dic[@"srvFee"],dic[@"nowPrice"]];
                _srvFee2 = [NSString stringWithFormat:@"%@",dic[@"srvFee"]];
                _nowPrice2 = [NSString stringWithFormat:@"%@",dic[@"nowPrice"]];
                _srvPriceS2 = [NSString stringWithFormat:@"%@",dic[@"srvPrice"]];
                
            }
        self.srvPrice1.text = [NSString stringWithFormat:@"服务价格 %@元 ",dic[@"srvPrice"]];
        
        
       self.srvPrice2.hidden = YES;
        self.shoufei2.hidden = YES;
    }else{
        NSDictionary *dic1 = array[0];
        NSDictionary *dic2 = array[1];
        self.srvPrice2.hidden = NO;
        self.shoufei2.hidden = NO;
        if ([dic1[@"carType"] integerValue] == 1) {
            
            self.shoufei1.text = [NSString stringWithFormat:@"轿车:    服务费  %@  元,现价%@元",dic1[@"srvFee"],dic1[@"nowPrice"]];
            _srvFee1 = [NSString stringWithFormat:@"%@",dic1[@"srvFee"]];
            _nowPrice1 = [NSString stringWithFormat:@"%@",dic1[@"nowPrice"]];
            _srvPriceS1 = [NSString stringWithFormat:@"%@",dic1[@"srvPrice"]];
            
        }else{
            self.shoufei1.text = [NSString stringWithFormat:@"商务车:服务费  %@  元,现价%@元",dic1[@"srvFee"],dic1[@"nowPrice"]];
            _srvFee2 = [NSString stringWithFormat:@"%@",dic1[@"srvFee"]];
            _nowPrice2 = [NSString stringWithFormat:@"%@",dic1[@"nowPrice"]];
            _srvPriceS2 = [NSString stringWithFormat:@"%@",dic1[@"srvPrice"]];
            
        }
       self.srvPrice1.text = [NSString stringWithFormat:@"服务价格%@元",dic1[@"srvPrice"]];
       
        if ([dic2[@"carType"] integerValue] == 1) {
            
            self.shoufei2.text = [NSString stringWithFormat:@"轿车:    服务费  %@  元,现价%@元",dic2[@"srvFee"],dic2[@"nowPrice"]];
            _srvFee1 = [NSString stringWithFormat:@"%@",dic2[@"srvFee"]];
            _nowPrice1 = [NSString stringWithFormat:@"%@",dic2[@"nowPrice"]];
            _srvPriceS1 = [NSString stringWithFormat:@"%@",dic2[@"srvPrice"]];
            
        }else{
            self.shoufei2.text = [NSString stringWithFormat:@"商务车:服务费  %@  元,现价%@元",dic2[@"srvFee"],dic2[@"nowPrice"]];
            _srvFee2 = [NSString stringWithFormat:@"%@",dic2[@"srvFee"]];
            _nowPrice2 = [NSString stringWithFormat:@"%@",dic2[@"nowPrice"]];
            _srvPriceS2 = [NSString stringWithFormat:@"%@",dic2[@"srvPrice"]];
        }
        self.srvPrice2.text = [NSString stringWithFormat:@"服务价格%@元",dic2[@"srvPrice"]];
        
    }
    
    _jianJieHeight.constant = [self getHeightWithString:_infoL.text withFont:13]+48;
    
    _serverInfoViewHeight.constant = [self getHeightWithString:_serverInfoL.text withFont:13] + 40;
    [_shoufei1 showDeleteLine:[UIColor redColor]];
    if (_shoufei1.text.length != 0) {
        [_shoufei1 label_AttributedString:_shoufei1.text attributedMode:@[PZAttributedModeToValue(PZAttributedMake(NSStrikethroughStyleAttributeName, @(NSUnderlinePatternSolid | NSUnderlineStyleSingle), [_shoufei1.text rangeOfString:[NSString stringWithFormat:@"%@",array[0][@"srvFee"]]]))]];

    }
    if (_shoufei2.text.length != 0) {
        [_shoufei2 label_AttributedString:_shoufei2.text attributedMode:@[PZAttributedModeToValue(PZAttributedMake(NSStrikethroughStyleAttributeName, @(NSUnderlinePatternSolid | NSUnderlineStyleSingle), [_shoufei2.text rangeOfString:[NSString stringWithFormat:@"%@",array[1][@"srvFee"]]]))]];
    }
    

    _containtViewHeight.constant =_jianJieHeight.constant+ _serverInfoViewHeight.constant+380;
    
    

}
- (IBAction)payOrder:(UIButton *)sender {
    
    ChooseCheXing *chooseVC = [[ChooseCheXing alloc]initWithController:self];
    __weak ChooseCheXing *weakChooseVC = chooseVC;
    
    chooseVC.carNumT.text = self.carNumber;
    chooseVC.chooseCarBlock = ^(){
        CarListViewController *CarList = [[CarListViewController alloc]init];
//        CarList.pushType = @"WashCar";
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

#pragma mark -- 选择车型









- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)getHeightWithString:(NSString *)string withFont:(CGFloat )size
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-28, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    return rect.size.height;
    
}



- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)washCarBtn:(id)sender {
    WashCarOrderController *washCar = [[WashCarOrderController alloc]init];
    [self.navigationController pushViewController:washCar animated:YES];
}
@end
