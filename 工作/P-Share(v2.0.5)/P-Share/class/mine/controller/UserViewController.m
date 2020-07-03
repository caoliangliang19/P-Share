//
//  UserViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoViewController.h"
#import "UserHomeCell.h"
#import "QRCodeGenerator.h"
#import "CarListViewController.h"
#import "HomeListViewController.h"
#import "SetViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "DiscountViewController.h"
#import "HistoryViewController.h"
#import "WalletVC.h"
#import "WebViewController.h"
#import "LBXScanWrapper.h"
#import "AllOrderController.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL _visitorBool;
    NSUserDefaults *_userDefaults;
    
    __weak phoneView *_phoneV;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];

    _userTableView.tableFooterView = [[UIView alloc] init];

    _VipImage.hidden = YES;

    
    
    NSString *identityStr = [_userDefaults objectForKey:identity];
    
    if ([identityStr isEqualToString:@"1"]) {
        _VipImage.hidden = NO;

    }
 
    self.userTableView.scrollEnabled = YES;
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setImage:[UIImage imageNamed:@"Newcustomerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
    
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
      [MobClick event:@"SelfCentreID"];

    [_bgScrollView setContentOffset:CGPointMake(0, 0)];
    [_userTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]  withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.navigationController.navigationBarHidden = YES;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:customer_mobile];
    NSString *userId = [userDefault objectForKey:customer_id];
    NSString *codeString = [NSString stringWithFormat:@"customer:%@ %@",userId,phoneNume];
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
    if([MyUtil getCustomId].length <= 0){
        _userNameLabel.text = @"游客";
        self.quickMarkImageView.image = [UIImage imageNamed:@""];
        self.myMark.hidden = YES;
        self.markLine.hidden = YES;
        self.userNumLabel.text = @"登录账号";
        self.userHeaderImageView.image = [UIImage imageNamed:@"userHomeHeader"];
    }else{
    UIImage *image = [QRCodeGenerator qrImageForString:codeString imageSize:self.quickMarkImageView.bounds.size.width];
        self.quickMarkImageView.image = [LBXScanWrapper addImageLogo:image centerLogoImage:[UIImage imageNamed:@"aboutUSImage"] logoSize:CGSizeMake(30, 30)];
        self.myMark.hidden = NO;
        self.markLine.hidden = NO;
        //设置用户基本信息
        NSString *userName = [userDefault objectForKey:customer_nickname];
        if (userName.length != 0) {
            self.userNameLabel.text = userName;
        }else{
            self.userNameLabel.text = @"未设置";
        }
        self.userNumLabel.text = [NSString stringWithFormat:@"登录账号:%@",phoneNume];
        //    imageString:网络头像的URL
        NSString *imageString = [userDefault objectForKey:customer_head];
        if (imageString.length > 5) {
            [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"userHomeHeader"]];
        }
    
    }
  
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人中心退出"];
}


#pragma mark UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if(section == 1){
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"userHomeCellId";
    UserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserHomeCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"userHome%ld",indexPath.row + 1]];
        if (indexPath.row == 0) {
            cell.userTitleLabe.text = @"我的收藏";
        }else if (indexPath.row == 1){
            cell.userTitleLabe.text = @"我的订单";
        }
        else if (indexPath.row == 2){
            cell.userTitleLabe.text = @"车辆管理";
        }else if (indexPath.row == 3){
            cell.userTitleLabe.text = @"停车记录";
        }
        cell.subTitle.text = @"";
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.userTitleLabe.text = @"我的钱包";
            _couponRedPoint = [_userDefaults boolForKey:@"couponRedPoint"];
            if (_couponRedPoint) {
                [MyUtil addBadgeWithView:cell.userTitleLabe WithNum:0];
            }else
            {
                [cell.userTitleLabe clearBadge];
            }
            
            cell.subTitle.text = @"优惠券、凭证";
            cell.leftImageView.image = [UIImage imageNamed:@"wallet_g"];
        }else if(indexPath.row == 1){
            cell.userTitleLabe.text = @"推荐有礼";
            cell.leftImageView.image = [UIImage imageNamed:@"wallet_g1"];
        }
        
    }else if (indexPath.section == 2){
        cell.userTitleLabe.text = @"设置";
        cell.leftImageView.image = [UIImage imageNamed:@"userHome21"];
        cell.subTitle.text = @"";
    }
    
    cell.pointV.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.userTableView deselectRowAtIndexPath:indexPath animated:YES];
    if([MyUtil getCustomId].length <= 0) {
        UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
            LoginViewController *login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }Fail:^{
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
     if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HomeListViewController *homeListCtrl = [[HomeListViewController alloc] init];
            [self.navigationController pushViewController:homeListCtrl animated:YES];
             
        }else if (indexPath.row == 1){
            AllOrderController *allOrder = [[AllOrderController alloc] init];
            [self.navigationController pushViewController:allOrder animated:YES];
        }else if (indexPath.row == 2){
            CarListViewController *carListCtrl = [[CarListViewController alloc] init];
            carListCtrl.goInType = GoInControllerTypeNumber;
            [self.navigationController pushViewController:carListCtrl animated:YES];
        }else if (indexPath.row == 3){
            HistoryViewController *historyCtrl = [[HistoryViewController alloc] init];
            [self.navigationController pushViewController:historyCtrl animated:YES];
        }
    }else if (indexPath.section == 1) {
        
        
        if (CUSTOMERMOBILE(customer_mobile).length == 0) {
            phoneView *phoneV = [[phoneView alloc]init];
            __weak typeof (phoneView *)weakPhoneV = phoneV;
            phoneV.nextVC = ^(){
                if (indexPath.row == 0) {
                    WalletVC *walletVC = [[WalletVC alloc]init];
                    [self.navigationController pushViewController:walletVC animated:YES];
                }else if (indexPath.row == 1){
                    WebViewController *webView = [[WebViewController alloc] init];
                    webView.type = WebViewControllerTypeUnNeedShare;
                    webView.titleStr = @"推荐有礼";
                    webView.url = [NSString stringWithFormat:@"http://%@/share/other/html5/share.html#%@",SERVER_ID,[_userDefaults objectForKey:customer_id]];
                    
                    [self.navigationController pushViewController:webView animated:YES];
                    
                }
                [weakPhoneV hide];
            };
            [phoneV show];
            return;
            
        }
        if (indexPath.row == 0) {
            WalletVC *walletVC = [[WalletVC alloc]init];
            [self.navigationController pushViewController:walletVC animated:YES];
        }else if (indexPath.row == 1){
            WebViewController *webView = [[WebViewController alloc] init];
            webView.type = WebViewControllerTypeUnNeedShare;
            webView.titleStr = @"推荐有礼";
            webView.url = [NSString stringWithFormat:@"http://%@/share/other/html5/share.html#%@",SERVER_ID,[_userDefaults objectForKey:customer_id]];

            [self.navigationController pushViewController:webView animated:YES];
        }


        
       
    }else if (indexPath.section == 2) {
        SetViewController *setCtrl = [[SetViewController alloc] init];
        [self.navigationController pushViewController:setCtrl animated:YES];
    }
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
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

#pragma mark -- 编辑个人资料
- (IBAction)setUserInfoBtnClick:(id)sender {
   if([MyUtil getCustomId].length <= 0) {
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
                    
                    UserInfoViewController *userInfoCtrl = [[UserInfoViewController alloc] init];
                    [self.navigationController pushViewController:userInfoCtrl animated:YES];
                  
                    [weakPhoneV hide];
                };
                [phoneV show];
                return;
    }
    UserInfoViewController *userInfoCtrl = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfoCtrl animated:YES];
    }
}
@end




