//
//  ShareHistoryDetailController.h
//  P-Share
//
//  Created by 亮亮 on 15/12/31.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "TemOrderModel.h"
#import "NewOrderModel.h"

@interface ShareHistoryDetailController : UIViewController

@property (nonatomic,assign)float nowLatitude;  //当前经度
@property (nonatomic,assign)float nowLongitude;   //当前纬度
@property (nonatomic,copy)NSString *currentPayfor; //当前付了多少钱
@property (nonatomic,strong)NSString *stopCarNumber;
@property (nonatomic,copy)NSString *hide;

@property (nonatomic,strong)OrderModel *orderModel;

@property (nonatomic,strong) TemOrderModel *temOrderModel;

@property (nonatomic,strong) NewOrderModel *model;

@property (nonatomic,copy)NSString *payState1;

@property (nonatomic,copy)NSString *passOnState;

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (nonatomic,copy)NSString *payPrice1;
@property (weak, nonatomic) IBOutlet UIView *StopCarView;
@property (weak, nonatomic) IBOutlet UILabel *StopLable;

@property (weak, nonatomic) IBOutlet UIButton *turePayfor;

@property (weak, nonatomic) IBOutlet UIButton *canclePay;

@property (weak, nonatomic) IBOutlet UIView *ScreenView;//控制屏幕变暗的全屏View
@property (weak, nonatomic) IBOutlet UIView *PopSuperView;//弹框View
@property (weak, nonatomic) IBOutlet UILabel *priceLable;//控制价格的lable
@property (weak, nonatomic) IBOutlet UITableView *shareTableView;//tableView的列表显示
@property (weak, nonatomic) IBOutlet UIImageView *zifubaoClick;//确定支付宝支付
@property (weak, nonatomic) IBOutlet UIButton *goToPay;
@property (weak, nonatomic) IBOutlet UIImageView *weiXinClick;//确定微信支付
//弹框上的去支付
- (IBAction)gotoPayfor:(UIButton *)sender;
//取消按钮
- (IBAction)nonment:(UIButton *)sender;
//付款按钮
- (IBAction)payfor:(UIButton *)sender;
//弹框上的叉号按钮
- (IBAction)cancelButton:(UIButton *)sender;
//支付宝支付按钮
- (IBAction)zhifubao:(UIButton *)sender;
//微信支付按钮
- (IBAction)weiXin:(UIButton *)sender;
//停车取消
- (IBAction)stopCarCancle:(UIButton *)sender;


@end
