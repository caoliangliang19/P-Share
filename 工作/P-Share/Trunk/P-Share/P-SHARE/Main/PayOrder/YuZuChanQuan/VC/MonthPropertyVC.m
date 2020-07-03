//
//  MonthPropertyVC.m
//  P-Share
//
//  Created by 亮亮 on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MonthPropertyVC.h"
#import "MonHeadView.h"
#import "InvoiceController.h"
#import "RenewTime.h"

@interface MonthPropertyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton    *_agreeButton;
    GroupManage *_manage;
    UIButton    *_tureBtn;
    BOOL        _isgreen;
    NSString    *_invoiceId;
    
}
@property (nonatomic ,strong)NSMutableArray *textArray;
@property (nonatomic ,strong)NSMutableArray *leftArray;
@property (nonatomic ,copy)  NSString       *endDate,*monthNum,*price;
@property (nonatomic,assign) NSInteger      renewTimeNum;
@property (nonatomic,strong) UITableView    *tableView;

@end

@implementation MonthPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _manage = [GroupManage shareGroupManages];
    _manage.order = self.orderModel;
    _renewTimeNum = 1;
    _monthNum = @"一个月";
    _price = _orderModel.price;
    _endDate = [UtilTool getCalendar:[_orderModel.endDate componentsSeparatedByString:@" "][0] WithMonthlyNum:_renewTimeNum];
    
    [self addHeadView];
    [self createTableView];
    [self createBtn];
}
- (NSMutableArray *)textArray{
    if (_textArray == nil) {
        
        _textArray = [NSMutableArray arrayWithObjects:@"续费时长(月)",@"当前有效期",@"续费有效期",@"发票",@"订单金额", nil];
    }
    return _textArray;
}
#pragma mark - 
#pragma mark - 添加NavigationBar；
- (void)addHeadView{
    _isgreen = NO;
    if (self.monthPropertyVCStyle == MonthPropertyVCStyleYueZu) {
        self.title = @"月租支付";
    }else{
        self.title = @"产权支付";
    }

}

#pragma mark - 创建TableView；
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-45) style:UITableViewStylePlain];
    _tableView.backgroundColor = KBG_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableHeaderView = [self createHeadView];
    _tableView.tableFooterView = [self createFootView];
    [self.view addSubview:_tableView];
    
}
#pragma mark -
#pragma mark - 创建头视图
- (MonHeadView *)createHeadView{
    MonHeadView *headView = [[MonHeadView alloc]initWithView:self.view];
    headView.parkingModel = _orderModel;
    return headView;
}
- (UIView *)createFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *protocolBtn = [UtilTool createBtnFrame:CGRectZero title:@"我已同意《口袋停线上缴费协议》" bgImageName:nil target:self action:@selector(showProtocol)];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *attributeText = [UtilTool getLableText:protocolBtn.currentTitle changeText:@"《口袋停线上缴费协议》" Color:[UIColor colorWithHexString:@"39d5b8"] font:13];
    [protocolBtn setAttributedTitle:attributeText forState:UIControlStateNormal];
    [footView addSubview:protocolBtn];
    UIButton *agreeBtn = [UIButton new];
    _agreeButton = agreeBtn;
    [agreeBtn setImage:[UIImage imageNamed:@"monthly_selected"] forState:UIControlStateSelected];
    [agreeBtn setImage:[UIImage imageNamed:@"monthly_default"] forState:UIControlStateNormal];

    [agreeBtn addTarget:self action:@selector(isGreenPshare:) forControlEvents:(UIControlEventTouchUpInside)];
    [agreeBtn setSelected:YES];
    [footView addSubview:agreeBtn];
    
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(footView);
        make.centerX.mas_equalTo(footView).offset(9);
        make.height.mas_equalTo(30);
    }];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(protocolBtn);
        make.right.mas_equalTo(protocolBtn.mas_left);
    }];
    return footView;
}
#pragma mark -- 展示口袋停线上缴费协议
- (void)showProtocol
{
    //获取文件路径
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"PshareProtrol" ofType:@"doc"];
    WebInfoModel *webModel      = [WebInfoModel new];
    webModel.urlType            = URLTypeNetLocal;
    webModel.shareType          = WebInfoModelTypeNoShare;
    webModel.title              = @"口袋停线上缴费协议";
    webModel.url                = filePath;
    webModel.imagePath          = @"";
    webModel.descibute          = @"";
    WebViewController *webView  = [[WebViewController alloc] init];
    webView.webModel            = webModel;
    [self.rt_navigationController pushViewController:webView animated:YES];
    
}
- (void)isGreenPshare:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        _tureBtn.backgroundColor = KMAIN_COLOR;
        _tureBtn.userInteractionEnabled = YES;
    }else
    {
        _tureBtn.backgroundColor = [UIColor lightGrayColor];
        _tureBtn.userInteractionEnabled = NO;
    }

}
#pragma mark -
#pragma mark - 创建tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text =self.textArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"959595"];

    if (indexPath.row == 0) {
        cell.detailTextLabel.text = _monthNum;
    }else if (indexPath.row == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [_orderModel.endDate componentsSeparatedByString:@" "][0];
    }else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = _endDate;
    }else if (indexPath.row == 3){
        if ([UtilTool isBlankString:_invoiceId]) {
            cell.detailTextLabel.text = @"不需要";
        }else
        {
            cell.detailTextLabel.text = @"需要";
        }
    }else if (indexPath.row == 4){
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"000000"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",_price];
    }
    
    
    if (indexPath.row == 0 || indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
//        填写发票
        InvoiceController *invoice = [[InvoiceController alloc]init];
        NSInteger type = self.monthPropertyVCStyle;
        invoice.state = type;
        invoice.order = self.orderModel;
        invoice.hasInvoice = [UtilTool isBlankString:_invoiceId] ? NO : YES;
        invoice.invoiceControllerBlock = ^(NSString *invoiceId){
            _invoiceId = invoiceId;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
            
        };
        
        [self.rt_navigationController pushViewController:invoice animated:YES];
    }else if (indexPath.row == 0){
        
        [self resetTimeData];
        
    }
}
- (void)resetTimeData
{
    RenewTime *renewTime;
    if (!renewTime) {
        renewTime = [[RenewTime alloc]init];
    }
    renewTime.renewTimeCallBackBlock = ^(NSDictionary *timeDic){
        NSString *temEndData = [UtilTool getCalendar:[_orderModel.endDate componentsSeparatedByString:@" "][0] WithMonthlyNum:[timeDic[@"littleNum"] integerValue]];
        
        NSInteger tem = [UtilTool compareOneDay:[UtilTool StringChangeDate:temEndData] withAnotherDay:[UtilTool StringChangeDate:_orderModel.maxDate]];
        if (tem == 1) {
            [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"您已经超出续费期限"];
        }else
        {
            _renewTimeNum = [timeDic[@"littleNum"] integerValue];
            _monthNum = timeDic[@"bigNum"];
            _price = [UtilTool StringValue:[_orderModel.price integerValue] * _renewTimeNum];
            
            _endDate = temEndData;
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:4 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[indexPath1,indexPath2,indexPath3] withRowAnimation:UITableViewRowAnimationFade];
        }
       
        
    };
    [renewTime show];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark -
#pragma mark - 创建确认按钮
- (void)createBtn{
    _tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tureBtn.frame = CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45);
    _tureBtn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
    [_tureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _tureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_tureBtn setTitle:@"立即下单" forState:UIControlStateNormal];
    [_tureBtn addTarget:self action:@selector(onTureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tureBtn];
    
    
}
#pragma mark -- 立即下单
- (void)onTureClick{
    
    MyLog(@"立即下单");
    
    PayCenterViewController *payCenter = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
    payCenter.order = [[OrderModel alloc] init];
    payCenter.order.price = _orderModel.price;
    payCenter.order.orderType = _orderModel.orderType;
//    payCenter.order.orderId = _orderModel.orderId;
    payCenter.order.parkingId = _orderModel.parkingId;
    payCenter.order.carNumber = _orderModel.carNumber;
    payCenter.order.beginDate = [self getBeginDate];
    payCenter.order.endDate   = _endDate;
    payCenter.order.monthNum  = [UtilTool StringValue:_renewTimeNum];
    payCenter.order.invoiceId = _invoiceId;
    payCenter.orderKind = self.monthPropertyVCStyle == MonthPropertyVCStyleYueZu ? PayCenterViewControllerOrferTypeYueZu : PayCenterViewControllerOrferTypeChanQuan;
    
    [self.rt_navigationController pushViewController:payCenter animated:YES];
    
    
}
- (NSString *)getBeginDate
{
    NSString *firstCharecter = [[_orderModel.endDate componentsSeparatedByString:@" "] firstObject];
    NSArray *arr = [firstCharecter componentsSeparatedByString:@"-"];
    
    if ([arr[1] intValue] < 9) {
        return [NSString stringWithFormat:@"%@-0%d-01",arr[0],[arr[1] intValue]+1];
        
    }else if ([arr[1] intValue] >= 9 &&[arr[1] intValue] <= 11){
        return [NSString stringWithFormat:@"%@-%d-01",arr[0],[arr[1] intValue]+1];
        
    } else
    {
        return [NSString stringWithFormat:@"%d-01-01",[arr[0] intValue]+1];
        
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
