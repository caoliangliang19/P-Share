//
//  TagView.m
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TagView.h"
#import "TagModel.h"
#import "FayLayout.h"
#import "TagCollectionViewCell.h"
 NSString *const TagViewReuseIdentifier  = @"TagCollectionViewCell";

@interface TagView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView    *_collectionView;

}
@end
@implementation TagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}
- (void)setStyle:(TagViewStyle)style
{
    _style = style;
    
}

- (void)setUpView
{
    _tagOneArray = [NSMutableArray array];
    _tagTwoArray = [NSMutableArray array];
    FayLayout *flowLayout = [[FayLayout alloc]init];

//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 7 ;
    flowLayout.minimumLineSpacing = 10 ;
    flowLayout.sectionInset = UIEdgeInsetsMake(10 , 5 , 0 , 10 );
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[TagCollectionViewCell class] forCellWithReuseIdentifier:TagViewReuseIdentifier];
    
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
    [_collectionView layoutIfNeeded];
    
}
- (void)setDataArray:(NSMutableArray *)dataArray
{
    [_tagOneArray removeAllObjects];

    [dataArray enumerateObjectsUsingBlock:^(TagModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isSelect) {
            [_tagOneArray addObject:model];
        }
    }];
    
    _dataArray = dataArray;
    [_collectionView reloadData];

}
- (void)setDataArrayTwo:(NSMutableArray *)dataArrayTwo
{
    [_tagTwoArray removeAllObjects];

    [dataArrayTwo enumerateObjectsUsingBlock:^(TagModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isSelect) {
            [_tagTwoArray addObject:model];
        }
    }];
    _dataArrayTwo = dataArrayTwo;
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataArray.count;
    }else
    {
        return _dataArrayTwo.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagViewReuseIdentifier forIndexPath:indexPath];
    TagModel *model;
    if (indexPath.section==0) {
        model = [_dataArray objectAtIndex:indexPath.row];
        
    }else{
        model = [_dataArrayTwo objectAtIndex:indexPath.row];
    }
    
    if (_style == TagViewStyleShow) {
        model.isSelect = YES;
    }
    cell.model = model;
    return cell;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_dataArrayTwo) {
        return 2;
    }
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = (TagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        TagModel *model = cell.model;
//        TagModel *model = [_dataArray objectAtIndex:indexPath.row];
        model.isSelect = !model.isSelect;
        if (model.isSelect) {
            [_tagOneArray addObject:model];
        }else
        {
            [_tagOneArray removeObject:model];
        }
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }else if (indexPath.section == 1) {
        TagModel *model = cell.model;
//        TagModel *model = [_dataArray objectAtIndex:indexPath.row];
        model.isSelect = !model.isSelect;
        if (model.isSelect) {
            [_tagTwoArray addObject:model];
        }else
        {
            [_tagTwoArray removeObject:model];
        }
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }

}

#pragma mark cellsize
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagModel *model;
    if (indexPath.section==0) {
        model = [_dataArray objectAtIndex:indexPath.row];
    }else{
        model = [_dataArrayTwo objectAtIndex:indexPath.row];
    }
    CGSize size = [model.info boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return CGSizeMake(size.width+40, 28);

}

@end
