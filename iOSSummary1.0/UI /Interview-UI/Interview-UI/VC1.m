//
//  VC1.m
//  Interview-UI
//
//  Created by zhangyangyang on 2022/5/30.
//

#import "VC1.h"
#import "TestAniView.h"

/*
  UIView 默认情况下禁止了 layer 动画，但是在 animation 中又重新启用了它们
 
  图层动作action 决定动画的类型
  当前事务的设置  决定动画的时长
 */
@interface VC1 ()
@property (nonatomic, strong) TestAniView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layerView = [[TestAniView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.layerView.backgroundColor = [UIColor yellowColor];
    self.layerView.layer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view addSubview:self.layerView];
 
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:self.colorLayer];
}

// 自定义事务  改变单独图层颜色
- (void)changeColor1
{
    //begin a new transaction  养成好习惯 调整动画之前压入一个新的事务
    [CATransaction begin];

    [CATransaction setAnimationDuration:2];   // 当前事务设置 动画时长
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    [CATransaction commit];
}

// 自定义事务  改变图层颜色 + 完成回调
- (void)changeColor2 {
    
    // 使用自定义的事务 设置为2秒
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:2.0];
    
    // 自定义事务完成之后 使用默认事务 继续做其他事情  这个过程是0.25s
    [CATransaction setCompletionBlock:^{
        //rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //commit the transaction
    [CATransaction commit];
}

// 使用新事务  没有平滑动画
- (void)changeViewLayerColor {
    
    [CATransaction begin];

    [CATransaction setAnimationDuration:2.0];

    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction commit];
}


/*
    CATransaction的   +begin                     和  +commit
    UIView的          +beginAnimations:context:  和  +commitAnimation
    实际上内部调用了CATransaction
 */

// iOS4之前写法
// 调用UIView的 2个方法 其实内部调用了CATransaction 的2个方法
// actionForLayer代理方法 在动画外为nil  动画内返回一个action
- (void)viewlayer1 {
    NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    [UIView beginAnimations:nil context:nil];
    NSLog(@"Inside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    [UIView commitAnimations];
}

// IOS4之后写法
- (void)viewlayer2 {
   
    NSLog(@"outside animation block: %@",
          [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    
    // 返回一个显式对象 而且内部会自己调用CATransaction 的 begin 和 commit
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"inside animation block: %@",
              [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    }];
    // 这段代码会被转化为
    
    /*
    [UIView animateWithDuration:0.3 animations:^{
        self.layerView.layer.backgroundColor = [UIColor redColor];
    }];
    
    会被转化为
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.layerView.layer.backgroundColor = [UIColor redColor];
    [UIView commitAnimations];
     
    本质是
    找到backgroundColor属性对应的 action object 来启动相应的动画 也就是说 CALayer改变属性时会自动应用动画。
     
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];  // 自定义事务设置 动画时长
    self.layerView.layer.backgroundColor = [UIColor redColor];
        当属性改变时 会调用actionForKey 方法  actionForKey方法会调用 代理对应的actionForLayer：forkey方法
        CAbaseAniation * cani = [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);  // 得到action  决定动画类型  寻找设置背景色这一属性对应的动画
    [CATransaction commit];

    */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 平滑动画
    [self changeColor1];
    
    // 平滑动画+动画完成回调
    [self changeColor2];
    
    // 没有平滑动画
    [self changeViewLayerColor];
}

/*
 隐式动画：不需要我们指定动画类型  Core Animation来决定如何并且何时去做动画
 显式动画：需要我们指定动画类型
 */

/*
 动画事长  事务设置
 动画类型  action
 */
@end
