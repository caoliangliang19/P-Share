//
//  GrowthValueVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/22.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "GrowthValueVC.h"
#import "FayBaseProgress.h"
#import "GrowthValueListCell.h"

@interface GrowthValueVC ()<UITableViewDelegate,UITableViewDataSource>
{
    FayBaseProgress *_fayProgress;
    UITableView *_growTableView;
}
@end

@implementation GrowthValueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigation];
    [self createUI];
}
- (void)createNavigation{
    self.view.backgroundColor = [UIColor colorWithHexString:@"EFEFF4"];
    self.title = @"成长值";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 40)];
    button.backgroundColor = [UIColor clearColor];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    [button setTitle:@"成长值说明" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(onRightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)onRightClick{
    BaseViewController *base = [[BaseViewController alloc]init];
    base.title = @"成长值说明";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    imageView.backgroundColor = [UIColor yellowColor];
    [base.view addSubview:imageView];
    
    [self.rt_navigationController pushViewController:base animated:YES];
}
- (void)createUI{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(75);
        make.height.mas_equalTo(114);
       }];
    
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:@"会员等级对应关系" textColor:[UIColor colorWithHexString:@"000000"] font:[UIFont systemFontOfSize:17] textAlignment:0 numberOfLine:1];
    [self.view addSubview:titleL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85);
        make.left.mas_equalTo(14);
    }];
    
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"Grade_GoldenCard"];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 50));
    }];
    if (_fayProgress == nil) {
        _fayProgress = [[FayBaseProgress alloc]initWithFrame:CGRectMake(80, 110, SCREEN_WIDTH-120, 60) LineHeight:7.0f Progress:0.5 space:13.0f ProgressValue:100 FayBaseProgressStyle:FayBaseProgressStyleBottom];
        _fayProgress.backgroundColor = [UIColor clearColor];
        _fayProgress.imageSize = 25.0f;
        _fayProgress.imageArray = @[@"Grade_Platinum_50",@"Grade_Platinum_50",@"Grade_Platinum_50",@"Grade_Platinum_50"];
        [self.view addSubview:_fayProgress];
    }
    _growTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _growTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _growTableView.delegate = self;
    _growTableView.dataSource = self;
    _growTableView.tableHeaderView = [self createHeadView];
    _growTableView.backgroundColor = [UIColor colorWithHexString:@"EFEFF4"];
     [_growTableView registerClass:[GrowthValueListCell class] forCellReuseIdentifier:@"GrowthValueListCell"];
    [self.view addSubview:_growTableView];
    [_growTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).offset(11);
        make.right.left.bottom.mas_equalTo(0);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GrowthValueListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GrowthValueListCell"];
    if (indexPath.row == 0) {
        cell.colorStyle = GrowthValueListCellColorStyleGray;
    }else
    {
        cell.colorStyle = GrowthValueListCellColorStyleNormal;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)createHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"成长值明细";
    [headView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(0);
        make.bottom.top.mas_equalTo(0);
    }];
    
    return headView;
    
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
