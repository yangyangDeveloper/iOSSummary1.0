//
//  ViewController.m
//  图层绘制
//
//  Created by zhangyangyang on 2022/6/14.
//

/*
  绘图入口
  1、drawlayer: InContext
     需要调用 display setneesdisplay 执行重绘
  2、drawInContext
  3、drawrect
  4、UIGraphicsBeginImageContextWithOptions
     需要调用 display setneesdisplay 执行重绘
     需要和UIGraphicsEndImageContext()组合使用
  
  2套API
  1、UIkit提供的
  2、Core Graphics API   cg需要旋转坐标
  
  图层绘制 多种组合形式
  
 */
#import "ViewController.h"
#import "ZYYView.h"

@interface ViewController ()

@end

@implementation ViewController

//3701776 byte
//3615kb
//3M多

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    ZYYView *zyy = [[ZYYView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    zyy.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:zyy];
    
    
    //[self imageDump:@"me"];
    
    //[self ima:5];
    
    size_t t = [self getImageBitmapSize:[UIImage imageNamed:@"me"]];
    
    NSUInteger m = [self imageCost:[UIImage imageNamed:@"me"]];

    UIImage *image = [UIImage imageNamed:@"me"];
    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    
}

// 色彩深度分  24位 32位
// 每行占用大小 = 宽 * 色彩深度/8
// 位图实际像素点占内存 = 高 × 每行占用大小 =  宽*高*色彩深度/8
// 由于iOS上色彩深度都是24位/32位, 经过对齐后都是4字节, 所以可以简化为
// 位图实际像素点占内存(字节数Byte) = 宽(像素)*高(像素)*4

// YY计算
- (NSUInteger)imageCost:(UIImage *)image {
    CGImageRef cgimage = image.CGImage;
    if (!cgimage) {
        return 1;
    }
    CGFloat height = CGImageGetHeight(cgimage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgimage);
    NSUInteger cost = bytesPerRow * height;
    if (cost == 0) cost = 1;
    return cost;
}


/// SD 计算出UIImage生成的位图大小
- (size_t)getImageBitmapSize:(UIImage *)image {
 
    CGImageRef imageRef = image.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, 8, 0, space, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
    CGContextDrawImage(ctx, CGRectMake( 0, 0, width, height), imageRef);
    size_t perRow = CGImageGetBytesPerRow(imageRef);
    size_t size = perRow * height;
    CFRelease(ctx);
    NSLog(@"size %@B,  %@K, %@M",@(size), @(size/1024), @(size/1024/1024));
    return size;
}


// 将颜色绘制为图片
- (void)test {
        
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
    // 绘图
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
    // 从图片上下文中获取绘制的图片
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    imagev.image = im;
    [self.view addSubview:imagev];
    
  
    
}

-(void)displayWithImg:(UIImage*)img {
    CGImageRef  imgRef = img.CGImage;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     CGContextRef context = CGBitmapContextCreate(nil, CGImageGetWidth(imgRef), CGImageGetHeight(imgRef), CGImageGetBitsPerComponent(imgRef), CGImageGetBytesPerRow(imgRef), CGImageGetColorSpace(imgRef), CGImageGetBitmapInfo(imgRef));
         CGContextSetInterpolationQuality(context, CGContextSetInterpolationQuality);//设置质量

        CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);//将图片绘制到图形上下文中 并指定rect
        CGImageRef img = CGBitmapContextCreateImage(context);
        CFRelease(context);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.layer.contents = (__bridge id _Nullable)(img);//将cgImgRef赋值给layer的content
        });
    });
    
}

- (void)imageDump:(int)t with:(NSString *)name {
    
}

// CGImage载入的图片，查看bitmap详细信息
- (void)imageDump:(NSString*)file
{
    UIImage* image = [UIImage imageNamed:file];
    CGImageRef cgimage = image.CGImage;
 
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
 
    size_t bpr = CGImageGetBytesPerRow(cgimage);
    size_t bpp = CGImageGetBitsPerPixel(cgimage);
    size_t bpc = CGImageGetBitsPerComponent(cgimage);
    size_t bytes_per_pixel = bpp / bpc;
 
    CGBitmapInfo info = CGImageGetBitmapInfo(cgimage);
 
    NSLog(
        @"\n"
        "===== %@ =====\n"
        "CGImageGetHeight: %d\n"
        "CGImageGetWidth:  %d\n"
        "CGImageGetColorSpace: %@\n"
        "CGImageGetBitsPerPixel:     %d\n"
        "CGImageGetBitsPerComponent: %d\n"
        "CGImageGetBytesPerRow:      %d\n"
        "CGImageGetBitmapInfo: 0x%.8X\n"
        "  kCGBitmapAlphaInfoMask     = %s\n"
        "  kCGBitmapFloatComponents   = %s\n"
        "  kCGBitmapByteOrderMask     = %s\n"
        "  kCGBitmapByteOrderDefault  = %s\n"
        "  kCGBitmapByteOrder16Little = %s\n"
        "  kCGBitmapByteOrder32Little = %s\n"
        "  kCGBitmapByteOrder16Big    = %s\n"
        "  kCGBitmapByteOrder32Big    = %s\n",
        file,
        (int)width,
        (int)height,
        CGImageGetColorSpace(cgimage),
        (int)bpp,
        (int)bpc,
        (int)bpr,
        (unsigned)info,
        (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
        (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
        (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
        (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
        (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
        (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
        (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
        (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
    );
    
    return;
    CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    //[data autorelease];
    const uint8_t* bytes = [data bytes];
 
    printf("Pixel Data:\n");
    static count = 0;
    for(size_t row = 0; row < height; row++)
    {
        for(size_t col = 0; col < width; col++)
        {
            const uint8_t* pixel =
                &bytes[row * bpr + col * bytes_per_pixel];
 
            printf("(");
            for(size_t x = 0; x < bytes_per_pixel; x++)
            {
                printf("%.2X", pixel[x]);
                count +=1;
                if( x < bytes_per_pixel - 1 )
                    printf(",");
            }
 
            printf(")");
            if( col < width - 1 )
                printf(", ");
        }
 
        printf("\n");
    }
    NSLog(@"count==%d",count);
}
@end
