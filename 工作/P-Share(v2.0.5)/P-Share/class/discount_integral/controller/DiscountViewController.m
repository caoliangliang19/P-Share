//
//  DiscountViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/6.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "DiscountViewController.h"
#import "DiscountCell.h"
#import "DiscountModel.h"
#import "NewDiscountCell.h"
#import "NSString+Encrypt.h"
#import "OldCouponVC.h"
#import "MJRefresh.h"
#import "CouponModel.h"

@interface DiscountViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,MJRefreshBaseViewDelegate>
{
    UILabel *_secTitleLabel;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    NSUserDefaults *_userDefaults;
    
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    NSInteger _curIndex;
    BOOL _isLoading;
    
}

@property (nonatomic,strong)NSMutableArray *canUseArray;
@property (nonatomic,strong)NSMutableArray *noUseArray;

@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _canUseArray = [NSMutableArray array];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    [_userDefaults setObject:@"0" forKey:remindCoupon];
    _discountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_discountTableView registerNib:[UINib nibWithNibName:@"NewDiscountCell" bundle:nil] forCellReuseIdentifier:@"NewDiscountCell"];
    
    [self setDefaultUI];

    
    if (self.strScan.length > 0) {
        [self getDiscount];
    }else{
        [self setRefresh];

    }
}


#pragma mark - 添加MJ刷新效果
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];

    _mjHeaderView.scrollView = _discountTableView;
    _mjHeaderView.delegate = self;
    _mjFooterView = [MJRefreshFooterView footer];
    
    
    _mjFooterView.scrollView = _discountTableView;
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)setDefaultUI
{
    self.discountTextField.delegate = self;
    
    self.canUseArray = [NSMutableArray array];
    self.noUseArray = [NSMutableArray array];
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    self.discountTableView.hidden = YES;
    self.noDiscountView.hidden = YES;
    self.discountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.discountBtn.layer.cornerRadius = 2;
    self.discountBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    self.discountBtn.layer.borderWidth = 1.5;
    
    ALLOC_MBPROGRESSHUD;
    NSString *customerID = [_userDefaults objectForKey:customer_id];
    NSString *summary = [NSString stringWithFormat:@"%@%@",customerID,MD5_SECRETKEY];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",closeRedDot,customerID,[summary MD5]];
    [RequestModel requestOrderPointWithUrl:url WithDic:nil Completion:^(NSDictionary *dic) {
        
    } Fail:^(NSString *errror) {
        
    }];
    
    [_userDefaults setBool:NO forKey:@"couponRedPoint"];
    
}

- (void)getDiscount{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[MyUtil getCustomId],customer_id,self.strScan,@"vouchersname", nil];

    NSString *urlString = [REXEIVEBYVOUCHERS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *requestModel = [RequestModel new];
    
    [requestModel getRequestWithURL:urlString WithDic:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            
            if ([dict[@"code"] isEqualToString:@"000000"])
            {
                ALERT_VIEW(@"领取成功");
                _alert = nil;
                
            }else{
                
                ALERT_VIEW(dict[@"msg"]);
                _alert = nil;
                
            }
        }
        END_MBPROGRESSHUD;
        [self loadDateWith:1];
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


#pragma mark -- 获取优惠券列表
- (void)loadDateWith:(NSInteger)index
{
    BEGIN_MBPROGRESSHUD;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"customerId",[NSString stringWithFormat:@"%ld",(long)index],@"pageIndex",ISUSECOUPON,@"couponStatus",[MyUtil getTimeStamp],TIMESTAMP, nil];
    
    [RequestModel requestGetCouponListWithURL:GETCOUPONLIST WithDic:paramDic Completion:^(NSMutableArray *dataArr) {
        
        if (index == 1) {
            [_canUseArray removeAllObjects];
        }
        
        [_canUseArray addObjectsFromArray:dataArr];
        
        if (self.canUseArray.count != 0 ) {
            self.discountTableView.hidden = NO;
            self.noDiscountView.hidden = YES;
            [_discountTableView reloadData];
        }else{
            self.discountTableView.hidden = NO;
            self.noDiscountView.hidden = YES;
        }
        
        [_mjFooterView endRefreshing];
        [_mjHeaderView endRefreshing];
        
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        [_mjFooterView endRefreshing];
        [_mjHeaderView endRefreshing];
        
        self.discountTableView.hidden = NO;
        self.noDiscountView.hidden = YES;
        [_discountTableView reloadData];

        
        ALERT_VIEW(error);
        _alert = nil;
       
        

    }];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.canUseArray.count == 0) {
        return 1;
    }
    
    return self.canUseArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canUseArray.count == 0) {
        return 0.1;
    }
    
    return 107;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.canUseArray.count == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel;
    if (section == 0) {
        titleLabel = [MyUtil createLabelFrame:CGRectMake(20, 0, SCREEN_WIDTH, 30) title:[NSString stringWithFormat:@"您有%ld张可使用优惠券",(unsigned long)self.canUseArray.count] textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    }else{
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 1)];
        lineView.backgroundColor = [MyUtil colorWithHexString:@"e5e5e5"];
        [headerView addSubview:lineView];
        
        titleLabel = [MyUtil createLabelFrame:CGRectMake(20, 0, SCREEN_WIDTH, 30) title:@"已过期优惠券" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    }
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 40;
        
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        
        view.backgroundColor = [UIColor clearColor];
    
    
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [MyUtil colorWithHexString:@"696969"];
        NSString *str = @"点击查看 已过期的优惠券 >";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[MyUtil colorWithHexString:@"39d5b8"] range:NSMakeRange(4, str.length-4)];
        label.attributedText = attributedStr;
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(view);
        }];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn addTarget:self action:@selector(oldCoupon) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    
        return view;
        
    }else
    {
        return nil;
        
    }
}
#pragma mark -- 查看过期优惠券
- (void)oldCoupon
{
    OldCouponVC *oldCouponVC = [[OldCouponVC alloc] init];
    
    [self.navigationController pushViewController:oldCouponVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.canUseArray.count != 0) {
        return 30;
    }else{
        return 0.1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.canUseArray.count == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
        
        return cell;
    }
    
    NewDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewDiscountCell"];
    CouponModel *model = self.canUseArray[indexPath.row];
    cell.discountTypeL.text = model.vouchersName;
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
    cell.infoL.text = [NSString stringWithFormat:@"•满%.0f元可用,%@",model.minconsumption,model.exclusionRule];
  
   
    if ([model.couponType isEqualToString:@"1"]) {//面值优惠
        cell.moneyL.text = [NSString stringWithFormat:@"%.0f元",model.parAmount];
    }else{
        cell.moneyL.text = [NSString stringWithFormat:@"%.1f折",(float)(model.parDiscount/10)];
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
    
    
    /*
    static NSString *cellId = @"discountCellId";
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountCell" owner:self options:nil] lastObject];
    }
    
    if (indexPath.section == 0) {//•
        DiscountModel *model = self.canUseArray[indexPath.row];
        
        cell.disTitleLabel.text = model.vouchers_name;
        cell.disDetailLabel1.text = [NSString stringWithFormat:@"•满%.0f元可用",model.minconsumption];
        cell.disDetailLabel3.text = [NSString stringWithFormat:@"•%@至%@",model.effective_begin,model.effective_end];
        if (model.coupon_type == 1) {//面值优惠
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.0f",model.par_amount];
            cell.disNameLabel.text = @"元";
        }else{
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.1f",(float)(model.par_discount/10)];
            cell.disNameLabel.text = @"折";
        }
        
        cell.backImageView.image = [UIImage imageNamed:@"couponsa_canUse"];
        cell.disTitleLabel.textColor = [UIColor whiteColor];
        cell.disDetailLabel1.textColor = [UIColor whiteColor];
        cell.disDetailLabel2.textColor = [UIColor whiteColor];
        cell.disDetailLabel3.textColor = [UIColor whiteColor];
        cell.disNumLabel.textColor = [UIColor whiteColor];
        cell.disNameLabel.textColor = [UIColor whiteColor];
    }else{
        DiscountModel *model = self.noUseArray[indexPath.row];
        
        cell.disTitleLabel.text = model.vouchers_name;
        cell.disDetailLabel1.text = [NSString stringWithFormat:@"•满%.0f元可用",model.minconsumption];
        cell.disDetailLabel3.text = [NSString stringWithFormat:@"•%@至%@",model.effective_begin,model.effective_end];
        if (model.coupon_type == 1) {//面值优惠
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.0f",model.par_amount];
            cell.disNameLabel.text = @"元";
        }else{
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.1f",(float)(model.par_discount/10)];
            cell.disNameLabel.text = @"折";
        }
        
        cell.backImageView.image = [UIImage imageNamed:@"couponsb_noUse"];
        cell.disTitleLabel.textColor = [UIColor lightGrayColor];
        cell.disDetailLabel1.textColor = [UIColor lightGrayColor];
        cell.disDetailLabel2.textColor = [UIColor lightGrayColor];
        cell.disDetailLabel3.textColor = [UIColor lightGrayColor];
        cell.disNumLabel.textColor = [UIColor lightGrayColor];
        cell.disNameLabel.textColor = [UIColor lightGrayColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;*/
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)discountBtnClick:(id)sender {
    [self.discountTextField resignFirstResponder];
    if (self.discountTextField.text.length > 0) {
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求
        
       
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@",[MyUtil getCustomId],self.discountTextField.text,MD5_SECRETKEY] md5];
      
        NSString *str = [NSString stringWithFormat:@"%@/%@/%@/%@",HAVEDISCOUNTCOUPON,[MyUtil getCustomId],self.discountTextField.text,summary];
        
       
        NSString *urlString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        RequestModel *requestModel = [RequestModel new];
        
        [requestModel getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = responseObject;
                
                if ([dict[@"errorNum"] isEqualToString:@"0"])
                {
                    [_userDefaults setObject:@"1" forKey:remindCoupon];
                    [_userDefaults synchronize];
                    [self loadDateWith:1];
                }else{
                    ALERT_VIEW(dict[@"errorInfo"]);
                    _alert = nil;
                    
                }
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
        
    }else{
        ALERT_VIEW(@"请输入有效兑换码");
        _alert = nil;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.discountTextField resignFirstResponder];
}


@end



