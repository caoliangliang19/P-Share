//
//  UIView+AddFrame.h
//  P-Share
//
//  Created by fay on 16/4/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddFrame)
@property (nonatomic) CGFloat Addleft;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat Addtop;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat Addright;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat Addbottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat Addwidth;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat Addheight;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat AddcenterX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat AddcenterY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint Addorigin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  Addsize;        ///< Shortcut for frame.size.
@end
