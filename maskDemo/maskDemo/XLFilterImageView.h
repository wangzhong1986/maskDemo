//
//  XLFilterImageView.h
//  XLCoreImage
//
//  Created by hebe on 15/6/29.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GLKit;

@interface XLFilterImageView : GLKView

+(instancetype)filterWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIImage *inputImage;

//选了下面，上面就失效
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) NSArray *filters;//按照顺序传进来，inputImage为数组中第一个滤镜的原始图片

@end
