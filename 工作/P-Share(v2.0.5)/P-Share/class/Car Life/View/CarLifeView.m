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
#import "SelectParkController.h"
#import "TitleView.h"
#import "BaoYangCell.h"
#import "BaoYangAlertCell.h"
#import "DatePickView.h"
#import "UIView+fayAdd.h"
#import "CarLifeTopCell.h"
#import "CarListViewController.h"

//#import "WebViewController.h"

static NSString *const HeadID = @"ActivityHeadview";
@interface CarLifeView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
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
}
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation CarLifeView



- (IBAction)parkingList:(id)sender {
     [MobClick event:@"xzcc"];
    if (self.jumpBlock) {
        self.jumpBlock();
    }
    
}

+ (CarLifeView *)instaceCarLifeView
{
    MyLog(@"创建成功");
    
    return [[NSBundle mainBundle] loadNibNamed:@"CarLifeView" owner:self options:nil].firstObject;
    
}


- (void)setParkModel:(ParkingModel *)parkModel
{
    if ([_parkModel.parkingId isEqualToString:parkModel.parkingId]) {
        
        return;
        
    }
    _parkModel = parkModel;

    if ([MyUtil isBlankString:parkModel.parkingId]) {
//        如果用户为设置家停车场
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
    [RequestModel requestGetCarLiftWith:queryActivity withDic:dic Completion:^(NSDictionary *dic) {
        
        [self hubHiden];

        _dataDic = dic;
        [_collectionView reloadData];
        
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        
        [self hubHiden];

    }];
    [RequestModel requestDaiBoOrder:getQiyuId WithType:@"getQiyuId" WithDic:dic Completion:^(NSArray *dataArray) {
        
//        if (dataArray.count > 0 ) {
//            [DataSource shareInstance].qiyuId  = dataArray[0];
//        }else
//        {
            [DataSource shareInstance].qiyuId = @"0";
//        }
        
      
    } Fail:^(NSString *error) {
        
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
    carInfBgView1.backgroundColor = [MyUtil colorWithHexString:@"f8f9fa"];
    carInfBgView2.backgroundColor = [MyUtil colorWithHexString:@"f8f9fa"];
    timeDescributeL.textColor = [MyUtil colorWithHexString:@"696969"];
    carNameL.textColor = [MyUtil colorWithHexString:@"333333"];
    distanceDescributeL.textColor = [MyUtil colorWithHexString:@"696969"];
    carDetailL.textColor = [MyUtil colorWithHexString:@"696969"];
    _distanceT.textColor = [MyUtil colorWithHexString:@"333333"];
    _timeL.textColor = [MyUtil colorWithHexString:@"333333"];
}
- (void)changeCarDetailWhiteColor
{
    carInfBgView1.backgroundColor = NEWMAIN_COLOR;
    carInfBgView2.backgroundColor = NEWMAIN_COLOR;
    timeDescributeL.textColor = [UIColor whiteColor];
    carNameL.textColor = [UIColor whiteColor];
    distanceDescributeL.textColor = [UIColor whiteColor];
    carDetailL.textColor = [UIColor whiteColor];
    _distanceT.textColor = [UIColor whiteColor];
    _timeL.textColor = [UIColor whiteColor];
    
}


- (void)awakeFromNib
{

    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLoveCar)];
    
    [carInfBgView1 addGestureRecognizer:tapGesture];
    
    _titleArray = [NSArray arrayWithObjects:@"优惠活动",@"用车心得",@"保养提醒", nil];
    
    _titleV = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
    [_headBgV addSubview:_titleV];
    [self setUpCollectionView];
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.hidden = YES;
    _hud.activityIndicatorColor = NEWMAIN_COLOR;
    _hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _distanceT.delegate = self;
    _distanceT.tintColor = [UIColor whiteColor];
    
    carImageV.layer.cornerRadius = 17;
    carImageV.layer.masksToBounds = YES;
    
}


#pragma mark --重写carModel set方法
- (void)setCarModel:(NewCarModel *)carModel
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
        
        if (![MyUtil isBlankString:_carModel.carName]) {
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
        
        if (![MyUtil isBlankString:_carModel.travlledDistance]) {
            _distanceT.text = [NSString stringWithFormat:@"%@KM",_carModel.travlledDistance];
        }else
        {
            _distanceT.text = @"－－";

        }
        
        if (![MyUtil isBlankString:_carModel.carUseDate]) {
            _timeL.text = _carModel.carUseDate;
            
        }else
        {
            _timeL.text = @"－－";
        }
    }
    
    if (![MyUtil isBlankString:_carModel.carUseDate] && ![MyUtil isBlankString:_carModel.travlledDistance] && ![MyUtil isBlankString:_carModel.carName]) {
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
    [self showAlertLoginOrChooseCarWithType:NO];
    [MobClick event:@"wdac"];
    
    CarListViewController *carListVC = [[CarListViewController alloc] init];
    carListVC.passOnCarNumber = ^(NewCarModel *carModel){
        [DataSource shareInstance].carModel = carModel;
        self.carModel = carModel;
    };
    
    carListVC.goInType = GoInControllerTypeWashCar;
    
    [self.viewController.navigationController pushViewController:carListVC animated:YES];
}

- (void)setUpCollectionView
{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
//    _collectionView.bounces = NO;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = layout;
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];

    [_collectionView registerClass:[ActivityHeadview class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellWithReuseIdentifier:@"ActivityCell"];
    
    [_collectionView registerClass:[BaoYangAlertCell class] forCellWithReuseIdentifier:@"BaoYangAlertCell"];
    
    [_collectionView registerClass:[BaoYangCell class] forCellWithReuseIdentifier:@"BaoYangCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CarLifeTopCell" bundle:nil] forCellWithReuseIdentifier:@"CarLifeTopCell"];
    
}
- (IBAction)selfHidden:(id)sender {

    [_distanceT resignFirstResponder];
    [MobClick event:@"fh"];
    if (self.backClick) {
        self.backClick(self);
    }
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
            if (self.carMasterBlock) {
                self.carMasterBlock(self);
            }

        }else
        {
//            点击微信
            [MobClick event:@"xxsq"];
            [self getWeChat2Dbarcode:self.parkModel];

        }
        
    }else
    {
        CarLiftModel *model;
        
        if (indexPath.section == 1) {
            NSArray *arr = _dataDic[@"type1"];
             [MobClick event:@"yhhd"];
            if (arr.count > indexPath.row  && arr.count>0) {
                model = [arr objectAtIndex:indexPath.row];
            }else
            {
                model = [[CarLiftModel alloc] init];
                
            }
            
        }else if (indexPath.section == 2){
            NSArray *arr = _dataDic[@"type2"];
             [MobClick event:@"ycxd"];
            if (arr.count > indexPath.row  && arr.count>0) {
                model = [arr objectAtIndex:indexPath.row];
            }else
            {
                model = [[CarLiftModel alloc] init];
                
            }
        }
        
        if (![MyUtil isBlankString:model.url]) {
            
            if (self.showActivityDetail) {
                self.showActivityDetail(model);
                
            }
            
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
        headV.moreBlock = ^(NSInteger index){
            //type1 优惠活动
             [MobClick event:@"yhhdgd"];
            NSMutableArray *array1 = _dataDic[@"type1"];
            NSMutableArray *array2 =  _dataDic[@"type2"];
            if (index == 0) {
                if (array1.count > 0) {
                    if (self.carLifeBlock) {
                        self.carLifeBlock(index,array1,self.parkModel);
                    }
                }
            }else if (index == 1){
                if (array2.count > 0) {
                     [MobClick event:@"ycxdgd"];
                    if (self.carLifeBlock) {
                        self.carLifeBlock(index,array2,self.parkModel);
                    }
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


- (void)getWeChat2Dbarcode:(ParkingModel *)model
{
    if (self.weChatAssociateBlock) {
        self.weChatAssociateBlock(self);
    }
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
    [UIView animateWithDuration:0.3 animations:^{
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.superview.mas_bottom).mas_equalTo(0);
        }];
        [self.superview layoutIfNeeded];
        
    }];
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
    NSString *summary = [NSString stringWithFormat:@"%@%@%@%@",[MyUtil getCustomId],_carModel.carId,@"2.0.2",MD5_SECRETKEY];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",gainupkeep,[MyUtil getCustomId],_carModel.carId,@"2.0.2",[summary MD5]];
    MyLog(@"保养提醒 %@",url);
    _baoYangArray = [NSArray array];
    [RequestModel getDicWithUrl:url Completion:^(NSDictionary *dataDic) {
        
        _baoYangArray = dataDic[@"data"];
        [_collectionView reloadData];
        
    } Fail:^(NSString *error) {
        
        
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

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_carModel.carId,@"carId",distance,@"travlledDistance",@"2.0.2",@"version",[MyUtil getTimeStamp],@"timestamp", nil];
    
    [RequestModel postGetDiction:modtravlleddistance WithDic:dic Completion:^(NSDictionary *dataDic) {
        
        [self hubHiden];
        [DataSource shareInstance].carModel.travlledDistance = distance;
        self.carModel = [DataSource shareInstance].carModel;


        
    } Fail:^(NSString *error) {
        [self hubHiden];
        self.carModel = [DataSource shareInstance].carModel;
        ALERT_VIEW(error);
        _alert = nil;

    }];
    
}

#pragma mark -- 修改上路时间
- (void)changeTimeWithyear:(NSString *)year month:(NSString*)month
{
    NSString *time = [NSString stringWithFormat:@"%@%.2d",year,[month intValue]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_carModel.carId,@"carId",time,@"carUseDate",@"2.0.2",@"version",[MyUtil getTimeStamp],@"timestamp", nil];
    
    [self hubShow];
    [RequestModel postGetDiction:modcanusedate WithDic:dic Completion:^(NSDictionary *dataDic) {
        
        [DataSource shareInstance].carModel.carUseDate = [NSString stringWithFormat:@"%@-%.2d",year,[month intValue]];
        self.carModel =  [DataSource shareInstance].carModel;
        [self hubHiden];

    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        self.carModel =  [DataSource shareInstance].carModel;

        
        [self hubHiden];

    }];
}

- (BOOL)showAlertLoginOrChooseCarWithType:(BOOL)type
{
//    type == yes  需要验证CarModel
    if ([MyUtil getCustomId].length > 0)
    {
        if (type) {
            if (_carModel == nil) {
                ALERT_VIEW(@"请先选择车辆");
                return NO;
            }
        }
        return YES;
        
    }else
    {
        UIAlertController *alert = [MyUtil alertController:@"使用该功能需要登录帐号,现在是否去登录？" Completion:^{
            self.positionStyle = PositionStyleBottom;
            LoginViewController *login = [[LoginViewController alloc]init];
            [self.viewController.navigationController pushViewController:login animated:YES];
            
        }Fail:^{
            
        }];
        [self.viewController presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
}



@end
