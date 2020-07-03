//
//  ParkingReservationVC.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ParkingReservationVC.h"
#import "ParkingReservationChooseTimeCell.h"
#import "YuYueTaoCanCell.h"
#import "YuYueModel.h"
#import "YuYueTimeModel.h"
#import "NoPackageCell.h"
#import "YouHuiQuanCell.h"
#import "ReservationParkingTimeCell.h"
#import "ParkingReservationPriceCell.h"
#import "ParkingReservationVipPriceCell.h"

static NSString *const KYuYueTimeModel = @"yuYueTimeModel";
@interface ParkingReservationVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YuYueModel      *_yuYueModel;
    NSMutableArray  *_taoCanArray;
    NSDictionary    *_changeDayDic;
    UIAlertView     *_alert;
    UIButton        *_payBtn;
//  纪录周一到周五单日套餐   多日套餐用GroupManage记录
    YuYueTimeModel  *_yuYueTimeModel;
    GroupManage     *_manage;
    NSString        *_temStr;
}
@property (nonatomic,strong) UITableView *tableV;


@end

@implementation ParkingReservationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预约停车";
    _temStr = @"优惠停车说明:[MyUtil createLabelFrame:CGRectZero title:@"" textColor: font: textAlignment: numberOfLine:]";
    _manage = [GroupManage shareGroupManages];
    [_manage addObserver:self forKeyPath:KYuYueTimeModel options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self loadTableView];


}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KYuYueTimeModel]) {
        if ([UtilTool isBlankString:_manage.yuYueTimeModel.price]) {
            _payBtn.userInteractionEnabled = NO;
            [_payBtn setBackgroundColor:[UIColor grayColor]];
        }else{
            _payBtn.userInteractionEnabled = YES;
            [_payBtn setBackgroundColor:KMAIN_COLOR];
        }
        [_tableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)loadTableView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    _changeDayDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"周一",@"2",@"周二",@"3",@"周三",@"4",@"周四",@"5",@"周五",@"6",@"周六",@"7",@"周日", nil];
    _taoCanArray = [NSMutableArray array];
    _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [_tableV registerClass:[ParkingReservationChooseTimeCell class] forCellReuseIdentifier:@"ParkingReservationChooseTimeCell"];
    [_tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_tableV registerClass:[YuYueTaoCanCell class] forCellReuseIdentifier:@"YuYueTaoCanCell"];
    [_tableV registerClass:[NoPackageCell class] forCellReuseIdentifier:@"NoPackageCell"];
    [_tableV registerClass:[ReservationParkingTimeCell class] forCellReuseIdentifier:@"ReservationParkingTimeCell"];
    [_tableV registerClass:[ParkingReservationVipPriceCell class] forCellReuseIdentifier:@"ParkingReservationVipPriceCell"];

    [_tableV registerClass:[ParkingReservationPriceCell class] forCellReuseIdentifier:@"ParkingReservationPriceCell"];
    [_tableV registerClass:[YouHuiQuanCell class] forCellReuseIdentifier:@"YouHuiQuanCell"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    }else if (section == 1){
        if (_taoCanArray.count > 0) {
            return _taoCanArray.count + 1;
        }else
        {
            return 2;
        }
    }else if (section == 2){
        return 3;
    }else if (section == 3){
        return 1;
    }else if (section == 4){
        return 2;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ParkingReservationChooseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingReservationChooseTimeCell"];
        cell.dataArray = _yuYueModel.weekArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(ws)
        cell.timeCallBackBlock = ^(ParkingReservationChooseTimeCell *cell,YuYueTimeModel *model){
            [ws requestYuYueTingChaTaoCanWithDay:model];
        };
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.textLabel.text = @"优惠套餐选择";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            return cell;
        }else if(indexPath.row == 1)
        {
            if (_taoCanArray.count == 0) {
                NoPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoPackageCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.describute = @"暂时无套餐";
                return cell;
            }else
            {
                YuYueTaoCanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueTaoCanCell"];
                YuYueTimeModel *model = [_taoCanArray objectAtIndex:indexPath.row-1];
                cell.timeArrar = _yuYueModel.weekArray;
                cell.model = model;
                if (model.isSelect) {
                    cell.selectStyle = YuYueTaoCanCellSelectStyleSelected;
                }else
                {
                    cell.selectStyle = YuYueTaoCanCellSelectStyleUnSelect;
                }
                return cell;
            }

        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.textLabel.text = @"停车时间";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            return cell;
        }else
        {
            ReservationParkingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReservationParkingTimeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (indexPath.row == 2) {
                cell.reservationParkingTimeCellStyle = ReservationParkingTimeCellStyleIn;
            }else
            {
                cell.reservationParkingTimeCellStyle = ReservationParkingTimeCellStyleOut;

            }
            return cell;
        }
    }else if (indexPath.section == 3){
        YouHuiQuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YouHuiQuanCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            ParkingReservationPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingReservationPriceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yuYueTimeModel = _manage.yuYueTimeModel;
            return cell;
        }else
        {
            ParkingReservationVipPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingReservationVipPriceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55.0f;
    }else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            return 40;
        }else
        {
            return 47;
        }
    }else if (indexPath.section == 2){
        return 40;
    }else if (indexPath.section == 3){
        return 60;
    }else if (indexPath.section == 4){
        return 40;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 12.5f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && _taoCanArray.count > 0) {
        YuYueTimeModel *model = [_taoCanArray objectAtIndex:indexPath.row-1];
        _manage.yuYueTimeModel = model;
        if (model.isSelect) {
            model.isSelect = NO;
            _manage.yuYueTimeModel = _yuYueTimeModel;

        }else
        {
            _manage.yuYueTimeModel = model;
            _yuYueTimeModel.isSelect = NO;
            model.isSelect = YES;
        }
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        
        [_tableV reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationFade)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 请求套餐
- (void)requestYuYueTingChaTaoCanWithDay:(YuYueTimeModel *)timeModel
{
    
    _yuYueTimeModel = timeModel;
    MyLog(@"%@",_yuYueTimeModel.week);
    
    _manage.yuYueTimeModel = timeModel;
    Parking *parking = _manage.parking;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:parking.parkingId,@"parkingId",[_changeDayDic valueForKey:timeModel.week],@"week",@"1.3.7",@"version", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(choseWeek) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [_taoCanArray removeAllObjects];
        for (NSDictionary *dic in responseObject[@"data"]) {
            YuYueTimeModel *model = [YuYueTimeModel shareObjectWithDic:dic];
            model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
            [_taoCanArray addObject:model];
        }
        [_tableV reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                                                 
        MyLog(@"%@",responseObject);
    } error:^(NSString *error) {
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *footView = [UIView new];
        UILabel *descributeL = [UtilTool createLabelFrame:CGRectZero title:_temStr textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
        descributeL.numberOfLines = 0;
        descributeL.textAlignment = 0;
        [footView addSubview:descributeL];
        [descributeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        UIButton *payBtn = [UIButton new];
        _payBtn = payBtn;
        payBtn.backgroundColor = KMAIN_COLOR;
        [payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [payBtn setTitle:@"确认提交" forState:(UIControlStateNormal)];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [footView addSubview:payBtn];
        payBtn.layer.cornerRadius = 6;
        payBtn.layer.masksToBounds = YES;
        
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(descributeL.mas_bottom).offset(15);
            make.height.mas_equalTo(45);
        }];
        
        
        return footView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        CGRect rect = [_temStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        return rect.size.height + 30 + 45;
    }
    return 0.1;
}
#pragma mark -- 前往支付界面
- (void)payBtnClick
{
    PayCenterViewController *payCenterVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
    payCenterVC.orderKind = PayCenterViewControllerOrferTypeYuYue;
    payCenterVC.packageId = _manage.yuYueTimeModel.Id;
    payCenterVC.appointmentDate = [_changeDayDic valueForKey:_yuYueTimeModel.week];
    
    [self.rt_navigationController pushViewController:payCenterVC animated:YES complete:nil];
}

- (void)dealloc
{

    [_manage removeObserver:self forKeyPath:KYuYueTimeModel];
}



@end
