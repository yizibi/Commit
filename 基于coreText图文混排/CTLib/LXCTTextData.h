//
//  LXCTTextData.h
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXCTImageData.h"

@interface LXCTTextData : NSObject

/** 绘制尺寸 */
@property (nonatomic, assign) CTFrameRef ct_Frame;
/** 绘制高度 */
@property (nonatomic, assign) CGFloat ct_Height;
/** 富文本 */
@property (nonatomic, strong) NSAttributedString *ct_content;

/** 新增加的图片 */
@property (nonatomic, strong) NSArray *imageArray;

@end
