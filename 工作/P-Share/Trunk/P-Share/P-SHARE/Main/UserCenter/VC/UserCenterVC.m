//
//  UserCenterVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "UserCenterVC.h"
#import "PersonCenterCell.h"
#import "CollectionHeadView.h"
#import "SetViewController.h"
#import "WebViewController.h"
#import "PurseViewController.h"
#import "DiscountController.h"
#import "AllOrderController.h"
#import "ProofListController.h"
#import "CarListVC.h"
#import "PrivilegeController.h"
#import "PersonInfoController.h"

@interface UserCenterVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_personCollection;
}
@property (nonatomic,strong)NSMutableArray *secondArray;
@property (nonatomic,strong)NSMutableArray *moneyArray;
@end

@implementation UserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigation];
    [self createCollectionView];
    [self requestData];
   
}
#pragma mark - 
#pragma mark - 懒加载
- (NSMutableArray *)secondArray{
    if (_secondArray == nil) {
        _secondArray = [[NSMutableArray alloc]initWithObjects:@"我的特权",@"订单管理",@"我的钱包",@"车辆管理",@"推荐有礼",@"设置", nil];
    }
    return _secondArray;
}
- (NSMutableArray *)moneyArray{
    if (_moneyArray == nil) {
        _moneyArray = [[NSMutableArray alloc]init];
    }
    return _moneyArray;
}
- (void)createNavigation{
    
    self.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - 
#pragma mark - 点击个人中心导航栏右边按钮
- (void)onRightClick{
   
}
#pragma mark -
#pragma mark - 个人中心请求数据
- (void)requestData{
    NSString *summary1 = [[NSString stringWithFormat:@"%@%@%@",[UtilTool getCustomId],@"2.0.5",SECRET_KEY] MD5];
    NSString *url1 = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(Info),[UtilTool getCustomId],@"2.0.5",summary1];
    [NetWorkEngine getRequestUse:(self) WithURL:url1 WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        OrderModel *model = [OrderModel shareObjectWithDic:dict];
        CGFloat wallet = [model.wallet floatValue]/100;
        NSString *money = [NSString stringWithFormat:@"%.2f",wallet];
        NSString *coupon = [NSString stringWithFormat:@"%@",model.coupon];
        self.customerDic = dict[@"customer"];
        if ([UtilTool isBlankString:money] == YES) {
            [self.moneyArray addObject:@"0"];
        }else{
            [self.moneyArray addObject:money];
        }
        
        [_moneyArray addObject:coupon];
        [_personCollection reloadData];
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}
#pragma mark -
#pragma mark - 创建CollectionView
- (void)createCollectionView{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
//    CGFloat WidthItem = (ScreenSize.width - 4*ItemWith)/3;
//    layOut.itemSize = CGSizeMake(WidthItem, 1.5*WidthItem);
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    //        layOut.headerReferenceSize = CGSizeMake(ScreenSize.width, 100);
    if (_personCollection == nil) {
        _personCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) collectionViewLayout:layOut];
        }
    _personCollection.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _personCollection.delegate = self;
    _personCollection.dataSource = self;
     [_personCollection registerClass:[PersonCenterCell class] forCellWithReuseIdentifier:@"CollectionCellID"];
     [_personCollection registerNib:[UINib nibWithNibName:@"CollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"celliD"];
    [self.view addSubview:_personCollection];
   

    
}
#pragma mark -
#pragma mark - collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return 6;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section <= 1) {
        return 4;
    }else if (section == 2){
        return 2;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    [cell setIndexPath:indexPath setMoney:self.moneyArray];
    cell.indexPath = indexPath;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WIDTH/2, 320/4);
    }else{
        return CGSizeMake(SCREEN_WIDTH/4, 320/4);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 155);
    }else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 155-102);
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
       
        
        CollectionHeadView *view = [CollectionHeadView viewWithCollectionViewHead:collectionView atIndexPath:indexPath atCustomerDic:self.customerDic];
        
        view.second = indexPath.section;
        if (indexPath.section == 0) {
            view.upView.hidden = NO;
        }else{
            view.upView.hidden = YES;
        }
        if (indexPath.section == 1 || indexPath.section == 2) {
            view.moreButton.hidden = YES;
        }else{
            view.moreButton.hidden = NO;
        }
        
        view.sectionTitleL.text = self.secondArray[indexPath.section];
        __weak typeof (self)weakself = self;
        view.headViewBlock = ^(NSInteger second){
            [weakself createPushView:second];
        };
        view.personInfo = ^(){
            PersonInfoController *person = [[PersonInfoController alloc]init];
//            person.customerDic = self.customerDic;
            [weakself.rt_navigationController pushViewController:person animated:YES];
        };
        
        return view;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                AllOrderController *allOrder = [[AllOrderController alloc] init];
                allOrder.state = CLLOrderTypeStateNOPayFor;
                [self.rt_navigationController pushViewController:allOrder animated:YES complete:nil];
            }
                break;
            case 1:
            {
                AllOrderController *allOrder = [[AllOrderController alloc] init];
                allOrder.state = CLLOrderTypeStateNOJudge;
                [self.rt_navigationController pushViewController:allOrder animated:YES complete:nil];
            }
                break;
            case 2:
            {
                AllOrderController *allOrder = [[AllOrderController alloc] init];
                allOrder.state = CLLOrderTypeStateAllOrder;
                [self.rt_navigationController pushViewController:allOrder animated:YES complete:nil];
            }
                break;
            case 3:
            {
                ProofListController *proof = [[ProofListController alloc]init];
                proof.type = DisfferentVCTypePing;
                [self.rt_navigationController pushViewController:proof animated:YES complete:nil];
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                PurseViewController *purse = [[PurseViewController alloc]init];
                [self.rt_navigationController pushViewController:purse animated:YES];
            }
                break;
            case 1:
            {
                DiscountController *discount = [[DiscountController alloc]init];
                [self.rt_navigationController pushViewController:discount animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)createPushView:(NSInteger)second{
    switch (second) {
        case 0:
        {
            PrivilegeController *privilege = [[PrivilegeController alloc]init];
            [self.rt_navigationController pushViewController:privilege animated:YES complete:nil];
        }
            break;
        case 3:
        {
            CarListVC *carListVC = [[CarListVC alloc] init];
            [self.rt_navigationController pushViewController:carListVC animated:YES complete:nil];
        }
            break;
        case 4:
        {
            WebInfoModel *model = [WebInfoModel new];
            model.urlType            = URLTypeNet;
            model.shareType = WebInfoModelTypeShare;
            model.title = @"推荐有礼";
            model.url = [NSString stringWithFormat:@"%@other/html5/share.html#%@",SERVER_URL,[UtilTool getCustomId]];
            
            WebViewController *webView = [[WebViewController alloc] init];
            webView.webModel = model;
            [self.rt_navigationController pushViewController:webView animated:YES];
        }
            break;
        case 5:
        {
            SetViewController *set = [[SetViewController alloc]init];
            [self.rt_navigationController pushViewController:set animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
