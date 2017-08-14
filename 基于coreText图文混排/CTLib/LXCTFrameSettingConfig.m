

//
//  LXCTFrameSettingConfig.m
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "LXCTFrameSettingConfig.h"

@implementation LXCTFrameSettingConfig

- (instancetype)init{
    if (self = [super init]) {
        
        _ct_width = 200.0f;
        _ct_fontSize = 16.0f;
        _ct_lineSpace = 8.0f;
        _ct_textColor = LXColor(108, 108, 108);
    }
    return self;
}

@end
