//
//  ViewController2.m
//  maskDemo
//
//  Created by hebe on 15/7/16.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "ViewController2.h"
#import "XLFilterImageView.h"

#import "UIImage+Blend.h"
#import "UIImage+vImage.h"

@interface ViewController2()

{
    CIFilter *filter;
}

@property (strong, nonatomic) XLFilterImageView *resultImageView;
- (IBAction)doClickBtn;
@property (weak, nonatomic) IBOutlet UISlider *colorslider;
@property (weak, nonatomic) IBOutlet UISlider *slider2;

- (IBAction)valueChanged:(id)sender;

@end

@implementation ViewController2

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    /**
     
     case 1:
     imageView.image = [self.orgImage gaussianBlur];
     title = @"gaussianBlur";
     break;
     case 2:
     imageView.image = [self.orgImage edgeDetection];
     title = @"edgeDetection";
     break;
     case 3:
     imageView.image = [self.orgImage emboss];
     title = @"emboss";
     break;
     case 4:
     imageView.image = [self.orgImage sharpen];
     title = @"sharpen";
     break;
     case 5:
     imageView.image = [self.orgImage unsharpen];
     title = @"unsharpen";
     break;
     case 6:
     imageView.image = [self.orgImage rotateInRadians:M_PI_2 * 0.3];
     title = @"rotate";
     break;
     case 7:
     imageView.image = [self.orgImage dilateWithIterations:3];
     title = @"dilate";
     break;
     case 8:
     imageView.image = [self.orgImage erodeWithIterations:3];
     title = @"erode";
     break;
     case 9:
     imageView.image = [self.orgImage gradientWithIterations:3];
     title = @"gradient";
     break;
     case 10:
     imageView.image = [self.orgImage tophatWithIterations:4];
     title = @"tophat";
     break;
     case 11:
     imageView.image = [self.orgImage equalization];
     title = @"equalization";
     break;

     */
    
    self.resultImageView.inputImage = [_image emboss];
    filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setDefaults];
    self.resultImageView.filter = filter;

//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70, 300, 300)];
//    imageView.image = _image;
//    [self.view addSubview:imageView];
}

- (IBAction)doClickBtn {

    [filter setValue:@0 forKey:kCIInputSaturationKey];
    self.resultImageView.filter = filter;
    
}
- (IBAction)valueChanged:(UISlider*)sender {
    
    [filter setValue:@(sender.value) forKey:kCIInputContrastKey];
    
    self.resultImageView.filter = filter;
}
- (IBAction)changed2:(UISlider *)sender {
    
//    [filter setValue:@(sender.value) forKey:kCIInputBrightnessKey];
//    
//    self.resultImageView.filter = filter;
}

-(XLFilterImageView *)resultImageView
{
    if (!_resultImageView) {
        _resultImageView = [XLFilterImageView filterWithFrame:CGRectMake(20, 70, 300, 300)];
        [self.view addSubview:_resultImageView];
    }
    return _resultImageView;
}


//add xiaoliang zhushi
//-  (UIImage *) grayscaleImage: (UIImage *) image
//{
//    
////    UIGraphicsBeginImageContext(self.bounds.size);
////    CGContextRef ctx = UIGraphicsGetCurrentContext();
////    [self.layer renderInContext:ctx];
////    // 从当前context中创建一个改变大小后的图片
////    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
////    CGImageRef image=CGImageCreateWithImageInRect([tImage CGImage], self.bounds);
////    UIImage *finalimage=[UIImage imageWithCGImage:image];
////    //    CGImageRelease(image);
////    // 使当前的context出堆栈
////    UIGraphicsEndImageContext();
//    
//    
//    CGSize size = image.size;
//    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width,
//                             image.size.height);
//    // Create a mono/gray color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    
//    //int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
//    
//    CGContextRef context = CGBitmapContextCreate(nil, size.width,
//                                                 size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
//    CGColorSpaceRelease(colorSpace);
//    // Draw the image into the grayscale context
//    CGContextDrawImage(context, rect, [image CGImage]);
//    CGImageRef grayscale = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    // Recover the image
//    UIImage *img = [UIImage imageWithCGImage:grayscale];
//    CFRelease(grayscale);
//    return img;
//}




@end
