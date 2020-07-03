//
//  SelectParkController.m
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "SelectParkController.h"
#import "SetParkingCell.h"
#import "JHRefresh.h"
#import "UIImageView+WebCache.h"


#import "UseCarFeelController.h"

@interface SelectParkController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    BOOL _isRefreshing;
   
}
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic,assign)NSInteger curIndex;
@end

@implementation SelectParkController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self JHRefresh];
    [self creatRefreshView];
}
#pragma mark - 
#pragma mark - 创建TableView
- (void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark - 添加刷新效果
- (void)JHRefresh{
    
    _curIndex = 1;
    _isLoading = NO;
    _isRefreshing = NO;
}
- (void)creatRefreshView{
    __weak typeof (self)weakself = self;
    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakself.isRefreshing) {
            return ;
        }
        weakself.isRefreshing = YES;
        weakself.curIndex = 1;
        [weakself createDataSource:weakself.curIndex];
    }];
    [_tableView headerStartRefresh];
    
    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.isLoading = YES;
        weakself.curIndex++;
        
        [weakself createDataSource:weakself.curIndex];
    }];
}
- (void)endRefresh{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [_tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    if (self.isLoading) {
        self.isLoading = NO;
        [_tableView footerEndRefreshing];
    }
}
#pragma mark -
#pragma mark - 创建TableView数据源
- (void)createDataSource:(NSInteger)curIndex{
    
    
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",(long)curIndex];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2.0.2",@"version",pageIndex,@"pageIndex", nil];
    NSString *url = [NSString stringWithFormat:@"%@",carParkingList];
    
   
    [RequestModel requestDaiBoOrder:url WithType:@"getParkingList" WithDic:dict Completion:^(NSArray *dataArray) {
       
        if (curIndex == 1) {
            _dataArray = [NSMutableArray arrayWithArray:dataArray];
            
        }else{
            [_dataArray addObjectsFromArray:dataArray];
        }
        [self endRefresh];
        
         [_tableView reloadData];
        
        } Fail:^(NSString *error) {
        [self endRefresh];
        
       
    }];
}
#pragma mark -
#pragma mark - 创建TableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *cellId = @"setParkingCellId";
    __weak SetParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetParkingCell" owner:self options:nil]lastObject];
    }
    ParkingModel *model = _dataArray[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    [cell.homeBtn setTitle:@"选择" forState:(UIControlStateNormal)];
    [cell.homeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
    cell.homeBtn.backgroundColor = [UIColor whiteColor];
    [cell.parkingImageView sd_setImageWithURL:[NSURL URLWithString:model.parkingPath] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    cell.parkingTitleLabel.text = model.parkingName;
    cell.parkingPriceLabel.text =model.parkingAddress;
    
    cell.setOfficeParkingBlock = ^(NSInteger index){
        ParkingModel *model = _dataArray[index];

        [DataSource shareInstance].model = model;
        
              
        if ([self.delegate respondsToSelector:@selector(refreshParking)]) {
            [self.delegate refreshParking];
        }
           [self.navigationController popViewControllerAnimated:YES];
      
    };
    
    MyLog(@"%@",[DataSource shareInstance].model.parkingName);
    
    if ([[DataSource shareInstance].model.parkingId isEqualToString:model.parkingId]) {
        [cell.homeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        cell.homeBtn.backgroundColor = NEWMAIN_COLOR;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
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

- (IBAction)backFrom:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
