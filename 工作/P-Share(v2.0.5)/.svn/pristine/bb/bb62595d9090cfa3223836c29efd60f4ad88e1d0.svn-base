//
//  CarKindVC.m
//  P-Share
//
//  Created by fay on 16/4/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarKindVC.h"
#import "CarKindCell.h"
#import "CarKindModel.h"
#import "CarSubKindVC.h"
#import "carDetailModel.h"
@interface CarKindVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableDictionary *_dataDic;
    UITextField *_temTextField;
    NSArray *_searchArray;
    NSArray *_dataArray;
    NSArray *_titleArray;
    NSMutableArray *_carKindArray;
    UIView *_clearBackView;
    MBProgressHUD *_mbView;
    
}
@end

@implementation CarKindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD
    self.tableV.backgroundColor = [MyUtil colorWithHexString:@"EEEEEE"];
    
    self.tableV.sectionIndexColor = [UIColor lightGrayColor];
    self.tableV.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableV.sectionHeaderHeight = 26;
    self.tableV.tableHeaderView = [self getHeadView];
    self.tableV.sectionHeaderHeight = 40;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    获取数据
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyBoardHidden:(NSNotification *)notif
{
    if (_temTextField.text.length == 0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _temTextField.textAlignment = 1;
 
        }];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.textAlignment = 0;
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_temTextField resignFirstResponder];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26;
}
- (void)loadData
{
    _dataDic = [NSMutableDictionary dictionary];
    NSString *summary = [[NSString stringWithFormat:@"%@%@",VERSION,MD5_SECRETKEY] MD5];
    
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@",getRecursionCarModel,VERSION,summary];
    BEGIN_MBPROGRESSHUD
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [RequestModel requestGetCarKindWith:str With:nil Completion:^(NSMutableDictionary *dataDic) {
            
            _dataDic = dataDic;
            
            _dataArray = [_dataDic allValues];
            
            _titleArray = [[_dataDic allKeys]  sortedArrayUsingSelector:@selector(compare:)];
            
            [self tableRefreshDataSource];
            
        } Fail:^(NSString *error) {
            
        }];
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

}

- (UIView *)getHeadView
{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    UIView *searchView = [UIView new];
    searchView.layer.cornerRadius = 2;
    searchView.layer.masksToBounds = YES;
    searchView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:searchView];
    [searchView makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(bgView);
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 8, 10, 8));
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"MapSearch"];
    [searchView addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
    [searchView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchView).offset(33);
        make.centerY.mas_equalTo(imgV);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    UITextField *textFile = [UITextField new];
    _temTextField = textFile;
    [textFile addTarget:self action:@selector(textValueChangeL:) forControlEvents:(UIControlEventEditingChanged)];
    
    textFile.borderStyle = UITextBorderStyleNone;
    textFile.placeholder = @"请输入查找内容";
    textFile.font = [UIFont systemFontOfSize:15];
    textFile.returnKeyType = UIReturnKeySearch;
    textFile.delegate = self;
    textFile.textAlignment = 1;
    [searchView addSubview:textFile];
    [textFile makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(searchView).offset(-40);
        make.left.mas_equalTo(searchView).offset(40);
        make.top.bottom.mas_equalTo(searchView).offset(0);
        
    }];
    
    return bgView;
}
#pragma mark -- textField内容变化
- (void)textValueChangeL:(UITextField *)textField
{
    MyLog(@"%@",textField.text);
    if (textField.text.length == 0) {
        textField.text = @"";
        _dataArray = [_dataDic allValues];
        [_tableV reloadData];
        return;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"nodeName CONTAINS[c] '%@'",textField.text]];
    
    NSArray *preArray = [_carKindArray filteredArrayUsingPredicate:pre];
    
//    if (preArray.count>0) {
        _dataArray = preArray;
        [_tableV reloadData];
        
//    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_dataArray isEqualToArray:[_dataDic allValues]]) {
        return _titleArray[section];
    }else
    {
        return @"搜索结果";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_dataArray isEqualToArray:[_dataDic allValues]]) {
        return _dataArray.count;
    }else
    {
        
        return 1;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray isEqualToArray:[_dataDic allValues]]) {
        CarKindModel *model = [_dataDic valueForKey:[_titleArray objectAtIndex:section]];
        return model.carDataArray.count;
        
    }else
    {
        
        return _dataArray.count;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableV deselectRowAtIndexPath:indexPath animated:YES];
    carDetailModel *detailModel;
    if ([_dataArray isEqualToArray:[_dataDic allValues]]) {
        CarKindModel *model = [_dataDic valueForKey:[_titleArray objectAtIndex:indexPath.section]];
        
        detailModel = [model.carDataArray objectAtIndex:indexPath.row];
    }else
    {
        detailModel = [_dataArray objectAtIndex:indexPath.row];
        
    }

    CarSubKindVC *subKindVC = [[CarSubKindVC alloc] init];
    subKindVC.carDetailModel = detailModel;
    
    [self.navigationController pushViewController:subKindVC animated:YES];
    
}

- (NSArray<NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if ([_dataArray isEqualToArray:[_dataDic allValues]])
    {
        return _titleArray;

    }else
    {
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CarKindCell";
    
    CarKindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    carDetailModel *detailModel;
    if ([_dataArray isEqualToArray:[_dataDic allValues]]) {
        CarKindModel *model = [_dataDic valueForKey:[_titleArray objectAtIndex:indexPath.section]];
        
       detailModel = [model.carDataArray objectAtIndex:indexPath.row];
    }else
    {
        detailModel = [_dataArray objectAtIndex:indexPath.row];
        
    }
    
    if (!cell) {
        cell = [[CarKindCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.carName = detailModel.nodeName;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

#pragma mark -- 返回主现场刷新数据
- (void)tableRefreshDataSource
{
    
    if (_carKindArray == nil) {
        _carKindArray = [NSMutableArray array];
        for (CarKindModel *model in _dataArray) {
            [_carKindArray addObjectsFromArray:model.carDataArray];
        }
    }

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_tableV reloadData];
        END_MBPROGRESSHUD
            
    }];
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 搜索相关
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_temTextField resignFirstResponder];
    
    return NO;
    
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
