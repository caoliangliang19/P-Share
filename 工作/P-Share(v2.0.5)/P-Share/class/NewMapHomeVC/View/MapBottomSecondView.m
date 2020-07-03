//
//  MapBottomSecondView.m
//  P-Share
//
//  Created by fay on 16/6/15.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MapBottomSecondView.h"
#import "PayKindView.h"
#import "NewParkingModel.h"
@interface MapBottomSecondView()<UIScrollViewDelegate>
{
    UIScrollView        *_scrollView;
    UIPageControl       *_pageControll;
    UIActivityIndicatorView *_activityView;
    
}
@end
@implementation MapBottomSecondView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubView];
        
    }
    
    return self;
    
}
- (void)setUpSubView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    _pageControll = [[UIPageControl alloc] init];
    _pageControll.currentPage = 0;
    [self addSubview:_pageControll];
    [_pageControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollView);
        make.top.mas_equalTo(_scrollView.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(10);
    }];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    _activityView.color = NEWMAIN_COLOR;
    [self addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
//    [activitysetCenter:CGPointMake(160, 140)];//指定进度轮中心点
//    
//    [activitysetActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    
}

- (void)ActivityViewShow
{
    [_activityView startAnimating];
}
- (void)ActivityViewHidden
{
    [_activityView stopAnimating];
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
//    NSAssert(dataArray.count<=3, @"月租产权临停订单超过最大数");
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    _dataArray = dataArray;
    UIView *containView = [UIView new];
    containView.backgroundColor = [UIColor whiteColor];
    containView.userInteractionEnabled = YES;
    [_scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    UIView *lastView = nil;

    
    if (_dataArray.count == 0) {
        PayKindView *payKindView = [PayKindView new];
        [containView addSubview:payKindView];
        [payKindView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(0);
            }else
            {
                make.left.mas_equalTo(0);
            }
            make.top.mas_equalTo(_scrollView.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(70);
        }];
        payKindView.userInteractionEnabled = YES;
        lastView = payKindView;
        payKindView.payKind = PayKindNoOrder;
        
    }
    
    for (int i=0; i<_dataArray.count; i++) {
        
        PayKindView *payKindView = [PayKindView new];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payKindViewClick:)];
        [payKindView addGestureRecognizer:tapGesture];
        payKindView.userInteractionEnabled = YES;
        if ([_dataArray[0] isKindOfClass:[NSString class]]) {
            payKindView.payKind = PayKindNoCar;
        }else
        {
            NSDictionary *dic = _dataArray[i];
            NSString *key = [dic allKeys][0];
            if ([key isEqualToString:@"equity"]) {
                
                payKindView.payKind = PayKindChanQuan;
                
            }else if ([key isEqualToString:@"monthly"]){
                
                payKindView.payKind = PayKindYueZu;

            }else if ([key isEqualToString:@"temporary"]){
                
                payKindView.payKind = PayKindLinTing;
                
            }
            payKindView.model = [dic objectForKey:key];
            payKindView.tag = i;
        }
        
        payKindView.backgroundColor = [UIColor whiteColor];
        [containView addSubview:payKindView];
        [payKindView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(0);
            }else
            {
                make.left.mas_equalTo(0);
            }
            make.top.mas_equalTo(_scrollView.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(70);
        }];
     
        
        lastView = payKindView;
        
    }
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_scrollView.mas_height);
        make.right.mas_equalTo(lastView.mas_right);
    }];
    if (_dataArray.count < 2) {
        _pageControll.hidden = YES;
    }else
    {
        _pageControll.hidden = NO;
        _pageControll.numberOfPages = _dataArray.count;
        _pageControll.pageIndicatorTintColor = [MyUtil colorWithHexString:@"e0e0e0"];
        _pageControll.currentPageIndicatorTintColor = NEWMAIN_COLOR;
    }
    
   
}
//PayKindLinTing, //临停支付
//PayKindYueZu,   //月租支付
//PayKindChanQuan,//产权支付
//PayKindNoCar,   //未绑定车辆
- (void)payKindViewClick:(UITapGestureRecognizer *)tapGesture
{
    
    BOOL isVisitor =  [[NSUserDefaults standardUserDefaults] boolForKey:@"visitorBOOL"];

   
    if (isVisitor) {
        PayKindView *payKindView = (PayKindView *)tapGesture.view;
        MyLog(@" payKindView.tag  %ld",(long)payKindView.tag);
        if (_dataArray.count <= payKindView.tag) {
            return;
        }
        
        id dic = _dataArray[payKindView.tag];
        
        NewParkingModel *model;
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            model = [dic allValues][0];
        }
        if (self.payKindViewClick) {
            self.payKindViewClick(model,payKindView);
        }
    }else
    {
        if (self.payKindViewClick) {
            self.payKindViewClick(nil,nil);
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControll.currentPage = _scrollView.contentOffset.x/SCREEN_WIDTH;
    
}
@end
