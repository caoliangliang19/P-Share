//
//  NewCarListVC.m
//  P-Share
//
//  Created by fay on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewCarListVC.h"
#import "FayCollectionView.h"
#import "FayCollectionViewHeadLayout.h"
#import "UIBarButtonItem+Extension.h"
#import "CarBraneCell.h"
#import "CarBraneReusableView.h"
#import "SubCarDetailView.h"
#import "CapacityVC.h"
#import "AddCarInfoViewController.h"


static NSString *const KCellIdentifier          = @"CarBraneCell";
static NSString *const KReusableViewIdentifier  = @"CarBraneReusableView";

@interface NewCarListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,FayCollectionViewDelegate>
{
    UICollectionViewFlowLayout  *_flowLayout;
    FayCollectionView           *_collectionView;
    NSMutableArray              *_sectionArray;
    NSArray                     *_rowsArray;
    NSMutableDictionary         *_rootDic;
    UIAlertView                 *_alert;
    
    UIView                      *_clearBackView;
    MBProgressHUD               *_mbView;
    
}
@property (nonatomic,strong)SubCarDetailView    *subCarDetailV;


@end

@implementation NewCarListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"车型选择";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self loadNavigationbar];

    
    ALLOC_MBPROGRESSHUD

    [self loadData];


}

- (void)loadData
{
    NSString *summary = [NSString stringWithFormat:@"2.0.2%@",MD5_SECRETKEY];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",gaincarbrand,@"2.0.2",[summary MD5]];
    
    BEGIN_MBPROGRESSHUD
    _sectionArray = [NSMutableArray array];
    _rootDic = [NSMutableDictionary dictionary];
    
    [RequestModel getDicWithUrl:url Completion:^(NSDictionary *dataDic) {
        END_MBPROGRESSHUD
       
        [_rootDic setDictionary:dataDic[@"data"]];
        
        if (_rootDic[@"hotBrands"]) {
            NSArray *hotBrandsArr = _rootDic[@"hotBrands"];
            [_rootDic removeObjectForKey:@"hotBrands"];
            [_rootDic setObject:hotBrandsArr forKey:@"hot"];
            
        }
        
        NSArray *temArray = [[_rootDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        [_sectionArray addObjectsFromArray:temArray];
        
        [_sectionArray removeObject:[_sectionArray lastObject]];
        
        [_sectionArray insertObject:@"hot" atIndex:0];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadCollectionView];

        });
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        ALERT_VIEW(error);
        _alert = nil;
    }];
    
    
}
- (void)loadCollectionView
{
    _flowLayout = [[FayCollectionViewHeadLayout alloc] init];
    
    _flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;

    _collectionView = [[FayCollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _collectionView.delegate = self;
    [_collectionView.collectionView setCollectionViewLayout:_flowLayout];
    _collectionView.collectionView.alwaysBounceVertical=YES;
    [_collectionView.collectionView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [_collectionView.collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView.collectionView registerClass:[CarBraneCell class] forCellWithReuseIdentifier:KCellIdentifier];
    [_collectionView.collectionView registerClass:[CarBraneReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KReusableViewIdentifier];
    [self.view addSubview:_collectionView];

   
    [self.view addSubview:self.subCarDetailV];

    
}
- (void)loadNavigationbar
{
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"defaultBack"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backVC)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
}


#pragma mark --FayCollectionViewDelegate
- (NSArray *)sectionIndexTitlesForFayCollectionView:(FayCollectionView *)tableView
{
    return _sectionArray;
}

#pragma mark -- collectionDelegate/collectionViewDataSource
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {SCREEN_HEIGHT,26};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        CarBraneReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KReusableViewIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            reusableView.type = CarBraneReusableViewHot;
        }else
        {
            reusableView.type = CarBraneReusableViewNormal;
        }
        reusableView.titleName = [_sectionArray objectAtIndex:indexPath.section];
        return reusableView;
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_sectionArray count];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *temArray = _rootDic[[_sectionArray objectAtIndex:section]];
    return temArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarBraneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.type = CarBraneCellTypeHot;
        if (indexPath.row>4) {
            cell.needLine = NO;
        }else
        {
            cell.needLine = YES;
        }
    }else
    {
        cell.type = CarBraneCellTypeNormal;
        cell.needLine = NO;
    }

    NSArray *temArray = _rootDic[[_sectionArray objectAtIndex:indexPath.section]];
    NSDictionary *dataDic = temArray[indexPath.row];
    cell.dataDic = dataDic;
    return cell;
    
   
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        return CGSizeMake((SCREEN_WIDTH - 28)/ 5, 72);
        
    }else
    {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *temArray = _rootDic[[_sectionArray objectAtIndex:indexPath.section]];
    NSDictionary *dataDic = temArray[indexPath.row];
    
    [self.view bringSubviewToFront:_clearBackView];
    [self.view bringSubviewToFront:_mbView];
    BEGIN_MBPROGRESSHUD
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:dataDic[@"brandName"],@"carBrand",@"2.0.2",@"version", nil];
    [RequestModel postGetDiction:gaincartrade WithDic:dic Completion:^(NSDictionary *jsonData) {
        
        END_MBPROGRESSHUD
        NSArray *dataArray = jsonData[@"data"];
        if (dataArray.count>0) {
            [_subCarDetailV animationShow];

            _subCarDetailV.dataDic = dataDic;
            _subCarDetailV.dataArray = dataArray;
        }else
        {
            NSDictionary *carType = [NSDictionary dictionaryWithObjectsAndKeys:dataDic[@"brandName"],@"carBrand", nil];
            
            [self backAddCarVCWithDic:carType];
        }

        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD

    }];

    MyLog(@"%ld  %ld",indexPath.section,indexPath.row);
}

#pragma mark -- lazy subCarDetailV
- (SubCarDetailView *)subCarDetailV
{
    if (!_subCarDetailV) {
        _subCarDetailV = [[SubCarDetailView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    _subCarDetailV.hidden = YES;
    __weak typeof(self)ws = self;
    _subCarDetailV.NextVC = ^(SubCarDetailView *subView,NSString *tradeName,NSString *carSeries,NSDictionary *dataDic){
        
        [ws getCarYearAnd:subView tradeName:tradeName carSeries:carSeries dataDic:dataDic];
        
    };
    
    
    return _subCarDetailV;
    
}

#pragma mark --- 获取车辆的排量  年产
- (void)getCarYearAnd:(SubCarDetailView *)subView tradeName:(NSString *)tradeName carSeries:(NSString *)carSeries dataDic:(NSDictionary *)oldDataDic
{
    
    BEGIN_MBPROGRESSHUD
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:oldDataDic[@"brandName"],@"carBrand",tradeName,@"tradeName",carSeries,@"carSeries",@"2.0.2",@"Version", nil];
    [RequestModel postGetDiction:gaincardisplacement WithDic:dic Completion:^(NSDictionary *dataDic) {
        
        END_MBPROGRESSHUD
        NSMutableArray *dataArray = [NSMutableArray array];
        
        NSArray *temArray = dataDic[@"data"];
        for (NSDictionary *dic in temArray) {
            if (![MyUtil isBlankString:dic[@"displacementShow"]]) {
                [dataArray addObject:dic];
            }
        }
        
        if (dataArray.count > 0 ) {
            CapacityVC *capacityVC = [[CapacityVC alloc] init];
            capacityVC.carSeries = carSeries;
            capacityVC.tradeName = tradeName;
            capacityVC.dataDic = oldDataDic;
            capacityVC.dataArray = dataArray;
            [self.navigationController pushViewController:capacityVC animated:YES];
        }else
        {
            NSDictionary *carType = [NSDictionary dictionaryWithObjectsAndKeys:tradeName,@"tradeName",oldDataDic[@"brandName"],@"carBrand",carSeries,@"carSeries", nil];
            [self backAddCarVCWithDic:carType];
        }

        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        ALERT_VIEW(error);
        _alert = nil;
    }];
    
}

#pragma mark -- 返回添加界面
- (void)backAddCarVCWithDic:(NSDictionary *)carType
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[AddCarInfoViewController class]])
        {
            NSNotification *nition = [NSNotification notificationWithName:@"CarSubKindVCChoseCarType" object:nil userInfo:carType];
            [[NSNotificationCenter defaultCenter] postNotification:nition];
            [self.navigationController popToViewController:temp animated:YES];
            
        }
    }

}

- (void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
