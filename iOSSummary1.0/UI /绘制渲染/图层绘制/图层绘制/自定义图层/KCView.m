//
//  KCView.m
//  图层绘制
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "KCView.h"
#import "KCLayer.h"

@implementation KCView

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"initWithFrame:");
    if (self = [super initWithFrame:frame]) {
        KCLayer *layer = [[KCLayer alloc]init];
        layer.bounds = CGRectMake(0, 0, 185, 185);
        layer.position = CGPointMake(160,284);
        layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
        
        //显示图层
        [layer setNeedsDisplay];
        
        [self.layer addSublayer:layer];
    }
    return self;
}



//    NSLog(@"2-drawRect:");
//    NSLog(@"CGContext:%@",UIGraphicsGetCurrentContext()); //得到的当前图形上下文正是drawLayer中传递的
//    [super drawRect:rect];
//}

// 调用之前创建空寄宿图 和cg上下文 #1    0x00007fff288e8794 in CABackingStoreUpdate_ ()

// view自带的layer会实现displayLayer 所以后面的方法都不会走了
// 如果drawRect方法实现了 那么就会调用displayLayer  然后是 创建上下文调用 -drawLayer:inContext:
//- (void)displayLayer:(CALayer *)layer {
//    
//}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"1-drawLayer:inContext:");
    NSLog(@"CGContext:%@",ctx);
    [super drawLayer:layer inContext:ctx];
}

@end
