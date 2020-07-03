//
//  FullAlert.m
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "FullAlert.h"
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>

@interface FullAlert ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    NSMutableArray *_dataArray;
    
    

}
@property (nonatomic,strong) UIView *bgView;

@end
@implementation FullAlert

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"FullAlert" owner:nil options:nil]lastObject];
        
        // 初始化设置
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, 281, 270);
        
        [window addSubview:self.bgView];
        
        [window addSubview:self];
        
        
    }
    
    return self;
    
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.alertTableView reloadData];
}
- (void)awakeFromNib{
    
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.alertTableView.delegate = self;
    self.alertTableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBackGroud)];
    [self.bgView addGestureRecognizer:tap];
    
}
- (void)onClickBackGroud{
    [self hide];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    ParkingModel *model = _dataArray[indexPath.row];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 16, 18)];
    imageView.image = [UIImage imageNamed:@"flow_v2"];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-40, 43)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = model.parkingName;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [MyUtil colorWithHexString:@"999999"];
    [view addSubview:label];
    [cell addSubview:view];
//    cell.imageView.image = [UIImage imageNamed:@"flow_v2"];
//    cell.textLabel.text = @"恒基大厦停车场";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     ParkingModel *model = _dataArray[indexPath.row];
    if (self.selectParking) {
        self.selectParking(model);
    }
     [self hide];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark -
#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        _bgView.hidden =YES;
        
    }
    
    return _bgView;
    
}

#pragma mark -
#pragma mark - view显示
- (void)show{
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bgView.hidden =NO;
        
        self.bgView.userInteractionEnabled =NO;
        
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        
        
    } completion:^(BOOL finished) {
        
        
        self.hidden = NO;
        self.bgView.userInteractionEnabled =YES;
        
    }];
    
    
}
#pragma mark -
#pragma mark - view消失
- (void)hide{
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [self performSelector:@selector(MyClick) withObject:self afterDelay:0.2];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
    
    
}


- (void)MyClick{
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
    }
    [self removeFromSuperview];
}

@end
