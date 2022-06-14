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
    [layer setNeedsDisplay];
    NSLog(@"layer==%@",layer);
}

# pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    CGContextSaveGState(ctx);
    
    // 图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -100);
    
    UIImage *image1 = [UIImage imageNamed:@"me"];
    //注意这个位置是相对于图层而言的不是屏幕
    
    CGContextDrawImage(ctx, CGRectMake(0,0,100,100), image1.CGImage);
    
    CGContextRestoreGState(ctx);
}

@end
