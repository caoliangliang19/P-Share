//
//  LocationTool.h
//  P-Share
//
//  Created by fay on 16/7/26.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    LocationStatusNoLocation,
    LocationStatusLocationSuccess,
}LocationStatus;
@interface LocationTool : NSObject

+ (LocationTool *)shareLocationTool;

@property (nonatomic,assign)LocationStatus locationStatus;

@end
