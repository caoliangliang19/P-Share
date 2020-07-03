//
//  StopCarHistoryController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "StopCarHistoryController.h"
#import "StopCarHistoryCell.h"
#import "ShareOrderDetailVC.h"
#import "DaiBoOrderDetailVC.h"

@interface StopCarHistoryController ()

@end

@implementation StopCarHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"停车记录";
    _select.selectArray =[[NSMutableArray alloc]initWithArray:@[@"自驾停车",@"代客泊车"]];
    [self createTableView];
    [self firstRefresh];
}
- (void)createTableView{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.tag = 2;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
     [_leftTableView registerClass:[StopCarHistoryCell class] forCellReuseIdentifier:@"leftID"];
    [_scrollView addSubview:_leftTableView];
    
    _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
    _centerTableView.tag = 3;
    _centerTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_centerTableView registerClass:[StopCarHistoryCell class] forCellReuseIdentifier:@"centerID"];
    _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_centerTableView];
    self.tableView = _leftTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.tab integerValue] == 0) {
        return self.leftArray.count;
    }else if ([self.tab integerValue] == 1){
        return self.centerArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StopCarHistoryCell *cell = nil;
    if(tableView == _leftTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:@"leftID" forIndexPath:indexPath];
        OrderModel *model = self.leftArray[indexPath.row];
         [cell setTableViewCellSize:0 passOn:model];
    }else if (tableView == _centerTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:@"centerID" forIndexPath:indexPath];
        OrderModel *model = self.centerArray[indexPath.row];
        [cell setTableViewCellSize:1 passOn:model];
    }
    
        
   
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      OrderModel *model = nil;
    if(tableView == _leftTableView){
        model = self.leftArray[indexPath.row];
        ShareOrderDetailVC *share = [[ShareOrderDetailVC alloc]init];
        if([model.orderType integerValue] == 10){
            share.type = CLLOrderDetailControllerShare;
        }else{
            share.type = CLLOrderDetailControllerLinT;
        }
        
        share.orderModel = model;
        [self.rt_navigationController pushViewController:share animated:YES complete:nil];
    }else if (tableView == _centerTableView){
        model = self.centerArray[indexPath.row];
        DaiBoOrderDetailVC *daiBo = [[DaiBoOrderDetailVC alloc] init];
        if ([model.orderType integerValue] == 12) {
            daiBo.type = CLLOrderDetailControllerDaiBo;
        }
        daiBo.orderModel = model;
        [self.navigationController pushViewController:daiBo animated:YES];
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
