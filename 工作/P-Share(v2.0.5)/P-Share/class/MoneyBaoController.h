//
//  MoneyBaoController.h
//  P-Share
//
//  Created by 亮亮 on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyBaoController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *historyScrollView;

@property (weak, nonatomic) IBOutlet UIButton *topUpHistory;//充值记录
@property (weak, nonatomic) IBOutlet UIButton *consumeHistory;//消费记录
@property (weak, nonatomic) IBOutlet UIView *topUpView;//充值View
@property (weak, nonatomic) IBOutlet UIView *consumeView;//消费View

- (IBAction)backBtnClick:(id)sender;

- (IBAction)topUpBtnClick:(UIButton *)payBtn;
@end
