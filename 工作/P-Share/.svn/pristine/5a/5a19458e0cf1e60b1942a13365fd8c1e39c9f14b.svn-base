//
//  SaveInfoView.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "SaveInfoView.h"
typedef NS_ENUM(NSInteger , ViewStyle){
    ViewStyleNumberPhone,
    ViewStyleTextField,
    ViewStylePicker
};
@interface SaveInfoView ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (nonatomic , assign)ViewStyle viewStyle;

@property (nonatomic , strong)NSArray *leftTextA;

@property (nonatomic , strong)NSMutableArray *rightTextA;

@property (nonatomic , assign)NSInteger indexNumber;

@property (nonatomic , strong)NSMutableArray *pickArray;
@end

@implementation SaveInfoView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self crateViewUI];
    }
    return self;
}

- (void)crateViewUI{
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 1+(35)*(i), 100, 35)];
        leftLable.text = self.leftTextA[i];
        leftLable.font = [UIFont systemFontOfSize:15];
        leftLable.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:leftLable];
        self.indexNumber = i;
        if (i == 0 || i == 3 || i == 5) {
            self.viewStyle = ViewStyleTextField;
        }else if (i == 2 || i == 4){
            self.viewStyle = ViewStylePicker;
        }else{
            self.viewStyle = ViewStyleNumberPhone;
        }
    }
}
- (void)setViewStyle:(ViewStyle)viewStyle{
    
    if (viewStyle == ViewStyleTextField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 1+(35)*self.indexNumber, SCREEN_WIDTH- 160, 35)];
        textField.tintColor = [UIColor colorWithHexString:@"39d5b8"];
        textField.font = [UIFont systemFontOfSize:15];
        textField.textAlignment = NSTextAlignmentRight;
        textField.delegate = self;
        textField.textColor = [UIColor colorWithHexString:@"333333"];
        textField.text = self.rightTextA[self.indexNumber];
        if (self.indexNumber == 0) {
            self.nameTextField = textField;
        }else if (self.indexNumber == 3){
            self.jobTextField = textField;
        }else if (self.indexNumber == 5){
            self.e_mailTextField = textField;
        }
        [self addSubview:textField];
    }else if (viewStyle == ViewStylePicker){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listRight"]];
        imageView.frame = CGRectMake(SCREEN_WIDTH-25, 13+(35)*self.indexNumber, 7, 12);
        [self addSubview:imageView];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 1+(35)*self.indexNumber, SCREEN_WIDTH- 160, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitle:self.rightTextA[self.indexNumber] forState:UIControlStateNormal];
        button.tag = self.indexNumber;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.indexNumber == 2) {
            self.sexBtn = button;
        }else if (self.indexNumber == 4){
            self.cityBtn = button;
        }
        [self addSubview:button];
        
    }else{
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(130, 1+(35)*self.indexNumber, SCREEN_WIDTH- 160, 35)];
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = [UIColor lightGrayColor];
        lable.text = self.rightTextA[self.indexNumber];
        self.phoneLable = lable;
        [self addSubview:lable];
    }
}
- (void)onClick:(UIButton *)btn{
    [self endEditing:YES];
    self.pickView.hidden = NO;
    [self.pickArray removeAllObjects];
    if (btn.tag == 2) {
        if ([UtilTool isBlankString:btn.currentTitle] == YES) {
            [btn setTitle:@"男" forState:(UIControlStateNormal)];
        }
        [self.pickArray addObjectsFromArray:@[@"男",@"女"]];
    }else if (btn.tag == 4){
        if ([UtilTool isBlankString:btn.currentTitle] == YES) {
            [btn setTitle:@"北京市" forState:(UIControlStateNormal)];
        }
        NSMutableArray *cityArray = [[NSMutableArray alloc]init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *city in array) {
            [cityArray addObject:city[@"ProvinceName"]];
        }
        self.pickArray = [NSMutableArray arrayWithArray:cityArray];
    }
    [self.pickView reloadAllComponents];
}
- (UIPickerView *)pickView{
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 150, SCREEN_WIDTH, 150)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        [self addSubview:_pickView];
    }
    return _pickView;
}
- (NSArray *)leftTextA{
    if (_leftTextA == nil) {
        _leftTextA = [[NSArray alloc] initWithObjects:@"姓名:",@"手机:",@"性别:",@"职业:",@"城市:",@"邮箱:", nil];
    }
    return _leftTextA;
}
- (NSMutableArray *)pickArray{
    if (_pickArray == nil) {
        _pickArray = [NSMutableArray new];
    }
    return _pickArray;
}
- (NSMutableArray *)rightTextA{
    if (_rightTextA == nil) {
        _rightTextA = [NSMutableArray new];
        if ([UtilTool isBlankString:[UtilTool getCustomerInfo:@"customerNickname"]]) {
            [_rightTextA addObject:@" "];
        }else{
            [_rightTextA addObject:[UtilTool getCustomerInfo:@"customerNickname"]];
        }
        if ([UtilTool isBlankString:[UtilTool getCustomerInfo:@"customerMobile"]]) {
            [_rightTextA addObject:@" "];
        }else{
            [_rightTextA addObject:[UtilTool getCustomerInfo:@"customerMobile"]];
        }
        if ([UtilTool isBlankString:[NSString stringWithFormat:@"%@",[UtilTool getCustomerInfo:@"customerSex"]]]) {
            [_rightTextA addObject:@" "];
        }else{
            if ([[UtilTool getCustomerInfo:@"customerSex"] integerValue] == 1) {
                [_rightTextA addObject:@"男"];
            }else{
                [_rightTextA addObject:@"女"];
            }
        }
        if ([UtilTool isBlankString:[UtilTool getCustomerInfo:@"customerJob"]]) {
            [_rightTextA addObject:@" "];
        }else{
            [_rightTextA addObject:[UtilTool getCustomerInfo:@"customerJob"]];
        }
        if ([UtilTool isBlankString:[UtilTool getCustomerInfo:@"customerRegion"]]) {
            [_rightTextA addObject:@" "];
        }else{
            [_rightTextA addObject:[UtilTool getCustomerInfo:@"customerRegion"]];
        }
        if ([UtilTool isBlankString:[UtilTool getCustomerInfo:@"customerEmail"]]) {
            [_rightTextA addObject:@" "];
        }else{
            [_rightTextA addObject:[UtilTool getCustomerInfo:@"customerEmail"]];
        }
    }
    return _rightTextA;
}

- (void)setMyType:(ControllerType)myType{
    if (myType == ControllerTypeModify) {
        self.jobTextField.userInteractionEnabled = NO;
        self.nameTextField.userInteractionEnabled = NO;
        self.e_mailTextField.userInteractionEnabled = NO;
        self.cityBtn.userInteractionEnabled = NO;
        self.sexBtn.userInteractionEnabled = NO;
        self.jobTextField.textColor = [UIColor lightGrayColor];
        self.nameTextField.textColor = [UIColor lightGrayColor];
        self.e_mailTextField.textColor = [UIColor lightGrayColor];
        [self.cityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.sexBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        self.jobTextField.userInteractionEnabled = YES;
        self.nameTextField.userInteractionEnabled = YES;
        self.e_mailTextField.userInteractionEnabled = YES;
        self.cityBtn.userInteractionEnabled = YES;
        self.sexBtn.userInteractionEnabled = YES;
        self.jobTextField.textColor = [UIColor colorWithHexString:@"333333"];
        self.nameTextField.textColor = [UIColor colorWithHexString:@"333333"];
        self.e_mailTextField.textColor = [UIColor colorWithHexString:@"333333"];
        [self.cityBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.sexBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetGrayStrokeColor(ctx, 0.9, 1);
    for (NSInteger i = 0; i < 6; i++) {
        const CGPoint points[] = {CGPointMake(20, 35*(i+1)),CGPointMake(SCREEN_WIDTH, 35*(i+1))};
        CGContextStrokeLineSegments(ctx, points, 2);
    }
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIButton *button = [self viewWithTag:2];
     UIButton *button1 = [self viewWithTag:4];
    if (self.pickArray.count >2) {
        [button1 setTitle:self.pickArray[row] forState:(UIControlStateNormal)];
    }else{
        [button setTitle:self.pickArray[row] forState:(UIControlStateNormal)];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.pickView setHidden:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
     [self.pickView setHidden:YES];
}
@end
