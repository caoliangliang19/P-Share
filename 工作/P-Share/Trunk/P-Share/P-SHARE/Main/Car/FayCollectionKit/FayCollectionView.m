//
//  FayCollectionView.m
//  FayCollectionAddIndex
//
//  Created by fay on 16/7/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayCollectionView.h"
#import "FayCollectionViewIndex.h"
#import "FayCollectionViewHeadLayout.h"
@interface FayCollectionView()<FayCollectionViewIndexDelegate>
{
    UICollectionViewFlowLayout  *_flowLayout;
    UILabel                     *_flotageLabel;//中间显示的背景框
    FayCollectionViewIndex      *_collectionViewIndex;
    
}
@end

@implementation FayCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _flowLayout = [[FayCollectionViewHeadLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(frame.size.width/2, frame.size.width/2);
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];;
        _collectionView.showsVerticalScrollIndicator = YES;
        [self addSubview:_collectionView];
        
        _collectionViewIndex = [[FayCollectionViewIndex alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, 0, 20, self.bounds.size.height)];
        [self addSubview:_collectionViewIndex];
        
        _flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.bounds.size.width - 64) / 2,(self.bounds.size.height -64) / 2,64,64}];
        _flotageLabel.backgroundColor = [UIColor blackColor];
        _flotageLabel.hidden = YES;
        _flotageLabel.layer.cornerRadius = 32;
        _flotageLabel.layer.masksToBounds = YES;
        _flotageLabel.textColor = [UIColor whiteColor];
        _flotageLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_flotageLabel];
    }
    
    return self;
}

- (void)setDelegate:(id<FayCollectionViewDelegate>)delegate
{
    _delegate = delegate;
    _collectionView.delegate = delegate;
    _collectionView.dataSource = delegate;
    _collectionViewIndex.titleIndexs = [self.delegate sectionIndexTitlesForFayCollectionView:self];
    [self setCollectionIndexHeight];
    _collectionViewIndex.isFrameLayer = NO;//设置是否有边框
    _collectionViewIndex.delegate = self;
    
}

- (void)setCollectionIndexHeight
{
    CGRect rect = _collectionViewIndex.frame;
    rect.size.height = _collectionViewIndex.titleIndexs.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height) / 2;
    _collectionViewIndex.frame = rect;

}

- (void)reloadData
{
    [_collectionView reloadData];
    UIEdgeInsets edgeInsets = _collectionView.contentInset;
    _collectionViewIndex.titleIndexs = [self.delegate sectionIndexTitlesForFayCollectionView:self];
    CGRect rect = _collectionView.frame;
    rect.size.height = _collectionViewIndex.titleIndexs.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height - edgeInsets.top - edgeInsets.bottom) / 2 + edgeInsets.top + 20;
    _collectionViewIndex.frame = rect;
    _collectionViewIndex.delegate = self;
    
}

#pragma mark --- FayCollectionViewIndexDelegate
- (void)collectionViewIndex:(FayCollectionViewIndex *)collectionView didSelectionAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    if ([_collectionView numberOfSections] > index && index > -1 ){
    
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:(UICollectionViewScrollPositionTop) animated:NO];
        CGPoint contentOffetSet = _collectionView.contentOffset;
        MyLog(@"%lf",contentOffetSet.y);
        if ([_collectionView numberOfSections] != index+1) {
            [_collectionView setContentOffset:CGPointMake(0, contentOffetSet.y-20) animated:NO];
        }
        _flotageLabel.text = title;
        
    }
}

- (void)collectionViewIndexTouchesBegan:(FayCollectionViewIndex *)collectionViewIndex
{
    _flotageLabel.alpha = 1;
    _flotageLabel.hidden = NO;
}

- (void)collectionViewIndexTouchesEnd:(FayCollectionViewIndex *)collectionViewIndex
{
    void (^animation)() = ^
    {
        _flotageLabel.alpha = 0;
    };
    
    [UIView animateWithDuration:0.4 animations:animation completion:^(BOOL finished) {
        
        _flotageLabel.hidden = YES;
        
    }];

}

@end
