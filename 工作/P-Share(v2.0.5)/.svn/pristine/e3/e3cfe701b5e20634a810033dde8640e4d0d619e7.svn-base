//
//  DaiBoOrderVC.m
//  P-Share
//
//  Created by fay on 16/6/30.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaiBoOrderVC.h"
#import "DaiBoPriceCell.h"
#import "DaiBoOrderCell.h"
#import "TimePickerView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CarListViewController.h"

NSString *const indifier = @"DaiBoOrderCell";
NSString *const image    = @"image";
NSString *const title    = @"title";

@interface DaiBoOrderVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray         *_dataArray;

    NSString        *_describute;
    TimePickerView  *_pickerView;
    NSString        *_day,*_hours,*_miunte;
    NSString        *_startTime,*_endTime;
    NSString        *_yuJiGetCarTime;
    
    
}
@property (nonatomic,strong) UIView          *grayView;
@property (nonatomic,strong) NSMutableArray  *rightLabelArray;
@property (nonatomic,strong)  UITableView     *tableView;
@end

@implementation DaiBoOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    self.title = @"代泊订单";
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    tableV.delegate = self;
    tableV.tableHeaderView.backgroundColor = [UIColor clearColor];
    tableV.dataSource = self;
    tableV.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    tableV.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _tableView = tableV;
    [tableV registerNib:[UINib nibWithNibName:@"DaiBoOrderCell" bundle:nil] forCellReuseIdentifier:indifier];
    [tableV registerNib:[UINib nibWithNibName:@"DaiBoPriceCell" bundle:nil] forCellReuseIdentifier:@"DaiBoPriceCell"];

    [self loadData];
    [self loadGrayView];
    
}
- (void)loadData
{
    _yuJiGetCarTime = @"";
    
    _dataArray = [NSArray arrayWithObjects:
                  @{image:@"point_v2.0.1",title:@"代泊车场"},
                  @{image:@"carImage_v2.0.1",title:@"车牌号码"},
                  @{image:@"calendar_v2.0.1",title:@"交车时间"},
                  @{image:@"getCarImage_v2.0.1",title:@"预计取车"},
                  nil];
    _rightLabelArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"您要几点取车", nil];
    
    
    _describute = @"说明内容说明内容说明内容说明内容说明内容说明内容说明内容说明内容说明内容说明内容说明内容";

}
- (void)loadGrayView
{
    UIView *grayView = [UIView new];
    _grayView = grayView;
    _grayView.hidden = YES;
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.5;
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4) {
        DaiBoOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:indifier];
        NSDictionary *aDic  = [_dataArray objectAtIndex:indexPath.row];
        cell.leftImage.image = [UIImage imageNamed:aDic[image]];
        cell.leftLabel.text = aDic[title];
        cell.rightL.text = _rightLabelArray[indexPath.row];
        if (indexPath.row == 2) {
            cell.rightImage.hidden = YES;
        }else
        {
            cell.rightImage.hidden = NO;
        }
        
        if (indexPath.row == 3 && [cell.rightL.text isEqualToString:@"您要几点取车"]) {
            cell.rightL.textColor = [MyUtil colorWithHexString:@"aaaaaa"];
        }else
        {
            cell.rightL.textColor = [MyUtil colorWithHexString:@"333333"];

        }
        
        return cell;
    }else
    {
        DaiBoPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DaiBoPriceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
        
    }
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
//            选择代泊车场
        }else if (indexPath.row == 1){
//            选择车牌号码
            [self chooseCarNum];
        }else if (indexPath.row == 3){
//            预计取车时间
            [self yuJiGetCarTime];
        }
    }
}
#pragma mark -- 选择车牌号
- (void)chooseCarNum
{
    CarListViewController *CarList = [[CarListViewController alloc]init];
    CarList.goInType = GoInControllerTypeWashCar;
    CarList.passOnCarNumber = ^(NewCarModel *carModel){
        NSString *temStr = _rightLabelArray[1];
        temStr = carModel.carNumber;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [_rightLabelArray replaceObjectAtIndex:1 withObject:temStr];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:CarList animated:YES];
}
#pragma mark -- 预计取车时间
- (void)yuJiGetCarTime
{
    
    _grayView.hidden = NO;
    if (!_pickerView) {
        _pickerView = [[TimePickerView alloc]init];
    }
    __weak typeof(self) myself = self;
    _pickerView.myblock = ^(NSString *day,NSString *hour,NSString *miunte){
        
        myself.grayView.hidden = YES;
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
        _startTime = startDate;
        _endTime = endDate;
        
        NSString *temStr = myself.rightLabelArray[3];
        temStr = [NSString stringWithFormat:@" %@  %@:%@",day,hour,miunte];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [myself.rightLabelArray replaceObjectAtIndex:3 withObject:temStr];
        [myself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    _pickerView.cblock = ^(){
        myself.grayView.hidden = YES;
    };
    [_pickerView show];
}

#pragma mark - 得到日期
-(NSString *)getTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        CGFloat height = [_describute boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-64-14, 300) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
        
        return height + 14 + 14 + 72;
        
    }else
    {
        return 52;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 72;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *payBtn = [UIButton new];
    [payBtn addTarget:self action:@selector(payBthClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
    }];
    [payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    payBtn.backgroundColor = NEWMAIN_COLOR;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [payBtn setTitle:@"立 即 支 付" forState:(UIControlStateNormal)];
    payBtn.layer.cornerRadius = 4;
    payBtn.layer.masksToBounds = YES;
    return view;
}
- (void)payBthClick
{
    MyLog(@"点击支付按钮");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
