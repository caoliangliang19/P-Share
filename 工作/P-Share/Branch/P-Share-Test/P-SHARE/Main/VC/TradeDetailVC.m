//
//  TradeDetailVC.m
//  P-Share
//
//  Created by fay on 16/4/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TradeDetailVC.h"
#import "YuYuePingZhengDetail.h"
#import "ShowTingCheMaViewController.h"
#import "AllOrderController.h"
#import "YuYueCell.h"
@interface TradeDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;
    NSMutableArray *_dataArr4;
    UITableView    *_tableView;
}

@end

@implementation TradeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rt_disableInteractivePop = YES;
    [self createData];
    
}
- (void)setup
{
    [super setup];
    self.title = @"交易详情";
    self.automaticallyAdjustsScrollViewInsets = YES;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"YuYueCell" bundle:nil] forCellReuseIdentifier:@"YuYueCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}
- (void)createData{
    _dataArr = [NSMutableArray arrayWithObjects:@"支付成功",@"订单号",@"车牌号",@"付款方式",@"付款时间",@"订单金额",@"优惠金额",@"实付金额", nil];
    _dataArr1 = [NSMutableArray arrayWithObjects:@"支付成功",@"订单号",@"车牌号",@"交易类型",@"续费时长",@"续费到期时间",@"付款方式",@"付款时间",@"订单金额",@"优惠金额",@"实付金额", nil];
    _dataArr2 = [NSMutableArray arrayWithObjects:@"支付成功",@"订单号",@"车牌号",@"交易类型",@"车型",@"预约时间",@"付款方式",@"付款时间",@"订单金额",@"优惠金额",@"实付金额", nil];
    
    _dataArr3 = [NSMutableArray arrayWithObjects:@"支付成功",@"订单号",@"交易流水号",@"车牌号",@"缴费类型",@"小区名称",@"进场时间",@"出场时间",@"付款方式",@"付款时间",@"优惠金额",@"实付金额", nil];
    _dataArr4 = [NSMutableArray arrayWithObjects:@"支付成功",@"订单号",@"车牌号",@"缴费类型",@"小区名称",@"进场时间",@"出场时间",@"付款方式",@"付款时间",@"优惠金额",@"实付金额", nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.style == TradeStyleLinTing){
        return _dataArr.count;
    }else if (self.style == TradeStyleYueZu){
        return _dataArr1.count;
    }else if (self.style == TradeStyleWashCar){
        return _dataArr2.count;
    }else if (self.style == TradeStylelinTing){
        if ([_order.payType integerValue] == 05) {
            return _dataArr4.count;
        }else{
            return _dataArr3.count;
        }
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
            
            UIImageView *imgV = [[UIImageView alloc]init];
            imgV.image = [UIImage imageNamed:@"paySuccess"];
            
            [cell addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell);
                make.top.mas_equalTo(16);
                make.size.mas_equalTo(CGSizeMake(52, 52));
                
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"支付成功";
            [cell addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell);
                make.top.mas_equalTo(imgV.mas_bottom).offset(16);
            }];
            
            UIView *lineV = [[UIView alloc]init];
            [cell addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
            lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    
    }else{
        YuYueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueCell"];
        [cell.rightImg removeFromSuperview];
        [cell.lineV removeFromSuperview];
        if(self.style == TradeStyleLinTing){
            cell.mainL.text = [_dataArr objectAtIndex:indexPath.row];
        }else if (self.style == TradeStyleYueZu){
            cell.mainL.text = [_dataArr1 objectAtIndex:indexPath.row];
        }else if (self.style == TradeStyleWashCar){
           cell.mainL.text = [_dataArr2 objectAtIndex:indexPath.row];
        }else if (self.style == TradeStylelinTing){
            if ([_order.payType integerValue] == 05) {
                cell.mainL.text = [_dataArr4 objectAtIndex:indexPath.row];
            }else{
                 cell.mainL.text = [_dataArr3 objectAtIndex:indexPath.row];
            }
        }
       
        cell.mainL.font = [UIFont systemFontOfSize:15];
        cell.mainL.textColor = [UIColor colorWithHexString:@"696969"];
        cell.subL.font = [UIFont systemFontOfSize:15];
        cell.subL.textColor = [UIColor colorWithHexString:@"696969"];
    if (self.style == TradeStyleLinTing) {
            switch (indexPath.row) {
            case 1:
            {
                cell.subL.text = _order.orderId;
                
                
            }
                break;

            case 2:
            {
                cell.subL.text =  _order.carNumber;

            }
                break;
            case 3:
            {
                if ([_order.payType integerValue] == 00) {
                   cell.subL.text = @"支付宝支付";
                }else if([_order.payType integerValue] == 01){
                    cell.subL.text = @"微信支付";
                    
                }else if([_order.payType integerValue] == 05){
                    cell.subL.text = @"钱包支付";
                    
                }
                

            }
                break;
            case 4:
            {
                cell.subL.text = _order.payTime;

            }
                break;
            case 5:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountPayable];

            }
                break;
            case 6:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountDiscount];
            }
                break;
            case 7:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountPaid];

            }
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (self.style == TradeStyleYueZu||self.style == TradeStyleWashCar){
        switch (indexPath.row) {
            case 1:
            {
                cell.subL.text = _order.orderId;
            }
                break;
            case 2:
            {
                cell.subL.text =  _order.carNumber;
            }
                break;

            case 3:
            {
                if ([_order.orderType integerValue] == 13) {
                    cell.subL.text = @"月租";
                }else if([_order.orderType integerValue] == 14){
                    cell.subL.text = @"产权";
                }else{
                    cell.subL.text = @"洗车";
                }
            }
                break;
            case 4:
            {
                if (self.style == TradeStyleYueZu) {
                    cell.subL.text = [NSString stringWithFormat:@"%@ 月",_order.monthNum];
                }else if(self.style == TradeStyleWashCar){
                    if([_order.carType integerValue] == 1){
                        cell.subL.text =@"轿车";
                    }else{
                        cell.subL.text =@"商务车";
                    }
                }
                
            }
                break;
            case 5:
            {
                if (self.style == TradeStyleYueZu) {
                    cell.subL.text = [self ChangeDate:_order.endDate];
                }else if(self.style == TradeStyleWashCar){
                    cell.subL.text =[self ChangeDate: _order.reserveDate];
                }

            }
                break;
            case 6:
            {
                if ([_order.payType integerValue] == 00) {
                    cell.subL.text = @"支付宝支付";
                }else if([_order.payType integerValue] == 01){
                    cell.subL.text = @"微信支付";
                    
                }else if([_order.payType integerValue] == 05){
                    cell.subL.text = @"钱包支付";
                    
                }
            }
                break;
            case 7:
            {
                  cell.subL.text = _order.payTime;
            }
                break;
            case 8:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountPayable];
            }
                break;
            case 9:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountDiscount];
            }
                break;
            case 10:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountPaid];
            }
                break;

                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (self.style == TradeStylelinTing){
        switch (indexPath.row) {
            case 1:
            {
                cell.subL.text = _order.orderId;
            }
                break;
            case 2:
            {
                if ([_order.payType integerValue] == 05) {
                    cell.subL.text = _order.carNumber;
                }else{
                cell.subL.text = _order.tradeNo;
                }
            }
                break;
            case 3:
            {
                if ([_order.payType integerValue] == 05) {
                    cell.subL.text = @"临停缴费";
                }else{
                cell.subL.text = _order.carNumber;
                }
            }
                break;
            case 4:
            {
                if ([_order.payType integerValue] == 05) {
                     cell.subL.text = _order.parkingName;
                }else{
                 cell.subL.text = @"临停缴费";
                }
            }
                break;
            case 5:
            {
                if ([_order.payType integerValue] == 05) {
                     cell.subL.text = _order.actualBeginDate;
                }else{
                cell.subL.text = _order.parkingName;
                }
            }
                break;
            case 6:
            {
                if ([_order.payType integerValue] == 05) {
                    cell.subL.text = _order.actualEndDate;
                }else{
                cell.subL.text = _order.actualBeginDate;
                }
            }
                break;
            case 7:
            {
                if ([_order.payType integerValue] == 05) {
                    if ([_order.payType integerValue] == 00) {
                        cell.subL.text = @"支付宝支付";
                    }else if([_order.payType integerValue] == 01){
                        cell.subL.text = @"微信支付";
                        
                    }else if([_order.payType integerValue] == 05){
                        cell.subL.text = @"钱包支付";
                        
                    }
                }else{
                cell.subL.text = _order.actualEndDate;
                }
            }
                break;
            case 8:
            {
                if ([_order.payType integerValue] == 05) {
                    cell.subL.text = _order.payTime;
                }else{
                if ([_order.payType integerValue] == 00) {
                    cell.subL.text = @"支付宝支付";
                }else if([_order.payType integerValue] == 01){
                    cell.subL.text = @"微信支付";
                    
                }else if([_order.payType integerValue] == 05){
                    cell.subL.text = @"钱包支付";
                    
                }
                }
            }
                break;
            case 9:
            {
                if ([_order.payType integerValue] == 05) {
                     cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountDiscount];
                }else{
                cell.subL.text = _order.payTime;
                }
            }
                break;
            case 10:
            {
                if ([_order.payType integerValue] == 05) {
                     cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountPaid];
                }else{
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountDiscount];
                }
            }
                break;
            case 11:
            {
                cell.subL.text = [NSString stringWithFormat:@"%@ 元",_order.amountPaid];
            }
                break;
            
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
      
        return nil;
    }
}
- (NSString *)ChangeDate:(NSString *)data{
    NSString *str = nil;
     if (data) {
        NSArray *array = [data componentsSeparatedByString:@" "];
         str = array[0];
    }
    return str;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 76);
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [footView addSubview:lineView];
    UILabel *lable = [[UILabel alloc]init];
    lable.backgroundColor = [UIColor clearColor];
    lable.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    lable.text = @"* 请于15分钟内离场，超过时间请重新计费";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor colorWithHexString:@"ff6160"];
    [footView addSubview:lable];
    CGFloat height = 0;
    if (self.style == TradeStylelinTing) {
        height = 40;
        lable.hidden = NO;
    }else{
        height = 14;
        lable.hidden = YES;
    }
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:(UIControlStateNormal)];
    backBtn.layer.cornerRadius = 4;
    backBtn.tag = 0;
    [backBtn setBackgroundColor:[UIColor colorWithHexString:@"e0e0e0"]];
    [backBtn setTitle:@"返回首页" forState:(UIControlStateNormal)];
    [footView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(tradeClick:) forControlEvents:(UIControlEventTouchUpInside)];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height);
        make.left.mas_equalTo(14);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((SCREEN_WIDTH-14*3)/2);
        
    }];
    
    UIButton *tradeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [tradeBtn setBackgroundColor:KMAIN_COLOR];
    [tradeBtn addTarget:self action:@selector(tradeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    tradeBtn.tag = 1;
    tradeBtn.layer.cornerRadius = 4;
    if(_style == TradeStyleWashCar){
         [tradeBtn setTitle:@"查看订单" forState:(UIControlStateNormal)];
    }else{
         [tradeBtn setTitle:@"查看凭证" forState:(UIControlStateNormal)];
    }
   
    [footView addSubview:tradeBtn];
    [tradeBtn setTitleColor:[UIColor colorWithHexString:@"fcfcfc"] forState:(UIControlStateNormal)];

    [tradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height);
        make.right.mas_equalTo(footView).offset(-14);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(backBtn.mas_width);
        
    }];
    
    return footView;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)leftBarButtonClick:(UIBarButtonItem *)item
{
    [self.rt_navigationController popToRootViewControllerAnimated:YES];
}
- (void)tradeClick:(UIButton *)btn
{
    if (btn.tag == 0) {

        [self.rt_navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        
        if (_style == TradeStyleLinTing) {
            
            YuYuePingZhengDetail *detailVC = [[YuYuePingZhengDetail alloc] init];
            detailVC.type = @"left";
            detailVC.pingZhengModel = _order;
            detailVC.type = @"left";
            [self.rt_navigationController pushViewController:detailVC animated:YES];
            
        }else if (_style == TradeStyleYueZu){
            
            NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_order.orderId,_order.orderType,SECRET_KEY] MD5];
            
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(orderdetail),_order.orderId,_order.orderType,summary];
            [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                ShowTingCheMaViewController *showT = [[ShowTingCheMaViewController alloc]init];
                showT.model = [OrderModel shareObjectWithDic:responseObject[@"order"]];
                [self.rt_navigationController pushViewController:showT animated:YES];
                
            } error:^(NSString *error) {
                
            } failure:^(NSString *fail) {
                
            }];
            
           
        }else if (_style == TradeStyleWashCar){

            
            for (UIViewController *VC in self.navigationController.childViewControllers) {
                if ([VC isKindOfClass:[AllOrderController class]]) {
                    [self.navigationController popToViewController:VC animated:YES];
                    return;
                    
                }
            }
            AllOrderController *orderVC = [[AllOrderController alloc] init];
            [self.rt_navigationController pushViewController:orderVC animated:YES];
            
            
        }else if (_style == TradeStylelinTing){
            ShowTingCheMaViewController *showT = [[ShowTingCheMaViewController alloc]init];
            showT.model = _order;
            [self.rt_navigationController pushViewController:showT animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.style == TradeStylelinTing){
        return 102;
    }else{
        return 76;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 117;
        
    }else
    {
        return 30;
        
    }
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
