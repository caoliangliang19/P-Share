//
//  SearchParkingViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "SearchParkingViewController.h"
#import "SetParkingCell.h"
#import "NewParkingdetailVC.h"
#import "UIImageView+WebCache.h"

@interface SearchParkingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UIButton *_temHomeBtn;
    UIButton *_temOfficeBtn;
}

@property (nonatomic,strong)NSMutableArray *searchArray;

@end

@implementation SearchParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchArray = [NSMutableArray array];
    
    [self setDefaultUI];
}
//- (NSMutableArray *)homeArray{
//    if (_homeArray) {
//        _homeArray = [NSMutableArray array];
//    }
//    return _homeArray;
//}
- (void)setDefaultUI
{
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.searchTextField.layer.cornerRadius = 4;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.backgroundColor = [MyUtil colorWithHexString:@"#269d8a"];
    [self.searchTextField setValue:[MyUtil colorWithHexString:@"#93cec5"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
}

- (void)dealloc
{
    
}

#pragma mark -UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.searchTextField resignFirstResponder];
    
    [self searchRefresh];
    
    return YES;
}

- (void)searchRefresh
{
    if (self.searchTextField.text.length != 0) {
        
        //---------------------------网路请求-----搜索车场

        
//        NSString *tem = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.searchTextField.text,[MyUtil getVersion],MD5_SECRETKEY] MD5];
        
        
//        MyLog(@"%@   ",summary);
        //
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",SEARCH_PARKLIST_BY_NAME,self.searchTextField.text,[MyUtil getVersion],summary];
      

        [RequestModel requestGetPhoneNumWithURL:url WithDic:nil Completion:^(NSDictionary *dict) {
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                [self.searchArray removeAllObjects];
                
              
                    NSArray *dataArray = dict[@"list"];
                if (dataArray.count == 0) {
                    ALERT_VIEW(@"无数据");
                    return ;
                }
                    for (NSDictionary *tmpDict in dataArray){
                        ParkingModel *model = [[ParkingModel alloc] init];
                        [model setValuesForKeysWithDictionary:tmpDict];
                        [self.searchArray addObject:model];
                    }
                
                [self.searchTableView reloadData];
            }else{
                
                #pragma mark --- 未搜索到目标停车场
                ALERT_VIEW(@"您所搜索的停车场口袋停暂未合作，您可以尝试搜索其他停车场,谢谢！");
                _alert = nil;
                
                MyLog(@"%@",dict[@"msg"]);
            }
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
            _alert = nil;
        }];
        //---------------------------网路请求
    }else{
        ALERT_VIEW(@"请输入关键字");
        _alert = nil;
    }
}

#pragma mark --   UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"setParkingCellId";
    __weak SetParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetParkingCell" owner:self options:nil]lastObject];
    }
    
    ParkingModel *model = self.searchArray[indexPath.row];
    cell.parkingTitleLabel.text = model.parkingName;
    cell.parkingPriceLabel.text = model.parkingAddress;
    if (model.parkingPath.length > 10) {
        [cell.parkingImageView sd_setImageWithURL:[NSURL URLWithString:model.parkingPath] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    }
    MyLog(@"%@===",_homeArray);
    ParkingModel *homeModel = [self.homeArray objectAtIndex:0];
    ParkingModel *officModel = [self.homeArray objectAtIndex:1];
    
    cell.homeBtn.backgroundColor = [UIColor whiteColor];
    [cell.homeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    
    cell.officeBtn.backgroundColor = [UIColor whiteColor];
    [cell.officeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    
    //    设置  如果车场已经被设置为首页
    if ([model.parkingId isEqualToString:homeModel.parkingId]) {
        cell.homeBtn.backgroundColor = NEWMAIN_COLOR;
        [cell.homeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
    }
    if([model.parkingId isEqualToString:officModel.parkingId])
    {
        cell.officeBtn.backgroundColor = NEWMAIN_COLOR;
        [cell.officeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    
    cell.homeBtn.tag = indexPath.row;
    cell.officeBtn.tag = indexPath.row;
    
    cell.colorView.backgroundColor = [UIColor lightGrayColor];
    cell.setHomeParkingBtn.layer.cornerRadius = 4;
    cell.setHomeParkingBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    cell.setHomeParkingBtn.layer.borderWidth = 1;
    
    cell.setHomeParkingBlock = ^(UIButton *btn){
        [self setHomeParkingWithIndex:cell.homeBtn];
    };
    
//    cell.setOfficeParkingBlock = ^(UIButton *btn){
//        [self setOfficeParkingWithIndex:cell.officeBtn];
//    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel *model = self.searchArray[indexPath.row];
    NewParkingdetailVC *parkingDetailVC = [[NewParkingdetailVC alloc] init];
    parkingDetailVC.parkingId = model.parkingId;
    [self.navigationController pushViewController:parkingDetailVC animated:YES];
//    ParkingDetailViewController *detailCtrl = [[ParkingDetailViewController alloc] init];
//    detailCtrl.parkingModel = model;
//    detailCtrl.nowLatitude = self.nowLatitude;
//    detailCtrl.nowongitude = self.nowLongitude;
//    [self.navigationController pushViewController:detailCtrl animated:YES];
}


#pragma mark -- 设置公司停车场
- (void)setOfficeParkingWithIndex:(UIButton *)btn
{
    
    _temOfficeBtn.backgroundColor = [UIColor whiteColor];
    [_temOfficeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    _temOfficeBtn = btn;
    _temOfficeBtn.backgroundColor = NEWMAIN_COLOR;
    [_temOfficeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    if (_temOfficeBtn.tag != _temHomeBtn.tag) {
        //        return;
    }
    else
    {
        _temHomeBtn.backgroundColor = [UIColor whiteColor];
        [_temHomeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
        
    }
    ParkingModel *model = _searchArray[btn.tag];
    BEGIN_MBPROGRESSHUD;

    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@%@",[MyUtil getCustomId],model.parkingId,@(2),[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",setDefaultScan,[MyUtil getCustomId],model.parkingId,@(2),[MyUtil getVersion],summary];
    
    
    [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[NewMapHomeVC class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        END_MBPROGRESSHUD;
        
    } Fail:^(NSString *errror) {
        ALERT_VIEW(errror);
        _alert = nil;
        END_MBPROGRESSHUD;
    }];
    
}


#pragma mark -- 设置家停车场

- (void)setHomeParkingWithIndex:(UIButton *)btn
{
    _temHomeBtn.backgroundColor = [UIColor whiteColor];
    [_temHomeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    _temHomeBtn = btn;
    _temHomeBtn.backgroundColor = NEWMAIN_COLOR;
    [_temHomeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    if (_temHomeBtn.tag != _temOfficeBtn.tag) {
        //        return;
    }
    else
    {
        _temOfficeBtn.backgroundColor = [UIColor whiteColor];
        [_temOfficeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    }
    ParkingModel *model = _searchArray[btn.tag];
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@%@",[MyUtil getCustomId],model.parkingId,@(1),[MyUtil getVersion],MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",setDefaultScan,[MyUtil getCustomId],model.parkingId,@(1),[MyUtil getVersion],summary];
    
    
    [RequestModel requestQueryAppointmentWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[NewMapHomeVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        END_MBPROGRESSHUD;
        
    } Fail:^(NSString *errror) {
        ALERT_VIEW(errror);
        _alert = nil;
        END_MBPROGRESSHUD;
    }];
    
}

#pragma mark -UIScrollView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end





