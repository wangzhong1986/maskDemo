//
//  ViewController2.m
//  maskDemo
//
//  Created by hebe on 15/7/16.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2()
@property (weak, nonatomic) IBOutlet UIImageView *ResultImageView;
- (IBAction)doClickBtn;
@property (weak, nonatomic) IBOutlet UISlider *colorslider;

- (IBAction)valueChanged:(id)sender;

@end

@implementation ViewController2

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.ResultImageView.image = _image;

}

- (IBAction)doClickBtn {
    
    self.ResultImageView.image = [self grayscaleImage:_image];
    
}
- (IBAction)valueChanged:(id)sender {
    
    UISlider* control = (UISlider*)sender;
    if(control == self.colorslider){

    }

}


//add xiaoliang zhushi
-  (UIImage *) grayscaleImage: (UIImage *) image
{
    
//    UIGraphicsBeginImageContext(self.bounds.size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [self.layer renderInContext:ctx];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
//    CGImageRef image=CGImageCreateWithImageInRect([tImage CGImage], self.bounds);
//    UIImage *finalimage=[UIImage imageWithCGImage:image];
//    //    CGImageRelease(image);
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
    
    
    CGSize size = image.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width,
                             image.size.height);
    // Create a mono/gray color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    //int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    
    CGContextRef context = CGBitmapContextCreate(nil, size.width,
                                                 size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    // Draw the image into the grayscale context
    CGContextDrawImage(context, rect, [image CGImage]);
    CGImageRef grayscale = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    // Recover the image
    UIImage *img = [UIImage imageWithCGImage:grayscale];
    CFRelease(grayscale);
    return img;
}




@end
