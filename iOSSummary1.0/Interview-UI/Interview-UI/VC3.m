//
//  VC3.m
//  Interview-UI
//
//  Created by zhangyangyang on 2022/5/30.
//

#import "VC3.h"

/*
 Core Animation来决定如何并且何时去做动画
 动画执行的时间取决于当前事务的设置，动画类型取决于图层行为(action)
 
 */
@interface VC3 ()

@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *layerView;
@end

@implementation VC3

// 自定义图层属性行为
// CATransition响应CAAction协议，并且可以当做一个图层行为
// 不论在什么时候改变背景颜色，新的色块都是从左侧滑入，而不是默认的渐变效果
// 直接创建一个显式动画对象
// Core Animation隐式调用    隐式动画对象/或者我们自己创建的显式动画对象   

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"自定义图层属性行为";
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    self.layerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.layerView];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    self.colorLayer.position = CGPointMake(self.layerView.bounds.size.width / 2, self.layerView.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    /*
     1、找代理
     2、找aciton字典
     3、找style字典
     4、-defaultActionForKey:方法
     */
    self.colorLayer.actions = @{@"backgroundColor": transition};
    
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

@end
