//
//  FayPointAnnotation.h
//  P-Share
//
//  Created by fay on 16/6/14.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@interface FayPointAnnotation : MAPointAnnotation
@property (nonatomic,strong)Parking         *model;
@property (nonatomic,strong)NSString        *annotationID;

@end
