//
//  CancelOrderVC.m
//  P-Share
//
//  Created by fay on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CancelOrderVC.h"
#import "WenQuanModel.h"

//问券类型 10:取消代泊问卷反馈
#define surveyType  @"10"

@interface CancelOrderVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_tableV;
    NSMutableArray *_descibuteArr;
    UITableViewCell *_temCell;
    UITextView *_infoTextV;
    UIAlertView *_alert;
    WenQuanModel *_textViewModel;
}
@property (nonatomic,strong)GroupManage *manage;

@end

@implementation CancelOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadUI];
    [self loadData];
}

- (void)loadData
{
    NSString *summary = [[NSString stringWithFormat:@"%@%@",surveyType,SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(questionnairelist),surveyType,summary];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"questionnaireInfo"]) {
                WenQuanModel *model = [WenQuanModel shareObjectWithDic:dic];
                [dataArr addObject:model];
            }
            _descibuteArr = dataArr;
            for (WenQuanModel *model in _descibuteArr) {
                if ([model.flag isEqualToString:@"0"]) {
                    _textViewModel = model;
                    [_descibuteArr removeObject:model];
                   }
                }
            [_tableV reloadData];
        }
    } error:^(NSString *error) {
    } failure:^(NSString *fail) {
    }];
}

- (void)loadUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
    self.title = @"选择取消下单原因";
    _tableV = [[UITableView alloc]initWithFrame:CGRectNull style:(UITableViewStyleGrouped)];
    _tableV.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableV];
    [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(0);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _descibuteArr.count;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *cancelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        cancelL.textColor = [UIColor grayColor];
        cancelL.text = @"已取消,您的反馈将帮助我们努力改进";
        cancelL.textAlignment = 1;
        cancelL.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
        return cancelL;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 36;
    }else
    {
        return 100;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }else
    {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
            UIImageView *img = [[UIImageView alloc]init];
            img.tag = 100;
            if (cell.selected) {
                img.image = [UIImage imageNamed:@"selected"];
            }else{
                img.image = [UIImage imageNamed:@"unselect"];
            }
            [cell.contentView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.top.mas_equalTo(8);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            UILabel *infoL = [[UILabel alloc]init];
            infoL.tag = 101;
            infoL.textColor = [UIColor grayColor];
            [cell.contentView addSubview:infoL];
            [infoL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(img.mas_centerY);
                make.left.mas_equalTo(img.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(250, 20));
            }];
            
        }
        UILabel *infoL = (UILabel *)[cell viewWithTag:101];
        WenQuanModel *model = [_descibuteArr objectAtIndex:indexPath.row];
        infoL.text = model.content;
        return cell;
    }else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell1"];
        __weak typeof(cell) weakCell = cell;
        UITextView *textV = [[UITextView alloc]init];
        textV.text = _textViewModel.content;
        textV.font = [UIFont systemFontOfSize:16];
        textV.textColor = [UIColor grayColor];
        textV.delegate = self;
        _infoTextV = textV;
        [cell.contentView addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakCell.contentView).insets(UIEdgeInsetsMake(0, 8, 0, 8));
        }];
        return cell;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = _textViewModel.content;
        textView.textColor = [UIColor grayColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 16, 70)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 30, SCREEN_WIDTH - 16, 35);
        [btn setTitle:@"确认提交" forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(commitBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"39d5b8"]];
        btn.layer.cornerRadius = 5;
        [bgView addSubview:btn];
        return bgView;
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_tableV endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if (section == 1) {
        return 70;

    }return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableV deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [_tableV cellForRowAtIndexPath:indexPath];
    
    if (_temCell) {
        if (cell == _temCell) {
            cell.selected = NO;
//            _temCell = nil;
            [_tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            return;

        }
        _temCell.selected = NO;
        UIImageView *imgV1 = [_temCell viewWithTag:100];
        imgV1.image = [UIImage imageNamed:@"unselect"];
    }
    
    cell.selected = YES;
    _temCell = cell;
    UIImageView *imgV2 = [_temCell viewWithTag:100];
    imgV2.image = [UIImage imageNamed:@"selected"];
    [_tableV reloadData];
    
    
}

- (void)commitBtnClick
{
    NSString *infoStr;
    UILabel *infoL = [_temCell viewWithTag:101];
    if (![_infoTextV.text isEqualToString:_textViewModel.content]) {
        infoStr = _infoTextV.text;
    }else if (infoL.text.length != 0){
        infoStr = infoL.text;
    }else{
        [self.manage groupAlertShowWithTitle:@"请选择提交内容"];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *userId = [userDefaults objectForKey:KCUSTOMER_ID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId,@"customerId",surveyType,@"surveyType",infoStr,@"content",[UtilTool getTimeStamp],@"timestamp", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(questionnairec) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errorInfo"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alertV.tag = 2;
        [alertV show];
        alertV = nil;
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (GroupManage *)manage
{
    if (!_manage) {
        _manage = [GroupManage shareGroupManages];
    }
    return _manage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
