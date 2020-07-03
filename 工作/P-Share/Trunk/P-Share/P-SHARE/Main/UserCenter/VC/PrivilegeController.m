//
//  PrivilegeController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/20.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PrivilegeController.h"
#import "CollectionHeadView.h"
#import "PersonCenterCell.h"

@interface PrivilegeController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_privilegeCollection;
}
@property (nonatomic ,strong)NSMutableArray *secArray;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *subArray;
@property (nonatomic ,strong)NSMutableArray *imageArray;
@end

@implementation PrivilegeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的特权";
    [self requestData];
    [self createCollectionView];
}
- (void)requestData{
//    NSString *summary1 = [[NSString stringWithFormat:@"%@%@%@",userID,@"2.0.4",MD5_SECRETKEY] MD5];
//    NSString *url1 = [NSString stringWithFormat:@"%@/%@/%@/%@",privileGepage,userID,@"2.0.4",summary1];
//    [NetWorkEngine getRequestUse:(self) WithURL:url1 WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//        for (NSDictionary *dict in responseObject[@"data"]) {
//            OrderModel *model = [[OrderModel shareObjectWithDic:dict];
//            [array addObject:model];
//        }
//        self.secArray = array;
//    } error:^(NSString *error) {
//        
//    } failure:^(NSString *fail) {
//        
//    }];
}
- (NSMutableArray *)secArray{
    if (_secArray == nil) {
        _secArray = [[NSMutableArray alloc]initWithObjects:@"钻石卡会员",@"金卡会员",@"黄卡会员",@"银卡会员",  nil];
    }
       return _secArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray= [NSMutableArray arrayWithObjects:@[@"超市服务",@"医院代泊"],@[@"贵宾专线",@"折扣服务"],@[@"专享礼包",@"会员特价"],@[@"生日礼包",@"新人礼包"], nil];
    }
    return _titleArray;
}
- (NSMutableArray *)subArray{
    if (_subArray == nil) {
        _subArray = [[NSMutableArray alloc]initWithObjects:@"还需98成长值",@"还需918成长值",@"还需498成长值",@"已晋级", nil];
    }
    return _subArray;
}
- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]initWithObjects:@[@"privilege_h_csfw",@"privilege_h_yydb"],@[@"privilege_h_gbzx",@"privilege_h_zkfw"],@[@"privilege_srlb",@"privilege_zxlb"],@[@"privilege_xrlb",@"privilege_zkfw"], nil];
    }
    return _imageArray;
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _privilegeCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
    _privilegeCollection.delegate = self;
    _privilegeCollection.dataSource = self;
    _privilegeCollection.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [_privilegeCollection registerClass:[PersonCenterCell class] forCellWithReuseIdentifier:@"CollectionCellID"];
    [_privilegeCollection registerNib:[UINib nibWithNibName:@"CollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"secondID"];
    [self.view addSubview:_privilegeCollection];
    [_privilegeCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    PersonCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    [cell setIndexPath:myIndexPath setMoney:nil];
    if (indexPath.row > 1) {
        cell.logoImageView.hidden = YES;
        cell.titieL.hidden = YES;
    }else{
        cell.logoImageView.hidden = NO;
        cell.titieL.hidden = NO;
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat Width = SCREEN_WIDTH/4;
    return CGSizeMake(Width, 320/4);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 155-102);
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"secondID" forIndexPath:indexPath];
        view.second = indexPath.section;
        view.upView.hidden = YES;
        [view.moreButton setImage:[UIImage imageNamed:@" "] forState:(UIControlStateNormal)];
        
        
        [view.moreButton setTitle:self.subArray[indexPath.section] forState:(UIControlStateNormal)];
        if ([self.subArray[indexPath.section] isEqualToString:@"已晋级"]) {
            view.moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 190, 0, 10);
        }else{
            view.moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 140, 0, 10);
        }
        view.sectionTitleL.text = self.secArray[indexPath.section];
        return view;
    }
    return nil;
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
