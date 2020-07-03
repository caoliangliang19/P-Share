//
//  CarSetVC.m
//  P-Share
//
//  Created by fay on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarSetVC.h"
#import "CustomAlertView.h"
@interface CarSetVC ()
{
    UIAlertView *_alert;
}
@end

@implementation CarSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([_carModel.carIsAutoPay integerValue] == 1) {
        _descributeL.text = @"已开启钱包自动支付";
        [_descributeL setTextColor:[MyUtil colorWithHexString:@"39D5B8"]];

        
        _switchBtn.on = YES;
    }else
    {
        _descributeL.text = @"未开启钱包自动支付";
        [_descributeL setTextColor:[MyUtil colorWithHexString:@"A7A7A7"]];

        _switchBtn.on = NO;
    }
    [self loadUI];
    
}
- (void)loadUI
{
    _switchBtn.tintColor = NEWMAIN_COLOR;
    _switchBtn.onTintColor = NEWMAIN_COLOR;
    
    _carNumL.text = _carModel.carNumber;
    _switchBtn.on = [_carModel.carIsAutoPay integerValue];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchBtnClick:(UISwitch *)sender {
    
    NSInteger temNum = [sender isOn] ? 1 : 0;
    
    
    if (temNum == 1) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) titleName:@"自动支付协议"];
        [alertView myTitleText:@"1.钱包安全自动支付功能用来支付已开通口袋停线上支付车场的停车费用2.当您的车辆离场时,系统会自动从钱包余额中自动支付本次停车费用,无需其它任何操作3.未开通口袋停线上支付的车场不支持此项功能4.本功能只在钱包的余额大于等于当次待支付费用时生效,当余额不足时,请线下付费或手动进行线上停车缴费功能5.自动支付成功后,对应车牌的车辆将被自动放行6.口袋停在法律规定范围内，对钱包安全自动支付功能涉及的各方面情况拥有解释权" Block:^{
            [self sendRequest:temNum WithSwitch:sender];
            [alertView dismissAlertView];
            
        } canBlock:^{
            _switchBtn.on = 0;
            [alertView dismissAlertView];
        }];
        
        alertView.backgroundColor = [UIColor whiteColor];
        [alertView showAlertView];
    }else
    {
        [self sendRequest:temNum WithSwitch:sender];

    }


    
}

- (void)sendRequest:(NSInteger)temNum WithSwitch:(UISwitch *)sender
{
    
    NSString *summary = [[NSString stringWithFormat:@"%@%ld%@",_carModel.carId,(long)temNum,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%ld/%@",isAutoPay,_carModel.carId,(long)temNum,summary];
    
    
    [RequestModel validatePurseBaoCodeWithURL:url WithDic:nil Completion:^(NSString *result) {
        
        
        if ([result isEqualToString:@"0"]) {
            
            if (sender.on) {
                _descributeL.text = @"已开启钱包自动支付";
                [_descributeL setTextColor:[MyUtil colorWithHexString:@"39D5B8"]];
                ALERT_VIEW(@"恭喜您，您的车辆已开通自动支付");
                
                _alert = nil;
            }else
            {
                _descributeL.text = @"未开启钱包自动支付";
                [_descributeL setTextColor:[MyUtil colorWithHexString:@"A7A7A7"]];
                
                
            }
            
            //            数据发生改变 通知上一个界面重新获取数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CarSetVCNotification" object:nil userInfo:nil];
            
    }else
        {
            
            _switchBtn.on = _switchBtn.on;
            
        }
        
        
    } Fail:^(NSString *error) {
        
    }];
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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
