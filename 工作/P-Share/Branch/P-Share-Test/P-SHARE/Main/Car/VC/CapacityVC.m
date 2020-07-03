//
//  CapacityVC.m
//  P-Share
//
//  Created by fay on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CapacityVC.h"
#import "ChooseCarTimeVC.h"
#import "AddCarInfoViewController.h"

@interface CapacityVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_tableView;
    UIView          *_headView;
    
    NSDictionary    *_dataDic;
    

    UIImageView     *_braneLogoImageV ;
    UILabel         *_braneName;
    UIView          *_bgView;
    UIView                      *_clearBackView;
    MBProgressHUD               *_mbView;
    
    UIAlertView     *_alert;
}

@end

@implementation CapacityVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.automaticallyAdjustsScrollViewInsets = YES;

    self.title = @"选择发动机排量";
    
    [self setHeadView];
    
    [self loadTableView];
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_braneLogoImageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"brandIcon"]] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    _braneName.text = [NSString stringWithFormat:@"%@ %@",_tradeName,_carSeries];
    [_tableView reloadData];
}




- (void)setHeadView
{
    UIView *bgView = [UIView new];
    _bgView = bgView;
    bgView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(52);
    }];
    
    UIView *headView = [UIView new];
    _headView = headView;
    headView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    
    UIImageView *braneLogoImageV = [UIImageView new];
    _braneLogoImageV = braneLogoImageV;
    [headView addSubview:braneLogoImageV];
    [braneLogoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *braneName = [UILabel new];
//    braneName.text = @"text";
    _braneName = braneName;
    [headView addSubview:braneName];
    [braneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(braneLogoImageV.mas_centerY);
        make.left.mas_equalTo(braneLogoImageV.mas_right).offset(14);
    }];

    [_braneLogoImageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"brandIcon"]] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    _braneName.text = [NSString stringWithFormat:@"%@ %@",_tradeName,_carSeries];

}
- (void)loadTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView.mas_bottom);
        make.right.left.bottom.mas_equalTo(0);
    }];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *temDic = _dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",temDic[@"displacementShow"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChooseCarTimeVC *chooseCarTimeVC = [[ChooseCarTimeVC alloc] init];
    NSDictionary *temDic = _dataArray[indexPath.row];
    NSArray *temArray = temDic[@"styleYear"];
    if (temArray.count>0) {
        chooseCarTimeVC.carSeries = _carSeries;
        chooseCarTimeVC.tradeName = _tradeName;
        chooseCarTimeVC.dataDic = _dataDic;
        chooseCarTimeVC.currentDic = temDic;
        [self.rt_navigationController pushViewController:chooseCarTimeVC animated:YES];
    }else
    {
        for (UIViewController *temp in self.rt_navigationController.viewControllers) {
            
            if ([[temp valueForKey:@"contentViewController"] isKindOfClass:[AddCarInfoViewController class]])
            {
                NSString *intakeType = [NSString stringWithFormat:@"%@",temDic[@"intakeTypeValue"]];
                NSDictionary *carType = [NSDictionary dictionaryWithObjectsAndKeys:_tradeName,@"tradeName",_dataDic[@"brandName"],@"carBrand",_carSeries,@"carSeries",temDic[@"displacement"],@"displacement",intakeType,@"intakeType", nil];
                NSNotification *nition = [NSNotification notificationWithName:KUSER_CHOOSE_CARTYPE object:nil userInfo:carType];
                
                [[NSNotificationCenter defaultCenter] postNotification:nition];
                
                [self.rt_navigationController popToViewController:[temp valueForKey:@"contentViewController"] animated:YES];
                
                
            }
        }

    }
    
 
    
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
