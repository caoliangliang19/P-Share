//
//  PayStatusView.m
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "PayStatusView.h"
#import "DaiBoInfoV.h"
#import "YuYueView.h"
#import "DaoHangView.h"

@interface PayStatusView()
{
    UIButton        *_greenBtn;
    UIView          *_lineV;//虚线
    UIImageView     *_leftImageV;

    DaoHangView     *_daoHangV;
    
}
@property (nonatomic,strong)UIView          *infoV;


@end
@implementation PayStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubView];
        
    }
    return self;
}
- (void)tapGestureClick
{
    if (self.tapGestureBlock) {
        self.tapGestureBlock(self.status,_yuYueView,_daoHangV,_daiBoInfoV);
    }
}
- (void)setUpSubView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self addGestureRecognizer:tapGesture];
    
    self.backgroundColor = [UIColor clearColor];
    UIView *bgView = [UIView new];
    _bgView = bgView;
    _bgView.backgroundColor = [UIColor whiteColor];
//    _bgView.alpha = 0.5;
    [self addSubview:bgView];
    
    UIView *infoV = [UIView new];
    _infoV = infoV;
//    infoV.backgroundColor = [UIColor grayColor];
    [bgView addSubview:_infoV];
    
    UIImageView *leftImageV = [UIImageView new];
    _leftImageV = leftImageV;
    leftImageV.image = [UIImage imageNamed:@"flow_v2"];
    [bgView addSubview:leftImageV];
    
    UIView *lineV = [UIView new];
    _lineV = lineV;
    lineV.layer.masksToBounds = YES;
//    lineV.backgroundColor = [UIColor redColor];
    [bgView addSubview:lineV];
    
    UIButton *greenBtn = [UIButton new];
    [self addSubview:greenBtn];
    _greenBtn = greenBtn;
    [greenBtn addTarget:self action:@selector(greenBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    greenBtn.layer.masksToBounds = YES;
    greenBtn.backgroundColor = NEWMAIN_COLOR;
    greenBtn.titleLabel.textColor = [UIColor whiteColor];
    
    [self layoutViews];
    
}

- (void)layoutViews
{
    CGFloat rowSpace = 26;
//    CGFloat colSpace = 18;
    
    if (SCREEN_WIDTH == 320) {
        _greenBtn.layer.cornerRadius = 25;
        _greenBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];

        [_greenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }else
    {
        _greenBtn.layer.cornerRadius = 32;
        _greenBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_greenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
    }
    
    [_infoV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_leftImageV.mas_right).offset(rowSpace);
        make.right.mas_equalTo(_greenBtn.mas_left).offset(0);
        //    高度下面计算
    }];
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_greenBtn.mas_centerY);
        make.bottom.mas_equalTo(_infoV.mas_bottom);
    }];
    
    [_leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(_infoV.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [_lineV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftImageV.mas_bottom);
        make.centerX.mas_equalTo(_leftImageV.mas_centerX);
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-10);
        make.width.mas_equalTo(1);
    }];
    

    
}

- (void)setDataModel:(ParkingModel *)dataModel
{
    _dataModel = dataModel;
    if ([dataModel.canUse intValue] == 2) {
        self.status = PayKindDaiBo;
    }else
    {
        if ([dataModel.isCooperate intValue] == 2) {
            self.status = PayKindYuYue;
        }else
        {
            self.status = PayKindDaoHang;

        }
    }
    [self layoutViews];
}
/**
 PayKindDaiBo,//代泊
 PayKindYuYue,//预约
 PayKindDaoHang//导航

 */
- (void)setStatus:(PayStatusViewKind)status
{
    _status = status;
    __weak typeof(self)ws = self;
    switch (status) {
        case PayKindDaiBo:
        {
            [_yuYueView removeFromSuperview];
            _yuYueView = nil;
            [_daoHangV removeFromSuperview];
            _daoHangV = nil;
            DaiBoInfoV *daiBoInfoV;
            if (!daiBoInfoV) {
                daiBoInfoV = [DaiBoInfoV new];
            }
            daiBoInfoV.tag = 100;
            
            HomeArray *homeArray = [HomeArray shareHomeArray];

            ParkingModel *homePark = homeArray.dataArray[0];
            if ([homePark.parkingId isEqualToString:self.dataModel.parkingId]) {
                daiBoInfoV.isHomePark = YES;
            }else
            {
                daiBoInfoV.isHomePark = NO;
            }
            __weak typeof(self)ws = self;
            
            if (![_daiBoInfoV.dataModel.parkingId isEqualToString:self.dataModel.parkingId]) {
                [_daiBoInfoV removeFromSuperview];
                _daiBoInfoV = nil;
            }

            daiBoInfoV.dataModel = self.dataModel;
            daiBoInfoV.statusCompleteBlock = ^(DaiBoInfoV *daiBoV){
                [ws setGreenBtnStatus:daiBoV Complete:^(BOOL statusIsEqual) {
                    
                    
                    [_infoV addSubview:daiBoV];
                    [daiBoV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.mas_equalTo(0);//高度内部实现
                        make.bottom.mas_equalTo(daiBoV.containV.mas_bottom);
                    }];
                    [daiBoV layoutIfNeeded];
                    MyLog(@"%lf  %lf",daiBoV.frame.size.width,daiBoV.frame.size.height);
                    [_infoV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(daiBoV.mas_bottom).offset(10);
                    }];
                    
                }];
               
            };            
        }
            break;
            
        case PayKindYuYue:
        {
            
            [_daiBoInfoV removeFromSuperview];
            _daiBoInfoV = nil;
            [_daoHangV removeFromSuperview];
            _daoHangV = nil;
            YuYueView *yuYueView;
            if (!yuYueView) {
                yuYueView = [YuYueView new];
            }
            
            yuYueView.distance = _distance;
            if (![_yuYueView.dataModel.parkingId isEqualToString:self.dataModel.parkingId]) {
                [_yuYueView removeFromSuperview];
                _yuYueView = nil;
            }
            
            yuYueView.dataModel = self.dataModel;
            __weak typeof(self)ws = self;

            yuYueView.statusCompleteBlock = ^(YuYueView *aYuYueView){
                [ws setGreenBtnStatus:aYuYueView Complete:^(BOOL statusIsEqual) {
                    
                    [_infoV addSubview:aYuYueView];
                    [aYuYueView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.mas_equalTo(0);//高度内部实现
                        make.bottom.mas_equalTo(aYuYueView.containV.mas_bottom);
                    }];
                    [_infoV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(aYuYueView.mas_bottom).offset(10);
                    }];
                    //            预约停车当可用停车位数为0时，预约停车按钮改为导航
                    
                    if ([self.dataModel.parkingCanUse intValue] == 0) {
                        [_greenBtn setTitle:@"导航" forState:(UIControlStateNormal)];
                    }

              
                }];
            };
            

        }
            break;

        case PayKindDaoHang:
        {
            [_yuYueView removeFromSuperview];
            _yuYueView = nil;
            [_daiBoInfoV removeFromSuperview];
            _daiBoInfoV = nil;
            MyLog(@"  %@  %@",_dataModel.parkingId,_daoHangV.dataModel.parkingId);
            
            if ([_dataModel.parkingId isEqualToString:_daoHangV.dataModel.parkingId] && _daoHangV != nil) {
                
                return;
            }
            [_daoHangV removeFromSuperview];
            DaoHangView *daoHangV;
            if (!daoHangV) {
                daoHangV = [DaoHangView new];
            }
            _daoHangV = daoHangV;
            daoHangV.distance = _distance;
            daoHangV.dataModel = _dataModel;
            daoHangV.tag = 100;
            [_infoV addSubview:daoHangV];
            [daoHangV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.bottom.mas_equalTo(daoHangV.containV.mas_bottom);
            }];
            [_infoV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(daoHangV.mas_bottom).offset(10);
            }];
            [ws setGreenBtnStatus:_daoHangV Complete:^(BOOL statusIsEqual) {
                
            }];

        }
            break;

        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_infoV.mas_bottom);
        }];
        [MyUtil drawDashLine:_lineV lineLength:3 lineSpacing:2 lineColor:[MyUtil colorWithHexString:@"6d7e8c"]];
    }];

}
/**
 PayKindDaiBo,//代泊
 PayKindYuYue,//预约
 PayKindDaoHang//导航
 */
- (void)setGreenBtnStatus:(UIView *)subView Complete:(void (^)(BOOL statusIsEqual))isEqual
{
    if (self.status == PayKindDaiBo) {
        DaiBoInfoV *newDaiBoV = (DaiBoInfoV *)subView;
        [_daiBoInfoV removeFromSuperview];
        _daiBoInfoV = newDaiBoV;
        
        if (isEqual) {
            isEqual(YES);
        }

        switch (_daiBoInfoV.status) {
            case DaiBoInfoVStatusHomeNoCheWei:
            {
                [_greenBtn setTitle:@"一键代泊" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusNoCheWei:
            {
                [_greenBtn setTitle:@"一键代泊" forState:(UIControlStateNormal)];

            }
                break;
                
            case DaiBoInfoVStatusGetOrder:
            {
                [_greenBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusShowCarPhoto:
            {
                [_greenBtn setTitle:@"查看" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusParking:
            {
                [_greenBtn setTitle:@"查看" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusParkEnd:
            {
                [_greenBtn setTitle:@"一键取车" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusSaveKey:
            {
                [_greenBtn setTitle:@"一键取车" forState:(UIControlStateNormal)];
                
            }
                break;
                
                
            case DaiBoInfoVStatusTimeNotification:
            {
                [_greenBtn setTitle:@"一键取车" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusGetCaring:
            {
                [_greenBtn setTitle:@"查看" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusGetCarEnd:
            {
                [_greenBtn setTitle:@"立即评价" forState:(UIControlStateNormal)];
                
            }
                break;
                
            default:
                break;
        }

    }else if (self.status == PayKindYuYue){
        
        
        YuYueView *yuYueView = (YuYueView *)subView;
        [_yuYueView removeFromSuperview];
        _yuYueView = yuYueView;
        if (isEqual) {
            isEqual(YES);
        }
        switch (_yuYueView.status) {
            case YuYueViewStatusNoOrder:
            {
                [_greenBtn setTitle:@"立即预约" forState:(UIControlStateNormal)];

            }
                break;
            case YuYueViewStatusSuccess:
            {
                [_greenBtn setTitle:@"查看凭证" forState:(UIControlStateNormal)];

            }
                break;

                
            default:
                break;
        }
        
    }else if (self.status == PayKindDaoHang){
        [_greenBtn setTitle:@"导航" forState:(UIControlStateNormal)];
        
    }
}
- (void)greenBtnClick:(UIButton *)greenBtn
{
    if (self.greenBtnClickBlock) {
        self.greenBtnClickBlock(self.status,_yuYueView,_daoHangV,_daiBoInfoV);
    }
}

@end
