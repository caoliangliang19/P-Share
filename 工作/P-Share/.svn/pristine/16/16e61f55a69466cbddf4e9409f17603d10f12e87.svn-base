//
//  MyQRCodeVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "MyQRCodeVC.h"
#import "LBXScanWrapper.h"

@interface MyQRCodeVC ()

@end

@implementation MyQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"我的二维码";
    UIView *mainView = [[UIView alloc]init];
    mainView.layer.cornerRadius = 5;
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    UILabel *mobile = [[UILabel alloc]init];
    mobile.textColor = [UIColor blackColor];
    mobile.font = [UIFont systemFontOfSize:15];
    mobile.text = [self getCustomerInfo:@"customerMobile"];
    [mainView addSubview:mobile];
    
    UILabel *nickName = [[UILabel alloc]init];
    nickName.textColor = [UIColor colorWithHexString:@"333333"];
    nickName.font = [UIFont systemFontOfSize:13];
    nickName.text = [self getCustomerInfo:@"customerNickname"];
    [mainView addSubview:nickName];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.backgroundColor = [UIColor redColor];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[self getCustomerInfo:KHEADIMG_URL]] placeholderImage:[UIImage imageNamed:@"item_Head-portrait_114"]];
    [mainView addSubview:headImage];
    
    
    NSString *codeString = [NSString stringWithFormat:@"customer:%@ %@",[UtilTool getCustomId],[self getCustomerInfo:@"customerMobile"]];
    UIImage *image = [LBXScanWrapper createQRWithString:codeString QRSize:CGSizeMake(124, 124) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    UIImageView *codeImage = [[UIImageView alloc]initWithImage:image];
    codeImage.backgroundColor = [UIColor redColor];
    [mainView addSubview:codeImage];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(mainView.mas_width).multipliedBy(1.25f);
    }];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.height.width.mas_equalTo(40);
    }];
    [mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(headImage.mas_right).offset(14);
        
    }];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mobile.mas_bottom).offset(5);
        make.left.mas_equalTo(headImage.mas_right).offset(14);
    }];
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(mainView);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(codeImage.mas_width).multipliedBy(1.0f);
    }];
    
    
}

- (NSString *)getCustomerInfo:(NSString *)customerInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:customerInfo];
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
