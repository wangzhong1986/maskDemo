//
//  ResizeImageView.m
//  maskDemo
//
//  Created by hebe on 15/7/14.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "ResizeImageView.h"

@interface ResizeImageView ()
{
    CGPoint beginP1;
    CGPoint beginP2;
    CGPoint beginPP1;
    CGPoint beginPP2;
    CGPoint beginP;
    CGAffineTransform endTransform;
    
    CGFloat atAngle;
    
    NSInteger isDouble;
}

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ResizeImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.multipleTouchEnabled = YES;
        
        CALayer *layer = [CALayer layer];
        layer.frame = self.bounds;
        layer.contents = (__bridge id)[UIImage imageNamed:@"遮罩1"].CGImage;
        self.layer.mask = layer;
        
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

+(instancetype)imageViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
    
    
}

//手指接触屏幕（两个手指按顺序接触，就执行两次）
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    endTransform = self.imageView.transform;
    isDouble = 0;
    beginP = [touches.anyObject locationInView:self];
    
    if (event.allTouches.count == 2) {
        UITouch *t1 = event.allTouches.allObjects[0];
        UITouch *t2 = event.allTouches.allObjects[1];
        isDouble ++;
        beginP1 = [t1 locationInView:self];
        beginP2 = [t2 locationInView:self];
        isDouble =2;
        beginPP1 = [t1 locationInView:self];
        beginPP2 = [t2 locationInView:self];
    }
}

//手指在屏幕上移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (event.allTouches.count == 1 && isDouble==0)
    {
        UITouch *t = touches.anyObject;
        CGPoint moveP = [t locationInView:self];
        
        self.imageView.transform = CGAffineTransformMake(endTransform.a, endTransform.b, endTransform.c, endTransform.d, endTransform.tx+moveP.x-beginP.x, endTransform.ty+moveP.y-beginP.y);
    }
    
    //2个手指在移动
    else if (event.allTouches.count == 2)
    {
        /**
         *     缩放
         */
        
        //获取两个手指点击生成的两个UITouch对象
        UITouch *t1 = event.allTouches.allObjects[0];
        UITouch *t2 = event.allTouches.allObjects[1];
        
        //移动中的点
        CGPoint moveP1 = [t1 locationInView:self];
        CGPoint moveP2 = [t2 locationInView:self];
        
        //移动中两点的间距
        CGFloat space = getDistance(moveP1,moveP2);
        
        //初始时两点的间距
        CGFloat beginSpace = getDistance(beginPP1,beginPP2);
        
        //计算比例，移动中的间距 除以 刚开始的间距
        CGFloat tmpScale = space/beginSpace;
        
        //根据上一次的矩阵来计算缩放或者放大,因为是等比缩放，所以用a和d计算效果一样，这里就用a了
        CGFloat scale = getScale(tmpScale*endTransform.a);
        
        /**
         *     旋转
         */
        
        //已知beginP1和beginP2，计算位移第三点的坐标
        //以beginP1为移动参照点来计算
        //计算移动后的两个点moveP1和moveP2各自距离beginP1的距离
        CGFloat tmpSpace1 = getDistance(beginP1, moveP1);
        CGFloat tmpSpace2 = getDistance(beginP1, moveP2);
        
        //远的点，近的点
        CGPoint farPoint,nearPoint;
        if (tmpSpace1>tmpSpace2) {
            farPoint = moveP1;
            nearPoint = moveP2;
        }else{
            farPoint = moveP2;
            nearPoint = moveP1;
        }
        
        //第三个点
        CGPoint point3;
        point3.x = beginP2.x + nearPoint.x - farPoint.x;
        point3.y = beginP2.y + nearPoint.y - farPoint.y;
        
        //beginP1,beginP2,point3组成一个三角形
        //beginP1的对边,邻边,斜边
        CGFloat a,b,c;
        a = getDistance(beginP1, point3);
        b = getDistance(beginP2, point3);
        c = getDistance(beginP1, beginP2);
        
        //余弦定理
        CGFloat cosBeginP1 = (pow(b, 2) + pow(c, 2) - pow(a, 2))/(2*b*c);
        
        if (cosBeginP1 > 1) {
            cosBeginP1 = 1;
        }
        
        //反余弦值,即π为180°单位的角度
        CGFloat tmpRotate = acos(cosBeginP1);
        
        CGFloat ta = beginP1.y - beginP2.y;
        CGFloat tb = beginP2.x - beginP1.x;
        CGFloat tc = beginP1.x * beginP2.y - beginP2.x * beginP1.y;
        CGFloat td = ta * point3.x + tb * point3.y + tc;
        
        if (td>0) {
            tmpRotate = 2 * M_PI - tmpRotate;
        }
        
        beginP1=nearPoint;
        beginP2=farPoint;
        
        tmpRotate = tmpRotate*180/M_PI + atAngle;
        tmpRotate = fmodf(tmpRotate, 360);

        atAngle = tmpRotate;
        tmpRotate = tmpRotate*M_PI/180;
        
        //        NSLog(@"\n%f\n%f\n%f\n%f\n%f\n%f\n%f\n",tempScale,self.imageView.transform.a,self.imageView.transform.b,self.imageView.transform.c,self.imageView.transform.d,self.imageView.transform.tx,self.imageView.transform.ty);
        self.imageView.transform = CGAffineTransformMake(cos(tmpRotate)*scale, sin(tmpRotate), -sin(tmpRotate), cos(tmpRotate)*scale, endTransform.tx, endTransform.ty);

//        self.imageView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(tmpRotate), CGAffineTransformMakeScale(scale, scale));
        
//        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
        
//        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
        
//        NSLog(@"\n%@",NSStringFromCGAffineTransform(CGAffineTransformIdentity));
    }
}

//手指离开屏幕
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (isDouble>0) {
        isDouble--;
    }
    
    endTransform = self.imageView.transform;
    
//    NSLog(@"\n%f",asin(endTransform.b));
}

//touch事件被打断，例如有电话打进来
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    endTransform = self.imageView.transform;
}

CGFloat getScale(CGFloat scale)
{
    CGFloat temp = MAX(0.2, scale);
    temp = MIN(4.0, temp);
    return temp;
}

//计算两点的间距
CGFloat getDistance(CGPoint p1, CGPoint p2)
{
    CGFloat xSpace = p1.x-p2.x;
    CGFloat ySpace = p1.y-p2.y;
    //数学公式,直角三角形：a*a+b*b=c*c
    CGFloat space = sqrt(pow(xSpace, 2)+pow(ySpace, 2));
    return space;
}

//getter懒加载
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}

//setter
-(void)setInputImage:(UIImage *)inputImage
{
    CGFloat width = inputImage.size.width;
    CGFloat height = inputImage.size.height;
    CGRect rect;
    if (width>height)
    {
        CGFloat w = self.bounds.size.width;
        CGFloat h = w * height/width;
        CGFloat x = 0;
        CGFloat y = self.bounds.size.height/2-h/2;
        rect = CGRectMake(x, y, w, h);
    }else
    {
        CGFloat h = self.bounds.size.height;
        CGFloat w = h * width/height;
        CGFloat x = self.bounds.size.width/2-w/2;
        CGFloat y = 0;
        rect = CGRectMake(x, y, w, h);
    }
    
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.frame = rect;
    self.imageView.image = inputImage;
}


-(UIImage *)outputImage
{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.imageView.bounds];
    [view addSubview:imgView];
    imgView.image = self.imageView.image;
    imgView.transform = self.imageView.transform;
    CALayer *layer = [CALayer layer];
    layer.frame = view.bounds;
    layer.contents = (__bridge id)[UIImage imageNamed:@"遮罩3"].CGImage;
    view.layer.mask = layer;
    
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    // 从当前context中创建一个改变大小后的图片
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tImage;
    
}



//-(CGImageRef) CopyImageAndAddAlphaChannel :(CGImageRef) sourceImage
//{
//    CGImageRef retVal = NULL;
//    size_t width = CGImageGetWidth(sourceImage);
//    size_t height = CGImageGetHeight(sourceImage);
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
//                                                          8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
//    
//    if (offscreenContext != NULL) {
//        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
//        
//        retVal = CGBitmapContextCreateImage(offscreenContext);
//        CGContextRelease(offscreenContext);
//    }
//    
//    CGColorSpaceRelease(colorSpace);
//    return retVal;
//}
//
//- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
//    CGImageRef maskRef = maskImage.CGImage;
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//                                        CGImageGetHeight(maskRef),
//                                        CGImageGetBitsPerComponent(maskRef),
//                                        CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef),
//                                        CGImageGetDataProvider(maskRef), NULL, false);
//    
//    CGImageRef sourceImage = [image CGImage];
//    CGImageRef imageWithAlpha = sourceImage;
//    //add alpha channel for images that don’t have one (ie GIF, JPEG, etc…)
//    //this however has a computational cost
//    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
//        imageWithAlpha = [self CopyImageAndAddAlphaChannel :sourceImage];
//    }
//    
//    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
//    CGImageRelease(mask);
//    
//    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
//    if (sourceImage != imageWithAlpha) {
//        CGImageRelease(imageWithAlpha);
//    }
//    
//    UIImage* retImage = [UIImage imageWithCGImage:masked];
//    CGImageRelease(masked);
//    return retImage;
//}




@end
