//
//  ChooseFreeViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/9.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ChooseFreeViewController.h"
#import "DiscountCell.h"
#import "NewDiscountCell.h"
#import "MJRefresh.h"

@interface ChooseFreeViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    NSInteger _curIndex;
    BOOL _isLoading;
}

@property (nonatomic,strong)NSMutableArray *canUseArray;

@end

@implementation ChooseFreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_chooseTableView registerNib:[UINib nibWithNibName:@"NewDiscountCell" bundle:nil] forCellReuseIdentifier:@"NewDiscountCell"];
    
    
    self.canUseArray = [NSMutableArray array];
    ALLOC_MBPROGRESSHUD;
    
    [self setRefresh];
    
}

#pragma mark - 添加MJ刷新效果
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    
    _mjHeaderView.scrollView = _chooseTableView;
    _mjHeaderView.delegate = self;
    _mjFooterView = [MJRefreshFooterView footer];
    
    
    _mjFooterView.scrollView = _chooseTableView;
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
#pragma mark -- 获取优惠券列表
- (void)loadDateWith:(NSInteger)index
{
    BEGIN_MBPROGRESSHUD;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:_orderType,@"orderType",[NSString stringWithFormat:@"%d",_orderTotalPay],@"amountPayable",userId,@"customerId",[NSString stringWithFormat:@"%ld",(long)index],@"pageIndex",ISUSECOUPON,@"couponStatus",[MyUtil getTimeStamp],TIMESTAMP,self.parkingId,@"parkingId", nil];
    
    [RequestModel requestGetCouponListWithURL:GETCOUPONLIST WithDic:paramDic Completion:^(NSMutableArray *dataArr) {
        
        if (index == 1) {
            [_canUseArray removeAllObjects];
        }
        
        [_canUseArray addObjectsFromArray:dataArr];
        [_chooseTableView reloadData];
        
        [_mjFooterView endRefreshing];
        [_mjHeaderView endRefreshing];
        
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        [_mjFooterView endRefreshing];
        [_mjHeaderView endRefreshing];
        
        ALERT_VIEW(error);
        _alert = nil;
        
    }];
}



- (void)loadData
{
    BEGIN_MBPROGRESSHUD;
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,customer_id,self.orderType,@"orderType", nil];

    NSString *urlString = [GETCOUPONLIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *model = [RequestModel new];
    [model getRequestWithURL:urlString WithDic:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            NSLog(@"%@",dict);
            if ([dict[@"code"] isEqualToString:@"000000"])
            {
                NSArray *dataArray = dict[@"datas"][@"couponList"];
                for (NSDictionary *temDict in dataArray){
                    if ([temDict[@"coupon_status"] isEqualToString:@"100201"] && [temDict[@"minconsumption"] intValue] <= self.orderTotalPay)
                    {
                        DiscountModel *model = [[DiscountModel alloc] init];
                        [model setValuesForKeysWithDictionary:temDict];
                        [self.canUseArray addObject:model];
                    }
                }
            }
        }
        
        MyLog(@"%@",_canUseArray);
        if (self.canUseArray.count != 0) {
            [self.chooseTableView reloadData];
        }else{
            ALERT_VIEW(@"没有可用优惠券");
            _alert = nil;
        }
        END_MBPROGRESSHUD;
    } error:^(NSString *error) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(error);
        _alert = nil;
    } failure:^(NSString *fail) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(fail);
        _alert = nil;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.canUseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewDiscountCell"];
    CouponModel *model = self.canUseArray[indexPath.row];
    cell.discountTypeL.text = model.vouchersName;
    cell.infoL.text = [NSString stringWithFormat:@"•满%.0f元可用,%@",model.minconsumption,model.exclusionRule];
    if ([model.couponType isEqualToString:@"1"]) {//面值优惠
        cell.moneyL.text = [NSString stringWithFormat:@"%.0f元",model.parAmount];
    }else{
        cell.moneyL.text = [NSString stringWithFormat:@"%.1f折",(float)(model.parDiscount/10)];
    }
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
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:cell.moneyL.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:17] range:NSMakeRange(attributedStr.length-1, 1)];
    cell.moneyL.attributedText = attributedStr;
    
    switch ([model.couponKind integerValue]) {
        case 0:
        {
            cell.discountTypeL.text = @"通用券";
            cell.colorType = GreenColor;
        }
            break;
            
        case 1:
        {
            cell.discountTypeL.text = @"停车券";
            cell.colorType = PurpleColor;
            
        }
            break;
        case 2:
        {
            cell.discountTypeL.text = @"月租产权券";
            cell.colorType = OrangeColor;
            
        }
            break;
        case 3:
        {
            cell.discountTypeL.text = @"代客泊车券";
            cell.colorType = OrangeColor;
        }
            break;
            
        case 4:
        {
            cell.discountTypeL.text = @"车管家券";
            cell.colorType = GreenColor;
            
        }
            break;

        case 5:
        {
            cell.discountTypeL.text = @"洗车券";
            cell.colorType = GreenColor;
            
        }
            break;
            
        default:
            break;
    }
    

    
    cell.timeL.text = [NSString stringWithFormat:@"•%@至%@",model.effectiveBegin,model.effectiveEnd];
    
    [cell layoutSubviews];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        CouponModel *model = self.canUseArray[indexPath.row];
        [self.delegate selectedFreeWithModel:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end




