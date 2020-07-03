//
//  KeyView.m
//  ETCP输入框
//
//  Created by 亮亮 on 16/8/31.
//  Copyright © 2016年 亮亮. All rights reserved.
//

#import "KeyView.h"

@implementation KeyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createMyKeyBoard];
    }
    return self;
}
- (void)createMyKeyBoard
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, 250);
    [self addSubview:self.scrollView];
    
    UIView  *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    
    [self.scrollView addSubview:keyView];
    [self addSubview:self.scrollView];
    
    CGFloat widthBtn = ([UIScreen mainScreen].bounds.size.width - 4 - 36)/10;
    CGFloat hightBtn = (250 - 90)/4;
    
    NSArray *titleArray =@[@[@"沪",@"京",@"渝",@"津",@"豫",@"湘",@"赣",@"苏",@"浙",@"陕"],@[@"晋",@"鲁",@"皖",@"琼",@"甘",@"辽",@"黑",@"冀",@"吉",@"鄂"],@[@"闽",@"滇",@"川",@"桂",@"粤",@"青",@"宁",@"港"],@[@"蒙",@"藏",@"新",@"贵",@"澳",@"台"]];
    
    
    for (NSInteger i = 0; i < 4; i++) {
        NSArray *array = titleArray[i];
        for (NSInteger j = 0; j < array.count ; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:titleArray[i][j] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            if (i == 0 || i == 1) {
                button.frame = CGRectMake(2+(widthBtn+4)*j, 15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 2){
                button.frame = CGRectMake(2+4+widthBtn+(widthBtn+4)*j,15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 3){
                button.frame = CGRectMake(10+2*widthBtn+(widthBtn+4)*j, 15+(hightBtn+20)*i, widthBtn, hightBtn);
            }
            [button addTarget:self action:@selector(onKeyBoardBtnClock:) forControlEvents:UIControlEventTouchUpInside];
//            [_buttonArray addObject:button];
            
            [keyView addSubview:button];
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-hightBtn-2, 250-hightBtn-15, hightBtn, hightBtn);
    
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [keyView addSubview:button];
    
    
    
    UIView *keyView1 = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    [_scrollView addSubview:keyView1];
    NSArray *numArray =@[@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"],@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"],@[@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S"],@[@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    for (NSInteger i = 0; i < 4; i++) {
        NSArray *array = numArray[i];
        for (NSInteger j = 0; j < array.count; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:numArray[i][j] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == 0 || i == 1) {
                button.frame = CGRectMake(2+(widthBtn+4)*j,15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 2){
                button.frame = CGRectMake(2+widthBtn/2+(widthBtn+4)*j,15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 3){
                button.frame = CGRectMake(6+widthBtn/2+widthBtn+(widthBtn+4)*j, 15+(hightBtn+20)*i, widthBtn, hightBtn);
            }
            
            if ([button.currentTitle isEqualToString:@"I"] || [button.currentTitle isEqualToString:@"O"]) {
                button.backgroundColor = [UIColor grayColor];
                button.userInteractionEnabled = NO;
            }
            
            [button addTarget:self action:@selector(onKeyBoardBtnClock:) forControlEvents:UIControlEventTouchUpInside];
            
            [keyView1 addSubview:button];
        }
    }
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-hightBtn-2, 250-hightBtn-15, hightBtn, hightBtn);
    
    button1.layer.cornerRadius = 5;
    button1.clipsToBounds = YES;
    button1.backgroundColor = [UIColor whiteColor];
    [button1 setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [keyView1 addSubview:button1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTimer)];
    [self addGestureRecognizer:tap];
    
}
- (void)onTimer{
    
}
- (void)onKeyBoardBtnClock:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(addKeyText:)]) {
        [self.delegate addKeyText:button];
    }
}
- (void)deleteClick{
    if ([self.delegate respondsToSelector:@selector(deleteKey)]) {
        [self.delegate deleteKey];
    }
}
@end
