//
//  SubCarDetailView.m
//  P-Share
//
//  Created by fay on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "SubCarDetailView.h"
@interface SubCarDetailView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView          *_infoView;
    UIImageView     *_braneLogoImageV;
    UILabel         *_braneName;
    UITableView     *_tableView;
    UIView          *_bgView;
    
    UIView          *_clearBackView;
    MBProgressHUD   *_mbView;
}
@end

@implementation SubCarDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUpView];
    }
    
    return self;
}

- (void)setUpView
{
    UIView *bgView = [UIView new];
    _bgView = bgView;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animationHidden)];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(animationHidden)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [bgView addGestureRecognizer:swipeGesture];
    [bgView addGestureRecognizer:tapGesture];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIView *infoView = [UIView new];
    _infoView = infoView;
    [self addSubview:infoView];
    [infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(SCREEN_WIDTH);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.75);
    }];
    [self setUpSubView];
    
}
- (void)setUpSubView
{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    [_infoView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    
    UIImageView *braneLogoImageV = [UIImageView new];
    _braneLogoImageV = braneLogoImageV;
    [headView addSubview:braneLogoImageV];
    [braneLogoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *braneName = [UILabel new];
    braneName.text = @"奥迪";
    
    _braneName = braneName;
    [headView addSubview:braneName];
    [braneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_braneLogoImageV.mas_centerY);
        make.left.mas_equalTo(_braneLogoImageV.mas_right).offset(14);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [_infoView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.right.left.bottom.mas_equalTo(0);
    }];
    
    ALLOC_MBPROGRESSHUD_VIEW
}
- (void)animationShow
{
    self.hidden = NO;

    [UIView animateWithDuration:0.5 animations:^{

        _bgView.hidden = NO;

        [_infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(SCREEN_WIDTH * 0.25);
          
        }];
        [_infoView layoutIfNeeded];

    }completion:^(BOOL finished) {
        

    } ];
    
}
- (void)animationHidden
{
    [UIView animateWithDuration:0.5 animations:^{

        [_infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(SCREEN_WIDTH);
        } ];
        [_infoView layoutIfNeeded];

    } completion:^(BOOL finished) {
        _bgView.hidden = YES;
        self.hidden = YES;
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *temDic = _dataArray[section];
    NSArray *aArray = temDic[@"carSeries"];
    return aArray.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *temDic = _dataArray[section];

    return temDic[@"tradeName"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *temDic = _dataArray[indexPath.section];
    
    NSArray *aArray = temDic[@"carSeries"];

    cell.textLabel.text = aArray[indexPath.row];
    
//    cell.textLabel.text = @"奥迪A4";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *temDic = _dataArray[indexPath.section];
    
    NSArray *aArray = temDic[@"carSeries"];
    
    if (self.NextVC) {
        self.NextVC(self,temDic[@"tradeName"],aArray[indexPath.row],_dataDic);
    }
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    _braneName.text = _dataDic[@"brandName"];
    [_braneLogoImageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"brandIcon"]]placeholderImage:[UIImage imageNamed:@"useCarFeel"]];
    [_tableView reloadData];
    
}


@end
