//
//  MapParkingListVC.m
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "MapParkingListVC.h"
#import "MapParkingCell.h"
#import "MyPointAnnotation.h"
#import "UIImageView+WebCache.h"
#import "ParkingModel.h"
#import "NewParkingdetailVC.h"
#import "YuYueTingCheVC.h"
#import "ShareTemParkingViewController.h"
#import "CarListViewController.h"
#import "selfAlertView.h"
#import "faySheetVC.h"
#import "NewYuYueTingChe.h"

#define kRandomColor  [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];

@interface MapParkingListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NewParkingdetailVC *_detailCtrl;
    selfAlertView *_selfView;
    faySheetVC *_faySheet;
    NSMutableArray *_colorArray;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}
@property (nonatomic,strong)phoneView *phoneV;

@property (nonatomic,assign)BOOL visitorBool;

@end

@implementation MapParkingListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCarView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _visitorBool = [userDefaults boolForKey:@"visitorBOOL"];
    
    [_tableV registerNib:[UINib nibWithNibName:@"MapParkingCell" bundle:nil] forCellReuseIdentifier:@"MapParkingCell"];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _colorArray = [NSMutableArray arrayWithObjects:[MyUtil colorWithHexString:@"8957a1"],[MyUtil colorWithHexString:@"00b7ee"],[MyUtil colorWithHexString:@"39d5b8"],[MyUtil colorWithHexString:@"fac539"],[MyUtil colorWithHexString:@"39d5b8"], nil];
    _grayView.hidden = YES;
    
    
}

- (void)loadCarView
{
    
    if (!_selfView) {
        _selfView = [[selfAlertView alloc]init];
    }
    _selfView.titleStr = @"选择您的车辆";
    _selfView.hidden = YES;
    _grayView.hidden = YES;
    _selfView.grayView = _grayView;
    
    _selfView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    
    _selfView.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self)weakSelf = self;
    
    [self.view addSubview:_selfView];
    _selfView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [_selfView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(220);
        
        make.width.mas_equalTo(SCREEN_WIDTH-108);
        
        make.centerY.mas_equalTo(weakSelf.view);
        
        make.centerX.mas_equalTo(weakSelf.view);
        
    }];
    BEGIN_MBPROGRESSHUD
    [_selfView getUserCarArrayWhenCompetion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            END_MBPROGRESSHUD;
        });
        
    } Failure:^{
         END_MBPROGRESSHUD;
    }];
}
#pragma mark -
#pragma mark - 监听键盘
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BEGIN_MBPROGRESSHUD
    [_selfView getUserCarArrayWhenCompetion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            END_MBPROGRESSHUD; 
        });
    } Failure:^{
         END_MBPROGRESSHUD;
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_phoneV removeFromSuperview];
    _phoneV = nil;
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    __weak typeof(self) weakSelf = self;
    
    NSInteger offectY;
    if (SCREEN_WIDTH == 320) {
        offectY = -120;
    }else
    {
        offectY = -60;
        
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
        [_phoneV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.view).offset(offectY);
            
        }];
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    __weak typeof(self) weakSelf = self;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
        [_phoneV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.view);
            
        }];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapParkingCell"];
    
    MyPointAnnotation *pointModel = [_dataArray objectAtIndex:indexPath.row];
    
    [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:pointModel.parkPath] placeholderImage:[UIImage imageNamed:@"aboutUSImage"]];
    cell.parkingName.text = pointModel.parkingName;
    cell.distanceL.text = [NSString stringWithFormat:@"%@米",pointModel.parkDistance];
    
    int colorNum = arc4random()%4;
    
    cell.colorImageV.backgroundColor = [_colorArray objectAtIndex:colorNum];
    
    cell.pinShiL.text = [NSString stringWithFormat:@"平时时段：%@",pointModel.peacetimeprice];
    NSString *str = [NSString stringWithFormat:@"%@",pointModel.isCooperate];
    
    if ([str isEqualToString:@"1"]) {
        cell.shareL.text = @"优惠时段:  口袋停暂未合作,请直接自驾前往";
    }else
    {
        if ([pointModel.startTime integerValue] == 0) {
            pointModel.startTime = @" ";
        }
        if ([pointModel.stopTime integerValue] == 0) {
            pointModel.stopTime = @" ";
        }
        if ([pointModel.shareprice integerValue] == 0) {
            pointModel.shareprice = @" ";
        }
        if ([pointModel.startTime integerValue] == 0&&[pointModel.stopTime integerValue] == 0&&[pointModel.shareprice integerValue] == 0) {
            cell.shareL.text = [NSString stringWithFormat:@"优惠时段:"];
        }else{
        cell.shareL.text = [NSString stringWithFormat:@"优惠时段：%@-%@,%@元/次",pointModel.startTime,pointModel.stopTime,pointModel.shareprice];
        }
    }
    
    if ([pointModel.isCooperate intValue] != 1) {
        [cell.daoHangBtn setTitle:@"去停车" forState:UIControlStateNormal];
    }else{
        [cell.daoHangBtn setTitle:@"导航" forState:UIControlStateNormal];
    }

    __block ParkingModel *parkingModel = [_parkingArray objectAtIndex:indexPath.row];
    
    
    __weak typeof(self)weakSelf = self;
    
    cell.daoHangBlock = ^(){
        
        if ([parkingModel.isCooperate intValue] == 1) {
//            导航
            [self myAnnotationTapForNavigationWithParkingModel:parkingModel];
            
        }else
        {
            if (weakSelf.visitorBool == NO) {
                UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
                    LoginViewController *login = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }Fail:^{
                    
                }];
                [self presentViewController:alert animated:YES completion:nil];
                
                return ;
                
            }
            
            if (CUSTOMERMOBILE(customer_mobile).length == 0) {
                UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
                view.alpha = .4;
                view.backgroundColor = [UIColor blackColor];
                [self.view addSubview:view];
                
                phoneView *phoneView = [MyUtil addPhoneViewFor:weakSelf Name:CUSTOMERMOBILE(customer_nickname)];
                weakSelf.phoneV = phoneView;
                 phoneView.cancelView = ^()
                {
                    [view removeFromSuperview];
                    [weakSelf.phoneV removeFromSuperview];
                    
                };
                phoneView.nextVC = ^()
                {
                    [_selfView getUserCarArrayWhenCompetion:^{
                        
                    } Failure:^{
                        
                    }];
                    
                };
                
                
                return;
            }
//            去停车
            if (_selfView.dataArray.count == 1) {
                
                [weakSelf quTingCheWith:_selfView.dataArray[0] With:parkingModel];
                
            }else if (_selfView.dataArray.count>1){
                
                [self showCarNumViewWithParkingModel:parkingModel];
                
            }else
            {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未添加车辆,是否立即添加车辆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertV.tag = 2;
                [alertV show];
            }
        }
    };
    
    return cell;
   
}

#pragma mark --- 调出导航
- (void)myAnnotationTapForNavigationWithParkingModel:(ParkingModel *)parkingModel
{
    
    _faySheet = [[faySheetVC alloc] init];
    _faySheet.nowLatitude = _nowLatitude;
    _faySheet.nowLongitude = _nowLongitude;
    _faySheet.modelLatitude = parkingModel.parkingLatitude;
    _faySheet.modelLongitude = parkingModel.parkingLongitude;
    _faySheet.modelParkingName = parkingModel.parkingName;
    [self.view addSubview:_faySheet.view];
    [self addChildViewController:_faySheet];
}

#pragma mark -- 展示自定义view
- (void)showCarNumViewWithParkingModel:(ParkingModel *)parkingModel
{
   
    __weak typeof(self)wekSelf = self;
    _selfView.hidden = NO;
    _grayView.hidden = NO;
    [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
        
        _selfView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion: nil];
    
        _selfView.nextStep = ^(CarModel *model){
           
        [wekSelf quTingCheWith:model With:parkingModel];
        
    };

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

- (void)quTingCheWith:(CarModel *)carModel With:(ParkingModel *)parkingModel
{
    if (parkingModel.parkingCanUse == 0) {
        [self alertController];
        return;
    }

//    YuYueTingCheVC *yuYueTingCheVC = [[YuYueTingCheVC alloc] init];
//    yuYueTingCheVC.carModel = carModel;
//    yuYueTingCheVC.carArray = _carArray;
//    yuYueTingCheVC.parkingModel = parkingModel;
//    yuYueTingCheVC.nowLatitude = self.nowLatitude;
//    yuYueTingCheVC.nowLongitude = self.nowLongitude;
//    [self.navigationController pushViewController:yuYueTingCheVC animated:YES];
    MyPointAnnotation *annotationModel = [[MyPointAnnotation alloc]init];
    annotationModel.parkingId = parkingModel.parkingId;
    annotationModel.parkingLatitude = parkingModel.parkingLatitude;
    annotationModel.parkingLongitude = parkingModel.parkingLongitude;
    
    NewYuYueTingChe *tingCheVC = [[NewYuYueTingChe alloc] init];
    tingCheVC.annotationMode = annotationModel;
    tingCheVC.carModel = carModel;
    tingCheVC.nowLatitude = self.nowLatitude;
    tingCheVC.nowLongitude = self.nowLongitude;
    [self.navigationController pushViewController:tingCheVC animated:YES];
}
#pragma mark － 弹框出现
- (void)alertController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该停车场车位已满,请前往其他车场,您也可以呼叫车管家为您服务" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (CGFloat)getHeightWithStr:(NSString *)str WithFont:(CGFloat)font
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPointAnnotation *pointModel = [_dataArray objectAtIndex:indexPath.row];
    NSString *str = [NSString stringWithFormat:@"平时时段：%@",pointModel.peacetimeprice];;
    
    if ([self getHeightWithStr:str WithFont:12]>14.5) {
        
        return 72+14.5;
        
    }
    
    return 72;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
   
    
    ParkingModel *model = [_parkingArray objectAtIndex:indexPath.row];
    _detailCtrl = [[NewParkingdetailVC alloc] init];
    _detailCtrl.parkingId = model.parkingId;
    [self.navigationController pushViewController:_detailCtrl animated:YES];

//    _detailCtrl = [[ParkingDetailViewController alloc] init];
//
//    _detailCtrl.parkingModel = model;
//    _detailCtrl.nowLatitude = _nowLatitude;
//    _detailCtrl.nowongitude = _nowLongitude;
//    [self.navigationController pushViewController:_detailCtrl animated:YES];

}

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
