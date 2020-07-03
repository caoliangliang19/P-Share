//
//  UserCenterController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/11.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "UserCenterController.h"
#import "UserCenterCell.h"
#import "LBXScanWrapper.h"
#import "SetViewController.h"
#import "AllOrderVC.h"
#import "PurseViewController.h"
#import "CarListVC.h"
#import "PersonSaveController.h"
#import "CollectionController.h"
#import "StopCarHistoryController.h"

@interface UserCenterController ()
<
    UITableViewDelegate ,
    UITableViewDataSource
>

@property (nonatomic , strong)UITableView *userTableView;

@end

@implementation UserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
    
    
}
- (UITableView *)userTableView{
    if (_userTableView == nil) {
        _userTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _userTableView.tableFooterView = [self createFootView];
    }
    return _userTableView;
}

- (void)createUI{
     self.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = nil;
}
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.userTableView];
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selector) name:LOGIN_SUCCESS object:nil];
}
- (void)selector{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.userTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    self.userTableView.tableFooterView = [self createFootView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UserCenterCell *cell =  [UserCenterCell installCellTableView:tableView];
    [cell setStyleCellIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3){
        return 0;
    }
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UtilTool isBlankString:[UtilTool getCustomId]]) {
        [UtilTool creatAlertController:self title:@"提示" describute:@"使用该功能需要登录帐号,是否去登录？" sureClick:^{
            LoginVC *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.rt_navigationController pushViewController:login animated:YES];
        } cancelClick:^{
            
        }];
        
        return ;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        PersonSaveController *person = [[PersonSaveController alloc] init];
        [self.rt_navigationController pushViewController:person animated:YES complete:nil];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        CollectionController *collect = [[CollectionController alloc] init];
        [self.rt_navigationController pushViewController:collect animated:YES complete:nil];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        AllOrderVC *allOrder = [[AllOrderVC alloc] init];
        allOrder.type = DisfferentVCTypeOrder;
        [self.rt_navigationController pushViewController:allOrder animated:YES complete:nil];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        CarListVC *carListVC = [[CarListVC alloc] init];
        carListVC.viewVC = @"UserCenterController";
        [self.rt_navigationController pushViewController:carListVC animated:YES complete:nil];
    }else if (indexPath.section == 1 && indexPath.row == 3) {
        StopCarHistoryController *stopCar = [[StopCarHistoryController alloc] init];
        stopCar.type = DisfferentVCTypeStop;
        [self.rt_navigationController pushViewController:stopCar animated:YES complete:nil];
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        PurseViewController *purse = [[PurseViewController alloc]init];
        [self.rt_navigationController pushViewController:purse animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        WebInfoModel *model = [WebInfoModel new];
        model.urlType            = URLTypeNet;
        model.shareType = WebInfoModelTypeShare;
        model.title = @"推荐有礼";
       //https://wxtest.i-ubo.com/share/other/html5/share.html
        model.url = [NSString stringWithFormat:@"%@other/html5/share.html#%@",SERVER_URL,[UtilTool getCustomId]];
        
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webModel = model;
        [self.rt_navigationController pushViewController:webView animated:YES];
    }else if (indexPath.section == 3 && indexPath.row == 0) {
        SetViewController *set = [[SetViewController alloc]init];
        [self.rt_navigationController pushViewController:set animated:YES];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)createFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    
    UILabel *footHeadL = [UtilTool createLabelFrame:CGRectZero title:@"我的二维码" textColor:[UIColor colorWithHexString:@"9c9c9c"] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    [footView addSubview:footHeadL];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"cecece"];
    [footView addSubview:lineView];
    
    UIImageView *codeImageView = [[UIImageView alloc] init];
   [footView addSubview:codeImageView];
    UIImage *image = nil;
    if ([UtilTool isBlankString:[UtilTool getCustomId]]) {
        image = nil;
    }else{
        NSString *codeString = [NSString stringWithFormat:@"customer:%@ %@",[UtilTool getCustomId],[self getCustomerInfo:@"customerMobile"]];
        image = [LBXScanWrapper createQRWithString:codeString QRSize:CGSizeMake(124, 124) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    }
      codeImageView.image = image;
    [footHeadL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footHeadL.mas_bottom).offset(2);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(footView);
        make.height.width.mas_equalTo(180);
    }];
    
    return footView;
}
- (NSString *)getCustomerInfo:(NSString *)customerInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:customerInfo];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
