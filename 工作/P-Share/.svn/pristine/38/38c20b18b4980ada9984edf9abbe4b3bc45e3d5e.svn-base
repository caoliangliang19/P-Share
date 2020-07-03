//
//  PurseTradeVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/18.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PurseTradeVC.h"
#import "MoneyBaoCell.h"


@interface PurseTradeVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PurseTradeVC

- (void)viewDidLoad {
   [super viewDidLoad];
    self.title = @"钱包交易记录";
    _select.selectArray =[[NSMutableArray alloc]initWithArray:@[@"充值纪录",@"消费纪录"]];
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
    [_leftTableView registerNib:[UINib nibWithNibName:@"MoneyBaoCell" bundle:nil] forCellReuseIdentifier:@"leftID"];
    [_scrollView addSubview:_leftTableView];
    
    _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
    _centerTableView.tag = 3;
    _centerTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_centerTableView registerNib:[UINib nibWithNibName:@"MoneyBaoCell" bundle:nil] forCellReuseIdentifier:@"centerID"];
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
    MoneyBaoCell *cell = nil;
    if(tableView == _leftTableView){
       cell = [tableView dequeueReusableCellWithIdentifier:@"leftID" forIndexPath:indexPath];
        OrderModel *model = self.leftArray[indexPath.row];
        cell.hourTimeL.text = model.payTimeForTime;
        cell.yearTimeL.text = model.payTimeForDate;
        if ([model.payType isEqualToString:@"00"]) {
            cell.payForTypeL.text = @"支付宝支付";
        }else if ([model.payType isEqualToString:@"01"]){
            cell.payForTypeL.text = @"微信支付";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.moneyL.text = [NSString stringWithFormat:@"+%@",model.amountPaid];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }else if (tableView == _centerTableView){
       cell = [tableView dequeueReusableCellWithIdentifier:@"centerID" forIndexPath:indexPath];
        OrderModel *model = self.centerArray[indexPath.row];
        cell.hourTimeL.text = model.payTimeForTime;
        cell.yearTimeL.text = model.payTimeForDate;
        NSString *orderType = [NSString stringWithFormat:@"%@",model.orderType];
        if ([orderType isEqualToString:@"10"]) {
            cell.payForTypeL.text = @"专享临停缴费";
        }else if ([orderType isEqualToString:@"11"]){
            cell.payForTypeL.text = @"临停缴费";
        }else if ([orderType isEqualToString:@"1"]){
            cell.payForTypeL.text = @"代泊缴费";
        }else if ([orderType isEqualToString:@"13"]){
            cell.payForTypeL.text = @"月租缴费";
        }else if ([orderType isEqualToString:@"14"]){
            cell.payForTypeL.text = @"产权缴费";
        }else if ([orderType isEqualToString:@"15"]){
            cell.payForTypeL.text = @"加油卡缴费";
        }else if ([orderType isEqualToString:@"16"]){
            cell.payForTypeL.text = @"钱包缴费";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.moneyL.text = [NSString stringWithFormat:@"-%@",model.amountPaid];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
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
