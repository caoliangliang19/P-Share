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
#import "YuYueRequest.h"
@interface PayStatusView()
{
    
    UIView          *_lineV;//虚线
    UIImageView     *_leftImageV;
    GroupManage     *_manage;
    
}
@property (nonatomic,strong)UIView          *infoV;
@property (nonatomic,strong)DaoHangView     *daoHangV;
@property (nonatomic,strong)UIButton        *greenBtn;
@property (nonatomic,strong)UIView          *progressView;
@property (nonatomic,strong)JQIndicatorView *indicator;

@end
@implementation PayStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _manage = [GroupManage shareGroupManages];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapVCWillAppear) name:MapVC_WillAppear object:nil];
        
        [self monitorUserChooseParking];
        [self setUpSubView];
        
    }
    return self;
}

/**
 *  通过KVO监听用户选择的停车场
 */
- (void)monitorUserChooseParking
{
    [_manage addObserver:self forKeyPath:KUSER_CHOOSE_PARKING options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KYUYUE_PAY_SUCCESS object:nil];
//    监听地图移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressShow) name:KMAP_MOVE object:nil];
}

- (void)mapVCWillAppear
{
    if (self.indicator.isAnimating) {
        self.indicator.flag = YES;
        [self.indicator startAnimating];
        
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KUSER_CHOOSE_PARKING]) {
        
        Parking *useChooseParking = _manage.parking;
        if (useChooseParking != nil) {
            self.hidden = NO;
            
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.bottom.mas_equalTo(self.bgView.mas_bottom);
            }];
            self.dataModel = useChooseParking;
        }else
        {
            self.hidden = YES;
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.height.mas_equalTo(0);
            }];

        }
        
        MyLog(@"PayStatusView 用户选择车厂发生变化");
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}
- (void)refreshData
{
    
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_manage.parking.parkingLatitude,_manage.parking.parkingLongitude,SECRET_KEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(getIsParking),_manage.parking.parkingLatitude,_manage.parking.parkingLongitude,summary];
    [self progressShow];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:NO showHud:NO  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        MyLog(@"%@",responseObject);
        
        Parking *parkingModel = [Parking shareObjectWithDic:responseObject[@"parkingList"][0]];
        parkingModel.distance = _manage.parking.distance;

        self.dataModel = parkingModel;

    } error:^(NSString *error) {
        
        self.dataModel = _manage.parking;
        
        
    } failure:^(NSString *fail) {
        self.dataModel = _manage.parking;
        
    }];

    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_manage removeObserver:self forKeyPath:KUSER_CHOOSE_PARKING];
    
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
    [self addSubview:bgView];
    
    UIView *infoV = [UIView new];
    _infoV = infoV;
    [bgView addSubview:_infoV];
    
    UIImageView *leftImageV = [UIImageView new];
    _leftImageV = leftImageV;
    leftImageV.image = [UIImage imageNamed:@"flow_v2"];
    [bgView addSubview:leftImageV];
    
    UIView *lineV = [UIView new];
    _lineV = lineV;
    lineV.layer.masksToBounds = YES;
    [bgView addSubview:lineV];
    
    UIButton *greenBtn = [UIButton new];
    [self addSubview:greenBtn];
    _greenBtn = greenBtn;
    [greenBtn addTarget:self action:@selector(greenBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    greenBtn.layer.masksToBounds = YES;
    greenBtn.backgroundColor = KMAIN_COLOR;
    greenBtn.titleLabel.textColor = [UIColor whiteColor];
    
    [self layoutViews];
    
}

- (void)layoutViews
{
    CGFloat rowSpace = 10;
    _greenBtn.mas_key = @"greenBtn";
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
    _infoV.mas_key = @"infoV";
    [_infoV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_leftImageV.mas_right).offset(rowSpace+6);
        make.right.mas_equalTo(_greenBtn.mas_left).offset(0);
        make.bottom.mas_equalTo(self.progressView.mas_bottom);
        //    高度下面计算
    }];
    _bgView.mas_key = @"bgView";
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(_greenBtn.mas_centerY);
        make.bottom.mas_equalTo(_infoV.mas_bottom);
    }];
    _leftImageV.mas_key = @"leftImageV";
    [_leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(_infoV.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    _lineV.mas_key = @"lineV";

    [_lineV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftImageV.mas_bottom);
        make.centerX.mas_equalTo(_leftImageV.mas_centerX);
        make.bottom.mas_equalTo(_infoV.mas_bottom).offset(-10);
        make.width.mas_equalTo(1);
    }];
    
}

- (void)setDataModel:(Parking *)dataModel
{
    if (dataModel == nil) {
        return;
    }
    _dataModel = dataModel;
    self.distance = dataModel.distance;
    [self progressShow];
    if (dataModel.canUse == 2) {//代泊
        self.status = PayKindDaiBo;
    }else
    {
        if (dataModel.isCooperate == 2) {//月租
            self.status = PayKindYuYue;
        }else
        {
            self.status = PayKindDaoHang;//导航

        }
    }
}
/**
 PayKindDaiBo,//代泊
 PayKindYuYue,//预约
 PayKindDaoHang//导航

 */
- (void)setStatus:(PayStatusViewKind)status
{
    if (self.dataModel == nil) {
        return;
    }
    _status = status;
    switch (status) {
        case PayKindDaiBo:
        {
            Parking *homePark = [GroupManage shareGroupManages].homeParking;
            if ([homePark.parkingId isEqualToString:self.dataModel.parkingId]) {
                self.daiBoInfoV.isHomePark = YES;
            }else
            {
                self.daiBoInfoV.isHomePark = NO;
            }
           
            self.daiBoInfoV.dataModel = self.dataModel;
            [YuYueRequest reloadDaiBoDataWithParkingModel:self.dataModel completion:^(BOOL hasOrder, OrderModel *order, DaiBoInfoVStatus status,NSString *tenseTime) {
                
                if (hasOrder) {
                    self.daiBoInfoV.temModel = order;
                }else
                {
                    self.daiBoInfoV.tenseTime = tenseTime;
                    self.daiBoInfoV.status = status;
                }
                if (self.status == PayKindDaiBo) {
                    [_daiBoInfoV mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(_daiBoInfoV.containV.mas_bottom);
                    }];
                    [_infoV mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(0);
                        make.left.mas_equalTo(_leftImageV.mas_right).offset(16);
                        make.right.mas_equalTo(_greenBtn.mas_left).offset(0);
                        make.bottom.mas_equalTo(self.daiBoInfoV.mas_bottom).offset(10);
                    }];
                    [self progressHidden];
                    
                    _daiBoInfoV.hidden = NO;
                    [self setGreenBtnStatus:_daiBoInfoV];
                }

            }];

            
            
        }
            break;
            
        case PayKindYuYue:
        {
            
            self.yuYueView.distance = _distance;
            
            self.yuYueView.dataModel = self.dataModel;

            [YuYueRequest reloadYuYueTingChe:self.dataModel Completion:^(int resultNum, OrderModel *model) {
                
                self.yuYueView.temModel = model;
                if (resultNum == 0) {//有可用凭证
                    self.yuYueView.status = YuYueViewStatusSuccess;
                }else if (resultNum == 1){//无可用凭证
                    self.yuYueView.status = YuYueViewStatusNoOrder;
                }
                if (self.status == PayKindYuYue) {
                    [_yuYueView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(_yuYueView.containV.mas_bottom);
                    }];
                    [_infoV mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(0);
                        make.left.mas_equalTo(_leftImageV.mas_right).offset(16);
                        make.right.mas_equalTo(_greenBtn.mas_left).offset(0);
                        make.bottom.mas_equalTo(self.yuYueView.mas_bottom).offset(10);
                    }];
                    
                    //
                    [_yuYueView layoutIfNeeded];
                    [_infoV layoutIfNeeded];
                    MyLog(@"%@---*---%@",NSStringFromCGRect(_infoV.bounds),NSStringFromCGRect(_yuYueView.bounds));
                    
                    [self progressHidden];
                    _yuYueView.hidden = NO;
                    [self setGreenBtnStatus:_yuYueView];

                }
               
            }];
        }
            break;

        case PayKindDaoHang:
        {
            self.daoHangV.distance = _distance;
            self.daoHangV.dataModel = _dataModel;
            
            [self.daoHangV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.bottom.mas_equalTo(self.daoHangV.containV.mas_bottom);
            }];
            [_infoV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(_leftImageV.mas_right).offset(16);
                make.right.mas_equalTo(_greenBtn.mas_left).offset(0);
                make.bottom.mas_equalTo(self.daoHangV.mas_bottom).offset(10);
            }];
            
            [self progressHidden];
            self.daoHangV.hidden = NO;
            [self setGreenBtnStatus:_daoHangV];
        }
            break;

        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [_lineV layoutIfNeeded];
        [_lineV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_infoV.mas_bottom).offset(-10);
        }];
        [UtilTool drawDashLine:_lineV lineLength:3 lineSpacing:2 lineColor:[UIColor colorWithHexString:@"6d7e8c"]];
    }];

}
/**
 PayKindDaiBo,//代泊
 PayKindYuYue,//预约
 PayKindDaoHang//导航
 */
- (void)setGreenBtnStatus:(UIView *)subView
{
    if (self.status == PayKindDaiBo) {
       
        switch (_daiBoInfoV.status) {
            case DaiBoInfoVStatusHomeNervous:
            {
                [_greenBtn setTitle:@"一键代泊" forState:(UIControlStateNormal)];
                
            }
                break;
                
            case DaiBoInfoVStatusNervous:
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
            case YuYueViewStatusNoParking:
            {
                [_greenBtn setTitle:@"导航" forState:(UIControlStateNormal)];
                
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
    if (_manage.networkStatus == NetworkStatusNotReachable) {
        [_manage groupAlertShowWithTitle:@"网络异常,请检查网络设置"];
        return;
    }
    if (self.greenBtnClickBlock) {
        self.greenBtnClickBlock(self.status,_yuYueView,_daoHangV,_daiBoInfoV);
    }
}
- (YuYueView *)yuYueView
{
    if (!_yuYueView) {
        _yuYueView = [YuYueView new];
        [_infoV addSubview:_yuYueView];
        [_infoV bringSubviewToFront:_progressView];

    }
    return _yuYueView;
}
- (DaiBoInfoV *)daiBoInfoV
{
    if (!_daiBoInfoV) {
        _daiBoInfoV = [DaiBoInfoV new];
        [_infoV addSubview:_daiBoInfoV];

        [_infoV bringSubviewToFront:_progressView];

    }
    return _daiBoInfoV;
}
- (DaoHangView *)daoHangV
{
    if (!_daoHangV) {
        _daoHangV = [DaoHangView new];
        [_infoV addSubview:_daoHangV];
        [_infoV bringSubviewToFront:_progressView];

    }
    return _daoHangV;
}
- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [UIView new];
        _progressView.backgroundColor = [UIColor whiteColor];
        [_infoV addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        [self layoutIfNeeded];
        [_progressView addSubview:self.indicator];
    }
    return _progressView;
    
}
- (void)progressShow
{
    self.yuYueView.hidden = YES;
    self.daiBoInfoV.hidden = YES;
    self.daoHangV.hidden = YES;
    self.progressView.hidden = NO;
    [self.greenBtn setTitle:@"" forState:(UIControlStateNormal)];
    self.greenBtn.userInteractionEnabled = NO;
    [self.indicator startAnimating];
    [_infoV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_leftImageV.mas_right).offset(16);
        make.right.mas_equalTo(_greenBtn.mas_left).offset(0);
        make.bottom.mas_equalTo(self.progressView.mas_bottom).offset(10);
    }];
}
- (void)progressHidden
{
    
    _progressView.hidden = YES;
    self.greenBtn.userInteractionEnabled = YES;
    [self.indicator stopAnimating];
    
}
- (JQIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[JQIndicatorView alloc] initWithType:3 tintColor:KMAIN_COLOR];
        _indicator.center = CGPointMake(SCREEN_WIDTH/2-38, _progressView.bounds.size.height/2+5);
    }
    return  _indicator;
    
}

@end

