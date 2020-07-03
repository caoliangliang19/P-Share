//
//  NewTemParkingVC.m
//  P-Share
//
//  Created by fay on 16/2/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewTemParkingVC.h"
#import "TableViewCell.h"
#import "HistoryCell.h"
#import "CarListViewController.h"
#import "temParkingPayResultVC.h"
#import "RequestModel.h"
#import "NSString+MD5.h"
#import "TemParkingListModel.h"
#import "NewTemParkingPayVC.h"
#import "WebViewController.h"
#import "TextFSearchCell.h"

@interface NewTemParkingVC ()<UITableViewDataSource,UITableViewDelegate,SearchOrderDelegate,PayOrderDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UITextField *_textF;
    UIAlertView *_alert;

    NSArray *_carNumArrar;
    NSMutableArray *_carNumMutableArr;

    temParkingPayResultVC *_temParkingPayResultVC;
    NSMutableArray *_dataArray;
    
    NSString *_userID;
    UIButton *_temBtn;
    
    NSMutableArray *_cancelBtnArr;
    
     __weak phoneView *_phoneV;
    UIView *_subView;
}

@end

@implementation NewTemParkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];

    [self loadData];
    
    _subView = [[UIView alloc]initWithFrame:self.view.frame];
    _subView.alpha = .4;
    _subView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_subView];
    _subView.hidden = YES;
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
    
}

- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadData
{
    _cancelBtnArr = [NSMutableArray array];
    
    _dataArray = [NSMutableArray array];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _carNumArrar = [userDefault objectForKey:customer_carNumArray];
    _userID = [userDefault objectForKey:customer_id];
    
    _carNumMutableArr = [NSMutableArray arrayWithArray:_carNumArrar];
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@",_userID,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",TemParkingOrderList,_userID,summary];
    
    
//    当用户没有搜索时  自动调出用户所有订单
//    if (_carNumArrar.count == 0) {
        BEGIN_MBPROGRESSHUD;
        [RequestModel requestTemParkingOrderWithURL:url WithTag:@"cars" Completion:^(NSArray *resultArray) {
            
            _dataArray = (NSMutableArray *)resultArray;
            [_tableView reloadData];
//            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
//            
//            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

            END_MBPROGRESSHUD;
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
            _alert = nil;
            END_MBPROGRESSHUD;
            [_dataArray removeAllObjects];
            
            [_tableView reloadData];

        }];
        
//    }

    
}

- (void)loadUI
{
//    初始化MBProgressHUD
    ALLOC_MBPROGRESSHUD;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"TextFSearchCell" bundle:nil] forCellReuseIdentifier:@"TextFSearchCell"];

    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellReuseIdentifier:@"HistoryCell"];
    
    //添加手势  让键盘消失
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];

}

-(void)dismissKeyBoard{
    [_textF resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2)
    {
        return _dataArray.count;
        
        
        
    }return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TextFSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFSearchCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textF = cell.carNumT;
        _textF.delegate = self;
        
        return cell;
    }
    
    else if (indexPath.section == 1) {
        HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        cell.delegate = self;
        cell.orderNumL.text = [NSString stringWithFormat:@"%ld",(unsigned long)_dataArray.count];
        
        if (_carNumArrar!= nil && _carNumArrar.count != 0) {
            
            cell.historyL.hidden = NO;
            
            for (int i=1; i<_carNumArrar.count+1; i++) {
                if (i<=3) {
                    UIButton *btn = [cell valueForKey:[NSString stringWithFormat:@"carNum%d",i]];
                    btn.hidden = NO;
                    [btn setTitle:_carNumArrar[_carNumArrar.count-i] forState:(UIControlStateNormal)];
                }
            }
        }
    
        cell.orderNumWidth.constant = [self getWidthWithStr:cell.orderNumL.text withFont:[UIFont systemFontOfSize:22]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.delegate = self;
    cell.payBtn.tag = indexPath.row;
    
    cell.selectBtn.tag = indexPath.row;
    
    if ([_cancelBtnArr containsObject:[NSString stringWithFormat:@"%ld",(long)cell.selectBtn.tag]]) {
        
        cell.selectImgV.image = [UIImage imageNamed:@"unselect"];
        cell.payBtn.backgroundColor = [UIColor grayColor];
    }else
    {
        cell.selectImgV.image = [UIImage imageNamed:@"selected"];
        cell.payBtn.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TemParkingListModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.carNumL.text = model.carNumber;
    cell.parkingNameL.text = model.parkingName;
    cell.startTimeL.text = model.beginDate;
    NSArray *array = [model.parkingTime componentsSeparatedByString:@"分"];
    if(array[1]){
        cell.parkingTimeL.text =[NSString stringWithFormat:@"%@分",array[0]];
    }else{
        cell.parkingTimeL.text =[NSString stringWithFormat:@"%@",model.parkingTime];
    }
    cell.priceL.text = [NSString stringWithFormat:@"%@",model.amountPayable];
    
    cell.priceWidth.constant = [self getWidthWithStr:cell.priceL.text withFont:[UIFont systemFontOfSize:22]]+10;
    
    
    return cell;
}

#pragma mark -- 字符串宽度
- (CGFloat)getWidthWithStr:(NSString *)str withFont:(UIFont *)size
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(1000, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:size} context:nil];

    return rect.size.width;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 46;
    }else if(indexPath.section == 1)
    {
        if (_carNumArrar.count == 0 || _carNumArrar == nil) {
            return 110;
            
        } return 184;

    }
    return 230;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text = [textField.text uppercaseString];
    return YES;
    
}

#pragma mark -- 自定义delegate

- (void)goToWebViewVC
{
       //获取文件路径
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"PshareProtrol" ofType:@"doc"];
    //根据本地文件路径生成url;
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.kind = @"file";
    
    webVC.url = filePath;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)agreeBtnClickDelegate:(UIButton *)btn
{
//    HistoryCell *cell = [_tableView sele]
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:2];
    TableViewCell *cell = (TableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.payBtn.userInteractionEnabled) {
        cell.selectImgV.image = [UIImage imageNamed:@"unselect"];
        cell.payBtn.backgroundColor = [UIColor grayColor];
        cell.payBtn.userInteractionEnabled = NO;
        [_cancelBtnArr addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        
    }else
    {
        cell.selectImgV.image = [UIImage imageNamed:@"selected"];
        cell.payBtn.backgroundColor = NEWMAIN_COLOR;
        cell.payBtn.userInteractionEnabled = YES;
        [_cancelBtnArr removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        
    }
   
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     [MobClick endLogPageView:@"临停下单进入"];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCarNum:) name:@"CarListViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"临停下单退出"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    __weak typeof(self) weakSelf = self;
    
    NSInteger offectY;
    if (SCREEN_WIDTH == 320) {
        offectY = -120;
    }else
    {
        offectY = -60;
        
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
        [_phoneV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.view).offset(offectY);
            
        }];
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    __weak typeof(self) weakSelf = self;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
        [_phoneV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.view);
            
        }];
        
    }];
}

- (void)getCarNum:(NSNotification *)notification
{
    _textF.text = notification.object;
    
}



- (void)goToCarMasterVC{
    CarListViewController *carMasterVC = [[CarListViewController alloc] init];
    
    carMasterVC.markForm = 1;
    
    [self.navigationController pushViewController:carMasterVC animated:YES];
}
//查找订单
- (void)searchOrder
{
    
    BOOL carRight = [self isValidateEmail:_textF.text];
    
    if (!carRight) {
        ALERT_VIEW(@"请正确输入车牌号");
        [_textF becomeFirstResponder];
        return;
    }else
    {
//        ALERT_VIEW(@"正确车牌号");
        
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_userID,_textF.text,MD5_SECRETKEY] MD5];
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",TemParkingOrderList,_userID,_textF.text,summary];
        
        BEGIN_MBPROGRESSHUD;
        [RequestModel requestTemParkingOrderWithURL:url WithTag:@"cars" Completion:^(NSArray *resultArray) {
                
            _dataArray = (NSMutableArray *)resultArray;
            [_tableView reloadData];

            
            END_MBPROGRESSHUD;
        } Fail:^(NSString *error) {
                MyLog(@"error******%@",error);
            ALERT_VIEW(error);
            _alert = nil;
            [_dataArray removeAllObjects];
            [_tableView reloadData];
            
            
            END_MBPROGRESSHUD;
                
        }];
        
        if(![_carNumMutableArr containsObject:_textF.text]){
            [_carNumMutableArr addObject:_textF.text];
        }else
        {
            [_carNumMutableArr removeObject:_textF.text];
            [_carNumMutableArr addObject:_textF.text];

        }
        _carNumArrar = [NSArray arrayWithArray:_carNumMutableArr];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_carNumArrar forKey:customer_carNumArray];
        [userDefault synchronize];

    }
    MyLog(@"%@",_textF.text);
    
}
#pragma mark -- 创建支付订单
- (void)payOrderWithBtn:(UIButton *)btn
{
      TemParkingListModel *model = [_dataArray objectAtIndex:btn.tag];
    if (CUSTOMERMOBILE(customer_mobile).length == 0) {
        
        
        _phoneV = [MyUtil addPhoneViewFor:self Name:CUSTOMERMOBILE(customer_nickname)];
        
        _subView.hidden = NO;
        
        _phoneV.cancelView = ^()
        {
            _subView.hidden = YES;
            
            [_phoneV removeFromSuperview];
            
        };
        
        _phoneV.nextVC = ^(){
            NewTemParkingPayVC *shareTemParkingVC = [[NewTemParkingPayVC alloc] init];
            shareTemParkingVC.temPayModel = model;
            
            [self.navigationController pushViewController:shareTemParkingVC animated:YES];
        };
        
        
        return;
    }
  
    
    NewTemParkingPayVC *shareTemParkingVC = [[NewTemParkingPayVC alloc] init];
    shareTemParkingVC.temPayModel = model;

    [self.navigationController pushViewController:shareTemParkingVC animated:YES];
       
   
    
}

//carNumBtnClick
- (void)searchBtnClickWithButton:(UIButton *)btn
{
    
    
    [_temBtn setBackgroundImage:nil forState:(UIControlStateNormal)];
    [_temBtn setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:(UIControlStateNormal)];

    
    _temBtn = btn;
    [_temBtn setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:(UIControlStateNormal)];
    
    
    NSString *carNum = _carNumArrar[_carNumArrar.count-1-btn.tag];
    MyLog(@"%@",carNum);
    
    _textF.text = carNum;

    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_userID,carNum,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",TemParkingOrderList,_userID,carNum,summary];
    
    BEGIN_MBPROGRESSHUD;
    [RequestModel requestTemParkingOrderWithURL:url WithTag:@"cars" Completion:^(NSArray *resultArray) {
        
        _dataArray = (NSMutableArray *)resultArray;
        [_tableView reloadData];
        
//        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
//        
//        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {

        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD;
        [_dataArray removeAllObjects];
        [_tableView reloadData];


        
    }];

    
    
}

#pragma mark -- 判断是否输入正确车牌号

//验证车牌号
-(BOOL)isValidateEmail:(NSString *)carNum
{
    NSString * strRegex =@"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$";
    
    BOOL rt = [self isValidateRegularExpression:carNum byExpression:strRegex];
    
    return rt;
}

//是否是有效的正则表达式
-(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression

{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    return [predicate evaluateWithObject:strDestination];
    
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
