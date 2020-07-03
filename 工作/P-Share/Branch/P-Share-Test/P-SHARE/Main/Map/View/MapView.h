//
//  MapView.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@interface MapView : BaseView
/**
 *  返回用户当前坐标
 */
- (void)location;
/**
 *  回到搜索结果所在位置
 */
- (void)locationWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude;

/**
 *  刷新地图界面数据
 */
- (void)refreshMapData;

- (void)addAnnotationWithCooordinate;



@end
