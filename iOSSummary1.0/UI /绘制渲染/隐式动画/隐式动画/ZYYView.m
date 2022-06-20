//
//  ZYYView.m
//  Interview-UIView动画原理
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ZYYView.h"

@implementation ZYYView

// 隐样动画
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    NSLog(@"-----%@",event);
    NSLog(@"%@",layer);
   // NSLog(@"%@",layer.sublayers);
    NSLog(@"方法返回%@",[super actionForLayer:layer forKey:event]);
    return [super actionForLayer:layer forKey:event];
}

/*
绘制流程

case1
- (void)displayLayer:(CALayer *)layer {

}

case2
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
}

case3
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //1.获取上下文  获取的其实是view对应的layer的上下文 渲染是把图形渲染到layer上

    // UIGraphicsGetCurrentContext(); 获取的就是CGContextRef对象
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //2.绘制图形
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));

    //设置属性（颜色）
    [[UIColor yellowColor] set];
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);

    //3.渲染
    CGContextFillPath(ctx);
}

*/

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
}
@end
