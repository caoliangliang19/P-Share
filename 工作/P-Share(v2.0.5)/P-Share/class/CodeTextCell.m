//
//  CodeTextCell.m
//  P-Share
//
//  Created by 亮亮 on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CodeTextCell.h"

@interface CodeTextCell ()<UITextFieldDelegate>

@end
@implementation CodeTextCell

- (void)awakeFromNib {
    CGFloat widthGip = (SCREEN_WIDTH - 18 - 65 - 192)/2;
    if (!_pass) {
        _pass =  [[QGPassWordTextField alloc]init];
        _pass.frame = CGRectMake(widthGip+65+18, 18, 192, 32);
        _pass.backgroundColor = [UIColor whiteColor];
        _pass.passWordCount = 6;
        _pass.delegate = self;
        _pass.textColor = [UIColor blueColor];
        _pass.layer.borderWidth = 1;
//        _pass.layer.borderColor = [MyUtil colorWithHexString:@"696969"].CGColor;
       
        _pass.delegate = self;

        [self.grayView addSubview:_pass];
    }
    if (!_pass1) {
        _pass1.delegate = self;
        
        _pass1 =  [[QGPassWordTextField alloc]init];
        _pass1.frame = CGRectMake(widthGip+65+18, 70, 192, 32);
        _pass1.backgroundColor = [UIColor whiteColor];
        _pass1.passWordCount = 6;
        _pass1.delegate = self;
        _pass1.textColor = [UIColor blueColor];
        _pass1.layer.borderWidth = 1;
//        _pass1.layer.borderColor = [MyUtil colorWithHexString:@"696969"].CGColor;

        [self.grayView addSubview:_pass1];
    }
    
    if (!_lable1) {
        _lable1 = [MyUtil createLabelFrame:CGRectMake(widthGip, 18, 65, 32) title:@"输入密码" textColor:[MyUtil colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight numberOfLine:0];
        _lable1.userInteractionEnabled = YES;
        [self.grayView addSubview:_lable1];
        
    }
    if (!_lable2) {
         _lable2 = [MyUtil createLabelFrame:CGRectMake(widthGip, 70, 65, 32) title:@"重复密码" textColor:[MyUtil colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight numberOfLine:0];
        _lable2.userInteractionEnabled = YES;
         [self.grayView addSubview:_lable2];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == _pass1) {
        _pass1.selected = YES;
        _pass1.layer.borderColor = NEWMAIN_COLOR.CGColor;
        _pass.layer.borderColor = [MyUtil colorWithHexString:@"E0E0E0"].CGColor;

    }else
    {
        _pass.selected = YES;
        _pass.layer.borderColor = NEWMAIN_COLOR.CGColor;
        _pass1.layer.borderColor = [MyUtil colorWithHexString:@"E0E0E0"].CGColor;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:self.pass.text];
    [array addObject:self.pass1.text];
    if (self.myBlock) {
        self.myBlock(array);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
