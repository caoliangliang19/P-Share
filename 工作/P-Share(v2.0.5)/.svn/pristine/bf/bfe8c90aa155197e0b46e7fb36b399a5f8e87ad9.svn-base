//
//  WalletSettingVC.m
//  P-Share
//
//  Created by fay on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "WalletSettingVC.h"
#import "AgainSetCodeController.h"

@interface WalletSettingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArr;
}

@end

@implementation WalletSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    _titleArr = [NSArray arrayWithObjects:@"设置密码",@"找回密码", nil];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.textLabel.text = _titleStr;
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
     AgainSetCodeController *again = [[AgainSetCodeController alloc]init];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:pay_password] isEqualToString:@"1"]) {
        again.isBeginCode = @"YES";

    }else
    {
        again.isBeginCode = @"NO";
    }

    again.titleStr = _titleStr;
    
    [self.navigationController pushViewController:again animated:YES];
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
