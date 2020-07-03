
//
//  InvoiceView.m
//  P-Share
//
//  Created by 亮亮 on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "InvoiceView.h"

@interface InvoiceView ()<UITextFieldDelegate>
{
    NSString *_select;
}
@end

@implementation InvoiceView

+(instancetype)shareInstance{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"InvoiceView" owner:nil options:nil] lastObject];
}
- (void)setSendType:(NSString *)sendType{
    _select = sendType;
    if ([_select isEqualToString:@"1"]) {
        
        self.selfTakeImage.image = [UIImage imageNamed:@"balance"];
        self.otherSendImage.image = [UIImage imageNamed:@"timea"];
        
    }else{
        
        self.selfTakeImage.image = [UIImage imageNamed:@"timea"];
        self.otherSendImage.image = [UIImage imageNamed:@"balance"];
    }
    
  
}
- (void)awakeFromNib{
    
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 8.0f;
//    _select = @"0";
    self.clipsToBounds = TRUE;
    self.invAddressField.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    self.invHeadField.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    self.invAddressField.layer.borderWidth = 1.0f;
    self.invHeadField.layer.borderWidth = 1.0f;
    UITapGestureRecognizer *selfTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSelfClick)];
    _surebtn.layer.cornerRadius = 6;
    [self.selfTake addGestureRecognizer:selfTap];
    
    UITapGestureRecognizer *otherTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onOtherClick)];
    [self.otherSend addGestureRecognizer:otherTap];
    
    _invAddressField.delegate = self;
    _invHeadField.delegate = self;
    
    UITapGestureRecognizer *removeViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeViewTap)];

    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:removeViewTap];
    
    
}

- (void)removeViewTap
{
    [self.invAddressField resignFirstResponder];
    [self.invHeadField resignFirstResponder];
    [UIView setAnimationsEnabled:YES];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.invHeadField) {
        [self.invAddressField becomeFirstResponder];
    }else{
        [self.invAddressField resignFirstResponder];
    }
    return YES;
}

- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)onSelfClick{
    _select = @"0";
    self.selfTakeImage.image = [UIImage imageNamed:@"timea"];
    self.otherSendImage.image = [UIImage imageNamed:@"balance"];
}
- (void)onOtherClick{
    _select = @"1";
    self.selfTakeImage.image = [UIImage imageNamed:@"balance"];
    self.otherSendImage.image = [UIImage imageNamed:@"timea"];
}
- (IBAction)cancleBtn:(UIButton *)sender {
    if (self.cancleBlock) {
        [self animatedOut];
        self.cancleBlock();
    }
}

- (IBAction)tureBtn:(UIButton *)sender {
    NSString *invoiceHead = self.invHeadField.text;
    NSString *invoiceAddress = self.invAddressField.text;
    NSString *sendType = _select;
    
    if (self.tureBlock) {
        self.tureBlock(invoiceHead,invoiceAddress,sendType);
    }
}


@end
