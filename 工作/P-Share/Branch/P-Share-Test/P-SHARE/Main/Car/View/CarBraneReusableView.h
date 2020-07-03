//
//  CarBraneReusableView.h
//  P-Share
//
//  Created by fay on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CarBraneReusableViewNormal,//正常车系
    CarBraneReusableViewHot,//热门车系
}CarBraneReusableViewType;
@interface CarBraneReusableView : UICollectionReusableView
@property (nonatomic,assign)CarBraneReusableViewType type;
@property (nonatomic,copy)NSString *titleName;

@end
