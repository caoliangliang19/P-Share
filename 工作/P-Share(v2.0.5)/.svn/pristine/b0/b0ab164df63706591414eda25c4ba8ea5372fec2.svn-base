//
//  OldCouponVC.m
//  P-Share
//
//  Created by fay on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "OldCouponVC.h"
#import "DiscountModel.h"
#import "MJRefresh.h"
#import "CouponModel.h"
@interface OldCouponVC ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    UIAlertView *_alert;
    
}

@end

@implementation OldCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD
    _dataArray = [NSMutableArray array];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"NewDiscountCell" bundle:nil] forCellReuseIdentifier:@"NewDiscountCell"];
    [self setRefresh];
    
}

#pragma mark - 添加MJ刷新效果
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    
    _mjHeaderView.scrollView = _tableView;
    _mjHeaderView.delegate = self;
    _mjFooterView = [MJRefreshFooterView footer];
    
    
    _mjFooterView.scrollView = _tableView;
    _mjFooterView.delegate = self;
    
    [self loadDateWith:_curIndex];
    
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    if (_mjHeaderView == refreshView) {
        _curIndex = 1;
    }
    if (refreshView == _mjFooterView) {
        _curIndex += 1;
    }
    [self loadDateWith:_curIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark -- 获取过期优惠券列表
- (void)loadDateWith:(NSInteger)index
{
    BEGIN_MBPROGRESSHUD;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"customerId",[NSString stringWithFormat:@"%ld",(long)index],@"pageIndex",UNUSECOUPON,@"couponStatus",[MyUtil getTimeStamp],TIMESTAMP, nil];
    
    [RequestModel requestGetCouponListWithURL:GETCOUPONLIST WithDic:paramDic Completion:^(NSMutableArray *dataArr) {
        
        if (index == 1) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:dataArr];
        [_tableView reloadData];
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        ALERT_VIEW(error);
        _alert = nil;
        
        END_MBPROGRESSHUD
       
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewDiscountCell"];
    CouponModel *model = _dataArray[indexPath.row];
    cell.discountTypeL.text = model.vouchersName;
    cell.infoL.text = [NSString stringWithFormat:@"•满%.0f元可用,%@",model.minconsumption,model.exclusionRule];
    NSArray *array = [model.parkingNames componentsSeparatedByString:@","];
    
    
    if ([MyUtil isBlankString:model.parkingNames] == NO) {
        if (array.count == 1) {
            cell.parkDiscountL.text = [NSString stringWithFormat:@"仅限于%@停车场使用",array[0]];
        }else{
            cell.parkDiscountL.text = [NSString stringWithFormat:@"仅限于%@等%ld个停车场使用",array[0],(unsigned long)array.count-1];
        }
        
        cell.parkDiscountL.hidden = NO;
    }else{
        cell.parkDiscountL.hidden = YES;
    }
    if ([model.couponType isEqualToString:@"1"]) {//面值优惠
        cell.moneyL.text = [NSString stringWithFormat:@"%.0f元",model.parAmount];
    }else{
        cell.moneyL.text = [NSString stringWithFormat:@"%.1f折",(float)(model.parDiscount/10)];
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:cell.moneyL.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:17] range:NSMakeRange(attributedStr.length-1, 1)];
    cell.moneyL.attributedText = attributedStr;
    cell.colorType = GrayColor;
    cell.timeL.text = [NSString stringWithFormat:@"•%@至%@",model.effectiveBegin,model.effectiveEnd];

    switch ([model.couponKind integerValue]) {
        case 0:
        {
            cell.discountTypeL.text = @"通用券";
        }
            break;
            
        case 1:
        {
            cell.discountTypeL.text = @"停车券";
            
        }
            break;
        case 2:
        {
            cell.discountTypeL.text = @"月租产权券";
            
        }
            break;
        case 3:
        {
            cell.discountTypeL.text = @"代客泊车券";
        }
            break;
            
        case 4:
        {
            cell.discountTypeL.text = @"车管家券";
            
        }
            break;
            
        default:
            break;
    }

    
    [cell layoutSubviews];
    
    return cell;
    
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
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
