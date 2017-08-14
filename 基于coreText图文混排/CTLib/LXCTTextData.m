
//
//  LXCTTextData.m
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "LXCTTextData.h"

@implementation LXCTTextData


- (void)setCt_Frame:(CTFrameRef)ct_Frame{
    if (_ct_Frame != nil) {
        CFRelease(_ct_Frame);
    }
    CFRetain(ct_Frame);
    _ct_Frame = ct_Frame;
}

- (void)dealloc{
    if (_ct_Frame != nil) {
        CFRelease(_ct_Frame);
        _ct_Frame = nil;
    }
}


- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    //绘制
    [self fillImagePosition];
}


- (void)fillImagePosition {
    if (self.imageArray.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ct_Frame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ct_Frame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    LXCTImageData * imageData = self.imageArray[0];
    
    for (int i = 0; i < lineCount; ++i) {
        if (imageData == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ct_Frame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imgIndex];
            }
        }
    }
}

//
//- (void)fillImagePosition{
//    if (!self.imageArray.count) {
//        return;
//    }
//    
//    NSArray *lines = (NSArray *)CTFrameGetLines(self.ct_Frame);
//    NSInteger lineCount = [lines count];
//    CGPoint lineOrigins[lineCount];
//    CTFrameGetLineOrigins(self.ct_Frame, CFRangeMake(0, 0), lineOrigins);
//    int imageIndex = 0;
//    LXCTImageData *imageData = self.imageArray[0];
//    for (int i = 0; i < lineCount; ++i) {
//        if (imageData == nil) {
//            break;
//        }
//        CTLineRef line = (__bridge CTLineRef)lines[i];
//        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
//        for (id runObj in runObjArray) {
//            CTRunRef run = (__bridge CTRunRef)runObj;
//            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
//            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes objectForKey:(id)kCTRunDelegateAttributeName];
//            if (delegate == nil) {
//                continue;
//            }
//            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
//            if (![metaDic isKindOfClass:[NSDictionary class]]) {
//                continue;
//            }
//            CGRect runBounds;
//            CGFloat descent;
//            CGFloat ascent;
//            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
//            runBounds.size.height = ascent + descent;
//            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
//            runBounds.origin.x = lineOrigins[i].x + xOffset;
//            runBounds.origin.y = lineOrigins[i].y;
//            runBounds.origin.y -= descent;
//            
//            CGPathRef pathRef = CTFrameGetPath(self.ct_Frame);
//            CGRect colRect = CGPathGetPathBoundingBox(pathRef);
//            
//            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
//            
//            imageData.imagePosition = delegateBounds;
//            imageIndex++;
//            if (imageIndex == self.imageArray.count) {
//                imageData = nil;
//                break;
//            }
//            else {
//                imageData = self.imageArray[imageIndex];
//            }
//        }
//    }
// 
//}

@end
