//
//  AllHistoryDetailViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/14.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "AllHistoryDetailViewController.h"
#import "AllHistoryCell.h"
#import "PictureView.h"
#import "JZAlbumViewController.h"
#import "ShowTingCheMaViewController.h"


@interface AllHistoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,PictureViewTapImageDelegate,MyClickDelegate>
{
    UIView *_clearBackView;
    MBProgressHUD *_mbView;
    
    NSString *_orderType;
    NSString *_orderId;
    
    
}

@property(nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong) TemParkingListModel *detailModel;

@end

@implementation AllHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ALLOC_MBPROGRESSHUD;
    
     [self createModel];
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    if ([self.historyType isEqualToString:@"daiBo"]) {
        self.headerTitleLabel.text = @"代泊订单详情";
    }else if ([self.historyType isEqualToString:@"linTing"]){
        self.headerTitleLabel.text = @"临停订单详情";
    }
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 100, 20) title:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    if ([self.historyType isEqualToString:@"daiBo"]) {
        titleLabel.text = @"订单信息";
    }else {
        titleLabel.text = @"支付凭证";
    }
    [tableHeaderView addSubview:titleLabel];
    self.allHistoryTableView.tableHeaderView = tableHeaderView;
    
    self.allHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.allHistoryTableView.bounces = YES;
    self.allHistoryTableView.tableFooterView = [[UIView alloc]init];
    self.allHistoryTableView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
}
- (void)createModel{
    MyLog(@"%@%@",self.myOrderModel.orderId,self.myOrderModel.orderType);
//    BEGIN_MBPROGRESSHUD
    if ([self.monthRent isEqualToString:@"monthRent"]) {
        _orderId = self.temParkModel.orderId;
        _orderType =[NSString stringWithFormat:@"%@",self.temParkModel.orderType];
    }else{
    _orderId = self.myOrderModel.orderId;
    _orderType =[NSString stringWithFormat:@"%@",self.myOrderModel.orderType];
    }
    [RequestModel requestHistoryOrderDetailListWithURL:_orderId WithType:_orderType Completion:^(TemParkingListModel *model) {
        self.detailModel = model;
        [self.allHistoryTableView reloadData];
//        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
//        END_MBPROGRESSHUD
    }];
//    END_MBPROGRESSHUD
}
#pragma mark --   UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.historyType isEqualToString:@"daiBo"]) {
         return 3;
    }else if ([self.historyType isEqualToString:@"linTing"]){
        return 3;
    }else{
        return 4;
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.historyType isEqualToString:@"daiBo"]) {
            return 4;
        }else{
         return 1;
        }

    }else if (section == 1){
        if ([self.historyType isEqualToString:@"daiBo"]) {
            if ([self.historyType isEqualToString:@"daiBo"]) {
                return 6;
            }else{
                return 4;
            }
        }else{
        return 4;
        }
       
    }else if(section == 2){
        if ([self.historyType isEqualToString:@"daiBo"]) {
            if ([self.historyType isEqualToString:@"linTing"]) {
                return 3;
            }else{
                return 4;
            }
        }else{
         if ([self.historyType isEqualToString:@"daiBo"]) {
            return 6;
        }else{
            return 4;
        }
        }
    }else{
        if ([self.historyType isEqualToString:@"daiBo"]) {
             return 1;
        }else{
         if ([self.historyType isEqualToString:@"linTing"]) {
            return 3;
        }else{
            return 4;
        }
        }
           }
        
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 && [self.historyType isEqualToString:@"daiBo"]){
        return 145;
    }else if (section == 2 || section == 1|| section == 3){
        return 45;
    }else{
        return 0;
        }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.historyType isEqualToString:@"daiBo"]) {
        CGFloat sectionHeaderHeight = 45;
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)pictureViewTapImageWithIndex:(NSInteger)index
{
    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
    jzAlbumCtrl.imgArr = self.imageArray;
    jzAlbumCtrl.currentIndex = index;
    [self presentViewController:jzAlbumCtrl animated:YES completion:nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 && [self.historyType isEqualToString:@"daiBo"]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
        backView.backgroundColor = [UIColor clearColor];
        
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"PictureView" owner:self options:nil];
        PictureView *pictureScrollView = [nibArray objectAtIndex:0];
        pictureScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        pictureScrollView.delegate = self;
        self.imageArray = [NSMutableArray array];
    
        NSArray *modelImages = [self.orderModel.validateImagePath componentsSeparatedByString:@","];
        [self.imageArray addObjectsFromArray:modelImages];
        [self.imageArray removeObject:@""];
        if (self.orderModel.parkingImagePath.length > 5) {
            NSString *imageString = [self.orderModel.parkingImagePath substringToIndex:[self.orderModel.parkingImagePath length]-1];
            [self.imageArray addObject:imageString];
        }
        [pictureScrollView configDataWithArray:self.imageArray];
        [backView addSubview:pictureScrollView];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 35)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:whiteView];
        UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 100, 20) title:@"支付信息" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [whiteView addSubview:titleLabel];
        
        return backView;
    }else if (section == 2 || section == 1|| section == 3){
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        backView.backgroundColor = [UIColor clearColor];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 35)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:whiteView];
        UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 100, 20) title:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [whiteView addSubview:titleLabel];
        
        if (section == 1) {
            if ([self.historyType isEqualToString:@"daiBo"]) {
                titleLabel.text = @"代泊信息";
            }else if ([self.historyType isEqualToString:@"linTing"]){
                titleLabel.text = @"临停信息";
            }else{
                titleLabel.text = @"订单信息";
            }
        }else if (section == 2){
            if ([self.historyType isEqualToString:@"daiBo"]) {
            titleLabel.text = @"支付信息";
            }else{
            titleLabel.text = @"车位信息";
            }
        }else if (section == 3){
            if ([self.historyType isEqualToString:@"daiBo"]) {
            titleLabel.text = @"支付凭证";
            }else{
            titleLabel.text = @"支付信息";
            }
        }
        
        return backView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.historyType isEqualToString:@"daiBo"]) {
        if (indexPath.section == 3) {
            return 60;
        }
        return 30;
    }else{
    if (indexPath.section == 0) {
        return 60;
    }else{
    return 30;
    }
    }
    return 0;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellId = @"allHistoryCellId";
    AllHistoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllHistoryCell" owner:self options:nil]lastObject];
    }
    cell.delegate = self;
    cell.payBtn.hidden = YES;
    cell.lineView.hidden = NO;
    if ([self.historyType isEqualToString:@"daiBo"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单号: %@",self.orderModel.orderId];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"订单状态: 已完成";
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单创建时间: %@",self.orderModel.createDate];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单支付时间: %@",self.orderModel.orderEndDate];
                cell.lineView.hidden = YES;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.orderModel.parkingName];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",self.orderModel.carNumber];
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"代泊员: %@",self.orderModel.parkerName];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"交车时间: %@",self.orderModel.orderBeginDate];
            }else if (indexPath.row == 4){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"取车时间: %@",self.orderModel.orderEndDate];
            }else{
                cell.orderTitleLabel.text = @"车辆照片:";
                cell.lineView.hidden = YES;
            }
        }else{
            if (indexPath.row == 0) {
                if ([self.orderModel.payType integerValue] == 00) {
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"支付宝支付"];
                    
                }else if([self.orderModel.payType integerValue] == 01){
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"微信支付"];
                    
                    
                }else if([self.orderModel.payType integerValue] == 05){
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"钱包支付"];
                }
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"%@",@" "];
                
            }else if(indexPath.row == 1){
                 cell.orderTitleLabel.text = [NSString stringWithFormat:@"优惠金额: %@元",self.orderModel.amountDiscount];
            }else if(indexPath.row == 2){
                 cell.orderTitleLabel.text = [NSString stringWithFormat:@"已付金额: %@元",self.orderModel.amountPaid];
                cell.lineView.hidden = YES;
            }
        }
    }else if ([self.historyType isEqualToString:@"linTing"]){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单号: %@",self.temOrderModel.order_ID];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"订单状态: 已完成";
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单创建时间: %@",self.temOrderModel.create_at];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单支付时间: %@",self.temOrderModel.order_actual_end_stop];
                cell.lineView.hidden = YES;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.temOrderModel.parking_Name];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",self.temOrderModel.car_Number];
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"进场时间: %@",self.temOrderModel.order_actual_begin_start];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"停车时长: %@",self.temOrderModel.carStoreTime];
                cell.lineView.hidden = YES;
            }
        }else{
            if (indexPath.row == 0) {
                if ([self.temOrderModel.pay_type integerValue] == 00) {
                     cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"支付宝支付"];
                    
                }else if([self.temOrderModel.pay_type integerValue] == 01){
                      cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"微信支付"];
                   
                    
                }else if([self.temOrderModel.pay_type integerValue] == 05){
                     cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"钱包支付"];
                }
               
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"优惠金额: %@",self.temOrderModel.order_discount];
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付金额: %@",self.temOrderModel.order_total_fee];
                cell.lineView.hidden = YES;
            }
        }
    }else if ([self.historyType isEqualToString:@"yueZu"] || [self.historyType isEqualToString:@"chanQuan"]){
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单号: %@",self.detailModel.orderId];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"订单状态: 已支付";
            }else if (indexPath.row == 2){

                NSArray *array = [self.detailModel.actualBeginDate componentsSeparatedByString:@" "];
                
                NSArray *array1 = [self.detailModel.actualEndDate componentsSeparatedByString:@" "];
                
                
                if (array1) {
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单有效时间:%@－%@",array[0],array1[0]];
                }else{
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单有效时间:%@",array[0]];
                }
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单支付时间: %@",self.detailModel.payTime];
                cell.lineView.hidden = YES;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                if (!(self.detailModel.parkingName.length == 0)) {
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.detailModel.parkingName];
                }else{
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",@""];
                }
                
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"车位类型: %@",self.detailModel.orderTypeName];
            }else if (indexPath.row == 2){
                if (!(self.detailModel.carNumber.length == 0)) {
                     cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",self.detailModel.carNumber];
                }else{
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",@""];
                }
               
            }else if (indexPath.row == 3){
                if ([self.historyType isEqualToString:@"chanQuan"]) {
                    if (!(self.detailModel.parkingNo.length == 0)) {
                         cell.orderTitleLabel.text = [NSString stringWithFormat:@"车位号: %@",self.detailModel.parkingNo];
                    }else{
                        cell.orderTitleLabel.text = [NSString stringWithFormat:@"车位号: %@",@""];
                    }
                    
                   
                }else{
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"车位号: %@",self.detailModel.parkingNo];
                }
                cell.lineView.hidden = YES;
            }
            
        }else if(indexPath.section == 3){
            if (indexPath.row == 0) {
                
                if ([self.detailModel.payType integerValue] == 00) {
                     cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"支付宝支付"];
                }else if([self.detailModel.payType integerValue] == 01){
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"微信支付"];
                    
                }else if([self.detailModel.payType integerValue] == 05){
                   cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",@"钱包支付"];
                    
                }
               
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"应付金额: %@元",self.detailModel.amountPayable];
                cell.lineView.hidden = YES;
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"优惠金额: %@元",self.detailModel.amountDiscount];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"已付金额: %@元",self.detailModel.amountPaid];
            }
        }else{
            if (indexPath.row == 0) {
            cell.orderTitleLabel.hidden = YES;
            cell.payBtn.hidden = NO;
            cell.payBtn.layer.cornerRadius = 3;
            cell.payBtn.clipsToBounds = YES;
            }
            
        }
       
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)onClickEvent{
    
    ShowTingCheMaViewController *showT = [[ShowTingCheMaViewController alloc]init];
    showT.model = self.detailModel;
    [self.navigationController pushViewController:showT animated:YES];
    
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
@end




