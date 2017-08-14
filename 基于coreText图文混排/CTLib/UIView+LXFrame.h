//
//  UIView+LXFrame.h
//  木言
//
//  Created by 李lucy on 14/01/7.
//  Copyright © 2014年 Lucy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LXFrame)

@property (nonatomic, assign) CGFloat lx_width;
@property (nonatomic, assign) CGFloat lx_height;
@property (nonatomic, assign) CGFloat lx_x;
@property (nonatomic, assign) CGFloat lx_y;
@property (nonatomic, assign) CGFloat lx_centerX;
@property (nonatomic, assign) CGFloat lx_centerY;
@property (nonatomic, assign) CGFloat lx_right;
@property (nonatomic, assign) CGFloat lx_bottom;
@property CGPoint origin;
@property CGSize size;
+ (instancetype)viewloadFromXib;
- (BOOL)intersectWithView:(UIView *)view;
- (void)moveBy:(CGPoint)delta;
- (void)scaleBy:(CGFloat)scaleFactor;
- (void)fitInSize:(CGSize)aSize;

/**
 *  返回一个任意圆角尺寸的view
 *
 *  @param corners     枚举UIRectCornerTopLeft左上,左下,右上,右下
 *  @param cornerRadii 圆角的尺寸
 *
 *  @return 返回一个任意圆角尺寸的view
 */
+ (CAShapeLayer *)viewByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii currentView:(UIView *)view;
//视频录制相关
-(void)makeCornerRadius:(float)radius borderColor:(UIColor*)bColor borderWidth:(float)bWidth;
@end
