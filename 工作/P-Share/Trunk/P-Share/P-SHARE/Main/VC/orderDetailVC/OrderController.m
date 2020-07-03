//
//  OrderController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "OrderController.h"

@interface OrderController ()

@end

@implementation OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTypeOrder];
    [self requestOrder];
}

#pragma mark - 懒加载数组

- (NSMutableArray *)requestArray{
    if (_requestArray == nil) {
        _requestArray = [[NSMutableArray alloc] init];
    }
    return _requestArray;
}
- (void)createTypeOrder{
    if (_type == CLLOrderDetailControllerShare) {
        _shareSecArray = @[@"停车凭证",@"订单信息",@"优惠停车信息",@"支付信息"];
        self.title = @"预约停车订单详情";
    }else if (_type == CLLOrderDetailControllerYuZu){
        _shareSecArray = @[@"支付凭证",@"订单信息",@"车位信息",@"支付信息"];
        self.title = @"月租/产权订单详情";
    }else if (_type == CLLOrderDetailControllerLinT){
        _shareSecArray = @[@"停车凭证",@"订单信息",@"优惠停车信息",@"支付信息"];
        self.title = @"临停订单详情";
    }else if (_type == CLLOrderDetailControllerDaiBo){
        _shareSecArray = @[@"订单信息",@"代泊信息",@"支付信息"];
    }
}
- (void)setType:(CLLOrderDetailController)type{
    _type = type;
}

- (void)requestOrder{
    if (_type == CLLOrderDetailControllerDaiBo) {
        [self addDaiBoOrderViewController:self.orderModel];
    }else{
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.orderModel.orderId,self.orderModel.orderType,SECRET_KEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(orderDetail),self.orderModel.orderId, self.orderModel.orderType,summary];
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   [NetWorkEngine getRequestUse:(self) WithURL:urlString WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
       _model = [OrderModel shareObjectWithDic:responseObject[@"order"]];
       if (_type == CLLOrderDetailControllerYuZu) {
           [self addRendModel:_model];
       }else if(_type == CLLOrderDetailControllerLinT || _type == CLLOrderDetailControllerShare){
           [self addOrderArrayModel:_model];
       }
   } error:^(NSString *error) {
      
       
   } failure:^(NSString *fail) {
       
   }];
}
}
#pragma mark -
#pragma mark - 月租产权数据布置
- (void)addRendModel:(OrderModel *)model{
    self.rendArray = [[NSArray alloc]initWithObjects:@[@"查看支付凭证"],@[@"订单号:",@"订单状态:",@"订单有效时间:",@"订单支付时间:"],@[@"小区名称:",@"车位类型:",@"车牌号:",@"地址:"],@[@"支付方式:",@"应付金额:",@"优惠金额:",@"已付金额:"], nil];
    self.orderArray = self.rendArray;
    NSMutableArray *pinArray = [[NSMutableArray alloc]init];
    [self.requestArray addObject:pinArray];
    NSMutableArray *infoArray = [[NSMutableArray alloc]init];
    if ([UtilTool isBlankString:model.orderId] == NO) {
        [infoArray addObject:model.orderId];
    }else{
        [infoArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.orderStatus] == NO&&[model.orderStatus integerValue]== 11) {
        [infoArray addObject:@"已付款"];
    }else{
        [infoArray addObject:@""];
    }
    NSArray *array = [model.actualBeginDate componentsSeparatedByString:@" "];
    
    NSArray *array1 = [model.effectEndDate componentsSeparatedByString:@" "];
    if (array1) {
         [infoArray addObject:[NSString stringWithFormat:@"%@－%@",array[0],array1[0]]];
    }else{
        [infoArray addObject:[NSString stringWithFormat:@"%@",array[0]]];
    }
    if ([UtilTool isBlankString:model.payTime] == NO) {
        [infoArray addObject:model.payTime];
    }else{
        [infoArray addObject:@""];
    }
    [self.requestArray addObject:infoArray];
    NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
    if ([UtilTool isBlankString:model.parkingName] == NO) {
        [distanceArray addObject:model.parkingName];
    }else{
        [distanceArray addObject:@""];
    }
    if ([model.orderType integerValue] == 13) {
        [distanceArray addObject:@"月租"];
    }else if([model.orderType integerValue] == 14){
        [distanceArray addObject:@"产权"];
    }
    if ([UtilTool isBlankString:model.carNumber] == NO) {
        [distanceArray addObject:model.carNumber];
    }else{
        [distanceArray addObject:@""];
    }
    [distanceArray addObject:@""];
    [self.requestArray addObject:distanceArray];
    NSMutableArray *payArray = [[NSMutableArray alloc]init];
    if ([model.payType integerValue] == 00) {
        [payArray addObject: @"支付宝支付"];
    }else if([model.payType integerValue] == 01){
        [payArray addObject: @"微信支付"];
    }else if([model.payType integerValue] == 05){
        [payArray addObject: @"钱包支付"];
    }
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountPayable]];
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountDiscount]];
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountPaid]];
    [self.requestArray addObject:payArray];
     [_orderTableView reloadData];
    
}
#pragma mark -
#pragma mark - 优惠 临停 数据布置

- (void)addOrderArrayModel:(OrderModel *)model{
    self.shareArray = [[NSArray alloc]initWithObjects:@[@"查看停车凭证"],@[@"订单号:",@"订单状态:",@"订单开始时间:",@"支付时间:"],@[@"小区名称:",@"车牌号:",@"停车码:",@"进场时间:",@"出场时间:"],@[@"支付方式:",@"应付金额:",@"抵扣金额:",@"已付金额:"], nil];
    self.orderArray = self.shareArray;
    NSMutableArray *pinArray = [[NSMutableArray alloc]init];
    [self.requestArray addObject:pinArray];
    
    NSMutableArray *infoArray = [[NSMutableArray alloc]init];
    if ([UtilTool isBlankString:model.orderId] == NO) {
        [infoArray addObject:model.orderId];
    }else{
        [infoArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.orderStatus] == NO&&[model.orderStatus integerValue]== 11) {
        [infoArray addObject:@"已付款"];
    }else{
        [infoArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.orderBeginDate] == NO) {
        [infoArray addObject:model.orderBeginDate];
    }else{
        [infoArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.payTime] == NO) {
        [infoArray addObject:model.payTime];
    }else{
        [infoArray addObject:@""];
    }
    [self.requestArray addObject:infoArray];
    
    NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
    if ([UtilTool isBlankString:model.parkingName] == NO) {
        [distanceArray addObject:model.parkingName];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.carNumber] == NO) {
        [distanceArray addObject:model.carNumber];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.parkingCode] == NO) {
        [distanceArray addObject:model.parkingCode];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.actualBeginDate] == NO) {
        [distanceArray addObject:model.actualBeginDate];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.actualEndDate] == NO) {
        [distanceArray addObject:model.actualEndDate];
    }else{
        [distanceArray addObject:@""];
    }
    [self.requestArray addObject:distanceArray];
    
    NSMutableArray *payArray = [[NSMutableArray alloc]init];
    if ([model.payType integerValue] == 00) {
         [payArray addObject: @"支付宝支付"];
    }else if([model.payType integerValue] == 01){
        [payArray addObject: @"微信支付"];
    }else if([model.payType integerValue] == 05){
        [payArray addObject: @"钱包支付"];
    }
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountPayable]];
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountDiscount]];
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountPaid]];
    [self.requestArray addObject:payArray];
    [_orderTableView reloadData];
    
}
#pragma mark -
#pragma mark - 代泊数据布置
- (void)addDaiBoOrderViewController:(OrderModel *)model{
    self.shareArray = [[NSArray alloc]initWithObjects:@[@"订单号:",@"订单状态:",@"订单创建时间:",@"订单支付时间:"],@[@"小区名称:",@"车牌号:",@"代泊员:",@"交车时间:",@"取车时间:",@""],@[@"支付信息:",@"应付金额:",@"抵扣金额:",@"已付金额:"], nil];
    self.orderArray = self.shareArray;
    NSMutableArray *infoArray = [[NSMutableArray alloc]init];
    if ([UtilTool isBlankString:model.orderId] == NO) {
        [infoArray addObject:model.orderId];
    }else{
        [infoArray addObject:@""];
    }
    if([model.orderStatus integerValue] == 5){
        [infoArray addObject:@"已完成"];
    }
    if ([UtilTool isBlankString:model.createDate] == NO) {
        [infoArray addObject:model.createDate];
    }else{
        [infoArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.payTime] == NO) {
        [infoArray addObject:model.payTime];
    }else{
        [infoArray addObject:@""];
    }
    [self.requestArray addObject:infoArray];
    NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
    if ([UtilTool isBlankString:model.parkingName] == NO) {
        [distanceArray addObject:model.parkingName];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.carNumber] == NO) {
        [distanceArray addObject:model.carNumber];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.parkerName] == NO) {
        [distanceArray addObject:model.parkerName];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.orderBeginDate] == NO) {
        [distanceArray addObject:model.orderBeginDate];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.orderEndDate] == NO) {
        [distanceArray addObject:model.orderEndDate];
    }else{
        [distanceArray addObject:@""];
    }
    if ([UtilTool isBlankString:model.parkingImagePath] == NO) {
        [distanceArray addObject:[NSString stringWithFormat:@"%@%@",model.parkingImagePath,model.validateImagePath]];
    }else{
        [distanceArray addObject:@""];
    }
     [self.requestArray addObject:distanceArray];
    NSMutableArray *payArray = [[NSMutableArray alloc]init];
    if ([model.payType integerValue] == 00) {
        [payArray addObject: @"支付宝支付"];
    }else if([model.payType integerValue] == 01){
        [payArray addObject: @"微信支付"];
    }else if([model.payType integerValue] == 05){
        [payArray addObject: @"钱包支付"];
    }
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountPayable]];
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountDiscount]];
    [payArray addObject:[NSString stringWithFormat:@"%@元",model.amountPaid]];
    [self.requestArray addObject:payArray];
    [_orderTableView reloadData];
    
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
