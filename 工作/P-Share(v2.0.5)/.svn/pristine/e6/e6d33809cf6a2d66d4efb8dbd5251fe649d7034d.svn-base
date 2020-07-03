//
//  CarErrorDetailController.m
//  P-Share
//
//  Created by 亮亮 on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CarErrorDetailController.h"
#import "ErrorDetailCell.h"
#import "ErrorDetailTwoCell.h"
@interface CarErrorDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *carTypeArray;
@property (nonatomic,strong)NSMutableArray *carDetailArray;
@end

@implementation CarErrorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([_regulation.handled isEqualToString:@"1"]) {
        _carType.text = @"已处理";
    }
    else if ([_regulation.handled isEqualToString:@"0"])
    {
        _carType.text = @"未处理";
    }
    else
    {
        _carType.text = @"处理状态未知";
    }

    
    _carNumber.text = _regulation.hphm;
    
    [self createDatasource];
    [self createTableView];
    
}
- (void)createTableView{
     self.carErrorTableView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    self.carErrorTableView.delegate = self;
    self.carErrorTableView.dataSource = self;
    self.carErrorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.carErrorTableView.tableFooterView = [[UIView alloc]init];

}
- (void)createDatasource{
    self.carTypeArray = [NSMutableArray arrayWithObjects:@"违章日期:",@"违章时间:",@"违章城市:",@"违章地点:",@"违章罚款:",@"违章扣分:",@"违章行为:", nil];
    NSArray *timeArr = [_regulation.date componentsSeparatedByString:@" "];
    
    _carDetailArray = [NSMutableArray arrayWithObjects:timeArr[0],timeArr[1],_regulation.place,_regulation.area,_regulation.money,_regulation.fen,_regulation.act, nil];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carTypeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 6) {
        ErrorDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorDetailTwoCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ErrorDetailTwoCell" owner:self options:nil]lastObject];
        }
        cell.carErrorTime.text = self.carTypeArray[indexPath.row];
        cell.carErrorDetail.text = _carDetailArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        ErrorDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ErrorDetailCell" owner:self options:nil]lastObject];
        }
        cell.carErrorTime.text = self.carTypeArray[indexPath.row];
        cell.carErrorDetail.text = _carDetailArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *temStr = [NSString stringWithFormat:@"%@:%@",_carTypeArray[indexPath.row],_carDetailArray[indexPath.row]];
    
    
    CGRect rect = [temStr boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
    
    if (indexPath.row == 6) {
        return rect.size.height+60;
    }
    
    return rect.size.height+15;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    MyLog(@"111111");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
