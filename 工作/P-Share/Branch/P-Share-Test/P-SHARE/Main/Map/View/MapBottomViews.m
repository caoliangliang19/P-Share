//
//  MapBottomView.m
//  P-SHARE
//
//  Created by fay on 16/8/31.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "MapBottomViews.h"
#import "PayKindTotalViews.h"
#import "PayStatusView.h"
#import "YuYueView.h"
#import "DaoHangView.h"
#import "DaiBoInfoV.h"
#import "DaoHangVC.h"
#import "ParkingReservationVC.h"
#import "OldMonthPropertyVC.h"
#import "OldYuYueViewController.h"

#import "MonthPropertyVC.h"
#import "NewDaiBoOrderVC.h"
#import "PayKindView.h"
#import "CarListVC.h"
#import "YuYuePingZhengDetail.h"
#import "StartDaiBoView.h"
#import "PayCenterViewController.h"
#import "TimeLineVC.h"
#import "YuYueRequest.h"
#import "CancelOrderVC.h"
#import "JZAlbumViewController.h"

@interface MapBottomViews ()

@property (nonatomic,strong)    PayKindTotalViews   *payKindTotalViews;
@property (nonatomic,strong)    PayStatusView       *payStatusView;
@property (nonatomic,strong)    StartDaiBoView      *startDaiBoView;
@end
@implementation MapBottomViews

- (void)setUpSubView
{
    [super setUpSubView];

    [self addSubview:self.payKindTotalViews];
    [self addSubview:self.payStatusView];
    
    
}
- (PayStatusView *)payStatusView
{
    
    if (!_payStatusView) {
        _payStatusView = [PayStatusView new];
        [self addSubview:_payStatusView];
        [_payStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(_payStatusView.bgView.mas_bottom);
        }];
    }
    
  
    //    绿色按钮点击block
    WS(ws);
    _payStatusView.greenBtnClickBlock = ^(PayStatusViewKind status,YuYueView *yuYueView,DaoHangView *daoHangV,DaiBoInfoV *daiBoV){
        
        if (status == PayKindDaoHang){
            //            直接导航
            [ws navigationParkingWith:daoHangV.dataModel];
        }else
        {
            if ([UtilTool isVisitor]) {
                [ws alertLogin];
                return ;
            }
            
            if ([UtilTool isBlankString:[GroupManage shareGroupManages].car.carNumber]) {
                
                [UtilTool creatAlertController:ws.viewController title:@"您暂未绑定车辆" describute:@"请先去绑定车辆" sureClick:^{
                    CarListVC *carListVC = [[CarListVC alloc] init];
                    [ws.viewController.rt_navigationController pushViewController:carListVC animated:YES complete:nil];
                } cancelClick:^{
                    
                }];
                
                return;
            }

            if (status == PayKindDaiBo) {
                 [MobClick event:@"jdan"];
                if (daiBoV.status ==DaiBoInfoVStatusNervous || daiBoV.status ==DaiBoInfoVStatusHomeNervous) {
                    //                开始代泊
//                    NewDaiBoOrderVC *daiBoVC = [[NewDaiBoOrderVC alloc] init];
//                    [ws.viewController.rt_navigationController pushViewController:daiBoVC animated:YES complete:nil];
                    

                    [ws.startDaiBoView StartDaiBoViewShow];
                    
                }else if (daiBoV.status == DaiBoInfoVStatusGetOrder){
                    //                取消订单
                    [YuYueRequest cancelDaiBoOrderWithOrder:daiBoV.temModel success:^(NSDictionary *dataDic) {
                        CancelOrderVC *cancelVC = [[CancelOrderVC alloc] init];
                        [ws.viewController.navigationController pushViewController:cancelVC animated:YES];
                        [GroupManage shareGroupManages].car = [GroupManage shareGroupManages].car;
                    } error:nil failure:nil];
                    
                }else if (daiBoV.status == DaiBoInfoVStatusParkEnd || daiBoV.status == DaiBoInfoVStatusSaveKey || daiBoV.status == DaiBoInfoVStatusTimeNotification){
                    //                去支付
                    PayCenterViewController *payCenter = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
                    payCenter.order = daiBoV.temModel;
                    payCenter.orderKind = PayCenterViewControllerOrferTypeDaiBo;
                    [ws.viewController.rt_navigationController pushViewController:payCenter animated:YES];
                    
                    
                }else if (daiBoV.status == DaiBoInfoVStatusShowCarPhoto){
                    //                查看照片
                    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
                    NSMutableArray *imageArray = [NSMutableArray array];
                    NSString *totalImagePath = [NSString stringWithFormat:@"%@,%@",daiBoV.temModel.validateImagePath,daiBoV.temModel.parkingImagePath];
                    
                    [imageArray addObjectsFromArray:[totalImagePath componentsSeparatedByString:@","]];
                    [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                            [imageArray removeObject:imagePath];
                        }
                    }];
                    jzAlbumCtrl.imgArr = imageArray;
                    jzAlbumCtrl.currentIndex = 0;
                    jzAlbumCtrl.modalPresentationCapturesStatusBarAppearance = true;
                    [ws.viewController presentViewController:jzAlbumCtrl animated:YES completion:nil];
                    
                   
                } else if (daiBoV.status == DaiBoInfoVStatusParking || daiBoV.status == DaiBoInfoVStatusGetCaring){
                    //                查看
                    TimeLineVC *timeLineVC = [[TimeLineVC alloc] init];
                    timeLineVC.timeLineVCStyle = YES;
                    timeLineVC.orderModel = daiBoV.temModel;
                    [ws.viewController.rt_navigationController pushViewController:timeLineVC animated:YES complete:nil];
                    [MobClick event:@"sjz"];
                }
                
            }else if(status == PayKindYuYue){
                if(yuYueView.status == YuYueViewStatusNoOrder)
                {
//                    ParkingReservationVC *appointmentVC = [[ParkingReservationVC alloc] init];
//                    [ws.viewController.rt_navigationController pushViewController:appointmentVC animated:YES];
                    
                    OldYuYueViewController *oldYuYueVC = [[OldYuYueViewController alloc] init];
                    [ws.viewController.rt_navigationController pushViewController:oldYuYueVC animated:YES];
                    
                    //                预约停车
                    
                }else if(yuYueView.status == YuYueViewStatusSuccess)
                {
                    //                查看凭证
                    YuYuePingZhengDetail *detailVC = [[YuYuePingZhengDetail alloc] init];
                    detailVC.pingZhengModel = yuYueView.temModel;
                    [ws.viewController.rt_navigationController pushViewController:detailVC animated:YES];
                  
                }else if(yuYueView.status == YuYueViewStatusNoParking)
                {
                    //                导航
                    [ws navigationParkingWith:yuYueView.dataModel];

                }
                
            }
            
        }
    };
    
    
    
    _payStatusView.tapGestureBlock = ^(PayStatusViewKind status,YuYueView *yuYueView,DaoHangView *daoHangV,DaiBoInfoV *daiBoV)
    {
        if ([GroupManage shareGroupManages].isVisitor) {
            [ws alertLogin];
            return ;
        }
        
        if (status == PayKindDaiBo) {
            if (daiBoV.status == DaiBoInfoVStatusNervous || daiBoV.status == DaiBoInfoVStatusHomeNervous) {
                //                     状态为代泊时无点击效果
                MyLog(@"无代泊订单－－－无点击效果");
                
            }else
            {
                TimeLineVC *timeLineVC = [[TimeLineVC alloc] init];
                timeLineVC.timeLineVCStyle = YES;
                timeLineVC.orderModel = daiBoV.temModel;
                [ws.viewController.rt_navigationController pushViewController:timeLineVC animated:YES complete:nil];
                [MobClick event:@"sjz"];
            }
        }
        
        else if(status == PayKindYuYue){
            
            if(yuYueView.status == YuYueViewStatusNoOrder)
            {
                //               状态为预约停车时无点击效果
                
            }else if(yuYueView.status == YuYueViewStatusSuccess)
                
            {
                [MobClick event:@"sjz"];
                TimeLineVC *timeLineVC = [[TimeLineVC alloc] init];
                timeLineVC.timeLineVCStyle = NO;
                timeLineVC.orderModel = yuYueView.temModel;
                [ws.viewController.rt_navigationController pushViewController:timeLineVC animated:YES];
                
            }
            
            
        }else if (status == PayKindDaoHang){
            //            导航时无点击效果
        }
        
    };

    return _payStatusView;
    
    
}



#pragma mark -- 去导航
- (void)navigationParkingWith:(Parking *)parking
{
    DaoHangVC *daoHangVC = [[DaoHangVC alloc] initWithParking:parking];
    [self.viewController.view addSubview:daoHangVC.view];
    [self.viewController addChildViewController:daoHangVC];
}
- (PayKindTotalViews *)payKindTotalViews
{
    if (!_payKindTotalViews) {
        
        _payKindTotalViews = [PayKindTotalViews new];
        [self addSubview:_payKindTotalViews];
        [_payKindTotalViews mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(85);
            make.top.mas_equalTo(self.payStatusView.mas_bottom);

        }];
        WS(ws)
        _payKindTotalViews.payKindViewClick = ^(Parking *model,PayKindView *payKindView){
             [MobClick event:@"AtOnceGetMoneyID"];
            if ([GroupManage shareGroupManages].isVisitor) {
                [ws alertLogin];
            }
            if (payKindView.payKind == PayKindNoCar) {
                //前往车辆管理界面
                [MobClick event:@"CarManage_addCar2ID"];
                CarListVC *carListVC = [[CarListVC alloc] init];
                [ws.viewController.rt_navigationController pushViewController:carListVC animated:YES complete:nil];
                

            }else if (payKindView.payKind == PayKindYueZu){
                 [MobClick event:@"ljxf"];
                
                OldMonthPropertyVC *monthPropertyVC = [[OldMonthPropertyVC alloc] init];
                monthPropertyVC.monthPropertyVCStyle = MonthPropertyVCStyleYueZu;
                monthPropertyVC.orderModel = payKindView.model;
                [ws.viewController.rt_navigationController pushViewController:monthPropertyVC animated:YES complete:nil];
                
//                MonthPropertyVC *monthPropertyVC = [[MonthPropertyVC alloc] init];
//                monthPropertyVC.monthPropertyVCStyle = MonthPropertyVCStyleYueZu;
//                monthPropertyVC.orderModel = payKindView.model;
//                [ws.viewController.rt_navigationController pushViewController:monthPropertyVC animated:YES complete:nil];
                
            }else if (payKindView.payKind == PayKindLinTing){
                
                [MobClick event:@"ljxf"];
                NSString *summary = [[NSString stringWithFormat:@"%@%@",[UtilTool getCustomId],SECRET_KEY] MD5];
                NSString *url = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(temporarycarlist),[UtilTool getCustomId],summary];
                MyLog(@"临停-------------------->url:%@",url);
                
                [NetWorkEngine getRequestUse:(ws) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    NSArray *temArray = responseObject[@"cars"];
                    if (temArray.count > 0) {
                        
                        for (NSDictionary *dic in responseObject[@"cars"]) {
                            if ([dic[@"carNumber"] isEqualToString:payKindView.model.carNumber]) {
                                
                                
                                if ([dic[@"flag"] isEqualToString:@"1"]) {
                                    
                                    [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"亲，你已经付过款了"];
                                }else
                                {
                                    
                                    PayCenterViewController *payCenterVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
                                    payCenterVC.orderKind = PayCenterViewControllerOrferTypeLinTing;
                                    payCenterVC.order = payKindView.model;
                                    [ws.viewController.rt_navigationController pushViewController:payCenterVC animated:YES];
                                    
                                }
                                
                                    return ;
                            }
                        }
                        
                            
                        
                      
                    }else
                    {
                        [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"订单已付款或该车辆不在车场内"];
                    }
                    
                } error:^(NSString *error) {
                    
                } failure:^(NSString *fail) {
                   
                }];

               
                
                
            }else if (payKindView.payKind == PayKindChanQuan){

                OldMonthPropertyVC *monthPropertyVC = [[OldMonthPropertyVC alloc] init];
                monthPropertyVC.monthPropertyVCStyle = MonthPropertyVCStyleChanQuan;
                monthPropertyVC.orderModel = payKindView.model;
                [ws.viewController.rt_navigationController pushViewController:monthPropertyVC animated:YES complete:nil];
                
//                MonthPropertyVC *monthPropertyVC = [[MonthPropertyVC alloc] init];
//                monthPropertyVC.monthPropertyVCStyle = MonthPropertyVCStyleChanQuan;
//                monthPropertyVC.orderModel = payKindView.model;
//                [ws.viewController.rt_navigationController pushViewController:monthPropertyVC animated:YES complete:nil];
            }
            
        };

        
    }
    return _payKindTotalViews;
    
}
- (StartDaiBoView *)startDaiBoView
{
    if (!_startDaiBoView) {
        _startDaiBoView = [[StartDaiBoView alloc] init];
    }
    return _startDaiBoView;
}
- (void)alertLogin
{
    [UtilTool creatAlertController:self.viewController title:@"提示" describute:@"使用该功能需要登录帐号,是否去登录?" sureClick:^{
        LoginVC *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.viewController.rt_navigationController pushViewController:login animated:YES complete:nil];
    } cancelClick:^{
        
    }];
}
- (void)refreshBottomViewsData
{
    [_payStatusView refreshData];
}




@end
