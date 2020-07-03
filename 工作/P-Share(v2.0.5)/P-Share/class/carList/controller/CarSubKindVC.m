//
//  CarSubKindVC.m
//  P-Share
//
//  Created by fay on 16/4/25.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarSubKindVC.h"
#import "CarKindCell.h"
#import "carDetailModel.h"
#import "CarKindModel.h"
#import "AddCarInfoViewController.h"

@interface CarSubKindVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CarSubKindVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableV.backgroundColor = [MyUtil colorWithHexString:@"EEEEEE"];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _carDetailModel.subCarArray.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CarKindModel *model = [_carDetailModel.subCarArray objectAtIndex:section];
    
    return model.nodeName;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    CarKindModel *model = [_carDetailModel.subCarArray objectAtIndex:section];
    if (model.carDataArray.count > 0) {
        return model.carDataArray.count;
    }else
    {
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CarKindCell";
    
    CarKindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CarKindCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        
    }
    CarKindModel *model = [_carDetailModel.subCarArray objectAtIndex:indexPath.section];
    carDetailModel *detailModel;
    if (model.carDataArray.count > 0) {
        detailModel = [model.carDataArray objectAtIndex:indexPath.row];
        cell.carName = detailModel.nodeName;
    }else
    {
        cell.carName = model.nodeName;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableV deselectRowAtIndexPath:indexPath animated:YES];
    
    CarKindModel *model = [_carDetailModel.subCarArray objectAtIndex:indexPath.section];
    carDetailModel *detailModel;
    NSString *temCarName;
    if (model.carDataArray.count > 0) {
        detailModel = [model.carDataArray objectAtIndex:indexPath.row];
        temCarName = detailModel.nodeName;
    }else
    {
        temCarName = model.nodeName;
    }
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
       
        if ([temp isKindOfClass:[AddCarInfoViewController class]])
        {
            NSNotification *nition = [NSNotification notificationWithName:@"CarSubKindVCChoseCarType" object:nil userInfo:@{@"carType":temCarName}];
            [[NSNotificationCenter defaultCenter] postNotification:nition];
            
            [self.navigationController popToViewController:temp animated:YES];
            
            
        }
    }

    
    MyLog(@"%@",detailModel.nodeName);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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
