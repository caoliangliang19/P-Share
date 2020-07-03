//
//  NewMonthlyRentSearchVC.m
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewMonthlyRentSearchVC.h"
#import "NewMonthlyRentLogoCell.h"
#import "NewMonthlyRentSearchCell.h"
#import "NewParkingModel.h"
#import "NewMonthlyRentPayVC.h"
#import "UIImageView+WebCache.h"
#import "CarListViewController.h"
#import "MonthRentOrderController.h"
#import "QYSDK.h"

@interface NewMonthlyRentSearchVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSUserDefaults *_user;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_dataDic;
    
    __weak phoneView *_phoneV;
    UIView *_subView;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}

@end

@implementation NewMonthlyRentSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ALLOC_MBPROGRESSHUD
    
    
    if ([_orderType isEqualToString:@"13"]) {
        _titleL.text = @"月租查询";
        
    }else
    {
        _titleL.text = @"产权查询";
        
    }

    [_tableV registerNib:[UINib nibWithNibName:@"NewMonthlyRentLogoCell" bundle:nil] forCellReuseIdentifier:@"NewMonthlyRentLogoCell"];
    [_tableV registerNib:[UINib nibWithNibName:@"NewMonthlyRentSearchCell" bundle:nil] forCellReuseIdentifier:@"NewMonthlyRentSearchCell"];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _dataArray = [NSMutableArray array];
    
    _user = [NSUserDefaults standardUserDefaults];
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 70, 70, 70, 70);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
    
    _subView = [[UIView alloc]initWithFrame:self.view.frame];
    _subView.alpha = .4;
    _subView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_subView];
    _subView.hidden = YES;
    
}


- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:YES];
    if ([_orderType isEqualToString:@"13"]) {
       
        [MobClick beginLogPageView:@"月租列表进入"];
    }else
    {
       
        [MobClick beginLogPageView:@"产权列表进入"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMonthlyData:) name:@"monthlyLoadDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMonthlyData:) name:@"PaySuccess" object:nil];
    [self loadMonthlyData:nil];
    
    
    OrderPointModel *orderPoint = [OrderPointModel shareOrderPoint];

    if ([_orderType isEqualToString:@"13"]) {
        if (orderPoint.monthly>0) {
            [MyUtil addBadgeWithView:_dingDanL WithNum:orderPoint.monthly];

        }else
        {
            [_dingDanL clearBadge];
        }
        
        
    }else
    {
        if (orderPoint.equity>0) {
            [MyUtil addBadgeWithView:_dingDanL WithNum:orderPoint.monthly];
        }else
        {
            [_dingDanL clearBadge];
        }
        
    }

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_orderType isEqualToString:@"13"]) {
        
        [MobClick beginLogPageView:@"月租列表退出"];
    }else
    {
        
        [MobClick beginLogPageView:@"产权列表退出"];
    }
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)loadMonthlyData:(NSNotification *)notification
{
    BEGIN_MBPROGRESSHUD
    
    [RequestModel getCarListWithURL:CARLIST WithDic:self.orderType Completion:^(NSMutableDictionary *resultDic) {
        
        _dataDic = resultDic;
        
        _dataArray = resultDic[@"parkingList"];
        
        if (_dataArray.count == 0){
            
            if (![notification.object isEqualToString:@"notification"]) {
                ALERT_VIEW(@"未查询到您的车辆账单,请去停车管理处咨询办理");
                _alert = nil;
            }
        }
        
        [_tableV reloadData];
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        
        if ([error isEqualToString:@"连接服务器失败"]) {
            
            ALERT_VIEW(error);
            _alert = nil;
            END_MBPROGRESSHUD
            return ;
            
        }
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertV.tag = 2;
        [alertV show];
        alertV = nil;
        END_MBPROGRESSHUD
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde{
    
    if (alertView.tag == 2) {
        if (buttonInde == 1) {
            CarListViewController *carVC = [[CarListViewController alloc]init];
            [self.navigationController pushViewController:carVC animated:YES];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_dataArray.count == 0) {
        return 1;
    }else
    {
        return _dataArray.count + 1;

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NewMonthlyRentLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMonthlyRentLogoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *imageArr;
        if (!imageArr) {
            imageArr = _dataDic[@"cooperation"];
            
        }
        
        for (int i=0 ; i<imageArr.count; i++) {
            UIImageView *imgV = (UIImageView *)[cell valueForKey:[NSString stringWithFormat:@"logo%d",i]];
            [imgV sd_setImageWithURL:[NSURL URLWithString:imageArr[i]]];
        }

        return cell;
    }
    NewMonthlyRentSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMonthlyRentSearchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NewParkingModel *model = [_dataArray objectAtIndex:indexPath.row - 1];

    cell.parkingNameL.text = model.parkingName;
    [cell.carNumBtn setTitle:model.carNumber forState:(UIControlStateNormal)];
    cell.endTime.text = [NSString stringWithFormat:@"到期时间：%@",[[model.endDate componentsSeparatedByString:@" "] firstObject]];
    
    
    cell.postParameter = ^(UIButton *btn){
        
        if (model.mobile.length != 11) {
            ALERT_VIEW(@"你在停车管理处预留的手机号不正确，请去办理");
            _alert = nil;
            return ;
        }
        if (model.endDate.length<4) {
            ALERT_VIEW(@"数据发生异常");
            _alert = nil;
            return ;
        }
        if (CUSTOMERMOBILE(customer_mobile).length == 0) {
            phoneView *phoneV = [[phoneView alloc]init];
            __weak typeof (phoneView *)weakPhoneV = phoneV;
            phoneV.nextVC = ^(){
                NewMonthlyRentPayVC *monthlyPayVC = [[NewMonthlyRentPayVC alloc] init];
                monthlyPayVC.model = model;
                monthlyPayVC.orderType = _orderType;
                
                [self.navigationController pushViewController:monthlyPayVC animated:YES];
                [weakPhoneV hide];
            };
            [phoneV show];
            return;
        }
        NewMonthlyRentPayVC *monthlyPayVC = [[NewMonthlyRentPayVC alloc] init];
        monthlyPayVC.model = model;
        monthlyPayVC.orderType = _orderType;
        
        [self.navigationController pushViewController:monthlyPayVC animated:YES];
        
    };

    return cell;
    
    
    
}
#pragma mark - 
#pragma mark - 第三方登录
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}







   


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row != 0) {
//        NewParkingModel *model = [_dataArray objectAtIndex:indexPath.row - 1];
//        
//        if (model.mobile.length != 11) {
//            ALERT_VIEW(@"");
//            
//        }
//
//        NewMonthlyRentPayVC *monthlyPayVC = [[NewMonthlyRentPayVC alloc] init];
//        
//        monthlyPayVC.model = model;
//        monthlyPayVC.orderType = _orderType;
//        
//        [self.navigationController pushViewController:monthlyPayVC animated:YES];
//        
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 207;
    }
    return 130;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backbtnClick:(UIButton *)sender {
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

- (IBAction)monthlyRentOrder:(id)sender {
    MonthRentOrderController *month = [[MonthRentOrderController alloc]init];
    month.orderType = self.orderType;
    [self.navigationController pushViewController:month animated:YES];
}



@end
