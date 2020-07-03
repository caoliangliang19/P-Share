//
//  ActivityHeadview.h
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ActivityHeadviewStyleOne,//有更多按钮
    ActivityHeadviewStyleTwo//隐藏更多按钮
}ActivityHeadviewStyle;
@interface ActivityHeadview : UICollectionReusableView
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)void(^moreBlock)(NSInteger i);
@property (nonatomic,assign)ActivityHeadviewStyle style;

@end
