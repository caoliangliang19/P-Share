//
//  NewMonthlyRentPayVC.m
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewMonthlyRentPayVC.h"
#import "NewMonthlyRentPayCell.h"
#import "NewMonthlyRentAuthCodeCell.h"
#import "SuccessCell.h"
#import "RendPayForController.h"
#import "WebViewController.h"
#import "NSString+Encrypt.h"
#import "InvoiceView.h"

#define Check @"0"

@interface NewMonthlyRentPayVC ()<UITableViewDataSource,UITableViewDelegate,NewMonthlyRentPayCellDelegate,NewMonthlyRentAuthCodeCellDeleaget>
{
    NSMutableArray *_cancelBtnArr;
    NSUserDefaults *_user;
    NSTimer *_buttonTimer;
    int _getCodeCount;
    UITextField *_messageCode;
    NSString *_validateResult;
    
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    __block UIAlertView *_alert;
    
    UIButton *_temBtn;
    
    NSString *_orderKind;
    NSString *_userId;
    
}
@property (nonatomic,strong)UIButton *getTextCodeBtn;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)InvoiceView *invoice;


@end

@implementation NewMonthlyRentPayVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    
    
    
}

- (void)loadData
{
    _orderKind = [_orderType isEqualToString:@"13"]?@"《口袋停线上缴费协议》":@"《口袋停线上缴费协议》";
    _titleL.text = [_orderType isEqualToString:@"13"]?@"月租支付":@"产权支付";
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _userId = [userDefaultes objectForKey:customer_id];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKeyboard)];
    
    self.tableV.userInteractionEnabled = YES;
    
    [self.tableV addGestureRecognizer:tapGesture];
    
    _getCodeCount = 60;
    _cancelBtnArr = [NSMutableArray array];
    _user = [NSUserDefaults standardUserDefaults];
    
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableV registerNib:[UINib nibWithNibName:@"NewMonthlyRentPayCell" bundle:nil] forCellReuseIdentifier:@"NewMonthlyRentPayCell"];
    [_tableV registerNib:[UINib nibWithNibName:@"NewMonthlyRentAuthCodeCell" bundle:nil] forCellReuseIdentifier:@"NewMonthlyRentAuthCodeCell"];
    [_tableV registerNib:[UINib nibWithNibName:@"SuccessCell" bundle:nil] forCellReuseIdentifier:@"SuccessCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"PaySuccess" object:nil];
    [self.tableV reloadData];
}
- (void)paySuccess
{
    NewMonthlyRentPayCell *cell;
    if ([_model.allow intValue] == 0) {
       cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }else
    {
        cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    }
    cell.payBtn.backgroundColor = [UIColor grayColor];
    cell.payBtn.userInteractionEnabled = NO;
    [cell.payBtn setTitle:@"已支付" forState:(UIControlStateNormal)];
    
}
- (void)downKeyboard
{
    [_messageCode resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MyLog(@"%@",_model.allow);
    
    if ([_model.allow intValue] != 0) {
        return 20;
    }
    
    return 0.1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_model.allow intValue] == 0) {
//        需要验证手机号
        return 2;
        
    }else{
        
        return 1;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.allow intValue] == 0)
    {
        if(indexPath.row == 0){
            if (![_validateResult isEqualToString:@"验证通过"]) {
                NewMonthlyRentAuthCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMonthlyRentAuthCodeCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                _getTextCodeBtn = cell.getAuthCodeBtn;
                
                _messageCode = cell.authCode;
                
                cell.delegate = self;
                
                return cell;
            }else
            {
                SuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuccessCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        
        return  [self createCell:tableView cellForRowAtIndexPath:indexPath];
        
    }else
    {
       return [self createCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

- (UITableViewCell *)createCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMonthlyRentPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMonthlyRentPayCell"];
    
    cell.agreeL.text = [NSString stringWithFormat:@"我已同意%@",_orderKind];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.agreeL.text];
    NSRange redRange1 = NSMakeRange([[noteStr string] rangeOfString:_orderKind].location, [[noteStr string] rangeOfString:_orderKind].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:NEWMAIN_COLOR range:redRange1];
    [cell.agreeL setAttributedText:noteStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.parkingNameL.text = _model.parkingName;
    cell.carNumL.text = _model.carNumber;
    cell.endTimeL.text = [NSString stringWithFormat:@"到期时间: %@", [[_model.endDate componentsSeparatedByString:@" "] firstObject]];
    cell.jiaoFeeEndTimeL.text = [MyUtil getCalendar:[[cell.endTimeL.text componentsSeparatedByString:@": "] lastObject] WithMonthlyNum:1];
    cell.maxDate = _model.maxDate;
    cell.InvoiceSwitch.on = NO;
   
    cell.selectBtn.tag = indexPath.row;
    cell.InvoiceSwitch.tag = indexPath.row;
    cell.delegate  =self;
    
    if ([_model.allow intValue] == 0) {
        cell.danJiaL.text = @"-";
        cell.priceL.text = @"-";
        if ([_validateResult isEqualToString:@"验证通过"]) {
            cell.selectBtn.userInteractionEnabled = YES;
            cell.payBtn.userInteractionEnabled = YES;
            
            cell.danJiaL.text = [NSString stringWithFormat:@"%@",_model.price];
            
            cell.priceL.text = cell.danJiaL.text;
            
            cell.selectImgV.image = [UIImage imageNamed:@"agree"];
            cell.payBtn.backgroundColor = [MyUtil colorWithHexString:@"39D5B8"];
            if ([_cancelBtnArr containsObject:[NSString stringWithFormat:@"%ld",(long)cell.selectBtn.tag ]]) {
                cell.selectImgV.image = [UIImage imageNamed:@"disagree"];
                cell.payBtn.backgroundColor = [UIColor grayColor];
                
            }else
            {
                cell.selectImgV.image = [UIImage imageNamed:@"agree"];
                cell.payBtn.backgroundColor = [MyUtil colorWithHexString:@"39D5B8"];
                
            }
        }

    }else
    {
        cell.selectBtn.userInteractionEnabled = YES;
        cell.payBtn.userInteractionEnabled = YES;
        NSString *price = [NSString stringWithFormat:@"%@",_model.price];
        
        cell.danJiaL.text = [[price componentsSeparatedByString:@"."] firstObject];
        cell.priceL.text = cell.danJiaL.text;
        cell.selectImgV.image = [UIImage imageNamed:@"agree"];
        cell.payBtn.backgroundColor = [MyUtil colorWithHexString:@"39D5B8"];
        
    }
    __weak NewMonthlyRentPayCell *weakCell = cell;
    
    cell.gotoWebVC = ^(){
        //获取文件路径
        NSString * filePath = [[NSBundle mainBundle]pathForResource:@"PshareProtrol" ofType:@"doc"];
        //根据本地文件路径生成url;
        
        WebViewController *webVC = [[WebViewController alloc]init];
        webVC.kind = @"file";
        
        webVC.url = filePath;
        
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    cell.gotoMonthiyPayVC = ^()
    {
        
        NSInteger tem = [weakCell compareOneDay:[weakCell StringChangeDate:weakCell.jiaoFeeEndTimeL.text] withAnotherDay:[weakCell StringChangeDate:weakCell.maxDate]];
        //判断当前月租到期时间是否大于或者等于最大缴费时间
        if (tem == 1) {
            ALERT_VIEW(@"您已经超出续费期限");
            return ;
        }
        
        
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_model.parkingId,@"parkingId",_userId,@"customerId",_model.carNumber,@"carNumber",_orderType,@"orderType",[self getStartTime],@"beginDate", weakCell.monthNumL.text,@"monthNum",[MyUtil getTimeStamp],@"timestamp",self.invoiceId,@"invoiceId",nil];
        
        RendPayForController *payVC = [[RendPayForController alloc] init];
        payVC.paramDic = paramDic;
        payVC.price = [NSString stringWithFormat:@"%@",_model.price];
        payVC.parkingId = _model.parkingId;
        
        OrderPointModel *orderModel = [OrderPointModel shareOrderPoint];
        
        if([_orderType isEqualToString:@"13"])
        {
            orderModel.monthly++;
            
        }else
        {
            orderModel.equity++;
        }
        
        
        [self.navigationController pushViewController:payVC animated:YES];
        
    };
    return cell;

}

- (NSString *)getStartTime
{
    NSString *firstCharecter = [[_model.endDate componentsSeparatedByString:@" "] firstObject];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.allow intValue] == 0){
        if (indexPath.row == 0) {
            if (![_validateResult isEqualToString:@"验证通过"]){
                return 127;

            }else
            {
                return 80;
            }
        }
        return 297;

    }
    return 297;

    
}


#pragma mark -- 协议相关

- (void)getMonthNum:(UIButton *)btn
{
    if (btn.tag == 0) {
        
    }
}

- (void)getAuthCodeWith:(UIButton *)btn
{
    
    NSString *Summary = [[NSString stringWithFormat:@"%@%@",_model.mobile,MD5_SECRETKEY] md5];
    
    NSDictionary *paramDic = @{MOBILE_CUSTOMER:_model.mobile,SUMMARY:Summary};
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",GETREGISTER_CODE,paramDic[MOBILE_CUSTOMER],paramDic[SUMMARY]];
    
    
    [RequestModel requestGetPhoneNumWithURL:urlStr WithDic:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"errorNum"] isEqualToString:@"0"])
        {
            NewMonthlyRentAuthCodeCell *cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.infoL.text = [NSString stringWithFormat:@"已发送短信至您尾号%@的手机",[_model.mobile substringFromIndex:7]];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.infoL.text];
            [str addAttribute:NSForegroundColorAttributeName value:[MyUtil colorWithHexString:@"39d5b8"] range:NSMakeRange(9,4)];
            
            cell.infoL.attributedText = str;
            
            _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefresh) userInfo:nil repeats:YES];
            [_buttonTimer fire];
            
        }else
        {
            ALERT_VIEW(@"验证异常");
            _alert = nil;
            END_MBPROGRESSHUD;
        }
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD;
    }];

}

- (void)sureCommitAuthCode:(UIButton *)btn
{

    _getCodeCount = 60;
   
    if(_messageCode.text.length == 0 ){
        ALERT_VIEW(@"请输入验证码");
        return;
    }
    
    if (_messageCode.text.length == 4) {
//        月租13  产权14
        
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        self.getTextCodeBtn.enabled = YES;
        [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getTextCodeBtn setTitleColor:[MyUtil colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        self.getTextCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39D5B8"].CGColor;

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_user objectForKey:customer_id],@"customerId",_orderType,@"orderType",_messageCode.text,@"varlidateCode",_model.parkingId,@"parkingId",_model.carNumber,@"carNumber",[MyUtil getTimeStamp],@"timestamp", nil];
        
        [RequestModel validateCodeWithURL:VALIDATECODE WithDic:dic Completion:^(NSString *result) {
            
            if ([result isEqualToString:@"0"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"monthlyLoadDate" object:@"notification"];
                
                _validateResult = @"验证通过";
                
                [_tableV reloadData];
                
            }else{
                
                _validateResult = @"验证失败";
                ALERT_VIEW(@"请输入正确验证码");
                _alert = nil;

            }
            
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
        }];
        
        
    }else
    {
        ALERT_VIEW(@"请输入正确验证码");
        _alert = nil;
        
    }
}


- (void)agreeBtnClick:(UIButton *)btn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    NewMonthlyRentPayCell *cell = (NewMonthlyRentPayCell *)[self.tableV cellForRowAtIndexPath:indexPath];
    if (cell.payBtn.userInteractionEnabled) {
        cell.selectImgV.image = [UIImage imageNamed:@"disagree"];
        cell.payBtn.backgroundColor = [UIColor grayColor];
        cell.payBtn.userInteractionEnabled = NO;
        [_cancelBtnArr addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        
    }else
    {
        cell.selectImgV.image = [UIImage imageNamed:@"agree"];
        cell.payBtn.backgroundColor = [MyUtil colorWithHexString:@"39D5B8"];
        cell.payBtn.userInteractionEnabled = YES;
        [_cancelBtnArr removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        
    }
    
    
}
#pragma mark - 
#pragma mark - Switch代理
- (void)getSwitchIsOn:(UISwitch *)swith{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:swith.tag inSection:0];
    NewMonthlyRentPayCell *cell = (NewMonthlyRentPayCell *)[self.tableV cellForRowAtIndexPath:indexPath];
    if (cell.InvoiceSwitch.isOn == YES) {
        
        NSString *summey = [[NSString stringWithFormat:@"%@%@%@",CUSTOMERMOBILE(customer_id),_model.parkingId,MD5_SECRETKEY] MD5];
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",getLatestInvoiceInfo,CUSTOMERMOBILE(customer_id),_model.parkingId,summey];
        [RequestModel requestGetLatestInvoiceInfoWithURL:url Completion:^(NSDictionary *dict) {
            [self creatAlertView:dict mySwitch:swith];
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
            _alert = nil;
        }];        
    }    
}
#pragma mark - 
#pragma mark - 弹出发票
- (void)creatAlertView:(NSDictionary *)dict mySwitch:(UISwitch *)swith{
    _invoice = [InvoiceView shareInstance];
    _invoice.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _invoice.bounds = CGRectMake(0, 0, 281, 360);
    _invoice.invHeadField.text = dict[@"invoice"][@"invoiceName"];
    _invoice.invAddressField.text = dict[@"invoice"][@"sendAddress"];
    _invoice.sendType =  dict[@"invoice"][@"sendType"];
    _invoice.textLable.text = dict[@"invoice"][@"invoiceDescribe"];
    [_invoice animatedIn];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.3;
    __weak typeof(self) weakSelf = self;
    _invoice.cancleBlock = ^(){
        swith.on = NO;
        weakSelf.bgView.hidden = YES;
        [weakSelf.view endEditing:YES];
        
    };
    _invoice.tureBlock = ^(NSString *invoiceName,NSString *invoiceAddress,NSString *sendType){
        
        
    
        MyLog(@"%@",sendType);
        if (sendType.length<1) {
            sendType = @"0";
        }
        
        
        if ([sendType isEqualToString:@"1"] && self.invoice.invAddressField.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"寄送上门地址不能为空" message:nil delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            return ;
        }
        
        if (self.invoice.invHeadField.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发票抬头不能为空" message:nil delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            return ;
        }

        [weakSelf.invoice animatedOut];
        weakSelf.bgView.hidden = YES;
        [weakSelf.view endEditing:YES];
        

        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",invoiceName,@"invoiceName",sendType,@"sendType",invoiceAddress,@"sendAddress",weakSelf.model.carNumber,@"carNumber",[MyUtil getTimeStamp],@"timestamp", nil];
        [RequestModel requestPostInvoiceInfoWithURL:postInvoiceInfo WithDic:dict Completion:^(NSDictionary *dict) {
           
            if ([dict[@"errorNum"] isEqualToString:@"0"]) {
                weakSelf.invoiceId = dict[@"invoiceId"];
                swith.on = YES;
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"errorInfo"] delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;

                
            }
        } Fail:^(NSString *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            [weakSelf.invoice animatedOut];
            weakSelf.bgView.hidden = YES;
            [weakSelf.view endEditing:YES];
            swith.on = NO;
            
        }];
    };
    [self.view addSubview:_bgView];
    [self.view addSubview:_invoice];
    
}
#pragma mark - 键盘 改变通知 弹键盘
-(void)keyboardWasChange:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    
    
    if ([[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y != [UIScreen mainScreen].bounds.size.height) {
       
        _invoice.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [UIView animateWithDuration:0.3 animations:^{
            _invoice.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-100);
        }];
    }else {
     
        [UIView animateWithDuration:1 animations:^{
            _invoice.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        }];
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ButtonTitleRefresh
{
    [self.getTextCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.getTextCodeBtn.enabled = NO;
    self.getTextCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    self.getTextCodeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.getTextCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        self.getTextCodeBtn.enabled = YES;
        [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getTextCodeBtn setTitleColor:[MyUtil colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        self.getTextCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39D5B8"].CGColor;

        _getCodeCount = 60;
    }
    _getCodeCount--;
    
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
