//
//  OldCouponController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/9.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "OldCouponController.h"
#import "CouponModel.h"
#import "NewDiscountCell.h"


@interface OldCouponController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_oldTableView;
}
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation OldCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self addMJRefresh];
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)createTableView{
    self.title = @"过期优惠劵";
    _oldTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:(UITableViewStylePlain)];
    _oldTableView.delegate = self;
    _oldTableView.dataSource = self;
    _oldTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_oldTableView registerNib:[UINib nibWithNibName:@"NewDiscountCell" bundle:nil] forCellReuseIdentifier:@"oldTableViewCellID"];
    [self.view addSubview:_oldTableView];
    
}
- (void)addMJRefresh{
    self.isLoading = NO;
    self.isRefresh = NO;
    self.pageIndex = 1;
    [self createRefresh];
    
}
- (void)createRefresh{
    __weak typeof (self)weakself = self;
    _oldTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isRefresh) {
            return ;
        }
        weakself.isRefresh = YES;
        weakself.pageIndex = 1;
        [weakself createRequest:weakself.pageIndex];
    }];
    [_oldTableView.mj_header beginRefreshing];
    _oldTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.isLoading = YES;
        weakself.pageIndex++;
        [weakself createRequest:weakself.pageIndex];
    }];
}
- (void)createRequest:(NSInteger)index{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:@"customerId"];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"customerId",[NSString stringWithFormat:@"%ld",(long)index],@"pageIndex",@"200102",@"couponStatus",dateString,@"timestamp", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(getCouponList) WithDic:paramDic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dataArray = responseObject[@"couponList"];
        for (NSDictionary *dict in dataArray) {
            CouponModel *model = [[CouponModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            __block BOOL isExsit = NO;
            [self.dataArray enumerateObjectsUsingBlock:^(CouponModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.couponId isEqualToString:model.couponId]) {
                    isExsit = YES;
                    *stop = YES;
                }
            }];
            if (isExsit == NO) {
                [self.dataArray addObject:model];
            }
        }
        if (self.dataArray.count == 0) {
            MyLog(@"%@",responseObject[@"errorInfo"]);
        }
        [_oldTableView reloadData];
        self.isRefresh = NO;
        self.isLoading = NO;
        [_oldTableView.mj_footer endRefreshing];
        [_oldTableView.mj_header endRefreshing];
    } error:^(NSString *error) {
        self.isRefresh = NO;
        self.isLoading = NO;
        [_oldTableView.mj_footer endRefreshing];
        [_oldTableView.mj_header endRefreshing];
    } failure:^(NSString *fail) {
        self.isRefresh = NO;
        self.isLoading = NO;
        [_oldTableView.mj_footer endRefreshing];
        [_oldTableView.mj_header endRefreshing];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oldTableViewCellID" forIndexPath:indexPath];
     CouponModel *model = _dataArray[indexPath.row];
    cell.discountTypeL.text = model.vouchersName;
    cell.infoL.text = [NSString stringWithFormat:@"•满%.0f元可用,%@",model.minconsumption,model.exclusionRule];
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
