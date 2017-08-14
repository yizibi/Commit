//
//  LXCTFrameSeting.h
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

///用于实现排版逻辑,根据配置以及内容构建排版


#import <Foundation/Foundation.h>
#import "LXCTTextData.h"
#import "LXCTFrameSettingConfig.h"
#import "LXCTImageData.h"

@interface LXCTFrameSeting : NSObject



/**
 提供对外使用的接口

 @param path json文件路径
 @return 对外使用接口
 */
+ (LXCTTextData *)frameSettingWithTempleFilePath:(NSString *)path config:(LXCTFrameSettingConfig *)config;

/**
 创建绘制布局

 @param content 绘制内容
 @param config 配置
 @return 布局
 */
+ (LXCTTextData *)frameSettingWithContent:(NSString *)content config:(LXCTFrameSettingConfig *)config;



/**
 创建富文本绘制布局
 
 @param content 绘制内容
 @param config 配置
 @return 布局
 */
+ (LXCTTextData *)frameSettingWithAttributedContent:(NSAttributedString *)content config:(LXCTFrameSettingConfig *)config;

/**
 构造文本属性

 @param config config
 @return 文本属性
 */
+ (NSMutableDictionary *)attributesWithConfig:(LXCTFrameSettingConfig *)config;

@end
