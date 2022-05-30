//
//  ZYYView.m
//  Interview-UI
//
//  Created by zhangyangyang on 2022/5/27.
//

#import "ZYYView.h"

@implementation ZYYView

/*
  1、生成bitmap
    可以是ctx + cgapi  也可以是layer.content =
  2、drawRect调用时机
  3、注意异步绘制 高效绘制
 
 */


/*
 (void)displayLayer:(CALayer *)layer
 (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
 (void)drawRect:(CGRect)rect
 */

// 本质上它的内部相当于执行了 [self.layer drawInContext:ctx];
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    //1.获取上下文  获取的其实是view对应的layer的上下文 渲染是把图形渲染到layer上
//    
//    // UIGraphicsGetCurrentContext(); 获取的就是CGContextRef对象
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //2.绘制图形
//    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
//    
//    //设置属性（颜色）
//    [[UIColor yellowColor] set];
//    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
//    
//    //3.渲染
//    CGContextFillPath(ctx);
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

//- (void)displayLayer:(CALayer *)layer {
//    
//}

/*
 
 
 */
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    NSLog(@"-----%@",event);
    NSLog(@"%@",layer);
   // NSLog(@"%@",layer.sublayers);
    NSLog(@"方法返回%@",[super actionForLayer:layer forKey:event]);
    return [super actionForLayer:layer forKey:event];
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
}
@end
