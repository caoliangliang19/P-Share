//
//  InvoiceController.m
//  P-Share
//
//  Created by 亮亮 on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "InvoiceController.h"
#import "RadioCell.h"
#import "SwitchCell.h"
#import "TextFieldCell.h"
@interface InvoiceController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton    *_tureBtn;
//    寄送方式 0:送票上门 1:寄送
    NSInteger   _sendType;

    
}
@property (nonatomic,strong)UITableView *tableView;
//    发票名称 个人或公司名称
@property (nonatomic,copy)  NSString    *invoiceName;
//    寄送地址
@property (nonatomic,copy)  NSString    *invoiceAddress;



@end

@implementation InvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sendType = 0;
    [self addHeadView];
    [self createTableView];
    [self createBtn];
}
- (void)addHeadView{
    if (self.state == CLLIsNotInvoiceStateMonth) {

        self.title = @"月租支付";
    }else{
        self.title = @"产权支付";

    }
}
- (void)setHasInvoice:(BOOL)hasInvoice
{
    _hasInvoice = hasInvoice;
    if (hasInvoice) {
        [self loadInvoiceData];
    }
}

#pragma mark -
#pragma mark - 创建TableView；
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_tableView registerClass:[RadioCell class] forCellReuseIdentifier:@"RadioCell"];
    [_tableView registerClass:[TextFieldCell class] forCellReuseIdentifier:@"TextFieldCell"];
    [_tableView registerClass:[SwitchCell class] forCellReuseIdentifier:@"SwitchCell"];
    
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_hasInvoice == NO) {
        return 1;
    }else{
        return 4;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 3;
    }else if(section == 3){
        return 2;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        WS(ws)
        cell.rightSwitch.on = _hasInvoice ? YES : NO;
        cell.switchClick = ^(SwitchCell *cell,UISwitch *rightSwitch){
            if (rightSwitch.isOn == YES) {
                ws.hasInvoice = YES;
                [ws loadInvoiceData];
            }else{
                ws.hasInvoice = NO;
                if (ws.invoiceControllerBlock) {
                    ws.invoiceControllerBlock(@"");
                }
                
            }
            [ws.tableView reloadData];
        };
        
        cell.titleL.text = @"是否需要发票";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1 || indexPath.section == 3){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.textLabel.text = indexPath.section == 1 ? @"发票抬头":@"寄送地址";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.placeholder = indexPath.section == 1 ? @"个人或公司全称":@"详细地址(如门牌号等)";
            cell.textField.text = indexPath.section == 1 ? _invoiceName:_invoiceAddress;
            WS(ws)
            cell.textFieldCellCallBackBlock = ^(UITextField *textField){
                
                if (indexPath.section == 1) {
                    ws.invoiceName = textField.text;
                }else
                {
                    ws.invoiceAddress = textField.text;
                }
            };

            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.textLabel.text = @"寄送方式";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else
        {
            RadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioCell"];
            cell.titleL.text = indexPath.row == 1 ? @"送票上门":@"寄送";
            if (indexPath.row-1 == _sendType) {
                cell.isSelect = YES;
            }else
            {
                cell.isSelect = NO;
            }
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        _sendType = indexPath.row-1;
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationFade)];
        MyLog(@"%ld",_sendType);
    }
    
}
#pragma mark -
#pragma mark - 创建确认按钮
- (void)createBtn{
    _tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tureBtn.frame = CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45);
    _tureBtn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
    [_tureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _tureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_tureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_tureBtn addTarget:self action:@selector(onTureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tureBtn];
    
    
}

#pragma mark - 获取发票信息
- (void)loadInvoiceData
{
    NSString *summey = [[NSString stringWithFormat:@"%@%@%@",[UtilTool getCustomId],_order.parkingId,SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(getLatestInvoiceInfo),[UtilTool getCustomId],_order.parkingId,summey];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        MyLog(@"%@",responseObject);
//        invoiceDescribe: 发票说明  暂未用上
        _invoiceAddress = responseObject[@"invoice"][@"sendAddress"];
        _invoiceName = responseObject[@"invoice"][@"invoiceName"];
        if (![UtilTool isBlankString:responseObject[@"invoice"][@"sendType"]]) {
            _sendType = [responseObject[@"invoice"][@"sendType"] integerValue];
        }
        [_tableView reloadData];
        
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
}
- (void)onTureClick{
   
    MyLog(@"%@   %@",_invoiceName,_invoiceAddress);
    if ([UtilTool isBlankString:_invoiceName]) {
        [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"发票抬头不能为空"];
    }else if ([UtilTool isBlankString:_invoiceAddress] && _sendType == 1)
    {
        [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"寄送地址不能为空"];
    }
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",_invoiceName,@"invoiceName",[UtilTool StringValue:_sendType],@"sendType",_invoiceAddress,@"sendAddress",_order.carNumber,@"carNumber",[UtilTool getTimeStamp],@"timestamp", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(postInvoiceInfo) WithDic:dict needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        MyLog(@"%@",responseObject);
        if (self.invoiceControllerBlock) {
            self.invoiceControllerBlock(responseObject[@"invoiceId"]);
            [self.rt_navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
    
//    [self.rt_navigationController popViewControllerAnimated:YES];
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
