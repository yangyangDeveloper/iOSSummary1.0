//
//  ZYYLabel.m
//  Layer
//
//  Created by zhangyangyang on 2022/1/13.
//

#import "ZYYLabel.h"

@implementation ZYYLabel


/*
 
 - (void)test6 {
     self.label = [[ZYYLabel alloc]initWithFrame:CGRectMake(100, 250, 100, 20)];
     self.label.backgroundColor = [UIColor redColor];
     self.label.font = [UIFont systemFontOfSize:14.0f];
     self.label.layer.contents = (__bridge id)[UIImage imageNamed:@"btnimage"].CGImage;
     self.label.text = @"test";
    [self.view addSubview:self.label];
 }
 
 */
// 优先级1
- (void)displayLayer:(CALayer *)layer {
    // 没有给我ctx 我自己创建
    NSLog(@"%s",__func__);
}

// 优先级2
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"CGContextRef== %@",ctx);
    
    CGBitmapContextCreate(<#void * _Nullable data#>, <#size_t width#>, <#size_t height#>, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef  _Nullable space#>, <#uint32_t bitmapInfo#>)
    //    子线程 {
    //        // 创建bitmap
    //        CGBitmapContextCreate(void * _Nullable data
    //       , <#size_t width#>, <#size_t height#>, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef  _Nullable space#>, <#uint32_t bitmapInfo#>)
    //
    //        CG绘制代码  绘制到上下文中
    //
    //        弄一个image   // 从上下文中弄一个新的位图
    //        CGBitmapContextCreateImage(<#CGContextRef  _Nullable context#>)
    //
    //
    //        切换主线程 {
    //            self.layer.contents = image.CGImage
    //        }
    //    }
    NSLog(@"%s",__func__);
}

// 优先级3
- (void)drawRect:(CGRect)rect {
    NSLog(@"%s",__func__);
    cadis
}

@end
