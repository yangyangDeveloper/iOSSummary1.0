//
//  VC1.m
//  图层绘制
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "VC1.h"

@interface VC1 ()<CALayerDelegate>

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义图层
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(160, 200);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = 50;
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2;
    layer.delegate = self;
    [self.view.layer addSublayer:layer];
    
//    UIImage *headerImage = [UIImage imageNamed:@"me"];
//    layer.contents = (__bridge id)headerImage.CGImage;
    
    //[layer setNeedsDisplay];
    NSLog(@"layer==%@",layer);
}

 
# pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的

/*
 //方法1：可以直接设置contents属性；
  - (void)displayLayer:(CALayer *)layer;
  
 //方法2：在不实现方法1时，CALayer就会转而尝试调用此方法；
 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
 */

/*
 方法1
- (void)displayLayer:(CALayer *)layer {
    NSLog(@"1");
    NSLog(@"%@",layer);
}
*/

// 方法2
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"2");
    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    NSLog(@"ctx=%@",ctx);
    
    CGContextSaveGState(ctx);
    
    // 图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -100);
    
    UIImage *image1 = [UIImage imageNamed:@"me"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0,0,100,100), image1.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(ctx);
    
    CGContextRestoreGState(ctx);
    
    
    /*
   
    Bitmap.Config.ARGB_8888
    bitmap在屏幕上显示的每一像素在内存中存储的格式
     
    自定义ctx
    UIImage *headerImage = [UIImage imageNamed:@"me"];
    CGImageRef imageRef = headerImage.CGImage;
    
    // 单位是像素
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
   
    
    // 每个像素占用4个字节  32位图像为例：一个像素有4byte(rgba)
    NSUInteger bytesPerPixel = 4;
    
    // 位图的每一行包含 bytesPerRow 字节
    NSUInteger bytesPerRow = bytesPerPixel * width;
    
    // 每个颜色占用的位bit  32位图像为例
    NSUInteger bitsPerComponent = 8;
    
    // 颜色空间，是RGBA、CMYK还是灰度值
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
     width,
     height,
     bitsPerComponent,
     bytesPerRow,
     colorspaceRef,
     kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast);
     
     */
}

/*
 
  属性                                       结果
 .premultipliedFirst + .byteOrder32Big       A R G B
 .premultipliedLast + .byteOrder32Big        R G B A
 .premultipliedFirst + .byteOrder32Little    R G B A
 .premultipliedLast + .byteOrder32Little     A R G B
 
 */
@end
