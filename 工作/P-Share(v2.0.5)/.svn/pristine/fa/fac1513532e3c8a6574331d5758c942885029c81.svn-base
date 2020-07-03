//
//  StartView.h
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    StartViewShowStyleSet,
    StartViewShowStyleShow
}StartViewShowStyle;
typedef enum {
    StartViewStyleBig,
    StartViewStyleSmall
}StartViewStyle;
@interface StartView : UIView
@property (nonatomic,assign)StartViewStyle              style;
@property (nonatomic,assign)StartViewShowStyle          showStyle;
@property (nonatomic,strong)UIButton                    *lastBtn;
@property (nonatomic,strong)UIButton                    *firstBtn;
@property (nonatomic,assign) CGFloat                    startWidth,
                                                        startspace;
@property (nonatomic,assign)NSInteger                   lightStartNum;//需要亮星星的数量
@property (nonatomic,assign)NSInteger                   lightingStartNum;//已经点亮星星的数量
@property (nonatomic,strong)NSArray                     *tagArray;//保存标签
@property (nonatomic,copy)void (^startViewClick)(NSInteger startNum);

@end
