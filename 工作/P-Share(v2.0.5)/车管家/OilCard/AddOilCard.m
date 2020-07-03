//
//  AddOilCard.m
//  P-Share
//
//  Created by fay on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "AddOilCard.h"
#import "OilCardCell.h"
#import "SuccessView.h"
#import "AddOilCardController.h"
#import "RequestModel.h"
#import "DataSource.h"

#import "OilCardHuaController.h"
@interface AddOilCard ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation AddOilCard

- (void)viewDidLoad {
    [super viewDidLoad];
     [self requestUI];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
    [_tableV registerNib:[UINib nibWithNibName:@"OilCardCell" bundle:nil] forCellReuseIdentifier:@"OilCardCell"];
}
#pragma mark - 
#pragma mark - 网络请求更新数据
- (void)requestUI{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    MyLog(@"%@",userId);
    [RequestModel requestAddOilCardListWithURL:userId WithType:nil Completion:^(NSMutableArray * array) {
        [self.tableV reloadData];
    } Fail:^(NSString *error) {
        
    }];
}
#pragma mark -
#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataSource shareInstance].oilCardListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OilCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OilCardCell"];
    OilCardModel *model = [DataSource shareInstance].oilCardListArray[indexPath.row];
    if ([model.cardType integerValue] == 1) {
        cell.oilName.text = @"中国石化";
        cell.oilImageView.image = [UIImage imageNamed:@"sinopec_w"];
    }else{
        cell.oilName.text = @"中国石油";
        cell.oilImageView.image = [UIImage imageNamed:@"cnpc"];
    }
  
    cell.myLable.text = model.cardNo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     OilCardModel *model = [DataSource shareInstance].oilCardListArray[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(passOnChange:)]) {
        [self.delegate passOnChange:model];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
   
    
}
#pragma mark -
#pragma mark - 出现更新完成弹框
- (void)newPopView{
    __weak typeof(self) weakself = self;
    
    SuccessView *successV = [[SuccessView alloc]init];
    //    successV.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:successV];
    
     successV.layer.zPosition = 2;
    [successV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakself.view);
        make.left.mas_equalTo(47);
        make.right.mas_equalTo(-47);
        make.height.mas_equalTo(successV.mas_width).dividedBy(281/126);
        
    }];
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
- (IBAction)backVC:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addOilCardClick:(id)sender {
    AddOilCardController *addOil = [[AddOilCardController alloc]init];
    addOil.myBlock = ^(){
        [self requestUI];
        [self newPopView];
    };
    [self.navigationController pushViewController:addOil animated:YES];
}


@end
