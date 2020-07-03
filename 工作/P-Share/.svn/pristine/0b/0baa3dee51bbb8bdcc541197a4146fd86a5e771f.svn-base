//
//  NewMonthlyRentAuthCodeCell.m
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewMonthlyRentAuthCodeCell.h"
@interface NewMonthlyRentAuthCodeCell()
{
    dispatch_source_t _timer;
    NSInteger       _getCodeCount;

}

@end
@implementation NewMonthlyRentAuthCodeCell



- (void)awakeFromNib {
    [super awakeFromNib];
    _getCodeCount = 60;

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _commitBtn.layer.cornerRadius = 4;
    _commitBtn.layer.masksToBounds = YES;
    _getAuthCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"39D5B8"].CGColor;
    _getAuthCodeBtn.layer.borderWidth = 1.5;
    _getAuthCodeBtn.layer.cornerRadius = 5;
    _getAuthCodeBtn.layer.masksToBounds = YES;
}

- (IBAction)getAuthCodeBtnClick:(UIButton *)sender {
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@",_orderModel.mobile,SECRET_KEY] MD5];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(sendSmsCode),_orderModel.mobile,summary];
    
    [NetWorkEngine getRequestUse:(self) WithURL:urlStr WithDic:nil needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        [self setGetCodeBtnColor:NO];
        self.infoL.text = [NSString stringWithFormat:@"已发送短信至您尾号%@的手机",[_orderModel.mobile substringFromIndex:7]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.infoL.text];
        [att addAttribute:NSForegroundColorAttributeName value:KMAIN_COLOR range:NSMakeRange(9,4)];
        
        self.infoL.attributedText = att;
        
        NSTimeInterval period = 1.0; //设置时间间隔
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            BOOL result = [self refreashCountdown];
            //在这里执行事件
            if (result) {
                dispatch_cancel(_timer);
            }
        });
        
        dispatch_resume(_timer);
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
        
    }];
}
- (BOOL)refreashCountdown
{
    MyLog(@"%ld",_getCodeCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        _getAuthCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%ld)",_getCodeCount];
        [_getAuthCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_getCodeCount] forState:UIControlStateNormal];
        
    });
    if (_getCodeCount == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setGetCodeBtnColor:YES];
        });
        _getCodeCount = 60;
        return YES;
    }
    
    _getCodeCount--;
    return NO;
    
    
}
- (void)setGetCodeBtnColor:(BOOL)isGreen
{
    if (isGreen) {
        [_getAuthCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        _getAuthCodeBtn.userInteractionEnabled = YES;
        [_getAuthCodeBtn setTitleColor:KMAIN_COLOR forState:(UIControlStateNormal)];
        _getAuthCodeBtn.layer.borderColor = KMAIN_COLOR.CGColor;
    }else
    {
        _getAuthCodeBtn.userInteractionEnabled = NO;
        [_getAuthCodeBtn setTitleColor: [UIColor colorWithHexString:@"aaaaaa"] forState:(UIControlStateNormal)];
        _getAuthCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
    }
    
}
- (IBAction)commitBtnClick:(UIButton *)sender {
    
    if (_authCode.text.length == 4) {
//                月租13  产权14
        if (_timer) {
            dispatch_cancel(_timer);
        }
        [self setGetCodeBtnColor:YES];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",_orderModel.orderType,@"orderType",_authCode.text,@"varlidateCode",_orderModel.parkingId,@"parkingId",_orderModel.carNumber,@"carNumber",[UtilTool getTimeStamp],@"timestamp", nil];
        
        [NetWorkEngine postRequestUse:self WithURL:APP_URL(parkingvalidatecode) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (self.verificationHandle) {
                self.verificationHandle(YES);
            }
            
        } error:^(NSString *error) {
            if (self.verificationHandle) {
                self.verificationHandle(NO);
            }
        } failure:^(NSString *fail) {
            if (self.verificationHandle) {
                self.verificationHandle(NO);
            }
        }];
    }else  if (_authCode.text.length == 0){
        
        [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"请输入验证码"];
        
    }else{
         [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"请输入正确验证码"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
