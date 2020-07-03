//
//  CollectionView.m
//  P-SHARE
//
//  Created by fay on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CollectionView.h"
#import "AddressCell.h"
@interface CollectionView()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *_dataArray;
    UIView              *_grayView;
    UITableView         *_tableView;
}
@end
@implementation CollectionView
- (void)setUpSubView
{

    [super setUpSubView];
    
   
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_dataArray) {
        [self loadData];

    }
    
    
}
- (void)loadUI
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *grayView = [UIView new];
    _grayView = grayView;
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.5;
    
    [keyWindow addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    [tableView registerClass:[AddressCell class] forCellReuseIdentifier:@"AddressCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44.0f;
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelBtn setTitleColor:KMAIN_COLOR forState:(UIControlStateNormal)];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tableView.mas_bottom);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(keyWindow);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(self.mas_width).multipliedBy(0.84);
    }];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;

    [self collectionViewShow];
}

#pragma mark -- 获取用户收藏的停车场
- (void)loadData
{
    _dataArray = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.0",@"version",nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryCollection) WithDic:dic needEncryption:YES needAlert:YES showHud:YES  success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSDictionary *dic in responseObject[@"collectionList"]) {
                MapSearchModel *model = [MapSearchModel shareObjectWithDic:dic];
                [_dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataArray.count >0) {
                    [self loadUI];
                    [_tableView reloadData];
                }else
                {
                    [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"暂未收藏车厂"];
                    
                }
            });
            
        });
    } error:^(NSString *error) {
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
}

#pragma mark -- tableView  delegate  dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self collectionViewHidden];
    if (self.CollectionViewBlock) {
        
        self.CollectionViewBlock(_dataArray[indexPath.row]);
        
    }
}
- (void)collectionViewShow
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.66 initialSpringVelocity:1/0.66 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
}
- (void)collectionViewHidden
{
    [self removeFromSuperview];
    [_grayView removeFromSuperview];
}


- (void)cancelBtnClick
{
    [self collectionViewHidden];
}

@end
