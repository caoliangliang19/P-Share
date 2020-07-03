//
//  WashCarOrderController.h
//  P-Share
//
//  Created by 亮亮 on 16/4/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CLLIsGoInController){
    CLLIsGoInPushController   =   0,
    CLLIsGoInOrderController  =   1,
};
@interface WashCarOrderController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *orderScrollView;

@property (weak, nonatomic) IBOutlet UIButton *noPayfor;
@property (weak, nonatomic) IBOutlet UIButton *yesPayfor;
@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet UIView *yesView;

- (IBAction)backBtnClick:(id)sender;

- (IBAction)payForBtnClick:(UIButton *)payBtn;

@property (nonatomic,assign)CLLIsGoInController goInType;

@property (nonatomic,copy)NSString *orderType;
@end
