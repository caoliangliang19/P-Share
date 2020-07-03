//
//  ShareOrderDetailVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ShareOrderDetailVC.h"
#import "ShowTingCheMaViewController.h"
#import "YuYuePingZhengDetail.h"

@interface ShareOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ShareOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createTableView{
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:(UITableViewStyleGrouped)];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:_orderTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rowArray = self.orderArray[section];
    return rowArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"shareCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0&&indexPath.row == 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12, 13, 150, 35);
        button.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
        [button setTitle:self.orderArray[indexPath.section][indexPath.row] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(onCodePageViewController) forControlEvents:(UIControlEventTouchUpInside)];
        [cell addSubview:button];
        return cell;
    }else{
        if (self.requestArray.count > 0) {
            cell.textLabel.text =[NSString stringWithFormat:@"%@%@",self.orderArray[indexPath.section][indexPath.row],self.requestArray[indexPath.section][indexPath.row]];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row == 0) {
        return 60;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 31)];
    lable.text = [NSString stringWithFormat:@"   %@",_shareSecArray[section]];
    lable.backgroundColor = [UIColor whiteColor];
    lable.textColor = [UIColor colorWithHexString:@"333333"];
    [bgView addSubview:lable];
    return bgView;
}
#pragma mark -
#pragma mark - 进入凭证页面
- (void)onCodePageViewController{
    if ([_model.orderType integerValue] == 10) {
        YuYuePingZhengDetail *yuYue = [[YuYuePingZhengDetail alloc]init];
        yuYue.pingZhengModel = _model;
        [self.rt_navigationController pushViewController:yuYue animated:YES];
    }else{
        ShowTingCheMaViewController *ping = [[ShowTingCheMaViewController alloc]init];
        ping.model = _model;
        [self.rt_navigationController pushViewController:ping animated:YES];
    }
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
