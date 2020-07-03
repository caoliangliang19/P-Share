//
//  NewDaiBoOrderVC.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewDaiBoOrderVC.h"
#import "ParkingReservationVipPriceCell.h"
#import "DaiBoOrderPriceCell.h"
#import "TimePickerView.h"


@interface NewDaiBoOrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString    *_day,*_hours,*_miunte;
    NSString    *_startTime,*_endTime;
    GroupManage *_manage;
    
    NSArray     *_titleArray;
    NSMutableArray *_subTitleArray;

    NSArray     *_sectionTwoTitleArray;
    
    NSString    *_temStr;

}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation NewDaiBoOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代泊";
    [MobClick event:@"StopACarID"];
    _manage = [GroupManage shareGroupManages];
    [self loadTableView];
}

- (void)createChooseTimeView
{
    TimePickerView *_pickerView;

    if (!_pickerView) {
        _pickerView = [[TimePickerView alloc]init];
    }
    __weak typeof(self) myself = self;
    _pickerView.myblock = ^(NSString *day,NSString *hour,NSString *miunte){
        
        _day = day;
        _hours = hour;
        _miunte = miunte;
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *startDate = [dateFormatter stringFromDate:date];
        NSString *endDate;
        if ([day isEqualToString:@"今日"]) {
            endDate = [NSString stringWithFormat:@"%@ %@:%@:00",[myself getToday:[NSDate date]],hour,miunte];
        }else
        {
            endDate = [NSString stringWithFormat:@"%@ %@:%@:00",[myself getTomorrowDay:[NSDate date]],hour,miunte];
        }
        
        MyLog(@"startDate: %@ endDate:%@",startDate,endDate);
        
        _startTime = startDate;
        _endTime = endDate;
        [_subTitleArray replaceObjectAtIndex:3 withObject:endDate];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    _pickerView.cblock = ^(){

    };
    [_pickerView show];
}
#pragma mark - 得到日期
-(NSString *)getTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"YYYY-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}
- (NSString *)getToday:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    return day;
    
}
- (void)loadTableView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _temStr = @"(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section";
//    Car *carModel = _manage.car;
    Parking *park = _manage.parking;
    _titleArray = [NSArray arrayWithObjects:@"代泊车场",@"车牌号码",@"交车时间",@"取车时间", nil];
    _subTitleArray = [NSMutableArray arrayWithObjects:park.parkingName,@"沪A12345",@"17日 18：00",@"请选择取车时间", nil];
    
    _sectionTwoTitleArray = [NSArray arrayWithObjects:@"停车费",@"服务费",@"金卡会员专享价", nil];

    [_tableView registerClass:[DaiBoOrderPriceCell class] forCellReuseIdentifier:@"DaiBoOrderPriceCell"];
    [_tableView registerClass:[ParkingReservationVipPriceCell class] forCellReuseIdentifier:@"ParkingReservationVipPriceCell"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 4;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }

        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = _subTitleArray[indexPath.row];
        if (indexPath.row%2 == 0) {
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"959595"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else
        {
            cell.detailTextLabel.textColor = KMAIN_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;

        }
        
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row < 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"959595"];
            }
            cell.textLabel.text = _sectionTwoTitleArray[indexPath.row];
            cell.detailTextLabel.text = @"¥15";
            return cell;
        }else if (indexPath.row == 2){
            ParkingReservationVipPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingReservationVipPriceCell"];
            return cell;
        }else if (indexPath.row == 3){
            DaiBoOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DaiBoOrderPriceCell"];
            return cell;
        }
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        CGRect rect = [_temStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        return rect.size.height + 30 + 45;
    }
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self createChooseTimeView];
            
        }else if (indexPath.row == 1){
          
        }
    }
}
- (void)payBtnClick
{
    
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.rt_navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
