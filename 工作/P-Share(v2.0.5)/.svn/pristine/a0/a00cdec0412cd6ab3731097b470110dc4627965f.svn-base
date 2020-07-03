//
//  AddOilCardController.m
//  P-Share
//
//  Created by 亮亮 on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "AddOilCardController.h"
#import "RequestModel.h"
@interface AddOilCardController ()
{
    UIScrollView *_scrollView;
    BOOL _OilCartType;//No为中国石油  Yes为中国石化
    UIAlertView *_alert;
}
@end

@implementation AddOilCardController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self createUI];
  
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)createUI{
   
    self.shiHuaL.layer.cornerRadius = 6;
    self.shiHuaL.clipsToBounds = YES;
    self.shiHuaL.layer.borderColor = NEWMAIN_COLOR.CGColor;
    self.shiHuaL.layer.borderWidth = 1;
    self.shiYouL.layer.cornerRadius = 6;
    self.shiYouL.clipsToBounds = YES;
 
   
    self.tureBtn.layer.cornerRadius = 3;
    self.tureBtn.clipsToBounds = YES;
    
    _OilCartType = YES;
    
    UITapGestureRecognizer *shiHuaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onShiHuaClick)];
    [self.shiHuaL addGestureRecognizer:shiHuaTap];
    UITapGestureRecognizer *shiYouTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onShiYouClick)];
    [self.shiYouL addGestureRecognizer:shiYouTap];
    //监听键盘变化,
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)onShiHuaClick{
    _OilCartType = YES;
    self.shiYouL.layer.borderWidth = 1;
    self.shiYouL.layer.borderColor = [UIColor whiteColor].CGColor;
    self.shiHuaSelect.image = [UIImage imageNamed:@"selected_g"];
    self.shiYouSelect.image = [UIImage imageNamed:@""];
    self.shiHuaL.layer.borderWidth = 1;
    self.shiHuaL.layer.borderColor = NEWMAIN_COLOR.CGColor;
}
- (void)onShiYouClick{
    _OilCartType = NO;
    self.shiHuaL.layer.borderWidth = 1;
    self.shiHuaL.layer.borderColor = [UIColor whiteColor].CGColor;
    self.shiHuaSelect.image = [UIImage imageNamed:@""];
    self.shiYouSelect.image = [UIImage imageNamed:@"selected_g"];
    self.shiYouL.layer.borderWidth = 1;
    self.shiYouL.layer.borderColor = NEWMAIN_COLOR.CGColor;
}
#pragma mark - 键盘 改变通知 弹键盘
-(void)keyboardWasChange:(NSNotification *)notification
{
   [self.view bringSubviewToFront:self.headView];
    NSDictionary *info = [notification userInfo];
    if ([[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y != [UIScreen mainScreen].bounds.size.height) {
        self.shangLayOut.constant = -50;
        
        [UIView animateWithDuration:0.3 animations:^{
           [self.view layoutIfNeeded];
        }];
      }else {
        self.shangLayOut.constant = 19;
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
        }];
       
     
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

- (IBAction)tureBtnClick:(id)sender {
    
    NSString *cardType = nil;
    NSString *phoneNumber = nil;
    NSString *cardNumber = nil;
    if (_OilCartType == NO) {
        cardType = [NSString stringWithFormat:@"2"];
    }else{
         cardType = [NSString stringWithFormat:@"1"];
    }
    if(self.phoneText.text.length != 11){
        ALERT_VIEW(@"请输入正确的手机号");
        _alert = nil;
        return;

    }else{
        phoneNumber = self.phoneText.text;
    }
    if ([[self panduanAddOilCard] integerValue] == 100011||[[self panduanAddOilCard] integerValue] == 9) {
         cardNumber = self.addOilText.text;
    }else{
        ALERT_VIEW(@"请输入正确的加油卡号");
       return;
    }
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    //        NSDictionary *paramDic = @{customer_id:userId};
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId,@"customerId",cardNumber,@"cardNo",self.nameText.text,@"cardName",phoneNumber,@"cardMobile",cardType,@"cardType",nil];
    [RequestModel requestGetAddOilCardWithURL:nil WithDic:paramDic Completion:^(NSMutableArray *resultArray) {
        MyLog(@"%@",resultArray[0]);
        if (self.myBlock) {
            self.myBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } Fail:^(NSString *error) {
        
    }];
   
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (NSString *)panduanAddOilCard{
    NSString *str = nil;
    if (_OilCartType == YES) {
        if (self.addOilText.text.length>6) {
            str = [self.addOilText.text substringToIndex:6];
        }else
        {
            str = self.addOilText.text;
            
        }
    }else{
        str = [self.addOilText.text substringToIndex:1];
    }
    MyLog(@"%@",str);
    return str;
}
@end
