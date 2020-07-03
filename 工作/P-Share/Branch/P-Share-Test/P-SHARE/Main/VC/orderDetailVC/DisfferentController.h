//
//  DisfferentController.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectView.h"
typedef NS_ENUM(NSInteger , DisfferentVCType){
    DisfferentVCTypePing              = 0,//支付凭证
    DisfferentVCTypeJiLu,                 //消费记录
    DisfferentVCTypeStop,                 //停车记录
    DisfferentVCTypeOrder                 //所有订单
};

@interface DisfferentController : BaseViewController<UIScrollViewDelegate,SelectViewDelegate>
{
    UITableView *_leftTableView;
    UITableView *_centerTableView;
    UITableView *_rightTableView;
    UIScrollView *_scrollView;
    SelectView *_select;
    BOOL _isLeft;
    BOOL _isCenter;
    BOOL _isRight;
    
    
}
@property (nonatomic,assign)DisfferentVCType type;
@property (nonatomic,copy)NSString *tab;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableArray *centerArray;
@property (nonatomic,strong)NSMutableArray *rightArray;
@property(nonatomic,assign)NSInteger leftPageIndex;
@property(nonatomic,assign)NSInteger centerPageIndex;
@property(nonatomic,assign)NSInteger rightPageIndex;
- (void)createRequest:(NSInteger)index tab:(NSString *)tab;
- (void)firstRefresh;
- (void)createTableData:(NSString *)tab;
- (void)selectBtn:(UIButton *)button;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
