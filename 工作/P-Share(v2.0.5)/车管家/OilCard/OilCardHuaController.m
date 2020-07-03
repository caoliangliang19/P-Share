//
//  OilCardHuaController.m
//  P-Share
//
//  Created by 亮亮 on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "OilCardHuaController.h"
#import "AddOilCard.h"
#import "CardPayViewController.h"
#import "OilCardOrderList.h"
#import "AddOilCardController.h"

@interface OilCardHuaController ()<passOnModel,UITextFieldDelegate,UIScrollViewDelegate>
{
    
    NSString *_payMoney;
    NSString *_readyMoney;
    NSInteger _mySign;//标记在石油还是石化支付
    BOOL _isButton;
    NSString *_proId;//选择充值类型
    NSString *_tableString;
    NSString *_clickBtn;//点击Btn的事件
    
}
@end

@implementation OilCardHuaController


- (void)viewDidLoad {
    [super viewDidLoad];
    //判断是否有加油卡
    _tableString = [[NSMutableString alloc]init];
        [self createUI];
   
  
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  SCREEN_HEIGHT - 70, 60, 60);
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.request == 2) {
        self.gengChange.userInteractionEnabled = NO;
        self.changeLable.hidden = YES;
    }
   
}
#pragma mark -
#pragma mark - 第一次进入页面没有一张加油卡
- (void)isNotAddOilCard{
    self.addOilCardView.hidden = NO;
    self.oilName.hidden = YES;
    self.oilSignImage.hidden = YES;
    self.oilCardL.hidden = YES;
    self.card4L.hidden = YES;
    self.view2.hidden = NO;
    self.view1.hidden = YES;
    self.payButton.backgroundColor = [UIColor grayColor];
    self.payButton.userInteractionEnabled = NO;
    self.gengChange.userInteractionEnabled = NO;
    self.changeLable.hidden = YES;
     self.moreImageView.hidden = YES;
    self.textView.editable=NO;
    self.textView.scrollEnabled = NO;
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
    [self.addOilCardView addGestureRecognizer:tap];
    self.scrollView.delegate = self;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
}
- (void)touchScrollView{
    [self.moneyText resignFirstResponder];
    [self.moneyText1 resignFirstResponder];
}
#pragma mark -
#pragma mark - 第二次进入页面至少有一张加油卡
- (void)isAddOilCard{
    self.addOilCardView.hidden = YES;
    self.oilName.hidden = NO;
    self.oilSignImage.hidden = NO;
    self.oilCardL.hidden = NO;
    self.card4L.hidden = NO;
    if ([self.model.cardType integerValue] == 1) {
        self.view1.hidden = YES;
        self.view2.hidden = NO;
    }else{
        self.view1.hidden = NO;
        self.view2.hidden = YES;
    }
    self.payButton.userInteractionEnabled = YES;
    self.gengChange.userInteractionEnabled = YES;
    self.payButton.backgroundColor = [MyUtil colorWithHexString:@"39D5B8"];
    self.changeLable.hidden = NO;
    self.moreImageView.hidden = NO;
    
    
    self.textView.editable=NO;
    self.textView.scrollEnabled = NO;
    self.myHeadlayOut.constant = 23;

}
#pragma mark - 
#pragma mark - 进入添加加油卡界面
- (void)onClick{

    AddOilCardController *addOil123 = [[AddOilCardController alloc]init];
    __weak typeof(self)weakSelf = self;
    addOil123.myBlock = ^(){
        [weakSelf requestModelUI];
    };
    [self.navigationController pushViewController:addOil123 animated:YES];
}
- (void)requestModelUI{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    [RequestModel requestAddOilCardListWithURL:userId WithType:nil Completion:^(NSMutableArray * array) {
    
            self.model = array[0];
            self.signString = @"2";
            [self createUI];
        
        } Fail:^(NSString *error) {
        
    }];
}
#pragma mark -
#pragma mark - UI的更新
- (void)createUI{
  
    self.scrollView.delaysContentTouches = NO;
    if ([self.signString integerValue]==1) {
        [self isNotAddOilCard];
    }else if ([self.signString integerValue]== 2){
        [self isAddOilCard];
        self.addOilCardView.hidden = YES;
    }
    _payMoney = @"0";
    _readyMoney = @"0";
    self.moneyText1.delegate = self;
    self.moneyText.delegate = self;
    self.secondView.layer.cornerRadius = 6;
    self.secondView.clipsToBounds = YES;
    self.secondView.layer.borderWidth = 1;
    self.secondView.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    self.view1.layer.cornerRadius = 6;
    self.view1.clipsToBounds = YES;
    self.view1.layer.borderWidth = 1;
    self.view1.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    self.view2.layer.cornerRadius = 6;
    self.view2.clipsToBounds = YES;
    self.view2.layer.borderWidth = 1;
    self.view2.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    
    
    self.myButton1.layer.borderWidth =1;
    self.myButton1.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    self.myButton1.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.myButton2.layer.borderWidth =1;
    self.myButton2.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    self.myButton2.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.myButton3.layer.borderWidth =1;
    self.myButton3.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    self.myButton3.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    if ([self.model.cardType integerValue]==1) {
        [self chinaShiHua:self.model];
    }else if([self.model.cardType integerValue] == 2){
        [self chinaShiyou:self.model];
    }
    _payMoney = @"100";
    _proId = @"10001";
    [self.myButton1 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
    [self.myButton2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.myButton3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if ([self.model.cardType integerValue] == 1){
    CGFloat price = [_payMoney floatValue]*0.99;
    _readyMoney = [NSString stringWithFormat:@"%.2lf",price];
    NSString *str = [NSString stringWithFormat:@"支付%.2lf元",price];
    self.payButton.titleLabel.text = str;
    [self.payButton setTitle:str forState:UIControlStateNormal];
    }else{
        CGFloat price = [@"0" floatValue]*0.99;
        _readyMoney = [NSString stringWithFormat:@"%.2lf",price];
        NSString *str = [NSString stringWithFormat:@"支付%.2lf元",price];
        self.payButton.titleLabel.text = str;
        [self.payButton setTitle:str forState:UIControlStateNormal];
    }
    //监听键盘变化,
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)chinaShiHua:(OilCardModel *)model{
    _mySign = 10;
    self.oilName.text = @"中国石化";
    self.heightLayOut.constant = 28;
    self.oilSignImage.image = [UIImage imageNamed:@"sinopec_w"];
    NSString *card4 = [self create:model.cardNo];
    self.card4L.text = card4;
    self.myHeadlayOut.constant = 23;
    
}

- (void)chinaShiyou:(OilCardModel *)model{
    _mySign = 11;
    self.oilName.text = @"中国石油";
    self.heightLayOut.constant = 28;
    self.oilSignImage.image = [UIImage imageNamed:@"cnpc"];
    self.card4L.text =[self create:model.cardNo];
    self.myHeadlayOut.constant = -30;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 键盘 改变通知 弹键盘
-(void)keyboardWasChange:(NSNotification *)notification
{
   
    [self.view bringSubviewToFront:self.headView];
    NSDictionary *info = [notification userInfo];
    if ([[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y != [UIScreen mainScreen].bounds.size.height) {
        self.headLayOut.constant = -50;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self.myButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.myButton2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.myButton3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else {
        
        if ([_clickBtn isEqualToString:@"Btn"]) {
            [self.payButton setTitle:[NSString stringWithFormat:@"支付%@元",_readyMoney] forState:UIControlStateNormal];
            self.headLayOut.constant = 19;
            [UIView animateWithDuration:1 animations:^{
                [self.view layoutIfNeeded];
            }];
            return;
        }
        
        if (_mySign == 10) {//中石化
            _payMoney = self.moneyText.text;
            _proId = @"10007";
        }else if(_mySign == 11){//中石油
            _payMoney = self.moneyText1.text;
            _proId = @"10008";
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",_payMoney];
        CGFloat price = [str floatValue]*1.003;
        NSString *str1 = [NSString stringWithFormat:@"%.3f",price];
        _readyMoney = [self createFloatValue:str1];
        self.payButton.titleLabel.text = [NSString stringWithFormat:@"支付%@元",_readyMoney];
        [self.payButton setTitle:[NSString stringWithFormat:@"支付%@元",_readyMoney] forState:UIControlStateNormal];
       
        self.headLayOut.constant = 19;
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        
    }
}
- (IBAction)payButtonClick:(id)sender {
    CardPayViewController *cardPay = [[CardPayViewController alloc]init];
    cardPay.model = self.model;
    cardPay.myMoney = _readyMoney;
    cardPay.proid = _proId;
    cardPay.Money = _payMoney;
    [self.navigationController pushViewController:cardPay animated:YES];
    
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 
#pragma mark - 三个按钮 选择金额
- (IBAction)moneyBtn:(UIButton *)sender;{
    _isButton = YES;
    if (sender.tag == 10) {
        _payMoney = @"100";
        _proId = @"10001";
         [self.myButton1 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
         [self.myButton2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
         [self.myButton3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if(sender.tag == 50){
        _payMoney = @"500";
        _proId = @"10003";
        [self.myButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.myButton2 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
        [self.myButton3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if(sender.tag == 100){
        _payMoney = @"1000";
        _proId = @"10004";
        [self.myButton1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.myButton2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.myButton3 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
    }
  
    CGFloat price = [_payMoney floatValue]*0.99;
    _readyMoney = [NSString stringWithFormat:@"%.2lf",price];
       NSString *str = [NSString stringWithFormat:@"支付%.2lf元",price];
    self.payButton.titleLabel.text = str;
    [self.payButton setTitle:str forState:UIControlStateNormal];
    _clickBtn = @"Btn";
    [self removeOilBtnTitle];
    
}
#pragma mark - 加油卡列表界面回调代理
- (void)passOnChange:(OilCardModel *)model;{
    self.model = model;
   
    [self createUI];
    
}

#pragma mark - 进入加油卡列表界面
- (IBAction)cjangeClick:(id)sender {
    AddOilCard *addOil = [[AddOilCard alloc]init];
    addOil.delegate = self;
    [self.navigationController pushViewController:addOil animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma  mark -
#pragma mark - UITextField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    
    _clickBtn = @"noBtn";
    
    static NSString *str = nil;
    if (range.length == 0) {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        _tableString = str;
        
       
    }else if (range.length == 1) {
        NSString *str1 = [str substringToIndex:range.location];
        _tableString = str1;
    }else{
        [self.moneyText resignFirstResponder];
        [self.moneyText1 resignFirstResponder];
        
        return NO;
    }
//    if (range.length == 0) {
//       [_tableString appendFormat:@"%@",string];
//    }else if (range.length == 1){
//        [_tableString deleteCharactersInRange:NSMakeRange(range.location, 1)];
//    }
    if(textField == self.moneyText){
        NSString *str = [NSString stringWithFormat:@"%@",_tableString];
        _payMoney = str;
        _proId = @"10007";
        CGFloat price = [str floatValue]*1.003;
        NSString *str1 = [NSString stringWithFormat:@"%.3f",price];
        _readyMoney = [self createFloatValue:str1];
         self.payButton.titleLabel.text = [NSString stringWithFormat:@"支付%@元",_readyMoney];
         [self.payButton setTitle:
          
          [NSString stringWithFormat:@"支付%@元",_readyMoney] forState:UIControlStateNormal];
    }else if(textField == self.moneyText1){
        NSString *str = [NSString stringWithFormat:@"%@",_tableString];
        _payMoney = str;
          _proId = @"10008";
        CGFloat price = [str floatValue]*1.003;
        NSString *str1 = [NSString stringWithFormat:@"%.3f",price];
         _readyMoney = [self createFloatValue:str1];
        self.payButton.titleLabel.text = [NSString stringWithFormat:@"支付%@元",_readyMoney];
        [self.payButton setTitle:[NSString stringWithFormat:@"支付%@元",_readyMoney] forState:UIControlStateNormal];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [self.moneyText resignFirstResponder];
    [self.moneyText1 resignFirstResponder];
    return YES;
}




#pragma mark - 计算实际充值金额
- (NSString *)createFloatValue:(NSString *)str{

    CGFloat myfloat = [str doubleValue]+0.001;
//    CGFloat myfloat1 = ceil(myfloat);
//    CGFloat myfloat2 = myfloat1/100;
    
    NSString *str1 = [NSString stringWithFormat:@"%.2lf",myfloat];
    return str1;
}
#pragma mark - 
#pragma mark - 进入订单列表界面
- (IBAction)myOrderList:(id)sender {
    OilCardOrderList *list = [[OilCardOrderList alloc]init];
    
    [self.navigationController pushViewController:list animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self removeOilBtnTitle];
    [self removeOilBtn1];
}
- (void)removeOilBtnTitle{
    
    
    
}
- (void)removeOilBtn1{
    [self.moneyText resignFirstResponder];
    [self.moneyText1 resignFirstResponder];
    [self.payButton setTitle:[NSString stringWithFormat:@"支付%@元",@"0.00"] forState:UIControlStateNormal];
}
- (NSMutableString *)create:(NSString *)string{
    NSMutableString *string1 = [[NSMutableString alloc]init];
    for (int i = 0; i< string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        [string1 appendFormat:@"%c",ch];
        if (i%4 == 3&&i > 0) {
            [string1 appendString:@" "];
        }
    }
    return string1;
}

@end
