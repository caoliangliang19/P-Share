//
//  PresentVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PresentVC.h"

@interface PresentVC ()<UIScrollViewDelegate>

@end

@implementation PresentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    
    
    
}
- (void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.imageArray.count, 100);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*self.tap, 0);
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 20)];
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.tap+1,(unsigned long)self.imageArray.count];
    [self.view addSubview:self.sliderLabel];
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:nil];
        imageV.userInteractionEnabled = YES;
        imageV.tag = 100+i;
        [scrollView addSubview:imageV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
        [imageV addGestureRecognizer:tap];
    }
}

- (void)onClick{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i = scrollView.contentOffset.x/SCREEN_WIDTH;
   
    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)self.imageArray.count];
    
    NSLog(@"%@---%d",self.sliderLabel.text,i);
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
