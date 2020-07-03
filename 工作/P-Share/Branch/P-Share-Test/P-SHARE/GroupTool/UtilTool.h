//
//  UtilTool.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  定义一些全局的方法
 */
@interface UtilTool : NSObject
/**
 *  富文本
 */
+ (NSMutableAttributedString *)getLableText:(NSString *)text changeText:(NSString *)changeString Color:(UIColor *)color font:(NSInteger)font;
/**
 *  判断字符串是否为空
 */
+ (BOOL) isBlankString:(NSString *)string;
/**
 *  NSInteger转字符串
 */
+ (NSString*)StringValue:(NSInteger)num;
/**
 *  快速构建button
 */
+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgColor:(UIColor *)color textColor:(UIColor *)textColor textFont:(float)font target:(id)target action:(SEL)action;
/**
 *  快速构建label
 */
+(UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLine:(NSInteger)numberOfLines;
/**
 *  获取用户CustomId
 */
+ (NSString *)getCustomId;
/**
 *  拆分停车码
 */
+ (NSString *)separateParkingCode:(NSString *)parkingCode;
/**
 *  画虚线
 */
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 *  验证手机号
 */
+(BOOL)isValidateTelNumber:(NSString *)number;
/**
 *  验证验证码
 */
+(BOOL)isValidateSecurityCode:(NSString *)securityCode;

/**
 *  获取APP版本号
 */
+ (NSString *)getAppVersion;
/**
 *  获取手机型号
 */
+ (NSString *)getPhoneType;

/**
 *  判断用户是否是游客
 */
+ (BOOL)isVisitor;
/**
 *  获取字符串高度
 */
+ (CGFloat)getStringHeightWithString:(NSString *)string Font:(CGFloat )font MaxWitdth:(CGFloat )maxWidth;
/**
 *  快速构建button
 */
+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;
/**
 *  获取时间戳
 */
+ (NSString *)getTimeStamp;
/**
 *  创建选择框
 */
+ (void)creatAlertController:(UIViewController *)viewController   title:(NSString *)title describute:(NSString *)describute sureClick:(void (^)())sureClick cancelClick:(void (^)())cancelClick;
/**
 *  创建文件夹
 */
+ (NSString *)createFilePathWith:(NSString *)fileName;
/**
 *  删除文件夹及其内容
 */
+ (void)deleteFileWith:(NSString *)fileName;
/**
 *  计算两个时间差
 */
+ (NSString *)mathTimeDifferenceWith:(NSDate*)time otherTime:(NSDate*)otherTime;
/**
 *  获得月租到期时间
 */
+ (NSString *)getCalendar:(NSString *)string WithMonthlyNum:(NSInteger)num;
/**
 *  拿到客户信息
 */
+ (NSString *)getCustomerInfo:(NSString *)customerInfo;
/**
 *  比较两个时间的大小
 */
+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
/**
 *  string->date
 */
+ (NSDate*)StringChangeDate:(NSString *)str;

@end
