//
//  ViewController.m
//  图层绘制
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//3701776 byte
//
//3615kb
//
//3M多

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self imageDump:@"me"];
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
