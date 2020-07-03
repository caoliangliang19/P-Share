//
//  ChooseCarTimeVC.m
//  P-Share
//
//  Created by fay on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ChooseCarTimeVC.h"
#import "AddCarInfoViewController.h"

@interface ChooseCarTimeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView      *_headView;
    NSArray     *_dataArray;
    UIView      *_bgView;

    UIImageView *_braneLogoImageV;
    UILabel     *_braneName;
}
@end

@implementation ChooseCarTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadNavigationbar];
    
    [self setHeadView];
    
    [self loadTableView];
    
    
}
- (void)loadNavigationbar
{
    self.title = @"选择年款";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"defaultBack"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backVC)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
- (void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)setHeadView
{
    UIView *bgView = [UIView new];
    _bgView = bgView;
    bgView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
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
    _braneName = braneName;
    [headView addSubview:braneName];
    [braneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(braneLogoImageV.mas_centerY);
        make.left.mas_equalTo(braneLogoImageV.mas_right).offset(14);
    }];
    
    [_braneLogoImageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"brandIcon"]] placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    _braneName.text = [NSString stringWithFormat:@"%@ %@ %@",_tradeName,_carSeries,_currentDic[@"displacement"]];
    
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
- (void)setCurrentDic:(NSDictionary *)currentDic
{
    _currentDic = currentDic;
    _dataArray = currentDic[@"styleYear"];
    [_braneLogoImageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"brandIcon"]] placeholderImage:nil];
    _braneName.text = [NSString stringWithFormat:@"%@ %@ %@",_tradeName,_carSeries,currentDic[@"displacement"]];
    [_tableView reloadData];
    
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@年产",_dataArray[indexPath.row]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[AddCarInfoViewController class]])
        {
            NSString *intakeType = [NSString stringWithFormat:@"%@",_currentDic[@"intakeType"]];
            NSString *displacementShow = [NSString stringWithFormat:@"%@",_currentDic[@"displacementShow"]];
            NSDictionary *carType = [NSDictionary dictionaryWithObjectsAndKeys:_tradeName,@"tradeName",_dataDic[@"brandName"],@"carBrand",_carSeries,@"carSeries",_currentDic[@"displacement"],@"displacement",_dataArray[indexPath.row],@"styleYear",intakeType,@"intakeType",displacementShow,@"displacementShow", nil];
            
            NSNotification *nition = [NSNotification notificationWithName:@"CarSubKindVCChoseCarType" object:nil userInfo:carType];
            
            [[NSNotificationCenter defaultCenter] postNotification:nition];
            
            [self.navigationController popToViewController:temp animated:YES];
            
            
        }
    }
    
}
@end
