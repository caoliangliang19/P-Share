//
//  TimeLineVC.m
//  P-SHARE
//
//  Created by fay on 16/10/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TimeLineVC.h"
#import "TimeLineBaseCell.h"
#import "TimeLineYuYueCell.h"
#import "TimeLineDaiBoCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YuYueRequest.h"
@interface TimeLineVC (tableView)<UITableViewDataSource,UITableViewDelegate>

@end
@implementation TimeLineVC(tableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.timeLineVCStyle) {
        return 2;
    }
    return self.row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.timeLineVCStyle ? @"TimeLineDaiBoCell":@"TimeLineYuYueCell";
    TimeLineBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!self.timeLineVCStyle) {
        if (indexPath.row == 0) {
            cell.positionStyle = TimeLineBaseCellPositionStyleTop;
        }else if (indexPath.row == 1){
            cell.positionStyle = TimeLineBaseCellPositionStyleBottom;
            
        }
    }else
    {
        if (indexPath.row == 0) {
            if (self.row == 1) {
                cell.positionStyle = TimeLineBaseCellPositionStyleSingleTop;
            }else
            {
                cell.positionStyle = TimeLineBaseCellPositionStyleTop;
            }
        }else if (indexPath.row == self.row - 1){
            cell.positionStyle = TimeLineBaseCellPositionStyleBottom;
        }else
        {
            cell.positionStyle = TimeLineBaseCellPositionStyleMiddle;
        }
        
    }
    cell.orderModel = self.orderModel;
    [self configureCell:cell atIndexPath:indexPath];
    [cell layoutIfNeeded];
    MyLog(@"cell.lineView  %@",NSStringFromCGRect(cell.lineView.bounds));
    
#warning 此代码待优化
    [UtilTool drawDashLine:cell.lineView lineLength:3 lineSpacing:2 lineColor:[UIColor colorWithHexString:@"6d7e8c"]];

    return cell;
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (!self.timeLineVCStyle) {
        TimeLineYuYueCell *newCell = (TimeLineYuYueCell *)cell;
        
        if (indexPath.row == 0) {
            newCell.yuYueCellStyle = TimeLineYuYueCellStyleLineOne;
        }else
        {
            newCell.yuYueCellStyle = TimeLineYuYueCellStyleLineTwo;
            
        }
        newCell.fd_enforceFrameLayout = NO;
    }else
    {
        TimeLineDaiBoCell *newCell = (TimeLineDaiBoCell *)cell;

        [self setPropertyCell:newCell withIndexPath:indexPath];
        
        newCell.fd_enforceFrameLayout = NO;
    }
}
- (void)setPropertyCell:(TimeLineDaiBoCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSInteger temNum = indexPath.row;
    if ( self.orderModel.keyBox.length == 0 && indexPath.row >= 4) {
        temNum++;
    }
    switch (temNum) {
        case 0:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLine;
            cell.mainLabel.text = @"代泊员接单成功";
            if ([self.orderModel.parkerMobile rangeOfString:@"null"].length>0 || self.orderModel.parkerMobile == nil) {
                self.orderModel.mobile = @"";
            }
            cell.subLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",self.orderModel.parkerName,self.orderModel.parkerMobile];
        }
            break;
        case 1:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLineAddImage;
            cell.mainLabel.text = @"代泊员验车";
            NSMutableArray *imageArray = [NSMutableArray array];
            [imageArray addObjectsFromArray:[self.orderModel.validateImagePath componentsSeparatedByString:@","]];
            [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                    [imageArray removeObject:imagePath];
                }
            }];
           
            if (imageArray.count>0) {
                cell.subLabel.text = [NSString stringWithFormat:@"您的车况照片(1/%ld)",(unsigned long)imageArray.count];
                
                [cell.parkImageView sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultImage_v2"]];
            }
            
        }
            break;
            
        case 2:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLine;
            //            去停车
            cell.mainLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",self.orderModel.parkerName,self.orderModel.parkerMobile];
            cell.subLabel.text = [NSString stringWithFormat:@"前往%@停车场",self.orderModel.targetParkingName];
        }
            break;
            
        case 3:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLineAddImage;
            cell.mainLabel.text = @"爱车已存放妥当";
            cell.subLabel.text = [NSString stringWithFormat:@"%@停车场",self.orderModel.targetParkingName];
            NSMutableArray *imageArray = [NSMutableArray array];
            [imageArray addObjectsFromArray:[self.orderModel.parkingImagePath componentsSeparatedByString:@","]];
            [imageArray enumerateObjectsUsingBlock:^(NSString *imagePath, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (imagePath.length<2 || [imagePath isEqualToString:@"null"] || imagePath == nil) {
                    [imageArray removeObject:imagePath];
                }
            }];
            if (imageArray.count>0) {
                [cell.parkImageView sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultImage_v2"]];
            }
            
        }
            break;
            
        case 4:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLine;
            cell.mainLabel.text = @"钥匙已存入“门岗密码箱”";
            cell.subLabel.text = [NSString stringWithFormat:@"编号:%@",self.orderModel.keyBox];
        }
            break;
            
        case 5:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLine;
            cell.mainLabel.text = @"车位服务时间即将结束";
            
            NSString *outTime = [self intervalSinceNow:self.orderModel.orderEndDate];
            if ([outTime intValue] > 0 ) {
                cell.subLabel.text = [NSString stringWithFormat:@"还有%@分钟到期!",outTime];
                
            }else
            {
                cell.subLabel.text = [NSString stringWithFormat:@"取车时间已到期"];
                
            }
            
        }
            break;
            
        case 6:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLine;
            cell.mainLabel.text = @"代泊员取车中";
            cell.subLabel.text = [NSString stringWithFormat:@"代泊员:%@ %@",self.orderModel.parkerBackName,self.orderModel.parkerBackMobile];
        }
            break;
            
        case 7:
        {
            cell.daiBoCellStyle = TimeLineDaiBoCellStyleTwoLine;
            cell.mainLabel.text = @"服务已顺利结束";
            cell.subLabel.text = @"任何建议与吐槽我们都竭诚欢迎";
        }
            break;
            
        case 8:
        {
            
        }
            break;
            
        default:
            break;
    }
}
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
    //    if (cha/3600<1) {
    timeString = [NSString stringWithFormat:@"%f", cha/60];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@", timeString];

    return timeString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.timeLineVCStyle ? @"TimeLineDaiBoCell":@"TimeLineYuYueCell";
//    CGFloat height = [tableView fd_heightForCellWithIdentifier:identifier configuration:^(TimeLineBaseCell *cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];

    CGFloat height =  [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(TimeLineBaseCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    MyLog(@"heightForRowAtIndexPath  %ld  %lf",indexPath.row,height);

    return height;
    
}


@end


@interface TimeLineVC ()
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation TimeLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
}
- (void)setNav
{
    self.title = @"订单状态";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"kefu_v2"] style:(UIBarButtonItemStylePlain) target:self action:@selector(callPhone)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[TimeLineYuYueCell class] forCellReuseIdentifier:@"TimeLineYuYueCell"];
    [_tableView registerClass:[TimeLineDaiBoCell class] forCellReuseIdentifier:@"TimeLineDaiBoCell"];

    
}

- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    
    if (self.timeLineVCStyle) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.3.7",@"version",orderModel.orderId,@"orderId",_orderModel.orderType,@"orderType", nil];
        
        [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryOrderDetail) WithDic:dic needEncryption:YES needAlert:YES showHud:YES  success:^(NSURLSessionDataTask *task, id responseObject) {
            
            OrderModel *order = [OrderModel shareObjectWithDic:responseObject[@"data"]];
            
            _orderModel = order;
            [self setStatus];
            
            MyLog(@"%@",responseObject);
            
        } error:^(NSString *error) {
            
            MyLog(@"%@",error);
            
        } failure:^(NSString *fail) {
            
            MyLog(@"%@",fail);
            
        }];

    }else
    {
        self.row = 2;
    }

    
    
    
  
}
- (void)setStatus
{
    NSInteger state = [_orderModel.orderStatus integerValue];
    if (state == 1) {
        self.row = 1;
        
    }else if ( state == 2 ) {
        
        if (_orderModel.validateImagePath.length >4 ) {
            
            self.row = 2;
            
        } else{
            
            self.row = 3;
        }
    }else if (state == 4 ){
        
        if (_orderModel.keyBox.length > 0) {
            
            self.row =  6;
            
        }else {
            
            self.row =  5;
        }
        
    }else if (state == 14 || state == 15) {
        
        self.row = 6;
        
    }else if (state == 8 || state == 9){
        
        if (_orderModel.keyBox.length > 0) {
            
            self.row =  7;
            
        }else {
            
            self.row =  6;
        }
        
    }else if (state == 5){
        if (_orderModel.keyBox.length > 0) {
            
            self.row =  8;
            
        }else {
            
            self.row =  7;
        }
    }
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.row-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
- (void)callPhone
{
    NSString *callNum =  @"4000062637";
    if (_timeLineVCStyle) {
        if (_orderModel.parkerBackMobile.length > 4) {
            callNum = _orderModel.parkerBackMobile;
        }else if (_orderModel.parkerMobile.length > 4) {
            callNum = _orderModel.parkerMobile;
        }
    }
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",callNum]]]];
    [self.view addSubview:callWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


