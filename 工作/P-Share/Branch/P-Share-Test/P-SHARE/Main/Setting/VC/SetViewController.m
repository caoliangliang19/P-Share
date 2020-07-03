//
//  SetViewController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "SetViewController.h"
#import "SetSecondController.h"
#import "MapViewController.h"
#import "LoginVC.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavUI];
    [self createSetUI];
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [[NSMutableArray alloc]initWithObjects:@"意见反馈",@"评分打气",@"关于我们",@"帮助我们", nil];
    }
    return _titleArray;
}

- (void)createNavUI{
    self.title = @"设置";
}
- (void)createSetUI{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _tableView.tableFooterView = [self createFootView];
        [self.view addSubview:_tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystleCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SystleCellID"];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"setImage%ld",indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == 1) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1049233050"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        SetSecondController *setSecond = [[SetSecondController alloc]init];
        if (indexPath.row == 0) {
            setSecond.state = CLLSetControllerStateAdvice;
        }else if(indexPath.row == 2){
            setSecond.state = CLLSetControllerStateWe;
        }else if(indexPath.row == 3){
            setSecond.state = CLLSetControllerStateHelp;
        }
        [self.rt_navigationController pushViewController:setSecond animated:YES];
    }
   
}

- (UIView *)createFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"退出登录" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(onBaseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:button];
    return view;
}
- (void)onBaseClick{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    alertView = nil;
}

#pragma mark -- alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"================%ld",buttonIndex);
    if (buttonIndex == 1) {
           GroupManage *manage = [GroupManage shareGroupManages];
            manage = nil;
           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
           [userDefaults setObject:nil forKey:KCUSTOMER_ID];
           [userDefaults setObject:nil forKey:KCUSTOMER_MOBILE];
           [userDefaults setObject:nil forKey:KHEADIMG_URL];
           [userDefaults setObject:nil forKey:@"customerSex"];
           [userDefaults setObject:nil forKey:@"customerEmail"];
           [userDefaults setObject:nil forKey:@"customerRegion"];
           [userDefaults setObject:nil forKey:@"customerJob"];
           [userDefaults setObject:nil forKey:@"pay_password"];
           [[SDWebImageManager sharedManager].imageCache clearDisk];
           [[SDWebImageManager sharedManager].imageCache clearMemory];
           [userDefaults synchronize];
    
           [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
    
    
           self.tabBarController.selectedIndex = 0;
           [self.rt_navigationController popViewControllerAnimated:YES];
    

    }
    
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
