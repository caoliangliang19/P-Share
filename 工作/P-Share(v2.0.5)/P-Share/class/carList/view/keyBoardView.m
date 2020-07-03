//
//  keyBoardView.m
//  P-Share
//
//  Created by 亮亮 on 16/4/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "keyBoardView.h"

@implementation keyBoardView

- (void)createkey{
    NSArray *titleArray =@[@[@"沪",@"京",@"渝",@"津",@"豫",@"湘",@"赣",@"苏",@"浙",@"陕"],@[@"晋",@"鲁",@"皖",@"琼",@"甘",@"辽",@"黑",@"冀",@"吉",@"鄂"],@[@"闽",@"滇",@"川",@"桂",@"粤",@"港",@"澳",@"台"],@[@"蒙",@"藏",@"新",@"贵",@"宁",@"青"]];
    
    CGFloat interve = 4;
    CGFloat width = (self.frame.size.width-40)/10;
    CGFloat height = (self.frame.size.height-50)/4;
    for (int i = 0; i < titleArray.count; i++) {
        NSArray *titlearray = titleArray[i];
        for (int j = 0; j < titlearray.count; j++) {
            
            UIButton *button = nil;
            if (i == 0 || i == 1) {
            button = [[UIButton alloc]initWithFrame:CGRectMake(2+(width+interve)*j, 10+(height+10)*i, width, height)];
                 button.layer.cornerRadius = 2;
            [button setTitle:titleArray[i][j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else if (i == 2){
                button = [[UIButton alloc]initWithFrame:CGRectMake(6+width+(width+interve)*j, 10+(height+10)*i, width, height)];
                [button setTitle:titleArray[i][j] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else if (i == 3){
                button = [[UIButton alloc]initWithFrame:CGRectMake(10+2*width+(width+interve)*j, 10+(height+10)*i, width, height)];
                [button setTitle:titleArray[i][j] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [button addTarget:self action:@selector(Value:) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:button];
        }
        
    }
    UIButton *ABCbutton = [[UIButton alloc]initWithFrame:CGRectMake(2, 3*height+40, height, height)];
    [ABCbutton setTitle:@"ABC" forState:UIControlStateNormal];
    ABCbutton.titleLabel.font = [UIFont systemFontOfSize:20];
    ABCbutton.backgroundColor = [UIColor grayColor];
    
    ABCbutton.layer.cornerRadius = 3;
    [ABCbutton addTarget:self action:@selector(onSystemBoardCkick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ABCbutton];
    UIButton *Delbutton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2-height, 3*height+40, height, height)];
    [Delbutton setTitle:@"X" forState:UIControlStateNormal];
    Delbutton.titleLabel.font = [UIFont systemFontOfSize:20];
    Delbutton.backgroundColor = [UIColor grayColor];
    Delbutton.layer.cornerRadius = 3;
    [self addSubview:Delbutton];
}
- (void)Value:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(passOnValueString:)]) {
        [self.delegate passOnValueString:button.currentTitle];
    }
}
- (void)onSystemBoardCkick{
    if ([self.delegate respondsToSelector:@selector(changeSystemClick:)]) {
        [self.delegate changeSystemClick:1];
    }
}
- (void)createLastkey;{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
