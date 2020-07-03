//
//  DaiBoOrderDetailVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "DaiBoOrderDetailVC.h"
#import "ImageView.h"

@interface DaiBoOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DaiBoOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createTableView{
    self.title = @"代泊订单详情";
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:(UITableViewStyleGrouped)];
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if (indexPath.section == 1 && indexPath.row == 5) {
        NSString *imageString = [NSString stringWithFormat:@"%@%@",self.orderArray[indexPath.section][indexPath.row],self.requestArray[indexPath.section][indexPath.row]];
        NSArray *array = [imageString componentsSeparatedByString:@","];
        ImageView *view = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        view.imageArray = array;
        [cell addSubview:view];
    }else{
         cell.textLabel.text =[NSString stringWithFormat:@"%@%@",self.orderArray[indexPath.section][indexPath.row],self.requestArray[indexPath.section][indexPath.row]];
    }
    return cell;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 5) {
        return 130;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
