//
//  WalletVC.m
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "WalletVC.h"
#import "MindPingZhengVC.h"
#import "walletView.h"
#import "UserHomeCell.h"
#import "DiscountViewController.h"
#import "subLabel.h"
#import "MoneyBaoController.h"
#import "PurseTopUpController.h"
#import "WalletSettingVC.h"
#import "UIImageView+WebCache.h"

@interface WalletVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_imageArr;
    NSArray *_titleArray;
    NSUserDefaults *_userDefaults;
    float _money;
    walletView *_walletView;
    NSArray *_ruleArr;
    UIAlertView *_alert;
    UIView *_clearBackView;
    MBProgressHUD *_mbView;
}

@end

@implementation WalletVC

- (void)viewDidLoad {
    [super viewDidLoad];

    ALLOC_MBPROGRESSHUD;
    
    [self loadData];
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  70, 60, 60);
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoney) name:@"refreshWalletMoney" object:nil];
    
    [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)refreshMoney
{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [_userDefaults objectForKey:customer_id];
    NSString *summary = [[NSString stringWithFormat:@"%@%@",userID,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",getMoney,userID,summary];

    BEGIN_MBPROGRESSHUD
    [RequestModel requestWalletMoneyWithURL:url Completion:^(NSString *money) {
        
        _money = [money floatValue];
        [_walletView.moneyL animationFromnum:0.00 toNum:_money duration:1];
        
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        ALERT_VIEW(NETWORKINGERROE);
        _alert = nil;
        END_MBPROGRESSHUD
        
    }];

}
- (void)loadData
{
    [self refreshMoney];
    
    BEGIN_MBPROGRESSHUD

    [RequestModel requestWalletRuleWithURL:[NSString stringWithFormat:@"%@/%@",getRule,[MD5_SECRETKEY MD5]] Completion:^(NSArray *resultArray) {
        
        _ruleArr = resultArray;
        [_tableview reloadData];
        
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        
        END_MBPROGRESSHUD
        
    }];
    
    
    if (![_userDefaults objectForKey:remindCoupon]) {
        
        NSString *summary = [NSString stringWithFormat:@"%@%@",[_userDefaults objectForKey:customer_id],MD5_SECRETKEY];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",getCouponNum,[_userDefaults objectForKey:customer_id],[summary MD5]];
        [RequestModel requestRemindCouponWithURL:urlStr Completion:^(NSDictionary *dic) {
            NSString *tem = [dic[@"num"] integerValue] < 1 ? @"0" : @"1";
            
            [_userDefaults setObject:tem forKey:remindCoupon];
            [_tableview reloadData];
            [_userDefaults synchronize];
        }];
        
    }

    _titleArray = [NSArray arrayWithObjects:@"我的优惠券",@"我的停车凭证", nil];
    _imageArr = [NSArray arrayWithObjects:@"userHome11",@"certificate", nil];
    
    _tableview.tableFooterView = [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREEN_WIDTH * 0.92;
}




- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _walletView = [[NSBundle mainBundle] loadNibNamed:@"walletView" owner:nil options:nil][0];
    
    _walletView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.92);
    
    [_walletView.moneyL animationFromnum:0.00 toNum:_money duration:1];
    
    _walletView.descributeL.marqueeType = MLContinuous;
    _walletView.descributeL.animationCurve = UIViewAnimationCurveLinear;
    _walletView.descributeL.continuousMarqueeExtraBuffer = 50.0f;
    _walletView.descributeL.opaque = NO;
    _walletView.descributeL.enabled = YES;
    _walletView.descributeL.shadowOffset = CGSizeMake(0.0, -1.0);
    _walletView.descributeL.textAlignment = NSTextAlignmentLeft;
    
    [_walletView.payBtn addTarget:self action:@selector(chongZhi) forControlEvents:(UIControlEventTouchUpInside)];
    [_walletView.setBtn addTarget:self action:@selector(walletSetVC) forControlEvents:(UIControlEventTouchUpInside)];
  
    if (_ruleArr.count>0) {
        NSMutableString *ruleStr = [[NSMutableString alloc] init];
        
        
        for (int i=0; i<_ruleArr.count-1; i++) {
            [ruleStr appendString:_ruleArr[i]];
        }
        [_walletView.ruleImageV sd_setImageWithURL:[NSURL URLWithString:[_ruleArr lastObject]] placeholderImage:[UIImage imageNamed:@""]];
        _walletView.descributeL.text = ruleStr;
    }
    
    
    return _walletView;
    
}
#pragma mark -- 进入钱包设置界面
- (void)walletSetVC
{
    WalletSettingVC *walletSettingVC = [[WalletSettingVC alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    MyLog(@"%@",[user objectForKey:pay_password]);
    
    if ([[user objectForKey:pay_password] isEqualToString:@"0"]) {
        walletSettingVC.titleStr = @"设置支付密码";
    }else
    {
        walletSettingVC.titleStr = @"重置支付密码";

    }
    [self.navigationController pushViewController:walletSettingVC animated:YES];
}
#pragma mark -- 点击充值按钮
- (void)chongZhi
{
    PurseTopUpController *purseVC = [[PurseTopUpController
                                      alloc] init];
    [self.navigationController pushViewController:purseVC animated:YES];
    
}
- (IBAction)showRecord:(id)sender {
    MoneyBaoController *recordVC = [[MoneyBaoController
                                     alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *cellId = @"userHomeCellId";
    UserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserHomeCell" owner:self options:nil]lastObject];
    }
    
    cell.leftImageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    
    cell.userTitleLabe.text = [_titleArray objectAtIndex:indexPath.row];
 
    _couponRedPoint = [_userDefaults boolForKey:@"couponRedPoint"];
    
    if (indexPath.row == 0 && _couponRedPoint) {
        
        cell.pointV.hidden = NO;
    
    }else
    {
        cell.pointV.hidden = YES;
    }

    
    return cell;
    

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    switch (indexPath.row) {
        case 0:
        {
            DiscountViewController *discountCtrl = [[DiscountViewController alloc] init];
            [self.navigationController pushViewController:discountCtrl animated:YES];
        }
            break;
            
        case 1:
        {
            MindPingZhengVC *mindPingZhengVC = [[MindPingZhengVC alloc] init];
            [self.navigationController pushViewController:mindPingZhengVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backVC:(id)sender {
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
