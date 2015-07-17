//
//  ResizeImageView.h
//  maskDemo
//
//  Created by hebe on 15/7/14.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResizeImageView : UIView

+(instancetype)imageViewWithFrame:(CGRect)frame;

@property (nonatomic, weak) UIImage *inputImage;

-(UIImage *)outputImage;

@end
