//
//  ZuCheVC.m
//  P-Share
//
//  Created by fay on 16/3/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ZuCheVC.h"
#import "RentCarModel.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
@interface ZuCheVC (){
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    UIAlertView *_alert;
    NSArray *_dataArray;
    
}

@end

@implementation ZuCheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
    
   
}


- (void)loadData
{
    BEGIN_MBPROGRESSHUD
    [RequestModel requestRentCarInfoWithURL:CarRentList Completion:^(NSMutableArray *resultArray) {
        _dataArray = resultArray;
        [self loadUIWithData];
        
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
    }];
    
}

- (void)loadUI
{
    ALLOC_MBPROGRESSHUD
//    _btn4.layer.cornerRadius = 4;
    
//    for (int i=1; i<4; i++) {
//        NSString *viewName = [NSString stringWithFormat:@"view%d",i];
//        NSString *btnName = [NSString stringWithFormat:@"btn%d",i];
//        UIView *view = [self valueForKey:viewName];
//        UIButton *btn = [self valueForKey:btnName];
//        btn.layer.cornerRadius = 4;
//        [self initView:view];
//    }
    
}

- (void)loadUIWithData{
    
    NSArray *modelArr = [_dataArray objectAtIndex:1];
    
    NSArray *infoArr = [_dataArray objectAtIndex:0];
    
    _title1.text = [NSString stringWithFormat:@"        %@",infoArr[0]];
    _title2.text = [NSString stringWithFormat:@"        %@",infoArr[1]];
    
    for (int i=1; i<5; i++) {
        RentCarModel *model = modelArr[i-1];
        
        UILabel *cheXingL;
        
        UILabel *cheJiaL = [self valueForKey:[NSString stringWithFormat:@"cheJia%d",i]];

        UIImageView *cheImage = [self valueForKey:[NSString stringWithFormat:@"chePic%d",i]];
        
        [cheImage sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@""]];
        
        if (i<4) {
            cheXingL = [self valueForKey:[NSString stringWithFormat:@"cheXing%d",i]];
            cheXingL.text = model.name;
            cheJiaL.text = [NSString stringWithFormat:@"%@/元起",model.price];

        }else
        {
            cheJiaL.text = [NSString stringWithFormat:@"每小时%@元起",model.price];

        }
        
        
    }
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)initView:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag == 3){
        NSArray *modelArr = [_dataArray objectAtIndex:1];
        RentCarModel *model = modelArr[3];
        WebViewController *webVC = [[WebViewController alloc] init];
        
        webVC.url = model.jumpUrl;
        
        [self.navigationController pushViewController:webVC animated:YES];

    }else
    {
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:4000062637"]]];
        [self.view addSubview:callWebview];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)detailBtnClick:(UIButton *)sender {
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
