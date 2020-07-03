//
//  YuYueTingCheVC.m
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "YuYueTingCheVC.h"
#import "YuYueTingCheCell.h"
#import "YuYueCell.h"
#import "YuYueBtnCell.h"
#import "YuYueShiDuanCell.h"
#import "YuYuePingZhengDetail.h"
#import "PingZhengModel.h"
#import "selfAlertView.h"
#import "CalendarView.h"
#import "BQLCalendar.h"
#import "ShareTemParkingViewController.h"
@interface YuYueTingCheVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray *_arr;
    UIAlertView *_alert;
    UIButton *_temBtn;
    NSString *_temPrice;
    selfAlertView *_selfView;
    UIView *_grayView;
    NSString *_temCarNum;
    NSString *_temDate;

}

@end

@implementation YuYueTingCheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arr = [NSArray arrayWithObjects:@"停车场名称",@"车牌号码",@"预约日期",@"预计优惠时间短",@"优惠停车次数",@"优惠停车价格", nil];
    
//    [_tableV registerClass:[YuYueTingCheCell class] forCellReuseIdentifier:@"YuYueTingCheCell"];YuYueBtnCell
    [_tableV registerNib:[UINib nibWithNibName:@"YuYueCell" bundle:nil] forCellReuseIdentifier:@"YuYueCell"];
    [_tableV registerNib:[UINib nibWithNibName:@"YuYueShiDuanCell" bundle:nil] forCellReuseIdentifier:@"YuYueShiDuanCell"];
    [_tableV registerNib:[UINib nibWithNibName:@"YuYueBtnCell" bundle:nil] forCellReuseIdentifier:@"YuYueBtnCell"];

    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableV.tableFooterView = [[UIView alloc] init];
    _grayView = [[UIView alloc] init];
    _grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _grayView.backgroundColor = [UIColor blackColor];
    _grayView.alpha = 0.5f;
    [self.view addSubview:_grayView];
    _grayView.hidden = YES;
    
    _temCarNum = _carModel.carNumber;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    _temDate = [formatter stringFromDate:[NSDate date]];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        YuYueShiDuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueShiDuanCell"];
        cell.startTimeL.text = _parkingModel.startTime;
        cell.endTimeL.text = _parkingModel.stopTime;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ( indexPath.row == 6){
        YuYueBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueBtnCell"];
        
        __weak typeof(self)weakSelf = self;
        _temBtn = cell.commitBtn;
        
        
        cell.commitYueYue = ^()
        {
            NSArray *dataArray = [_temDate componentsSeparatedByString:@"/"];
            NSString *dataS = [dataArray componentsJoinedByString:@"-"];
            NSString *summmery  = [[NSString stringWithFormat:@"%@%@%@%@%@",_parkingModel.parkingId,_temCarNum,dataS,[MyUtil getVersion],MD5_SECRETKEY] MD5];
            
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",queryAppointment,_parkingModel.parkingId,_temCarNum,dataS,[MyUtil getVersion],summmery];
            [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
                
                
            ShareTemParkingViewController *shareVC = [[ShareTemParkingViewController alloc] init];
            shareVC.parkingNum = @"1";
            shareVC.appointmentDate = dataS;
            shareVC.pModel = weakSelf.parkingModel;
            shareVC.carModel = weakSelf.carModel;
            shareVC.nowLatitude = weakSelf.nowLatitude;
            shareVC.nowLongitude = weakSelf.nowLongitude;
            [self.navigationController pushViewController:shareVC animated:YES];
                
            } Fail:^(NSString *errror) {
                ALERT_VIEW(errror);
                _alert = nil;
            }];
           
            
      
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }else{
        YuYueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueCell"];
        cell.mainL.text = _arr[indexPath.row];

        if (indexPath.row == 0)
        {
//            cell.mainL.text = _arr[indexPath.row];
            [cell.rightImg removeFromSuperview];
            cell.subL.text = _parkingModel.parkingName;
            
        }else  if (indexPath.row == 1){
//            cell.mainL.text = _arr[indexPath.row];
            cell.subL.text = _temCarNum;
            
        }else if (indexPath.row == 2){
//            cell.mainL.text = _arr[indexPath.row];
           
            cell.subL.text = _temDate;
            
        }else if (indexPath.row == 4){
            [cell.rightImg removeFromSuperview];
            cell.subL.text = [NSString stringWithFormat:@"1 次"];
            
        } else{
            //            pointModel.startTime,pointModel.stopTime,pointModel.shareprice
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            if ([[userDefault objectForKey:identity] isEqualToString:@"1"] && [_parkingModel.vipSharePrice intValue] != 0 ) {
                
                cell.subL.text = [NSString stringWithFormat:@"%@  元",_parkingModel.vipSharePrice];
                
            }else
            {
                cell.subL.text = [NSString stringWithFormat:@"%@  元",_parkingModel.sharePrice];
            }
            
            NSMutableAttributedString *attrbuteStr = [[NSMutableAttributedString alloc] initWithString:cell.subL.text];
            [attrbuteStr addAttribute:NSForegroundColorAttributeName value:[MyUtil colorWithHexString:@"f98100"] range:NSMakeRange(0, cell.subL.text.length-3)];
            [attrbuteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28] range:NSMakeRange(0, cell.subL.text.length-3)];
            cell.subL.attributedText = attrbuteStr;
            
            [cell.rightImg removeFromSuperview];
            _temPrice = cell.subL.text;
            
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    if (indexPath.row == 6){
        return 100;
    }
    return 55;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableV deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
//        重新选车辆
        _selfView = [[selfAlertView alloc]init];
        
        _selfView.grayView = _grayView;
        _selfView.grayView.hidden = NO;
        _selfView.titleStr = @"选择您的车辆";
        _selfView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        _selfView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self)weakSelf = self;
        _selfView.nextStep = ^(CarModel *model){
            MyLog(@"%@",model.carNumber);
            
            if (model == nil) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择车辆" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;
                return ;
            }
            _temCarNum = model.carNumber;
            [weakSelf.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
        [self.view addSubview:_selfView];
        _selfView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
//        _selfView.dataArray = _carArray;
        [_selfView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(220);
            
            make.width.mas_equalTo(SCREEN_WIDTH-108);
            
            make.centerY.mas_equalTo(weakSelf.view);
            
            make.centerX.mas_equalTo(weakSelf.view);
            
        }];
        
        [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
            _selfView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        } completion: nil];

        
    }else if (indexPath.row == 2){
//        重新选时间
        
        CalendarView *calendarView = [[CalendarView alloc] init];
        __weak typeof(self)weakSelf = self;
        [calendarView makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf.view);
            make.size.mas_equalTo(CGSizeMake(281, 386));
        }];

        
        calendarView.sureClick = ^(NSString *date)
        {
           
            [weakSelf.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            

        };
        
        BQLCalendar *calendar = [[BQLCalendar alloc] initWithFrame:CGRectMake(0, 102, 281, 240)];
        calendar.tag = 100;
        [calendarView addSubview:calendar];
        calendarView.calendar = calendar;
        calendar.dateSource = [NSDate date];
        [calendar initSign:nil Touch:^(NSString *date) {
            MyLog(@"点击了日期:%@",date);
            
            _temDate = date;
            
            
            
        }];
        
        
        return;

    }
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
