//
//  MyUtil.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "phoneView.h"
@interface MyUtil : NSObject
+ (NSString *)parking_code:(NSString *)parking_code;

//画虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
/**
 *  计算一个时间距离现在的时间
 *
 *  @param theDate
 *
 *  @return
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate;

/**
 *  字符串转时间
 *
 *  @param str 需要转换的字符串
 *
 *  @return 转成的date
 */
+ (NSDate*)StringChangeDate:(NSString *)str;

/**
 *  比较两个时间的大小
 *
 *  @param oneDay     时间1
 *  @param anotherDay 时间2
 *
 *  @return 0:两个时间相等 1:时间1在前 2:时间1在后
 */
+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

//获取字符串高度
+ (CGFloat)getStringHeightWithString:(NSString *)string Font:(CGFloat )font MaxWitdth:(CGFloat )maxWidth;


//添加phoneView
+ (phoneView *)addPhoneViewFor:(UIViewController *)viewController Name:(NSString *)userName;

#pragma mark -- 获得月租到期时间
+ (NSString *)getCalendar:(NSString *)string WithMonthlyNum:(int)num;

//给view添加红点
+ (void)addBadgeWithView:(UIView *)view WithNum:(NSInteger)num;


//创建label的方法
+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLine:(NSInteger)numberOfLines;

//创建label的另外一个方法
+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;



//创建按钮的方法
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;

//创建图片视图的方法
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;

//16进制颜色转换
+ (UIColor *) colorWithHexString: (NSString *)color;

//判断是否是手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断车架号
+ (BOOL)isCarFrameNumber:(NSString *)carFrame;

//获取时间戳
+ (NSString *)getTimeStamp;

//获取用户ID
+ (NSString *)getCustomId;

//从沙盒获取数据
+ (NSString *)getUseDefault:(NSString *)str;
//弹框
+ (UIAlertController *)alertController:(NSString *)message Completion:(void (^)())completion Fail:(void (^)())fail;
//弹框
+ (void)alertController:(NSString *)message viewController:(UIViewController *)VC Completion:(void (^)())completion Fail:(void (^)())fail;
//生成条形码
+ (UIImage *)code39ImageFromString:(NSString *)strSource Width:(CGFloat)barcodew Height:(CGFloat)barcodeh;
//当前版本号
+ (NSString *)getVersion;
//改变lable上部分字体大小和颜色 text所有文字  changeText改变颜色的字符串
+ (NSMutableAttributedString *)getLableText:(NSString *)text changeText:(NSString *)changeString Color:(UIColor *)color font:(NSInteger)font;
// 检验空的字符串
+ (BOOL) isBlankString:(NSString *)string;

@end










