//
//  carMasterViewController.m
//  P-Share
//
//  Created by fay on 16/2/1.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "carMasterViewController.h"
#import "CollectionViewCell.h"
#import "imageCell.h"
#import "UIImageView+WebCache.h"
#import "ImageModel.h"
#import "CallAlertView.h"
#import "UIImageView+WebCache.h"
#import "DCWebImageManager.h"
#import "DCPicScrollView.h"
#import "WebViewController.h"
#import "CarMasterDescribeModel.h"
#import "ServerInfoModel.h"
#import "LoginViewController.h"
#import "OilCardModel.h"
#import "OilCardHuaController.h"
#import "CarErrorDriveController.h"
#import "ServerInfoModel.h"
#import "ZuCheVC.h"
#import "ClearCarVC.h"

@interface carMasterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
{
    UIPageControl *_pageCotrol;
    UIAlertView *_alert;
    CallAlertView *_callV;
    UIWebView *_webView;
    UIScrollView *_bgView;
    UIButton *_cancelBtn;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _visitorBool;
    
    NSArray *_imageDataArr;
    NSArray *_describeArr;
    NSUserDefaults *_userDefaults;
    
     __weak phoneView *_phoneV;
}

@end

@implementation carMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _visitorBool = [_userDefaults boolForKey:@"visitorBOOL"];
    [self createNetWark];
    [self setUI];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadData];

    });
    

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
}
#pragma mark -
#pragma mark - 首页请求代码
- (void)createNetWark{
    //气泡中的内容
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.parkingModel.parkingId,@"parkingId",@"2.0.0",@"version", nil];
    NSString *url = [NSString stringWithFormat:@"%@",getParkingStatus];
    [RequestModel requestGetParkingStatusWith:url WithDic:dict Completion:^(ParkingModel *model) {
        
    } Fail:^(NSString *error) {
        
    }];
   
}

- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
   
    
}



- (void)loadData
{
    if (!_describeArr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BEGIN_MBPROGRESSHUD;
        });
        NSString *url = [NSString stringWithFormat:@"%@/%@",List,[MD5_SECRETKEY MD5]];
        
        [RequestModel requestCarMasterServerDescribeWithUrl:url Completion:^(NSArray *resultArr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD
                _describeArr = resultArr;
                [_bgCollectionView reloadData];
            });
           
            
        }];
        
       

        
    }
    
    if (!_imageDataArr) {
        [RequestModel requestCarMasterLunBoImageWithURL:nil Completion:^(NSArray *resultArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD;
                _imageDataArr = resultArray;
                [self loadUpCollection];
            });
            
           
            
            
        } Fail:^(NSString *fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                END_MBPROGRESSHUD;

                ALERT_VIEW(fail);
                _alert = nil;
            });
            
        }];
        
    }
    
}

- (void)setUI
{
    ALLOC_MBPROGRESSHUD
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-2)/3, (SCREEN_WIDTH-2)/3);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    

    _bgCollectionView.collectionViewLayout = flowLayout;
    
    _bgCollectionView.delegate = self;
    _bgCollectionView.dataSource = self;
    _bgCollectionView.showsVerticalScrollIndicator = YES;
//    _bgCollectionView.backgroundColor = [UIColor redColor];
    _bgCollectionView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    _bgCollectionView.contentInset = UIEdgeInsetsMake(140, 0, 0, 0);
    [_bgCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    _callV = [[NSBundle mainBundle] loadNibNamed:@"CallAlertView" owner:nil options:nil][0];
    
    [_callV.cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:(UIControlEventTouchUpInside)];
    

    _callV.userInteractionEnabled = YES;
    
    if (SCREEN_WIDTH == 320) {
        _callV.frame = CGRectMake(40, 10, SCREEN_WIDTH - 80, 460);
        
    }else
    {
        _callV.frame = CGRectMake(40, 60, SCREEN_WIDTH - 80, 460);
        
    }
    __weak typeof(self)weakSelf = self;
    
    _callV.callServer = ^()
    {
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:4000062637"]]];
        [weakSelf.view addSubview:callWebview];
        
        weakSelf.upScrollView.hidden = YES;
        weakSelf.grayView.hidden = YES;
        //    _callV.hidden = YES;
    };
    
    
    _grayView.hidden = YES;
    [_contentView addSubview:_callV];
    _upScrollView.hidden = YES;
    _upScrollView.showsHorizontalScrollIndicator = NO;
    _upScrollView.showsVerticalScrollIndicator = NO;
    
    
}
- (void)cancelView
{
    
    _grayView.hidden = YES;
    _callV.hidden = YES;
    _upScrollView.hidden = YES;
   
}

- (void)loadUpCollection
{
    //网络加载
    
    NSMutableArray *UrlStringArray = [NSMutableArray array];
    
    
    for (int i=0; i<_imageDataArr.count-1; i++) {
        ImageModel *model = [_imageDataArr objectAtIndex:i];
        [UrlStringArray addObject:model.imagePath];
        
    }
    
    //显示顺序和数组顺序一致
    //设置图片url数组,和滚动视图位置
    
    DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, -140, SCREEN_WIDTH, 116) WithImageUrls:UrlStringArray];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //显示顺序和数组顺序一致
    //设置标题显示文本数组
    
//    if (SCREEN_WIDTH >= 414) {
//        
//        picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, 414, 130) WithImageUrls:UrlStringArray];
//    }
    
    if (SCREEN_WIDTH == 320) {
        picView.PageControl.center = CGPointMake(SCREEN_WIDTH/2, 95 );
        
    }
    
    picView.currentPageIndicatorTintColor = NEWMAIN_COLOR;
    picView.pageIndicatorTintColor = [UIColor whiteColor];
    //占位图片,你可以在下载图片失败处修改占位图片
    
    picView.placeImage = [UIImage imageNamed:@"banner.png"];
    
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
        
        ImageModel *model = [_imageDataArr objectAtIndex:index];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.url = model.imageLink;
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }];
    
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 5.0f;
    //    picView.textColor = [UIColor redColor];
    
    [_bgCollectionView addSubview:picView];
    
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        MyLog(@"%@",error);
    }];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
  
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _describeArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    CarMasterDescribeModel *model = [_describeArr objectAtIndex:indexPath.item];
    
    if (model.srvName.length<1) {
        ImageModel *imageModel = [_imageDataArr lastObject];
        cell.infoL.text = nil;
        cell.nameL.text = nil;
        cell.headImg = nil;
        
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[imageModel.imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"carMaster.jpg"]];
        
    }else
    {
        cell.infoL.text = model.intro;
        cell.nameL.text = model.srvName;
        cell.bgImageView = nil;
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.logoPath] placeholderImage:[UIImage imageNamed:@"newservice"]];
        
        
        
        if ([model.flag isEqualToString:@"1"]) {
            
            
            cell.biaoQianV.image = [UIImage imageNamed:@"new"];
                    
            
        }else if ([model.flag isEqualToString:@"2"]){
            
            
            cell.biaoQianV.image = [UIImage imageNamed:@"hot"];
                    
            
        }else
        {
            cell.biaoQianV = nil;
        }

    }

//    cell.headImg.frame = CGRectMake(0, 0,cell.headImg.image.size.width, cell.headImg.image.size.height);
    
    
    

    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    CarMasterDescribeModel *model = [_describeArr objectAtIndex:indexPath.item];

    switch ([model.srvId intValue]) {
        case 1:
        {
            
            if (_visitorBool == NO) {
                UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
                    LoginViewController *login = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }Fail:^{
                    
                }];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            if (CUSTOMERMOBILE(customer_mobile).length == 0) {
                UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
                view.alpha = .4;
                view.backgroundColor = [UIColor blackColor];
                [self.view addSubview:view];
                
                _phoneV = [MyUtil addPhoneViewFor:self Name:CUSTOMERMOBILE(customer_nickname)];
                
                
                
               
                return;
            }
            
            
            
                //            违章查询
                CarErrorDriveController *errorDrive = [[CarErrorDriveController alloc]init];
                [self.navigationController pushViewController:errorDrive animated:YES];
                return;
            
            
        }
            break;
            
        case 2:
        {
            if (_visitorBool == NO) {
                UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
                    LoginViewController *login = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }Fail:^{
                    
                }];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
               
                
                if (CUSTOMERMOBILE(customer_mobile).length == 0) {
                    phoneView *phoneV = [[phoneView alloc]init];
                    __weak typeof (phoneView *)weakPhoneV = phoneV;
                    phoneV.nextVC = ^(){
                        [weakPhoneV hide];
                    };
                    [phoneV show];
                    
                    return;
                }
                //            加油卡充值
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                NSString *userId = [userDefaultes objectForKey:customer_id];
                BEGIN_MBPROGRESSHUD;
                [RequestModel requestAddOilCardListWithURL:userId WithType:nil Completion:^(NSMutableArray * array) {
                   END_MBPROGRESSHUD;
                    if (array.count == 0) {
                        OilCardHuaController *oilCard = [[OilCardHuaController alloc]init];
                        oilCard.signString = @"1";//第一次进去
                        [self.navigationController pushViewController:oilCard animated:YES];
                    }else{
                        OilCardModel *model = array[0];
                        
                        OilCardHuaController *oilCard = [[OilCardHuaController alloc]init];
                        oilCard.model = model;
                        oilCard.signString = @"2";//第二次等后面进去
                        [self.navigationController pushViewController:oilCard animated:YES];
                        
                    }
                    
                } Fail:^(NSString *error) {
                    END_MBPROGRESSHUD;
                }];
                
                return;
            }
        }
            break;
       
        case -1:
        {
            //            车管家
            ImageModel *carMasterModel = [_imageDataArr objectAtIndex:_imageDataArr.count-1];
            
            WebViewController *webVC = [[WebViewController alloc] init];
            
            webVC.url = carMasterModel.imageLink;
            
            [self.navigationController pushViewController:webVC animated:YES];
            
            return;
            
        }
        case 7:
        {
            
            ZuCheVC *zuCheVC = [[ZuCheVC alloc] init];
            [self.navigationController pushViewController:zuCheVC animated:YES];
            
        }
            break;
        case 3:
        {
            if (_visitorBool == NO) {
                UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
                    LoginViewController *login = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }Fail:^{
                    
                }];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                
                NSString *summary = [[NSString stringWithFormat:@"%@%@",self.parkingModel.parkingId,MD5_SECRETKEY] MD5];
                NSString *url = [NSString stringWithFormat:@"%@/%@/%@",queryCharge,self.parkingModel.parkingId,summary];
                BEGIN_MBPROGRESSHUD;
                [RequestModel requestGetQueryChargeWithURL:url Completion:^(NSDictionary *dict) {
                    NSArray *array = dict[@"srvList"];
                    END_MBPROGRESSHUD;
                    if (array.count == 2) {
                        if (CUSTOMERMOBILE(customer_mobile).length == 0) {
                            phoneView *phoneV = [[phoneView alloc]init];
                            __weak typeof (self)wealSelf = self;
                            __weak typeof (phoneView *)weakPhoneV = phoneV;
                            phoneV.nextVC = ^(){
                                ClearCarVC *clearCar = [[ClearCarVC alloc]init];
                                clearCar.parkingModel = wealSelf.parkingModel;
                                clearCar.dict = dict;
                                [self.navigationController pushViewController:clearCar animated:YES];
                                [weakPhoneV hide];
                            };
                            [phoneV show];
                            
                            
                            
                            return;
                        }

                        
                        ClearCarVC *clearCar = [[ClearCarVC alloc]init];
                        clearCar.parkingModel = self.parkingModel;
                        clearCar.dict = dict;
                        [self.navigationController pushViewController:clearCar animated:YES];
                    }else{
                        ALERT_VIEW(@"此停车场暂未开通,敬请期待");
                        _alert = nil;
                    }
                    
                } Fail:^(NSString *error) {
                    ALERT_VIEW(@"此停车场暂未开通,敬请期待");
                    _alert = nil;
                    END_MBPROGRESSHUD;
                }];
              
            }
        }
           break;
        default:
            
           
                //            汽车打蜡
                BEGIN_MBPROGRESSHUD;
                [RequestModel requestCarMasterServerInfoWithParkingID:_parkingModel.parkingId ServerID:model.srvId Completion:^(ServerInfoModel *serverInfoModel) {
                    END_MBPROGRESSHUD;
                    [self refreshCallVWith:serverInfoModel];
                } Fail:^(NSString *errorMsg) {
                    END_MBPROGRESSHUD;
                    ALERT_VIEW(errorMsg);
                    _alert = nil;
                }];
            

            break;
    }

    
}


#pragma mark -- 设置——callV
- (void)refreshCallVWith:(ServerInfoModel *)serverInfoModel
{
    _callV.messageAlertL.text = serverInfoModel.intro;
    _callV.shouFeeL.text = serverInfoModel.srvBilling[0];
    if (serverInfoModel.srvBilling.count > 1) {
        _callV.shouFeeL.text = [NSString stringWithFormat:@"%@\n%@",serverInfoModel.srvBilling[0],serverInfoModel.srvBilling[1]];
    }
    _callV.shouFeeLabelHeight.constant = [self HeightWithString:_callV.shouFeeL.text];
    _upScrollView.hidden = NO;
    _callV.hidden = NO;
    _grayView.hidden = NO;
    
}
            
#pragma mark --根据字符串计算高度
- (CGFloat)HeightWithString:(NSString *)str

{
        CGRect rect = [str boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
            
        return rect.size.height;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
