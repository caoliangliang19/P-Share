//
//  ChooseFreeCouponVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ChooseFreeCouponVC.h"
#import "NewDiscountCell.h"
#import "CouponModel.h"

@interface ChooseFreeCouponVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_chooseTableView;
}
@property (nonatomic , assign)BOOL isLoading;
@property (nonatomic , assign)BOOL isRefresh;
@property (nonatomic , assign)NSInteger indexPage;
@property (nonatomic , strong)NSMutableArray *dataArray;
@end

@implementation ChooseFreeCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self isRefreshUI];
}
- (void)isRefreshUI{
    self.isLoading = NO;
    self.isRefresh = NO;
    self.indexPage = 1;
    [self createMJRefresh];
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)createMJRefresh{
    __weak typeof (self)weakself = self;
    _chooseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.isLoading = YES;
        weakself.indexPage = 1;
        [weakself createRequest:weakself.indexPage];
    }];
    [_chooseTableView.mj_header beginRefreshing];
    _chooseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isRefresh) {
            return ;
        }
        weakself.isRefresh = YES;
        weakself.indexPage++;
        [weakself createRequest:weakself.indexPage];
    }];
}
- (void)createRequest:(NSInteger)index{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:@"customerId"];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:_orderType,@"orderType",[NSString stringWithFormat:@"%d",_orderTotalPay],@"amountPayable",userId,@"customerId",[NSString stringWithFormat:@"%ld",(long)index],@"pageIndex",@"100201",@"couponStatus",dateString,@"timestamp",self.parkingId,@"parkingId", nil];

    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(getCouponList) WithDic:paramDic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
         NSArray *dataArray = responseObject[@"couponList"];
        for (NSDictionary *dict in dataArray) {
            CouponModel *model = [[CouponModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            __block BOOL isExist = NO;
            [self.dataArray enumerateObjectsUsingBlock:^(CouponModel *obj, NSUInteger idx, BOOL  *stop) {
                if ([obj.couponId isEqualToString:model.couponId]) {
                    isExist = YES;
                    *stop = YES;
                }
            }];
            if (!isExist) {
                [self.dataArray addObject:model];
            }
        }
        [_chooseTableView reloadData];
        self.isRefresh = NO;
        self.isLoading = NO;
        [_chooseTableView.mj_footer endRefreshing];
        [_chooseTableView.mj_header endRefreshing];
        if (self.dataArray.count == 0) {
            
        }
    } error:^(NSString *error) {
        self.isRefresh = NO;
        self.isLoading = NO;
        [_chooseTableView.mj_footer endRefreshing];
        [_chooseTableView.mj_header endRefreshing];

    } failure:^(NSString *fail) {
        self.isRefresh = NO;
        self.isLoading = NO;
        [_chooseTableView.mj_footer endRefreshing];
        [_chooseTableView.mj_header endRefreshing];
    }];
}
- (void)createTableView{
    self.title = @"优惠劵";
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:(UITableViewStylePlain)];
    _chooseTableView.delegate = self;
    _chooseTableView.tableFooterView = [UIView new];
    _chooseTableView.dataSource = self;
    _chooseTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_chooseTableView registerNib:[UINib nibWithNibName:@"NewDiscountCell" bundle:nil] forCellReuseIdentifier:@"ChooseCellID"];
    [self.view addSubview:_chooseTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCellID" forIndexPath:indexPath];
    CouponModel *model = self.dataArray[indexPath.row];
    cell.discountTypeL.text = model.vouchersName;
    cell.infoL.text = [NSString stringWithFormat:@"•满%.0f元可用,%@",model.minconsumption,model.exclusionRule];
    if ([model.couponType isEqualToString:@"1"]) {//面值优惠
        cell.moneyL.text = [NSString stringWithFormat:@"%.0f元",model.parAmount];
    }else{
        cell.moneyL.text = [NSString stringWithFormat:@"%.1f折",(float)(model.parDiscount/10)];
    }
    NSArray *array = [model.parkingNames componentsSeparatedByString:@","];
    if ([UtilTool isBlankString:model.parkingNames] == NO) {
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
        CouponModel *model = self.dataArray[indexPath.row];
        [self.delegate selectedFreeWithModel:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
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
