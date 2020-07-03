//
//  NumberKeyBoard.m
//  P-SHARE
//
//  Created by fay on 16/9/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "NumberKeyBoard.h"
#define num_w SCREEN_WIDTH/3
#define num_h 54
@implementation NumberKeyBoard

+ (instancetype)createNumberKeyBoard
{
    return [[self alloc] init];
}

- (void)setUpSubView
{

    self.frame = CGRectMake(0, SCREEN_HEIGHT-256, SCREEN_WIDTH, 256);
    self.backgroundColor = [UIColor whiteColor];
    //数组定义
    NSArray *numArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@" ",nil];
    
    UIView * safeView = [[UIView alloc]init];
    safeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:safeView];
    [safeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
    }];
    UILabel *safeTipLabel = [[UILabel alloc]init];
    safeTipLabel.text = @"口袋停安全键盘";
    safeTipLabel.font = [UIFont systemFontOfSize:12];
    safeTipLabel.textColor = [UIColor colorWithHexString:@"999999"];
    safeTipLabel.textAlignment = NSTextAlignmentCenter;
    [safeView addSubview:safeTipLabel];
    [safeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(safeView.mas_centerY);
        make.centerX.equalTo(safeView.mas_centerX).offset(20);
        make.height.mas_equalTo(40);
        
    }];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.32*[UIScreen mainScreen].bounds.size.width,12, 15, 17)];
    [imageView setImage:[UIImage imageNamed:@"anquan"]];
    [safeView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(safeView.mas_centerY);
        make.right.equalTo(safeTipLabel.mas_left).offset(-10);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(15);
        
    }];
    for (int i=0; i<12; i++) {
        float kx ;
        float ky ;
        kx = 0 + i%3 * num_w;
        ky = 40 + i/3 * num_h;
        UIButton * keyButton= [UIButton buttonWithType:UIButtonTypeSystem];
        [keyButton setTag:(1000+i)];
        [keyButton setFrame:CGRectMake(kx, ky, num_w, num_h)];
        [keyButton setTitle:[numArray objectAtIndex:i] forState:UIControlStateNormal];
        keyButton.layer.borderWidth = 0.25;
        keyButton.layer.borderColor = [UIColor colorWithHexString:@"c8cace"].CGColor;
        keyButton.enabled = YES;
        if (i == 9) {
            
            
        } else if (i == 11){
            
            [keyButton setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [keyButton addTarget:self action:@selector(deleteValue) forControlEvents:UIControlEventTouchUpInside];
            
            
        } else {
            [keyButton addTarget:self action:@selector(keyValuePress:) forControlEvents:UIControlEventTouchUpInside];
            
            [keyButton.titleLabel setFont:[UIFont systemFontOfSize:26]];
            [keyButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
            
        }
        
         UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT*0.8, 100, 30)];
        
        [self addSubview:numLabel];
        [self addSubview:keyButton];
        
    }

}
- (void)deleteValue
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberKeyBoardChange:)]) {
        [self.delegate numberKeyBoardChange:@""];
    }
}
- (void)keyValuePress:(UIButton *)numBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberKeyBoardChange:)]) {
        [self.delegate numberKeyBoardChange:numBtn.titleLabel.text];
    }
}
@end
