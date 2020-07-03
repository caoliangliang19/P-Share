//
//  MyUtil.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "MyUtil.h"
#import "QYSDK.h"
#import <QuartzCore/QuartzCore.h>
@interface MyUtil ()

@property (nonatomic,strong)UIViewController *viewControl;

@end
@implementation MyUtil

+ (NSString *)parking_code:(NSString *)parking_code{
    NSString *str = parking_code;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    MyLog(@"%ld",(unsigned long)str.length);
    if (str.length >6) {
        return str;
    }else{
        
        for (int i = 0; i<str.length; i++) {
            unichar an = [str characterAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%c",an];
            if (i == 1) {
                [array addObject:str];
                [array addObject:@"-"];
            }else if (i == 3) {
                [array addObject:str];
                [array addObject:@"-"];
            }else{
                [array addObject:str];
            }
            
        }
        
    }
    
    return [array componentsJoinedByString:@""];
}


+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    MyLog(@"%f  %f",CGRectGetWidth(lineView.frame),CGRectGetHeight(lineView.frame));
    
//    shapeLayer.frame = CGRectMake(0, 0,CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame));
    shapeLayer.frame = CGRectMake(0, 0,CGRectGetWidth(lineView.frame), 220);

    
//    [shapeLayer setBounds:lineView.bounds];
//    [shapeLayer setPosition:lineView.center];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,0, 220);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=now-late;
    return [MyUtil getStrOfSeconds:cha];
    
}

+ (NSString *)getStrOfSeconds:(long)seconds {
    
    if(seconds < 0){
        
        return @"";
        
    }
    
    long one_day = 60 * 60 * 24;
    
    long one_hour  = 60 * 60;
    
    long one_minute = 60;
    
    long day,hour,minute,second = 0L;
    
    day = seconds / one_day;
    
    hour = seconds % one_day / one_hour ;
    
    minute = seconds % one_day % one_hour /  one_minute;
    
    second = seconds % one_day % one_hour %  one_minute;
    
    
    
    if(seconds < one_minute){
        
        return [NSString stringWithFormat:@"%ld秒",seconds];
        
    }else if(seconds >= one_minute && seconds < one_hour){
        
        return [NSString stringWithFormat:@"%ld分钟",minute];

//        return [NSString stringWithFormat:@"%ld分%ld秒",minute,second];
        
    }else if (seconds >= one_hour && seconds < one_day){
        
//        return [NSString stringWithFormat:@"%ld时%ld分%ld秒",hour,minute,second];
        return [NSString stringWithFormat:@"%ld时%ld分钟",hour,minute];


        
    }else{  
        
//        return [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",day,hour,minute,second];
        return [NSString stringWithFormat:@"%ld天%ld时%ld分钟",day,hour,minute];

    }
    
}


+ (NSDate*)StringChangeDate:(NSString *)str
{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [inputFormatter dateFromString:str];
    
    return inputDate;
    
}


+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    MyLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //MyLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //MyLog(@"Date1 is in the past");
        return -1;
    }
    //MyLog(@"Both dates are the same");
    return 0;
    
}

//获取字符串高度
+ (CGFloat)getStringHeightWithString:(NSString *)string Font:(CGFloat )font MaxWitdth:(CGFloat )maxWidth
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
    
}


+ (phoneView *)addPhoneViewFor:(UIViewController *)viewController Name:(NSString *)userName
{
    phoneView *phoneV = [[NSBundle mainBundle]loadNibNamed:@"phoneView" owner:nil options:nil][0];
    
    phoneV.name = userName;
    
    phoneV.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:phoneV];
    [phoneV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(window);
        make.size.mas_equalTo(CGSizeMake(280, 210));
        
    }];
    [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 10 options: 0 animations: ^{
        phoneV.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion: nil];
    
    return phoneV;
    
}

+ (void)addBadgeWithView:(UIView *)view WithNum:(NSInteger)num
{
    view.badgeBgColor = [UIColor redColor];
    view.badgeCenterOffset = CGPointMake(0, 0);
    [view showBadgeWithStyle:WBadgeStyleRedDot value:num animationType:WBadgeAnimTypeNone];
}

#pragma mark -- 获得月租到期时间
+ (NSString *)getCalendar:(NSString *)string WithMonthlyNum:(int)num
{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:num];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:inputDate options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:mDate];
    NSInteger numberOfDaysInMonth = range.length;
    
    MyLog(@"%zi",range.length);
    
    NSString *year;
    NSString *mouthly;
    [formatter setDateFormat:@"MM"];
    mouthly = [formatter stringFromDate:mDate];
    [formatter setDateFormat:@"yyyy"];
    year = [formatter stringFromDate:mDate];
    NSString *str = [NSString stringWithFormat:@"%@-%@-%ld",year,mouthly,(long)numberOfDaysInMonth];
    
    return str;
    
}

+(UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLine:(NSInteger)numberOfLines
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    //文字
    if (title) {
        label.text = title;
    }
    //文字颜色
    if (color) {
        label.textColor = color;
    }
    if (font) {
        label.font = font;
    }
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    if (numberOfLines) {
        label.numberOfLines = numberOfLines;
    }
    
    return label;
    
}

+(UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font
{
    
    return [self createLabelFrame:frame title:title textColor:[UIColor blackColor] font:font textAlignment:NSTextAlignmentLeft numberOfLine:1];
}

+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
    
}

+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:frame];
    tmpImageView.image = [UIImage imageNamed:imageName];
    return tmpImageView;
}

//16进制颜色转换
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];

}
//车架号
+ (BOOL)isCarFrameNumber:(NSString *)carFrame{
     NSString *phoneRegex = @"^[a-zA-Z0-9]{17}$";
     NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
     return [phoneTest evaluateWithObject:carFrame];
}

//获取时间戳
+ (NSString *)getTimeStamp
{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    return dateString;
    
}

+ (NSString *)getCustomId{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    return userID;
}
+ (NSString *)getUseDefault:(NSString *)str{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *customerMobile = [NSString stringWithFormat:@"%@",[userDefault objectForKey:str]];
    return customerMobile;
}
+ (UIAlertController *)alertController:(NSString *)message Completion:(void (^)())completion Fail:(void (^)())fail{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
     [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (fail) {
            fail();
        }
        
    }]];
   
   return alert;
}
//弹框
+ (void)alertController:(NSString *)message viewController:(UIViewController *)VC Completion:(void (^)())completion Fail:(void (^)())fail;{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (fail) {
            fail();
            
        }
        
    }]];
    [VC presentViewController:alert animated:YES completion:nil];
}
+ (UIImage *)code39ImageFromString:(NSString *)strSource Width:(CGFloat)barcodew Height:(CGFloat)barcodeh;{
    int intSourceLength = (int)strSource.length;
    CGFloat x = 1; // Left Margin
    CGFloat y = 0; // Top Margin
    // Width = ((WidLength * 3 + NarrowLength * 7) * (intSourceLength + 2)) + (x * 2)
    CGFloat NarrowLength = (barcodew/(intSourceLength + 2)) / 17.0; // Length of narrow bar
    CGFloat WidLength = NarrowLength * 2; // Length of Wide bar
    NSString *strEncode = @"010010100"; // Encoding string for starting and ending mark *
    NSString * AlphaBet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*"; // Code39 alphabets
    NSString* Code39[] = //Encoding strings for Code39 alphabets
    {
        /* 0 */ @"000110100",
        /* 1 */ @"100100001",
        /* 2 */ @"001100001",
        /* 3 */ @"101100000",
        /* 4 */ @"000110001",
        /* 5 */ @"100110000",
        /* 6 */ @"001110000",
        /* 7 */ @"000100101",
        /* 8 */ @"100100100",
        /* 9 */ @"001100100",
        /* A */ @"100001001",
        /* B */ @"001001001",
        /* C */ @"101001000",
        /* D */ @"000011001",
        /* E */ @"100011000",
        /* F */ @"001011000",
        /* G */ @"000001101",
        /* H */ @"100001100",
        /* I */ @"001001100",
        /* J */ @"000011100",
        /* K */ @"100000011",
        /* L */ @"001000011",
        /* M */ @"101000010",
        /* N */ @"000010011",
        /* O */ @"100010010",
        /* P */ @"001010010",
        /* Q */ @"000000111",
        /* R */ @"100000110",
        /* S */ @"001000110",
        /* T */ @"000010110",
        /* U */ @"110000001",
        /* V */ @"011000001",
        /* W */ @"111000000",
        /* X */ @"010010001",
        /* Y */ @"110010000",
        /* Z */ @"011010000",
        /* - */ @"010000101",
        /* . */ @"110000100",
        /*' '*/ @"011000100",
        /* $ */ @"010101000",
        /* / */ @"010100010",
        /* + */ @"010001010",
        /* % */ @"000101010",
        /* * */ @"010010100"
    };
    
    strSource = [strSource uppercaseString];
    // calculate graphic size
    CGSize size = CGSizeMake(barcodew, barcodeh + (y * 2));
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // fill background color (white)
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    // beging encoding
    for (int i = 0; i < intSourceLength; i++)
    {
        // check for illegal characters
        char c = [strSource characterAtIndex:i];
        long index = [AlphaBet rangeOfString:[NSString stringWithFormat:@"%c",c]].location;
        if ((index == NSNotFound) || (c == '*'))
        {
            MyLog(@"This string contains illegal characters");
            return nil;
        }
        // get and concat encoding string
        strEncode = [NSString stringWithFormat:@"%@0%@",strEncode, Code39[index]];
    }
    // pad with ending *
    strEncode = [NSString stringWithFormat:@"%@0010010100", strEncode];
    
    int intEncodeLength = (int)strEncode.length; // final encoded data length
    CGFloat fBarWidth;
    // Draw Code39 BarCode according the the encoded data
    for (int i = 0; i < intEncodeLength; i++)
    {
        fBarWidth = ([strEncode characterAtIndex:i] == '1' ? WidLength : NarrowLength);
        // drawing with black color
        if (i % 2 == 0) {
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        }
        // drawing with white color
        else {
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        }
        CGContextFillRect(context, CGRectMake(x, y, fBarWidth, barcodeh));
        x += fBarWidth;
    }
    // get image from context and return
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
+ (NSString *)getVersion{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//  
//       // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    return app_Version;
    return @"1.3.7";
    
}

+ (NSMutableAttributedString *)getLableText:(NSString *)text changeText:(NSString *)changeString Color:(UIColor *)color font:(NSInteger)font;{
    
    if ([self isBlankString:changeString] == YES || text == nil) {
        return nil;
        
    }
    
    if ([text rangeOfString:changeString].location != NSNotFound ) {

        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:changeString];
        

        NSDictionary *dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:font]};
        [noteStr addAttributes:dict range:range];
        return noteStr;
        
        
    }
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:text];
    return noteStr;
}
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


@end








