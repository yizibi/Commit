//
//  LXCTImageData.h
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/11.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCTImageData : NSObject

/** name */
@property (nonatomic, copy) NSString *name;
/** 未知 */
@property (nonatomic, assign) NSInteger position;

/** 坐标,此处是CoreText左边,而不是UIKit坐标 */
@property (nonatomic, assign) CGRect imagePosition;
@end
