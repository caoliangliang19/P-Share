//
//  CarLifeVC.m
//  P-SHARE
//
//  Created by fay on 16/10/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CarLifeVC.h"
#import "ActivityCell.h"
#import "CarLiftModel.h"
#import "BaoYangCell.h"
#import "BaoYangAlertCell.h"
#import "DatePickView.h"
#import "CarLifeTopCell.h"
#import "ParkingListVC.h"
#import "WeChatController.h"
#import "ShowAllActivityVC.h"
#import "ActivityHeadview.h"
#import "CarListVC.h"
@interface CarLifeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    NSArray         *_titleArray;
    NSDictionary    *_dataDic;
    NSArray         *_baoYangArray;
    UIAlertView     *_alert;
    BOOL            _isNeedAlert;
    GroupManage     *_manage;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,strong)Parking *parkModel;
@property (nonatomic,strong)Car *carModel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageV;
@property (weak, nonatomic) IBOutlet UITextField *distanceT;
@property (weak, nonatomic) IBOutlet UILabel *carNameL;
@property (weak, nonatomic) IBOutlet UILabel *carDetailL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *carInfoView;

@end

@implementation CarLifeVC
static NSString *const HeadID = @"ActivityHeadview";
+ (instancetype)new
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarLifeVC"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLoveCar)];
    [_carInfoView addGestureRecognizer:tapGesture];
    _manage = [GroupManage shareGroupManages];
    self.carModel = _manage.car;
    _distanceT.delegate = self;
    _distanceT.tintColor = [UIColor whiteColor];
    _carImageV.layer.cornerRadius = 17;
    _carImageV.layer.masksToBounds = YES;
    _titleArray = [NSArray arrayWithObjects:@"优惠活动",@"用车心得",@"保养提醒", nil];
    [self setUpCollectionView];
    [self initDefaultCarLiftParking];


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"carLiftParking"]) {
        MyLog(@"%@",_manage.carLiftParking.parkingName);
        self.parkModel = _manage.carLiftParking;
    }else if ([keyPath isEqualToString:KUSER_CHOOSE_CAR]){
        
        MyLog(@"用户车辆发生变化");

        self.carModel = _manage.car;
    }

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
    [_manage addObserver:self forKeyPath:KUSER_CHOOSE_CAR options:NSKeyValueObservingOptionNew context:nil];

}
- (void)setParkModel:(Parking *)parkModel
{
    if ([_parkModel.parkingId isEqualToString:parkModel.parkingId]) {
        
        return;
        
    }
    _parkModel = parkModel;
    
    if ([UtilTool isBlankString:parkModel.parkingId]) {
        self.navigationItem.title = @"请选择社区名称";
        return;
    }
    self.navigationItem.title = parkModel.parkingName;
    [self loadCarLiftData];
    
}
#pragma mark --切换车辆
- (void)changeLoveCar
{
    [MobClick event:@"wdac"];
    [self showAlertLoginOrChooseCarWithType:NO];
    CarListVC *carListVC = [[CarListVC alloc] init];
    [self.rt_navigationController pushViewController:carListVC animated:YES complete:nil];
    

}
#pragma mark --重写carModel set方法
- (void)setCarModel:(Car *)carModel
{
    _carModel = carModel;
    if (_carModel == nil) {
        
        _carNameL.text = @"－－";
        _carDetailL.text = @"请输入车辆信息";
        _distanceT.text = @"－－";
        _timeL.text = @"－－";
        _carImageV.image = [UIImage imageNamed:@"useCarFeel"];
    }else
    {
        _distanceT.userInteractionEnabled = YES;
        _chooseBtn.userInteractionEnabled = YES;
        [_carImageV sd_setImageWithURL:[NSURL URLWithString:_carModel.brandIcon] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
        
        if (![UtilTool isBlankString:_carModel.carName]) {
            NSArray *aTemArray = [_carModel.carName componentsSeparatedByString:@" "];
            if (aTemArray.count > 2) {
                _carNameL.text = [NSString stringWithFormat:@"%@ %@",aTemArray[0],aTemArray[1]];
                NSMutableString *temStr = [NSMutableString string];
                for (int i=2; i<aTemArray.count; i++) {
                    [temStr appendString:[NSString stringWithFormat:@"%@ ",aTemArray[i]]];
                    
                }
                _carDetailL.text = temStr;
            }else
            {
                _carNameL.text = _carModel.carName;
                _carDetailL.text = @"";
                
            }
        }else
        {
            _carNameL.text = @"－－";
            _carDetailL.text = @"请输入车辆信息";
            
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_carModel.carId,@"carId",distance,@"travlledDistance",@"2.0.2",@"version",[UtilTool getTimeStamp],@"timestamp", nil];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(modtravlleddistance) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        _manage.car.travlledDistance = distance;
        self.carModel = _manage.car;
        
    } error:^(NSString *error) {
        self.carModel = _manage.car;
    } failure:^(NSString *fail) {
        self.carModel = _manage.car;
    }];
}

#pragma mark -- 修改上路时间
- (void)changeTimeWithyear:(NSString *)year month:(NSString*)month
{
    NSString *time = [NSString stringWithFormat:@"%@%.2d",year,[month intValue]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_carModel.carId,@"carId",time,@"carUseDate",@"2.0.2",@"version",[UtilTool getTimeStamp],@"timestamp", nil];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(modcanusedate) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _manage.car.carUseDate = [NSString stringWithFormat:@"%@-%.2d",year,[month intValue]];
        
        self.carModel = _manage.car;
        
    } error:^(NSString *error) {
        self.carModel =  _manage.car;
    } failure:^(NSString *fail) {
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
        
        [UtilTool creatAlertController:self title:@"提示" describute:@"使用该功能需要登录帐号,是否去登录？" sureClick:^{
            LoginVC *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.rt_navigationController pushViewController:login animated:YES];
        } cancelClick:^{
            
        }];
        
        return NO;
    }
    
}



- (void)loadCarLiftData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_parkModel.parkingId,@"parkingId",@"2.0.2",@"version", nil];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryActivity) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        
    } failure:^(NSString *fail) {
        
    }];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(getQiyuId) WithDic:dic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _manage.qiyuId = @"0";
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
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

- (void)loadNav
{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white_edit"] style:UIBarButtonItemStylePlain  target:self action:@selector(chageCar)];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)chageCar
{
    [MobClick event:@"xzcc"];
    ParkingListVC *parkListVC = [[ParkingListVC alloc] init];
    parkListVC.style = ParkingListVCStyleLoveCarLife;
    [self.rt_navigationController pushViewController:parkListVC animated:YES complete:nil];
}

#pragma  mark -- collection delegate datasource
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
            [[QiYuTool new] goToCustomerServiceSessionVC:self];
            
        }else
        {
            //            点击微信
            [MobClick event:@"xxsq"];
            if (![UtilTool isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:KCARLIFT_PARKINGID]]) {
                
                WeChatController *wechatVC = [[WeChatController alloc] init];
                [wechatVC getWeChat2Dbarcode:^(WeChatController *weChatVC, BOOL haveImage, NSString *describute) {
                    if (haveImage) {
                        [self.rt_navigationController pushViewController:wechatVC animated:YES complete:nil];
                    }
                }];
                
            }else{
                [_manage groupAlertShowWithTitle:@"请先选择社区"];
            }
        
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
            [self.rt_navigationController pushViewController:webView animated:YES complete:nil];
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
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
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
                    [ws.rt_navigationController pushViewController:showAllActivityVC animated:YES complete:nil];
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
                    [ws.rt_navigationController pushViewController:showAllActivityVC animated:YES complete:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
