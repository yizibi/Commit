//
//  LXCTDisplayView.m
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "LXCTDisplayView.h"
#import "LXCTTextData.h"
#import "LXCTImageData.h"


@interface LXCTDisplayView()


@end

@implementation LXCTDisplayView


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ct_Frame, context);
    }
    //图像绘制
    for (LXCTImageData *imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
    
}



//混合版,未做拆分的功能
- (void)test{
    
    //获取当前绘制的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //翻转坐标系,底层GPU而言,左下角是(0,0),而UIKit认为左上角为(0,0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    //创建绘制的区域
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:
                                     @"hello World!"
                                     "测试绘制区域,coreText支持各种文字排版的区域,来来来,测试一下,"
                                     "测试绘制区域,coreText支持各种文字排版的区域,来来来,测试一下"
                                     "测试绘制区域,coreText支持各种文字排版的区域,来来来,测试一下"];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attString length]), path, NULL);
    
    //绘制
    CTFrameDraw(frame, context);
    
    //释放内存
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);

}


@end
