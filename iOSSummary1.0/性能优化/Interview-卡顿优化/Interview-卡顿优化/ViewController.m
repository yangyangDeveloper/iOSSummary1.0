//
//  ViewController.m
//  Interview-卡顿优化
//
//  Created by zhangyangyang on 2022/2/4.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self image];
}


// 耗时操作放子线程

- (void)text {
    // 文本计算
    [@"text" boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    
    //  文本绘制
    [@"text" drawWithRect:CGRectMake(0, 0, 100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
}

// 异步图片解码
- (void)image {
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.frame = CGRectMake(100, 100, 143/2, 210/2);
    [self.view addSubview:imageview];
    self.imageView = imageview;
//    self.imageView.image = [UIImage imageNamed:@"yang"];
//    return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获取 CGImage
        CGImageRef cgimage = [UIImage imageNamed:@"yang"].CGImage;
        
        BOOL hasAlpha = NO;
        
        // alphaInfo
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgimage) & kCGBitmapAlphaInfoMask;
        
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
                hasAlpha = YES;
            }
        
        // btimapinfo
        CGBitmapInfo bitMapinfo = kCGBitmapByteOrder32Host;
        bitMapinfo != hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        
        //size
        size_t width = CGImageGetWidth(cgimage);
        size_t height = CGImageGetWidth(cgimage);
        
        // context
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitMapinfo);
        
        // draw
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
        
        // get CGImage
        cgimage = CGBitmapContextCreateImage(context);
        
        // into UIImage
        UIImage *newImage = [UIImage imageWithCGImage:cgimage];
        
        // release
        CGContextRelease(context);
        CGImageRelease(cgimage);
        
        // back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
        });
    
    });
}
@end
