//
//  ViewController.m
//  maskDemo
//
//  Created by hebe on 15/7/14.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "ViewController.h"
#import "ResizeImageView.h"
#import "ViewController2.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) ResizeImageView *imageView;
- (IBAction)clickOpenn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageView = [ResizeImageView imageViewWithFrame:CGRectMake(60, 100, 300, 300)];
    [self.view addSubview:_imageView];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 450, 100, 50)];
//    [button setTitle:@"打开相册" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor blueColor];
//    [button addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(250, 450, 100, 50)];
//    [button2 setTitle:@"下一步" forState:UIControlStateNormal];
//    button2.backgroundColor = [UIColor yellowColor];
//    [button2 addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button2];
}


//- (void):openAlbum {
//    
//    UIImagePickerController *vc = [UIImagePickerController new];
//    vc.delegate =self;
//    vc.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:vc animated:YES completion:nil];
//}
//
//-(void)next
//{
//    ViewController2 *vc = [ViewController2 new];
//    vc.image = _imageView.outputImage;
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imageView.inputImage = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (IBAction)clickOpenn {
    UIImagePickerController *vc = [UIImagePickerController new];
    vc.delegate =self;
    vc.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 获取编辑个人信息控制器
    id destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[ViewController2 class]]) {
        ViewController2 *vc = destVc;
        vc.image = _imageView.outputImage;
    }
}

@end
