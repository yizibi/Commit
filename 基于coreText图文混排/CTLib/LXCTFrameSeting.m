
//
//  LXCTFrameSeting.m
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "LXCTFrameSeting.h"

@implementation LXCTFrameSeting

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}


//对外使用json文件接口
+ (LXCTTextData *)frameSettingWithTempleFilePath:(NSString *)path config:(LXCTFrameSettingConfig *)config{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray];
    LXCTTextData *data = [self frameSettingWithAttributedContent:content config:config];
    data.imageArray = imageArray;
    return data;
}

//读取json内容,并根据配置设置文本
+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(LXCTFrameSettingConfig *)config imageArray:(NSMutableArray *)imageArray {
    
    //根据type节点,对图片和文本分别进行处理
    //1.保存当前图片节点信息到imageArray变量中;
    //2.新建一个空白的占位符;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array  isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                //文本
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *attribuText = [self frameSetingWithAttributedStringFromDictionary:dict config:config];
                    [result appendAttributedString:attribuText];
                }
                //图片
                else if ([type isEqualToString:@"img"]) {
                    //创建CoreTextImageData
                    LXCTImageData *imageData = [[LXCTImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    //创建空白占位符,并且设置他的CTRunDelegate
                    NSAttributedString *attributeString = [self frameSettingWithImageDataFromDictionary:dict config:config];
                    [result appendAttributedString:attributeString];
                }
            }
        }
    }
    return result;
}

//根据图片信息,生成空白站位符
+ (NSAttributedString *)frameSettingWithImageDataFromDictionary:(NSDictionary *)dict config:(LXCTFrameSettingConfig *)config {
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallback;
    callBacks.getDescent = descentCallback;
    callBacks.getWidth = widthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)(dict));
    
    //使用纯白色作为空白占位符0xFFFC
    unichar objcReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objcReplacementChar length:1];
    
    NSDictionary *atttributes = [self attributesWithConfig:config];
    
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:atttributes];
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space,CFRangeMake(0, 1) , kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    
    return space;
}

//构造富文本
+ (NSAttributedString *)frameSetingWithAttributedStringFromDictionary:(NSDictionary *)dict config:(LXCTFrameSettingConfig *)config{
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    //设置颜色
    UIColor *color = [self colorFromtemplete:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (__bridge id)(color.CGColor);
    }
    //设置尺寸
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize>0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromtemplete:(NSString *)name{
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
    
}

//构建文本属性
+ (NSMutableDictionary *)attributesWithConfig:(LXCTFrameSettingConfig *)config{
    CGFloat fontSize = config.ct_fontSize;
    CFStringRef font = (__bridge CFStringRef)config.ct_font;
    CTFontRef fontRef = CTFontCreateWithName(font, fontSize, NULL);
    CGFloat lineSpacing = config.ct_lineSpace;
    const CFIndex kNUmberOfSetting = 3;
    CTParagraphStyleSetting theSetings[kNUmberOfSetting] = {
        {
            kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpacing
        },
        {
            kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpacing
        },
        {
            kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpacing
        }
    };
    CTParagraphStyleRef theParaphRef = CTParagraphStyleCreate(theSetings, kNUmberOfSetting);
    
    UIColor *textColor = config.ct_textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParaphRef;
    
    //释放
    CFRelease(theParaphRef);
    CFRelease(fontRef);
    return dict;
    
}


//普通文本布局
+ (LXCTTextData *)frameSettingWithContent:(NSString *)content config:(LXCTFrameSettingConfig *)config{
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
//    NSAttributedString *contentString = [self frameSetingWithAttributedStringFromDictionary:attributes config:config];
    
    
    /*
     
     //创建CTFramesetterRef实例
     CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    //获得绘制区域的高度
    CGSize restrictSize = CGSizeMake(config.ct_width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat height = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frameRef = [self creatFrameWithFrameSetter:frameSetter config:config height:height];
    
    //将生成的CTFrameRef实例和计算好的绘制高度保存到Textdata中,然后返回
    LXCTTextData *data = [[LXCTTextData alloc] init];
    data.ct_Height = height;
    data.ct_Frame = frameRef;
    
    CFRelease(frameRef);
    CFRelease(frameSetter);
    
    */

    return [self frameSettingWithAttributedContent:contentString config:config];
    
}

//支持富文本布局
+ (LXCTTextData *)frameSettingWithAttributedContent:(NSAttributedString *)content config:(LXCTFrameSettingConfig *)config{
    
    //创建CTFramesetterRef实例
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);

    //获得绘制区域的高度
    CGSize restrictSize = CGSizeMake(config.ct_width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat height = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frameRef = [self creatFrameWithFrameSetter:frameSetter config:config height:height];
    
    //将生成的CTFrameRef实例和计算好的绘制高度保存到Textdata中,然后返回
    LXCTTextData *data = [[LXCTTextData alloc] init];
    data.ct_Height = height;
    data.ct_Frame = frameRef;
    data.ct_content = content;
    
    CFRelease(frameRef);
    CFRelease(frameSetter);
    
    return data;

}


+ (CTFrameRef)creatFrameWithFrameSetter:(CTFramesetterRef)frameSetter config:(LXCTFrameSettingConfig *)config height:(CGFloat)height{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.ct_width,height));
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);

    return frameRef;
    
}



@end
