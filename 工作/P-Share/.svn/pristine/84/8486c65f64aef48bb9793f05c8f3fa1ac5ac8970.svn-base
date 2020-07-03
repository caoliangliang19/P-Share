//
//  ImageView.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ImageView.h"
#import "PresentVC.h"
@interface ImageView ()

@property (nonatomic , strong)NSMutableArray *array;

@property (nonatomic , strong)UIScrollView *scrollView;

@end

@implementation ImageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLable = [UtilTool createLabelFrame:CGRectMake(15, 10, 100, 15) title:@"车辆照片:" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft numberOfLine:0];
        [self addSubview:titleLable];
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH-80, 100)];
        self.scrollView = scrollView;
        scrollView.contentSize = CGSizeMake((SCREEN_WIDTH-100)/3*4+30, 100);
        [self addSubview:scrollView];
        UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 20, 20)];
        leftImageV.image = [UIImage imageNamed:@"leftArrows"];
        [self addSubview:leftImageV];
        UIImageView *rightImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 70, 20, 20)];
        rightImageV.image = [UIImage imageNamed:@"rightArrows"];
        [self addSubview:rightImageV];
    }
    return self;
}
- (void)setImageArray:(NSArray *)imageArray{
    NSMutableArray *imageArray1 = [[NSMutableArray alloc]initWithArray:imageArray];
    [imageArray1 removeObjectAtIndex:imageArray.count-1];
    self.array = imageArray1;
    for (NSInteger i = 0; i < imageArray1.count; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH-100)/3+10)*i, 0, (SCREEN_WIDTH-100)/3, 100)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageArray1[i]] placeholderImage:nil];
        imageV.userInteractionEnabled = YES;
        imageV.tag = 100+i;
        [self.scrollView addSubview:imageV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
        [imageV addGestureRecognizer:tap];
    }
}
- (void)onClick:(UIGestureRecognizer *)tap{
    PresentVC *imageVC = [[PresentVC alloc]init];
    imageVC.imageArray = self.array;
    imageVC.tap = tap.view.tag-100;
    [self.viewController presentViewController:imageVC animated:YES completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
