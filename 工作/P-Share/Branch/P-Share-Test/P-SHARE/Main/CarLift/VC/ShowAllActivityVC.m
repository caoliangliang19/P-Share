//
//  ShowAllActivityVC.m
//  P-SHARE
//
//  Created by fay on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ShowAllActivityVC.h"
#import "DiscountActCell.h"
#import "UseCarFeelCell.h"
#import "ActivityBaseCell.h"
#import "CarLiftModel.h"
@interface ShowAllActivityVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary    *_rootDic;
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    
}
@property (nonatomic,assign)NSInteger       page;

@end
static NSString *const KCellClass               = @"cellClass";
static NSString *const KShowAllActivityVCTitle  = @"title";
static NSString *const KDataType                = @"dataType";

@implementation ShowAllActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *temArray = @[
                         @{
                             KShowAllActivityVCTitle    : @"优惠活动",
                             KDataType                  : @"type1",
                             KCellClass                 : @"DiscountActCell",
                             },
                         @{
                             KShowAllActivityVCTitle    : @"用车心得",
                             KDataType                  : @"type2",
                             KCellClass                 : @"UseCarFeelCell",
                             }
                         
                         ].copy;
    
    if (_showAllActivityVCType == ShowAllActivityVCTypeActity) {
        _rootDic = temArray[0];
    }else
    {
        _rootDic = temArray[1];
    }
    self.title = _rootDic[KShowAllActivityVCTitle];

    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _page = 1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"whiteCarMarster"] style:(UIBarButtonItemStylePlain) target:self action:@selector(goToChatVC)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self createTableView];
    

}
- (void)goToChatVC
{
    [[QiYuTool new] goToCustomerServiceSessionVC:self];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (_showAllActivityVCType == ShowAllActivityVCTypeActity) {
        _tableView.rowHeight = (SCREEN_WIDTH - 16) / 1.73 + 40;
    }else
    {
        _tableView.rowHeight = SCREEN_WIDTH / 1.73;

    }
    [_tableView registerNib:[UINib nibWithNibName:_rootDic[KCellClass] bundle:nil] forCellReuseIdentifier:_rootDic[KCellClass]];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    WS(ws)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.page = 1;
        [ws requestDataWithPage:ws.page];
    }];
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        ws.page ++ ;
//        [ws requestDataWithPage:ws.page];
//    }];
    [_tableView.mj_header beginRefreshing];
    
    
}
- (void)endRefresh
{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}


- (void)requestDataWithPage:(NSInteger)page
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:KCARLIFT_PARKINGID],@"parkingId",@"2.0.2",@"version", nil];
 
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryActivity) WithDic:dic needEncryption:YES needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (page == 1) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *dic in responseObject[@"data"][_rootDic[KDataType]]) {
            CarLiftModel *model = [CarLiftModel shareObjectWithDic:dic];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        
        MyLog(@"%@",responseObject);
        
        [self endRefresh];
    } error:^(NSString *error) {
        [self endRefresh];

    } failure:^(NSString *fail) {
        [self endRefresh];

    }];
    

}

#pragma mark -- tableView delegate  dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_rootDic[KCellClass]];
   
    cell.model = _dataArray[indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarLiftModel *model = _dataArray[indexPath.row];
    if (![UtilTool isBlankString:model.url]) {
        
        WebInfoModel *webModel      = [WebInfoModel new];
        webModel.urlType            = URLTypeNet;
        webModel.shareType          = WebInfoModelTypeShare;
        webModel.title              = model.title;
        webModel.url                = model.url;
        webModel.imagePath          = model.imagePath;
        webModel.descibute          = @"";
        WebViewController *webView  = [[WebViewController alloc] init];
        webView.webModel            = webModel;
        [self.rt_navigationController pushViewController:webView animated:YES];
    }
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
