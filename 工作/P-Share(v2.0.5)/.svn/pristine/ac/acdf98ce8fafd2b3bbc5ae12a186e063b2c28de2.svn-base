//
//  MapActivityView.m
//  P-Share
//
//  Created by fay on 16/6/14.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MapActivityView.h"
#import "ActivityModel.h"
@interface MapActivityView()<UIScrollViewDelegate>
{
    UILabel         *_titleL;
    UIScrollView    *_scrollView;
    UIPageControl   *_pageControll;
}
@end

@implementation MapActivityView

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
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipeGesture];
    
    
    UIImageView *bgImageView = [UIImageView new];;
    bgImageView.image = [UIImage imageNamed:@"HomeVCprompt_v2"];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIButton *topBtn = [UIButton new];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"btnIco_v2"] forState:(UIControlStateNormal)];
    [topBtn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.08);//30
        make.height.mas_equalTo(topBtn.mas_width).multipliedBy(0.73);//22
    }];
    
    _titleL = [UILabel new];
    _titleL.font = [UIFont systemFontOfSize:14];
    _titleL.textColor = [MyUtil colorWithHexString:@"333333"];
    _titleL.textAlignment = 1;
    _titleL.text = @"爱车生活";
    [self addSubview:_titleL];
    [_titleL makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topBtn);
        make.top.mas_equalTo(topBtn.mas_bottom).offset(6);
        make.width.mas_equalTo(SCREEN_WIDTH - 10);
    }];
    
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
        make.top.mas_equalTo(_titleL.mas_bottom).offset(14);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_width).multipliedBy(0.28);
    }];
    
    _pageControll = [[UIPageControl alloc] init];
    _pageControll.currentPage = 0;
    [_pageControll addTarget:self action:@selector(pageControllClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControll];
    [_pageControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollView);
        make.top.mas_equalTo(_scrollView.mas_bottom).offset(14);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(28);
    }];
    
}

#pragma mark -- pageControll点击事件
- (void)pageControllClick:(UIPageControl *)pageControll
{
    [_scrollView setContentOffset:CGPointMake(pageControll.currentPage * SCREEN_WIDTH, 0) animated:YES];
    
}
#pragma mark -- scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControll.currentPage = _scrollView.contentOffset.x/SCREEN_WIDTH;

}

- (void)setActivityArray:(NSArray *)activityArray
{
    
    _activityArray = activityArray;
    UIView *containView = [UIView new];
    containView.userInteractionEnabled = YES;
    containView.backgroundColor = [UIColor whiteColor];
    
    [_scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
  
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIView *lastView = nil;
    for (int i=0; i<_activityArray.count; i++) {
        ActivityModel *model = [_activityArray objectAtIndex:i];
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:model.imageName];
      
        imageView.tag = i;
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
        imageView.backgroundColor = [UIColor whiteColor];
        [containView addSubview:imageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewTap:)];
        [imageView addGestureRecognizer:tapGesture];
        

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(28);
            }else
            {
                make.left.mas_equalTo(14);

            }
            make.top.mas_equalTo(_scrollView.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH - 28);
            make.height.mas_equalTo(_scrollView.mas_height);
        }];

        lastView = imageView;
        
    }
   
    
    
    [containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastView.mas_right).offset(14);
        make.height.mas_equalTo(_scrollView.mas_height);
    }];
    [containView layoutIfNeeded];

    MyLog(@"%f  %f  %f  %f",containView.frame.origin.x,containView.frame.origin.y,containView.frame.size.width,containView.frame.size.height);
    [_scrollView layoutIfNeeded];

    MyLog(@"%f  %f  %f  %f",_scrollView.frame.origin.x,_scrollView.frame.origin.y,_scrollView.frame.size.width,_scrollView.frame.size.height);

    
    if (_activityArray.count<2) {
        
        _pageControll.hidden = YES;
    }else
    {
        _pageControll.hidden = NO;
        _pageControll.numberOfPages = _activityArray.count;
        _pageControll.pageIndicatorTintColor = [MyUtil colorWithHexString:@"e0e0e0"];
        _pageControll.currentPageIndicatorTintColor = NEWMAIN_COLOR;
    }
    
   
    
}
- (void)ImageViewTap:(UITapGestureRecognizer *)tapGesture
{
    MyLog(@"image  Tap");
    if (self.washCarBlock) {
        self.washCarBlock();
    }
}
#pragma mark -- 隐藏
- (void)hideView
{
    if (self.hiddenActivtyView) {
        self.hiddenActivtyView();
    }
}

@end
