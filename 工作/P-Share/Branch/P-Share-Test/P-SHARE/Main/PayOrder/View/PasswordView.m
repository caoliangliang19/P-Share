//
//  PasswordView.m
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PasswordView.h"
#import "FayTextField.h"
#import "NumberKeyBoard.h"
@interface PasswordView()<UITextFieldDelegate,NumberKeyBoardDelegate>
{
    UIView          *_grayView;
    BOOL            _firstLoad;
    NSString        *_price;
    FayTextField    *_faytextField;
    NSMutableString *_temNumStr;
    
}
@end
@implementation PasswordView

+ (instancetype)createPasswordViewWithPrice:(NSString *)price
{
    return [[self alloc] initWithPrice:price];
}
- (id)initWithPrice:(NSString *)price
{
    if (self == [super init]) {
        _price = price;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    [super setUpSubView];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
    keyboardManager.shouldResignOnTouchOutside = NO;
    keyboardManager.enableAutoToolbar = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _grayView = [UIView new];
    _grayView.backgroundColor = [UIColor blackColor];
    _grayView.alpha = 0.5;
    [window addSubview:_grayView];
    [_grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [window addSubview:self];
    
    
    UIView *topView = [UIView new];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *titleL = [UtilTool createLabelFrame:CGRectZero title:@"请输入支付密码" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17.0f] textAlignment:1 numberOfLine:1];
    titleL.textAlignment = 1;
    [topView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topView);
    }];
    
    UIButton *cancelButton = [UIButton new];
    [cancelButton addTarget:self action:@selector(removeSelf) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelButton setImage:[UIImage imageNamed:@"MapClose"] forState:(UIControlStateNormal)];
    [topView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = KLINE_COLOR;
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    UIView *centerView = [UIView new];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(96);
    }];
    
    UILabel *titleTwoL = [UtilTool createLabelFrame:CGRectZero title:@"支付金额" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15.0f] textAlignment:1 numberOfLine:1];
    titleTwoL.textAlignment = 1;
    [centerView addSubview:titleTwoL];
    [titleTwoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView.mas_centerX);
        make.centerY.mas_equalTo(centerView.mas_centerY).offset(-20);
    }];
    
    UILabel *priceL = [UtilTool createLabelFrame:CGRectZero title:[NSString stringWithFormat:@"¥%@",_price] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:36.0f] textAlignment:1 numberOfLine:1];
    priceL.textAlignment = 1;
    [centerView addSubview:priceL];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView.mas_centerX);
        make.centerY.mas_equalTo(centerView.mas_centerY).offset(10);
    }];
    
    UIView *lineTwoView = [UIView new];
    lineTwoView.backgroundColor = KLINE_COLOR;
    [topView addSubview:lineTwoView];
    [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    UIView *bottomView = [UIView new];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(centerView.mas_bottom);
        make.height.mas_equalTo(86);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(window.mas_bottom).offset(-200);
        make.centerX.mas_equalTo(window);
        make.width.mas_equalTo(self.mas_height).multipliedBy(1.22);
    }];
    
    FayTextField *faytextField = [[FayTextField alloc] init];
    _faytextField = faytextField;
    NumberKeyBoard *numberKeyBoard = [NumberKeyBoard createNumberKeyBoard];
    numberKeyBoard.delegate = self;
    faytextField.inputView = numberKeyBoard;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [faytextField becomeFirstResponder];

    });
    [bottomView addSubview:faytextField];
    [faytextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bottomView);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [faytextField layoutIfNeeded];
    [faytextField setUpSubView];

    
}

- (void)removeSelf
{
    if (self.cancelWalletPay) {
        self.cancelWalletPay(self);
    }
    [self passwordViewHidden];
}
- (void)passwordViewShow
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.66 initialSpringVelocity:1/0.66 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
}
- (void)passwordViewHidden
{
    _firstLoad = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
    [_grayView removeFromSuperview];
}

#pragma mark -- NumberKeyBoardDelegate
- (void)numberKeyBoardChange:(NSString *)number
{
    if (!_temNumStr) {
        _temNumStr = [NSMutableString string];
    }
    if (![UtilTool isBlankString:number]) {
        if (_temNumStr.length < 6) {
            [_temNumStr appendString:number];
        }
        if(_temNumStr.length == 6)
        {
            [_faytextField resignFirstResponder];
            if (self.passwordViewBlock) {
                self.passwordViewBlock(self,_temNumStr);
            }
        }
    }else
    {
        if (_temNumStr.length > 0) {
            [_temNumStr deleteCharactersInRange:NSMakeRange(_temNumStr.length-1, 1)];
        }
    }
    _faytextField.text = _temNumStr;
    
}
#pragma mark 键盘将要出现
-(void)keyboardWillShow:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 键盘消失完毕
-(void)keyboardWillHide:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 处理键盘的位置
-(void)dealKeyboardFrame:(NSNotification *)changeMess{
    NSDictionary *dicMess=changeMess.userInfo;//键盘改变的所有信息
    CGFloat changeTime=[dicMess[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];//通过userInfo 这个字典得到对得到相应的信息//0.25秒后消失键盘
    CGFloat keyboardMoveY=[dicMess[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y-[UIScreen mainScreen].bounds.size.height;//键盘Y值的改变(字典里面的键UIKeyboardFrameEndUserInfoKey对应的值-屏幕自己的高度)
    MyLog(@"-------Keyboard change---%lf------",keyboardMoveY);
    
    [UIView animateWithDuration:changeTime animations:^{ //0.25秒密码框位置
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.superview.mas_bottom).offset(-260);
            [self layoutIfNeeded];
        }];
        if (_firstLoad) {
            [self layoutIfNeeded];
        }
        _firstLoad = YES;

    }];
   
}

@end
