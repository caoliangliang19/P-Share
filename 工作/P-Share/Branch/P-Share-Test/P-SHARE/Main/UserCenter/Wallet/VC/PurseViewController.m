//
//  PurseViewController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PurseViewController.h"
#import "PurseTradeVC.h"
#import "PursePayForVC.h"
#import "POPNumberAnimation.h"
#import "DiscountController.h"
#import "ProofListController.h"
#import "PassWordIsController.h"
#import "ScrollLable.h"

@interface PurseViewController ()<POPNumberAnimationDelegate>
{
    UIImageView *_purseLogo;
    UILabel *_myBalanceL;
    UILabel *_myMoneyL;
    UIButton *_addMoneyBtn;
    UILabel *_myBiaoL;
    UILabel *_otherL;
    CGFloat _currentMoney;
    
}
@property (nonatomic, strong) POPNumberAnimation *numberAnimation;

@property (nonatomic , strong)ScrollLable *lable;

@property (nonatomic , strong)NSMutableString *rultString;

@end

@implementation PurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshMoney];
    [self createNavGationView];
   
    
}
- (ScrollLable *)lable{
    if (_lable == nil) {
        _lable = [[ScrollLable alloc]initWithFrame:CGRectMake(90, 286, self.view.frame.size.width-180, 30) withDirection:ScrollLableDirectionH withMessage:self.rultString withAction:^{
            
        }];
        [self.view addSubview:_lable];
    }
    return _lable;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.lable start];
}
- (void)refreshMoney{
    NSString *summary = [[NSString stringWithFormat:@"%@%@",[UtilTool getCustomId],SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(getMoney),[UtilTool getCustomId],summary];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        _currentMoney = [responseObject[@"money"] floatValue];
         [self createUI];
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    [NetWorkEngine getRequestUse:(self) WithURL:[NSString stringWithFormat:@"%@/%@",APP_URL(getRult),[SECRET_KEY MD5]] WithDic:nil needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *rult = responseObject[@"rule"];
        if (rult.count-1>0) {
            NSMutableString *ruleStr = [[NSMutableString alloc] init];
            
            for (int i=0; i<rult.count-1; i++) {
                [ruleStr appendString:rult[i]];
            }
            self.rultString = ruleStr;
        }
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}
- (void)createNavGationView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.title = @"我的钱包";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"交易记录" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(onRightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWalletMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoneyData) name:@"refreshWalletMoney" object:nil];
}
- (void)refreshMoneyData{
    [self refreshMoney];
}
#pragma mark -
#pragma mark - 进入交易记录页面
- (void)onRightClick{
    PurseTradeVC *trade = [[PurseTradeVC alloc] init];
    trade.type = DisfferentVCTypeJiLu;
    [self.rt_navigationController pushViewController:trade animated:YES];
}
#pragma mark -
#pragma mark - 创建页面控件
- (void)createUI{
    _purseLogo = [[UIImageView alloc]init];
    _purseLogo.image = [UIImage imageNamed:@"balance"];
    [self.view addSubview:_purseLogo];
    
    _myBalanceL = [UtilTool createLabelFrame:CGRectZero title:@"余额(元)" textColor:[UIColor colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [self.view addSubview:_myBalanceL];
    
    _myMoneyL = [UtilTool createLabelFrame:CGRectZero title:[NSString stringWithFormat:@"0.0"] textColor:[UIColor colorWithHexString:@"FF6160"] font:[UIFont systemFontOfSize:40] textAlignment:NSTextAlignmentCenter numberOfLine:0];
    [self.view addSubview:_myMoneyL];

   
    [self configNumberAnimation];
    [self.numberAnimation startAnimation];
   
    
    _addMoneyBtn = [UtilTool createBtnFrame:CGRectZero title:@"立即充值" bgImageName:nil target:self action:@selector(onAddMoney)];
    _addMoneyBtn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
    [_addMoneyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _addMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _addMoneyBtn.layer.cornerRadius = 5;
    _addMoneyBtn.clipsToBounds = YES;
    [self.view addSubview:_addMoneyBtn];
    
   
    
    UIView *cellView1 = [self createView:@"coupon_g" title:@"我的优惠劵"];
    cellView1.frame = CGRectMake(0, 316, SCREEN_WIDTH, 40);
    [self.view addSubview:cellView1];
    
    UIView *cellView2 = [self createView:@"certificate" title:@"我的停车凭证"];
    cellView2.frame = CGRectMake(0, 356, SCREEN_WIDTH, 40);
    [self.view addSubview:cellView1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-70, 276, 80, 50);
    [button setImage:[UIImage imageNamed:@"setup_g"] forState:(UIControlStateNormal)];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(onSetUpClock) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    [_purseLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.mas_equalTo(self.view);
        make.height.width.mas_equalTo(212);
    }];
    [_myBalanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_purseLogo.mas_top).offset(60);
        make.centerX.mas_equalTo(_purseLogo);
    }];
    [_myMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_purseLogo.mas_top).offset(95);
        make.centerX.mas_equalTo(_purseLogo);
    }];
    [_addMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_purseLogo.mas_bottom).offset(20);
        make.width.mas_equalTo(174);
        make.height.mas_equalTo(38);
        make.centerX.mas_equalTo(self.view);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(distaceMomey)];
    [cellView1 addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopCarPingZ)];
    [cellView2 addGestureRecognizer:tap1];

}
- (void)onSetUpClock{
    BaseViewController *purseSet = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"pay_password"] integerValue] == 0) {
        purseSet = [self baseViewController:@"设置支付密码"];
    }else
    {
        purseSet = [self baseViewController:@"重置支付密码"];
        
    }
    [self.rt_navigationController pushViewController:purseSet animated:YES complete:nil];
}
- (BaseViewController *)baseViewController:(NSString *)lableTitle{
    BaseViewController *purseSet = [[BaseViewController alloc] init];
    purseSet.title = @"钱包设置";
    purseSet.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [purseSet.view addSubview:bgView];
    UILabel *titleLable = [UtilTool createLabelFrame:CGRectZero title:lableTitle textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight numberOfLine:0];
    [bgView addSubview:titleLable];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_Arrow"]];
    [bgView addSubview:imageView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(14);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(13);
        make.right.mas_equalTo(-8);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGoinPasswordSet)];
    [bgView addGestureRecognizer:tap];
    return purseSet;
}
- (void)onGoinPasswordSet{
    PassWordIsController *passWord = [[PassWordIsController alloc]init];
    [self.rt_navigationController pushViewController:passWord animated:YES complete:nil];
}
- (void)distaceMomey{
    DiscountController *discount = [[DiscountController alloc]init];
    [self.rt_navigationController pushViewController:discount animated:YES];
}
- (void)stopCarPingZ{
    ProofListController *proof = [[ProofListController alloc]init];
    proof.type = DisfferentVCTypePing;
    [self.rt_navigationController pushViewController:proof animated:YES complete:nil];
}
- (UIView *)createView:(NSString *)imageName title:(NSString *)title{
    UIView *tabView = [[UIView alloc] init];
    tabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabView];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [tabView addSubview:leftImage];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"listRight"]];
    [tabView addSubview:rightImage];
    
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:title textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    [tabView addSubview:titleL];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [tabView addSubview:lineView];
    
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tabView);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tabView);
        make.left.mas_equalTo(leftImage.mas_right).offset(10);
        make.height.mas_equalTo(17);
    }];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tabView);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(9);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(39);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    return tabView;
}
- (void)configNumberAnimation {
    self.numberAnimation = [[POPNumberAnimation alloc] init];
    self.numberAnimation.delegate        = self;
    self.numberAnimation.fromValue      = 0;
    self.numberAnimation.toValue        = _currentMoney;
    
    self.numberAnimation.duration       = 1.5f;
    self.numberAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.69 :0.11 :0.32 :0.88];
    [self.numberAnimation saveValues];
    
}

#pragma mark --- POPNumberAnimationDelegate
- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue
{

    MyLog(@"currentValue --->%lf",currentValue);
    // Init string.
    NSString *numberString = [NSString stringWithFormat:@"%.1f", currentValue];
    _myMoneyL.text = numberString;
   
}
#pragma mark -
#pragma mark - 进入支付页面
- (void)onAddMoney{
    PursePayForVC *payFor = [[PursePayForVC alloc]init];
    [self.rt_navigationController pushViewController:payFor animated:YES complete:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
