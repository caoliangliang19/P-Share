//
//  MyCertifyVC.m
//  P-Share
//
//  Created by 亮亮 on 16/8/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MyCertifyVC.h"

@interface MyCertifyVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_myCollectionView;
    NSMutableArray *_titleArray;
    NSMutableArray *_imageArray;
}
@property (nonatomic,strong)UIView *headerView;
@end

@implementation MyCertifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    [self createHeadView];
    [self createVC];
}
- (void)createDataSource{
    _titleArray = [[NSMutableArray alloc]initWithObjects:@"设置家",@"充值",@"固定车辆",@"添加爱车",@"充值",@"设置家",@"固定车辆",@"固定车辆", nil];
    _imageArray = [[NSMutableArray alloc]initWithObjects:@"authenticate_family",@"authenticate_fixed",@"authenticate_h_add-to",@"authenticate_h_family",@"authenticate_h_fixed",@"authenticate_h_recharge",@"authenticate_recharge",@"authenticate_add_to", nil];
}
- (void)createHeadView{
    
    self.title = @"我的认证";
}
- (void)backBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createVC{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.minimumLineSpacing = 30;
    layOut.minimumInteritemSpacing = 30;
    layOut.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layOut];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"393c45"];
    [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"defaultCell"];
    [self.view addSubview:_myCollectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *cellImageView = [[UIImageView alloc]init];
    cellImageView.backgroundColor = [UIColor clearColor];
    cellImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    
    [cell addSubview:cellImageView];
    [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(cell).offset(0);
        make.height.mas_equalTo(((SCREEN_WIDTH - 100)/3)*13/15);
    }];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = [UIColor whiteColor];
    lable.text = _titleArray[indexPath.row];
    [cell addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellImageView.mas_bottom).offset(5);
        make.left.right.bottom.mas_equalTo(cell).offset(0);
    }];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = (SCREEN_WIDTH - 100)/3;
    return CGSizeMake(itemWidth, itemWidth+30);
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
