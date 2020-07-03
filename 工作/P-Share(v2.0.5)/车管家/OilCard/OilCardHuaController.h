//
//  OilCardHuaController.h
//  P-Share
//
//  Created by 亮亮 on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OilCardModel.h"



@interface OilCardHuaController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property (nonatomic,assign)NSInteger request;
@property (nonatomic,strong)OilCardModel *model;
@property (nonatomic,strong)NSString *signString;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayOut;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headLayOut;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *card4L;

@property (weak, nonatomic) IBOutlet UILabel *oilName;
@property (weak, nonatomic) IBOutlet UIImageView *oilSignImage;


@property (weak, nonatomic) IBOutlet UIButton *myButton1;
@property (weak, nonatomic) IBOutlet UIButton *myButton2;
@property (weak, nonatomic) IBOutlet UIButton *myButton3;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
- (IBAction)payButtonClick:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)moneyBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *changeLable;
@property (weak, nonatomic) IBOutlet UIButton *gengChange;
- (IBAction)cjangeClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *oilCardL;

@property (weak, nonatomic) IBOutlet UITextField *moneyText1;


@property (weak, nonatomic) IBOutlet UIView *addOilCardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myHeadlayOut;
- (IBAction)myOrderList:(id)sender;

@end
