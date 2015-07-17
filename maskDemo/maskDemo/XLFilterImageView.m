//
//  XLFilterImageView.m
//  XLCoreImage
//
//  Created by hebe on 15/6/29.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "XLFilterImageView.h"
@import OpenGLES;
@import CoreImage;

@interface XLFilterImageView ()

@property (nonatomic, strong) CIContext *ciContext;

@end

@implementation XLFilterImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame context:[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2]];//目前GLES2兼容性最好，GLES3好多机型都不支持
    
    if (self)
    {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

+(instancetype)filterWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

-(void)drawRect:(CGRect)rect
{
    if (_inputImage == nil || (_filter == nil && _filters == nil) || self.ciContext == nil) return;
    
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:_inputImage];
    if (_filters) {
        _filter = [_filters lastObject];
        CIImage *tempCIImage;
        for (int i = 0; i<_filters.count; i++)
        {
            CIFilter *filter = _filters[i];
            if (i == 0)
            {
                [filter setValue:inputCIImage forKey:kCIInputImageKey];
                tempCIImage = filter.outputImage;
                continue;
            }
            
            [filter setValue:tempCIImage forKey:kCIInputImageKey];
            tempCIImage = filter.outputImage;
            
            if (i == _filters.count-1)
            {
                [filter setValue:tempCIImage forKey:kCIInputImageKey];
                tempCIImage = nil;
                break;
            }
        }
        
    }else{
        [_filter setValue:inputCIImage forKey:kCIInputImageKey];
    }
    CGRect inputBounds = inputCIImage.extent;
    CGRect drawableBounds = CGRectMake(0, 0, self.drawableWidth, self.drawableHeight);
    CGRect targetBounds = getTargetBounds(self.contentMode, inputBounds, drawableBounds);
    
    [self clearBackground];
    
    [self.ciContext drawImage:_filter.outputImage inRect:targetBounds fromRect:inputBounds];
    
    
}

-(void)clearBackground
{
    self.backgroundColor = [UIColor clearColor];
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
}

CGRect getTargetBounds(UIViewContentMode contentMode, CGRect fromRect, CGRect toRect)
{
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat fromAspectRatio = fromRect.size.width / fromRect.size.height;
            CGFloat toAspectRatio = toRect.size.width / toRect.size.height;
            
            CGRect fitRect = toRect;
            
            if (fromAspectRatio > toAspectRatio) {
                fitRect.size.width = toRect.size.height  * fromAspectRatio;
                fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
            } else {
                fitRect.size.height = toRect.size.width / fromAspectRatio;
                fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
            }
            return CGRectIntegral(fitRect);//转成整数，得到一个最小的矩形
        }
            break;
            
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat fromAspectRatio = fromRect.size.width / fromRect.size.height;
            CGFloat toAspectRatio = toRect.size.width / toRect.size.height;
            
            CGRect fitRect = toRect;
            
            if (fromAspectRatio > toAspectRatio) {
                fitRect.size.height = toRect.size.width / fromAspectRatio;
                fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
            } else {
                fitRect.size.width = toRect.size.height  * fromAspectRatio;
                fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
            }
            return CGRectIntegral(fitRect);
        }
            break;
            
        default:
            return fromRect;
            break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - getter && setter
-(CIContext *)ciContext
{
    if (_ciContext == nil)
    {
        _ciContext = [CIContext contextWithEAGLContext:self.context];
    }
    return _ciContext;
}

-(void)setInputImage:(UIImage *)inputImage
{
    _inputImage = inputImage;
    
    [self setNeedsDisplay];
}

-(void)setFilter:(CIFilter *)filter
{
    _filter = filter;
    
    [self setNeedsDisplay];
}

-(void)setFilters:(NSArray *)filters
{
    _filters = filters;
    
    [self setNeedsDisplay];
}

@end
