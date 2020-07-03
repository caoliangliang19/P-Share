//
//  CarLifeView.m
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarLifeView.h"
#import "ActivityCell.h"
#import "ActivityHeadview.h"
#import "CarLiftModel.h"
#import "TitleView.h"
#import "CarListVC.h"
#import "BaoYangCell.h"
#import "BaoYangAlertCell.h"
#import "DatePickView.h"
#import "CarLifeTopCell.h"
#import "ParkingListVC.h"
#import "WeChatController.h"
#import "ShowAllActivityVC.h"
static NSString *const HeadID = @"ActivityHeadview";
@interface CarLifeView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSArray         *_titleArray;
    NSDictionary    *_dataDic;
    NSArray         *_baoYangArray;
    TitleView       *_titleV;
    MBProgressHUD   *_hud;
    UIView          *_clearBackView;
    UIAlertView     *_alert;
    BOOL            _isNeedAlert;
   
    
    __weak IBOutlet UIView *carInfBgView1;
    __weak IBOutlet UIView *carInfBgView2;
    __weak IBOutlet UILabel *timeDescributeL;
    __weak IBOutlet UILabel *carNameL;
    __weak IBOutlet UIImageView *carImageV;
    __weak IBOutlet UIButton *chooseBtn;
    __weak IBOutlet UILabel *distanceDescributeL;
    __weak IBOutlet UILabel *carDetailL;
    
    GroupManage     *_manage;
}
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation CarLifeView





+ (CarLifeView *)instaceCarLifeView
{
    MyLog(@"创建成功");
    return [[NSBundle mainBundle] loadNibNamed:@"CarLifeView" owner:self options:nil].firstObject;
    
}
- (void)dealloc
{
    [_manage removeObserver:self forKeyPath:@"CarLifeView"];
}
#pragma mark -- 切换车场
- (IBAction)parkingList:(id)sender {
    [MobClick event:@"xzcc"];
    ParkingListVC *parkListVC = [[ParkingListVC alloc] init];
    parkListVC.style = ParkingListVCStyleLoveCarLife;
    [self.viewController.rt_navigationController pushViewController:parkListVC animated:YES complete:nil];
    
}

- (void)initDefaultCarLiftParking
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    Parking *park = [[Parking alloc] init];
    if (![UtilTool isBlankString:[userDefault objectForKey:KCARLIFT_PARKINGID]]) {
        park.parkingId = [userDefault objectForKey:KCARLIFT_PARKINGID];
        park.parkingName = [userDefault objectForKey:KCARLIFT_PARKINGNAME];
    }else
    {
        park = _manage.homeParking;
    }
    
    self.parkModel = park;
    
    [_manage addObserver:self forKeyPath:@"carLiftParking" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"carLiftParking"]) {
        MyLog(@"%@",_manage.carLiftParking.parkingName);
        self.parkModel = _manage.carLiftParking;
    }
}

- (void)setParkModel:(Parking *)parkModel
{
    if ([_parkModel.parkingId isEqualToString:parkModel.parkingId]) {
        
        return;
        
    }
    _parkModel = parkModel;
    
    if ([UtilTool isBlankString:parkModel.parkingId]) {
        _titleL.text = @"请选择社区名称";
        return;
    }
    _titleL.text = parkModel.parkingName;
    [self loadCarLiftData];

}


- (void)loadCarLiftData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_parkModel.parkingId,@"parkingId",@"2.0.2",@"version", nil];
    
    [self hubShow];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryActivity) WithDic:dic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hubHiden];

        NSDictionary *jsonDic = responseObject[@"data"];
        
        NSMutableArray *type1Array = [NSMutableArray array];
        for (NSDictionary *dic in jsonDic[@"type1"]) {
            CarLiftModel *model = [CarLiftModel shareObjectWithDic:dic];
            [type1Array addObject:model];
        }
        NSMutableArray *type2Array = [NSMutableArray array];
        for (NSDictionary *dic in jsonDic[@"type2"]) {
            CarLiftModel *model = [CarLiftModel shareObjectWithDic:dic];
            [type2Array addObject:model];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type1Array,@"type1",type2Array,@"type2", nil];
        _dataDic = dic;
        [_collectionView reloadData];

    } error:^(NSString *error) {
        [self hubHiden];

    } failure:^(NSString *fail) {
        [self hubHiden];

    }];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(getQiyuId) WithDic:dic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
       _manage.qiyuId = @"0";
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}



- (void)hubShow
{
    [_hud show:YES];
    _hud.hidden = NO;
}
- (void)hubHiden
{
    [_hud show:NO];
    _hud.hidden = YES;
}

- (void)changeCarDetailGrayColor
{
    carInfBgView1.backgroundColor = [UIColor colorWithHexString:@"f8f9fa"];
    carInfBgView2.backgroundColor = [UIColor colorWithHexString:@"f8f9fa"];
    timeDescributeL.textColor = [UIColor colorWithHexString:@"696969"];
    carNameL.textColor = [UIColor colorWithHexString:@"333333"];
    distanceDescributeL.textColor = [UIColor colorWithHexString:@"696969"];
    carDetailL.textColor = [UIColor colorWithHexString:@"696969"];
    _distanceT.textColor = [UIColor colorWithHexString:@"333333"];
    _timeL.textColor = [UIColor colorWithHexString:@"333333"];
}
- (void)changeCarDetailWhiteColor
{
    carInfBgView1.backgroundColor = KMAIN_COLOR;
    carInfBgView2.backgroundColor = KMAIN_COLOR;
    timeDescributeL.textColor = [UIColor whiteColor];
    carNameL.textColor = [UIColor whiteColor];
    distanceDescributeL.textColor = [UIColor whiteColor];
    carDetailL.textColor = [UIColor whiteColor];
    _distanceT.textColor = [UIColor whiteColor];
    _timeL.textColor = [UIColor whiteColor];
    
}


- (void)setPositionStyle:(PositionStyle)positionStyle
{
    _positionStyle = positionStyle;
    
    MyLog(@"-------%d",positionStyle);
    
    switch (positionStyle) {
        case PositionStyleBottom:
        {
           [MobClick event:@"acsh"];
            _bgView.hidden = YES;
            _collectionView.scrollEnabled = NO;
            [self changeCarDetailGrayColor];
            _headBgV.backgroundColor = [UIColor clearColor];
            _titleV.hidden = NO;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            _titleL.textColor = [UIColor colorWithHexString:@"333333"];
            [_editBtn setImage:[UIImage imageNamed:@"black_edit"] forState:(UIControlStateNormal)];
            
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
                
            } completion:^(BOOL finished) {
                self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
            }];
        }
            break;
            
        case PositionStyleCenter:
        {
            _bgView.hidden = NO;
            _collectionView.scrollEnabled = NO;
            [self changeCarDetailGrayColor];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            _headBgV.backgroundColor = [UIColor clearColor];
            _titleV.hidden = NO;
            _titleL.textColor = [UIColor colorWithHexString:@"333333"];
            [_editBtn setImage:[UIImage imageNamed:@"black_edit"] forState:(UIControlStateNormal)];
            if (![UtilTool isBlankString:_carModel.travlledDistance]) {
                _distanceT.text = [NSString stringWithFormat:@"%@KM",_carModel.travlledDistance];
            }else
            {
                _distanceT.text = @"－－";
                
            }
          
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.frame = CGRectMake(0, SCREEN_HEIGHT/2, self.frame.size.width, self.frame.size.height);
                
            } completion:^(BOOL finished) {
                self.frame = CGRectMake(0, SCREEN_HEIGHT/2, self.frame.size.width, self.frame.size.height);
                
            }];
            
            
        }
            break;
        case PositionStyleTop:
        {
            [MobClick event:@"acshs"];
            _bgView.hidden = NO;
            _collectionView.scrollEnabled = YES;
            [self changeCarDetailWhiteColor];
            
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

            _titleV.hidden = YES;
            _headBgV.backgroundColor = KMAIN_COLOR;
            _titleL.textColor = [UIColor whiteColor];
            [_editBtn setImage:[UIImage imageNamed:@"white_edit"] forState:(UIControlStateNormal)];
            
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                
            } completion:^(BOOL finished) {
                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                
            }];

        }
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _manage = [GroupManage shareGroupManages];
    self.positionStyle = PositionStyleBottom;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLoveCar)];
    [carInfBgView1 addGestureRecognizer:tapGesture];
    

    _contentViewHeight.constant = SCREEN_HEIGHT;
    
    _titleArray = [NSArray arrayWithObjects:@"优惠活动",@"用车心得",@"保养提醒", nil];
    
    _titleV = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
    [_headBgV addSubview:_titleV];
    [self setUpCollectionView];
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.hidden = YES;
    _hud.activityIndicatorColor = KMAIN_COLOR;
    _hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _distanceT.delegate = self;
    _distanceT.tintColor = [UIColor whiteColor];
    
    carImageV.layer.cornerRadius = 17;
    carImageV.layer.masksToBounds = YES;
    
    [self initDefaultCarLiftParking];
    
    
}
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    MyLog(@"%lf",[panGesture translationInView:self.superview].y);
    static BOOL directionUp;
    CGPoint point = [panGesture translationInView:self.superview];
    CGFloat offsetY = point.y;
    if (offsetY > 0) {
        MyLog(@"向下");
        directionUp = NO;
    }else if(offsetY < 0)
    {
        MyLog(@"向上");
        directionUp = YES;

    }
    
    CGFloat targetY = self.frame.origin.y + offsetY;
    if (targetY < 0) {
        targetY = 0;
    }
    
    self.frame = CGRectMake(0, targetY, self.frame.size.width, self.frame.size.height);
    
     MyLog(@"%ld   %lf",[panGesture state],self.frame.origin.y);
    if ([panGesture state] == UIGestureRecognizerStateEnded) {
        if (directionUp) {
            if (SCREEN_HEIGHT >= self.frame.origin.y && self.frame.origin.y >= SCREEN_HEIGHT/2 ) {
               
                self.positionStyle = PositionStyleCenter;
                
            }else if (SCREEN_HEIGHT/2 > self.frame.origin.y && self.frame.origin.y>=0){
                self.positionStyle = PositionStyleTop;
            }
        }else
        {
            if (self.frame.origin.y >= 0 && self.frame.origin.y < SCREEN_HEIGHT/2 ) {
                
                
                self.positionStyle = PositionStyleCenter;

                
            }else if (SCREEN_HEIGHT/2 <= self.frame.origin.y && self.frame.origin.y < SCREEN_HEIGHT){
                
                self.positionStyle = PositionStyleBottom;
            }
        }
    }
    [panGesture setTranslation:CGPointZero inView:self.superview];
}
- (void)setShowView:(UIView *)showView
{
    _showView = showView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActivityView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [showView addGestureRecognizer:tapGesture];
    [showView addGestureRecognizer:panGesture];
}
- (void)showActivityView:(UITapGestureRecognizer *)tapGesture
{
    self.positionStyle = PositionStyleCenter;
}
#pragma mark --重写carModel set方法
- (void)setCarModel:(Car *)carModel
{
    _carModel = carModel;
    if (_carModel == nil) {
        
        carNameL.text = @"－－";
        carDetailL.text = @"请输入车辆信息";
        _distanceT.text = @"－－";
        _timeL.text = @"－－";
        carImageV.image = [UIImage imageNamed:@"useCarFeel"];
    }else
    {
        _distanceT.userInteractionEnabled = YES;
        chooseBtn.userInteractionEnabled = YES;
        [carImageV sd_setImageWithURL:[NSURL URLWithString:_carModel.brandIcon] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
        
        if (![UtilTool isBlankString:_carModel.carName]) {
            NSArray *aTemArray = [_carModel.carName componentsSeparatedByString:@" "];
            if (aTemArray.count > 2) {
                carNameL.text = [NSString stringWithFormat:@"%@ %@",aTemArray[0],aTemArray[1]];
                NSMutableString *temStr = [NSMutableString string];
                for (int i=2; i<aTemArray.count; i++) {
                    [temStr appendString:[NSString stringWithFormat:@"%@ ",aTemArray[i]]];
                    
                }
                carDetailL.text = temStr;
            }else
            {
                carNameL.text = _carModel.carName;
                carDetailL.text = @"";
                
            }
        }else
        {
            carNameL.text = @"－－";
            carDetailL.text = @"请输入车辆信息";
            
        }
        
        if (![UtilTool isBlankString:_carModel.travlledDistance]) {
            _distanceT.text = [NSString stringWithFormat:@"%@KM",_carModel.travlledDistance];
        }else
        {
            _distanceT.text = @"－－";
            
        }
        
        if (![UtilTool isBlankString:_carModel.carUseDate]) {
            _timeL.text = _carModel.carUseDate;
            
        }else
        {
            _timeL.text = @"－－";
        }
    }
    
    if (![UtilTool isBlankString:_carModel.carUseDate] && ![UtilTool isBlankString:_carModel.travlledDistance] && ![UtilTool isBlankString:_carModel.carName]) {
        //        所有数据都不为空时   刷新  保养提醒
        _isNeedAlert = NO;
        
        [self getAlertBaoYang];
        
    }else
    {
        _isNeedAlert = YES;
        
        [_collectionView reloadData];
        //        数据不全   提醒用户补充信息
        
    }

}



#pragma mark -- 切换爱车
- (void)changeLoveCar
{
     [MobClick event:@"wdac"];
    [self showAlertLoginOrChooseCarWithType:NO];
    CarListVC *carListVC = [[CarListVC alloc] init];
    [self.viewController.rt_navigationController pushViewController:carListVC animated:YES complete:nil];
    

}

- (void)setUpCollectionView
{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.collectionViewLayout = layout;
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];

    [_collectionView registerClass:[ActivityHeadview class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellWithReuseIdentifier:@"ActivityCell"];
    
    [_collectionView registerClass:[BaoYangAlertCell class] forCellWithReuseIdentifier:@"BaoYangAlertCell"];
    
    [_collectionView registerClass:[BaoYangCell class] forCellWithReuseIdentifier:@"BaoYangCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CarLifeTopCell" bundle:nil] forCellWithReuseIdentifier:@"CarLifeTopCell"];
    
}
- (IBAction)selfHidden:(id)sender {
    [MobClick event:@"fh"];
    [_distanceT resignFirstResponder];
    self.positionStyle = PositionStyleBottom;
    
   
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_baoYangArray.count > 0 || _isNeedAlert == YES) {
//        如果有保养提醒  返回 3个section
        return 4;
    }else
    {
        return 3;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section != 3) {
        return 2;
    }else
    {
        if (_isNeedAlert == YES) {
            return 1;
        }
        return _baoYangArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CarLifeTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarLifeTopCell" forIndexPath:indexPath];
        //        车管家 微信
        if(indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"carMarster"];
            cell.titleL.text = @"车管家";
        }else
        {
            cell.imageView.image = [UIImage imageNamed:@"chartQun"];
            cell.titleL.text = @"微信社群";
        }
        return cell;
       
    }else if (indexPath.section == 1) {
        ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];

//        类型1:优惠活动
        cell.style = ActivityCellStyleYouHui;
        NSArray *arr = _dataDic[@"type1"];
        if (arr.count > indexPath.row  && arr.count>0) {
            CarLiftModel *model = [arr objectAtIndex:indexPath.row];
            cell.model = model;
        }else
        {
            cell.model = [[CarLiftModel alloc] init];
            
        }
        return cell;
//
    }else if (indexPath.section == 2){
        ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];

//        类型2:用户心得
        cell.style = ActivityCellStyleXinde;

        NSArray *arr = _dataDic[@"type2"];
        if (arr.count > indexPath.row && arr.count>0) {
            CarLiftModel *model = [arr objectAtIndex:indexPath.row];
            cell.model = model;
        }else
        {
            cell.model = [[CarLiftModel alloc] init];
        }
        return cell;
    }else if (indexPath.section == 3){
        
        if (_isNeedAlert == YES) {
            BaoYangAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaoYangAlertCell" forIndexPath:indexPath];
            return cell;
        }else
        {
            
            BaoYangCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaoYangCell" forIndexPath:indexPath];
            cell.dataDic = _baoYangArray[indexPath.row];
            return cell;
        }
        
    }
    
    return nil;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            点击车管家
             [MobClick event:@"cgj"];
            [[QiYuTool new] goToCustomerServiceSessionVC:self.viewController];
            
        }else
        {
//            点击微信
             [MobClick event:@"xxsq"];
            WeChatController *wechatVC = [[WeChatController alloc] init];
            [self.viewController.rt_navigationController pushViewController:wechatVC animated:YES complete:nil];
            
            
        }
        
    }else
    {
        CarLiftModel *model;
        
        if (indexPath.section == 1) {
            NSArray *arr = _dataDic[@"type1"];
             [MobClick event:@"yhhd"];
            if (arr.count > indexPath.row  && arr.count>0) {
                model = [arr objectAtIndex:indexPath.row];
            }
            
        }else if (indexPath.section == 2){
            NSArray *arr = _dataDic[@"type2"];
              [MobClick event:@"ycxd"];
            if (arr.count > indexPath.row  && arr.count>0) {
                model = [arr objectAtIndex:indexPath.row];
            }
        }
        
        if (![UtilTool isBlankString:model.url]) {
            
            WebInfoModel *webModel      = [WebInfoModel new];
            webModel.urlType            = URLTypeNet;
            webModel.shareType          = WebInfoModelTypeShare;
            webModel.title              = model.title;
            webModel.url                = model.url;
            webModel.imagePath          = model.imagePath;
            webModel.descibute          = @"";
            WebViewController *webView  = [[WebViewController alloc] init];
            webView.webModel            = webModel;
            [self.viewController.rt_navigationController pushViewController:webView animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    图片比  1.73:1
    
    if (indexPath.section == 0) {
        
        CGFloat width = SCREEN_WIDTH/2-0.5 ;

        return CGSizeMake(width, width*0.577);

    }else if (indexPath.section == 1 || indexPath.section == 2) {
        CGFloat width = SCREEN_WIDTH/2-0.5 ;
        CGFloat height = width/1.73;
        return CGSizeMake(width, height);
    }else
    {
        
        if(_isNeedAlert == YES){
            
            return CGSizeMake(SCREEN_WIDTH, 120);

        }
        return CGSizeMake(SCREEN_WIDTH/2-0.5, 108);

    }
    
 
}
//设置cell最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section != 0) {
        ActivityHeadview *headV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeadID forIndexPath:indexPath];
        
        if (!headV) {
            headV = [[ActivityHeadview alloc] init];
        }
        
        if(indexPath.section == 3){
//            隐藏更多按钮
            headV.style = ActivityHeadviewStyleTwo;
        }else
        {
            headV.style = ActivityHeadviewStyleOne;

        }
        
        headV.index = indexPath.section-1;
        headV.title = [_titleArray objectAtIndex:indexPath.section-1];
        WS(ws)
        headV.moreBlock = ^(NSInteger index){
            
            //type1 优惠活动
            NSMutableArray *array1 = _dataDic[@"type1"];
            NSMutableArray *array2 =  _dataDic[@"type2"];
            
            ShowAllActivityVC *showAllActivityVC;

            
            if (index == 0) {
                if (array1.count > 0) {
//                   优惠活动
                     [MobClick event:@"yhhdgd"];
                    showAllActivityVC = [[ShowAllActivityVC alloc] init];
                    showAllActivityVC.showAllActivityVCType = ShowAllActivityVCTypeActity;
                    [ws.viewController.rt_navigationController pushViewController:showAllActivityVC animated:YES];
                }else
                {
                    [_manage groupAlertShowWithTitle:@"暂无优惠活动"];
                }
            }else if (index == 1){
                if (array2.count > 0) {
//                    用车心得
                      [MobClick event:@"ycxdgd"];
                    showAllActivityVC = [[ShowAllActivityVC alloc] init];
                    showAllActivityVC.showAllActivityVCType = ShowAllActivityVCTypeExperience;
                    [ws.viewController.rt_navigationController pushViewController:showAllActivityVC animated:YES];
                }else
                {
                    [_manage groupAlertShowWithTitle:@"暂无用车心得"];
                }
            }
            
            
           
        };
        return headV;
        
    }else
    {
        
        UICollectionReusableView *headV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];

        return headV;
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return CGSizeMake(SCREEN_WIDTH, 46);

    }
    return CGSizeMake(SCREEN_WIDTH, 0.1);
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super initWithCoder:aDecoder]) {
        MyLog(@"开始初始化");
    }
    return self;
    
}


- (void)getWeChat2Dbarcode:(Parking *)model
{

}



#pragma mark ---UITextFieldDelegate----


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_distanceT resignFirstResponder];
    
    [self changeDistanceWithDistance:textField.text];
    
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (textField == self.distanceT) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
        }
    }
    return [self validateNumber:string];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0 && [textField.text rangeOfString:@"KM"].location == NSNotFound) {
        textField.text = [NSString stringWithFormat:@"%@KM",textField.text];
    }else if (textField.text.length == 0){
        textField.text = @"－－";

    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (![self showAlertLoginOrChooseCarWithType:YES]) {
        return NO;
    }
    
    self.positionStyle = PositionStyleTop;
   
    if ([textField.text isEqualToString:@"－－"]) {
        textField.text = @"";
    }
    if ([textField.text rangeOfString:@"KM"].location != NSNotFound) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length-2)];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark -- 改变上路时间
- (IBAction)changeTime:(id)sender {
    
    [_distanceT resignFirstResponder];
    [MobClick event:@"slsj"];
    if (![self showAlertLoginOrChooseCarWithType:YES]) {
        return;
    }
    
    DatePickView *yearMonth = [[DatePickView alloc] init];
    [yearMonth show];
    yearMonth.myBlock = ^(NSString *year,NSString *month){
        
        [self changeTimeWithyear:year month:month];
        
    };
    
}

#pragma mark -- 获取保养提醒
- (void)getAlertBaoYang
{
    NSString *summary = [NSString stringWithFormat:@"%@%@%@%@",[UtilTool getCustomId],_carModel.carId,@"2.0.2",SECRET_KEY];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",APP_URL(gainupkeep),[UtilTool getCustomId],_carModel.carId,@"2.0.2",[summary MD5]];
    MyLog(@"保养提醒 %@",url);
    _baoYangArray = [NSArray array];
    
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        _baoYangArray = responseObject[@"data"];
        [_collectionView reloadData];
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    

}
#pragma mark -- 修改行驶里程
- (void)changeDistanceWithDistance:(NSString *)distance
{
    [MobClick event:@"xclc"];
    if ([distance rangeOfString:@"KM"].location != NSNotFound) {
        distance = [distance substringToIndex:distance.length-2];
    }
    [self hubShow];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_carModel.carId,@"carId",distance,@"travlledDistance",@"2.0.2",@"version",[UtilTool getTimeStamp],@"timestamp", nil];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(modtravlleddistance) WithDic:dic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hubHiden];
        _manage.car.travlledDistance = distance;
        self.carModel = _manage.car;

    } error:^(NSString *error) {
        [self hubHiden];
        self.carModel = _manage.car;
    } failure:^(NSString *fail) {
        [self hubHiden];
        self.carModel = _manage.car;
    }];
}

#pragma mark -- 修改上路时间
- (void)changeTimeWithyear:(NSString *)year month:(NSString*)month
{
    NSString *time = [NSString stringWithFormat:@"%@%.2d",year,[month intValue]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_carModel.carId,@"carId",time,@"carUseDate",@"2.0.2",@"version",[UtilTool getTimeStamp],@"timestamp", nil];
    
    [self hubShow];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(modcanusedate) WithDic:dic needEncryption:YES needAlert:YES showHud:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hubHiden];
        
        _manage.car.carUseDate = [NSString stringWithFormat:@"%@-%.2d",year,[month intValue]];

        self.carModel = _manage.car;
        
    } error:^(NSString *error) {
        [self hubHiden];
        self.carModel =  _manage.car;
    } failure:^(NSString *fail) {
        [self hubHiden];
        self.carModel =  _manage.car;

    }];
    
}

- (BOOL)showAlertLoginOrChooseCarWithType:(BOOL)type
{
//    type == yes  需要验证CarModel
    if (!_manage.isVisitor)
    {
        if (type) {
            if (_carModel == nil) {
                return NO;
            }
        }
        return YES;
        
    }else
    {
        
        [UtilTool creatAlertController:self.viewController title:@"提示" describute:@"使用该功能需要登录帐号,是否去登录？" sureClick:^{
            self.positionStyle = PositionStyleBottom;
            LoginVC *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.viewController.rt_navigationController pushViewController:login animated:YES];
        } cancelClick:^{
            
        }];
        
        return NO;
    }
    
  }

@end
