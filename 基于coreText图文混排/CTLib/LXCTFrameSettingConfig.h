//
//  LXCTFrameSettingConfig.h
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

///用户配置绘制的颜色,行间距,文字大小

#import <Foundation/Foundation.h>

@interface LXCTFrameSettingConfig : NSObject

/** 字体 */
@property (nonatomic, copy) NSString *ct_font;
/** 文字宽度 */
@property (nonatomic, assign) CGFloat ct_width;
/** 文字大小 */
@property (nonatomic, assign) CGFloat ct_fontSize;
/** 行间距 */
@property (nonatomic, assign) CGFloat ct_lineSpace;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *ct_textColor;

@end
