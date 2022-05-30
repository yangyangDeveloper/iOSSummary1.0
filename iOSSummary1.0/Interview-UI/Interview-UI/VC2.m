//
//  VC2.m
//  Interview-UI
//
//  Created by zhangyangyang on 2022/5/30.
//

#import "VC2.h"

// 直接操作单个图层 默认有隐式动画

/*
 
 设置的属性是动画结束之后的值 是一个最终值和真实值
 过程中 当前现实在屏幕上的属性值 是呈现树
 
 呈现树通过图层树中所有图层的呈现图层所形成
 呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值
 
 呈现图层的应用
 一个是同步动画，一个是处理用户交互
 */
@interface VC2 ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"呈现树应用";
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    //self.colorLayer.contents = (__bridge  id)[UIImage imageNamed:@"me"].CGImage;
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
    NSLog(@"layer = %@",self.view.layer);
    NSLog(@"self.view.layer.modelLayer = %@",self.view.layer.modelLayer);
    NSLog(@"presentationLayer = %@",self.view.layer.presentationLayer);
}

//  呈现图层presentationLayer 是对 模型图层的复制
// （首次第一次在屏幕上显示）的时候创建 在这之前调用 为nil
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"------");
    NSLog(@"layer = %@",self.view.layer);
    NSLog(@"self.view.layer.modelLayer = %@",self.view.layer.modelLayer);
    NSLog(@"presentationLayer = %@",self.view.layer.presentationLayer);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //get the touch point  点击坐标
    CGPoint point = [[touches anyObject] locationInView:self.view];
    NSLog(@"%@", NSStringFromCGPoint(point));
    
    //如果点到自身 更新颜色
    // 对呈现图层调用-hitTest:来判断是否被点击
    // 呈现图层代表了用户当前看到的图层位置，而不是当前动画结束之后的位置
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        //randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        // 移动到点击的位置
        //otherwise (slowly) move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

@end
