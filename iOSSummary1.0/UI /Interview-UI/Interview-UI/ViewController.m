//
//  ViewController.m
//  Interview-UI
//
//  Created by zhangyangyang on 2022/5/27.
//

#import "ViewController.h"
#import "ZYYView.h"
#import "VC2.h"
#import "VC3.h"
#import "VC1.h"

@interface ViewController ()
@property (nonatomic, strong)ZYYView *zyy;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
   // [self testRadius];
   // [self test];
   // [self testdelayLayer];
    // [self testCustomLayer];
    // [self testRunloopLayer];
    // [self testdelayLayer];
    //[self testAni];
   //[self ani1];
}

// 测试圆角
- (void)testRadius {
    CALayer *layer=[CALayer layer];
    layer.backgroundColor=[UIColor brownColor].CGColor;
    layer.bounds=CGRectMake(100, 100, 200, 200);
    layer.position=CGPointMake(100, 100);
    layer.contents=(id)[UIImage imageNamed:@"me"].CGImage;
    layer.cornerRadius = 100;
    //layer.transform=CATransform3DMakeRotation(M_PI_4, 1, 1, 0.5);
    layer.masksToBounds=YES;
    [self.view.layer addSublayer:layer];
}

// 测试UIview的隐式动画
- (void)ani1 {
    self.zyy = [[ZYYView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    //self.zyy.backgroundColor = [UIColor greenColor];
    self.zyy.center = self.view.center;
    [self.view addSubview:self.zyy];
    self.zyy.layer.cornerRadius = 100;
    self.zyy.layer.masksToBounds = YES;
    self.zyy.layer.backgroundColor = [UIColor yellowColor].CGColor;
    //self.zyy.layer.contents=(id)[UIImage imageNamed:@"me"].CGImage;
    self.zyy.layer.borderColor = [UIColor orangeColor].CGColor;
    self.zyy.layer.borderWidth = 5;
    NSLog(@"&&&& %@",self.zyy.layer.sublayers);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self ani1];
    //[self.view addSubview:self.zyy];
    //self.zyy.backgroundColor = [UIColor yellowColor];
    VC4 *vc4 = [[VC4 alloc] init];
    [self.navigationController pushViewController:vc4 animated:true];
//
//    [self.view.layer.modelLayer ]
//    self.zyy.layer.backgroundColor = [UIColor yellowColor].CGColor;
}

- (void)testAni {
    
//    CALayer *layer=[CALayer layer];
//    layer.backgroundColor=[UIColor brownColor].CGColor;
//    layer.bounds=CGRectMake(100, 100, 200, 200);
//    layer.position=CGPointMake(100, 100);
//    layer.contents=(id)[UIImage imageNamed:@"me"].CGImage;
//    layer.cornerRadius = 100;
//    //layer.transform=CATransform3DMakeRotation(M_PI_4, 1, 1, 0.5);
//    layer.masksToBounds=YES;
//    [self.view.layer addSublayer:layer];
//
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transformPath"];
    CATransform3D scaleTransform = CATransform3DMakeScale(1.5, 1.5, 1);
    animation.toValue = [NSValue valueWithCATransform3D:scaleTransform];
    
    animation.duration = 1;
    animation.repeatCount = HUGE_VALF;
    
    animation.repeatCount = YES;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    //CATransaction
    
    
   // self.view.layer.actions
   
   
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    //imageview.image = [UIImage imageNamed:@"me"];
    imageview.backgroundColor = [UIColor yellowColor];
    imageview.layer.cornerRadius = 100;
    imageview.layer.masksToBounds = YES;
    [self.view addSubview:imageview];
    [imageview.layer addAnimation:animation forKey:@"animationScaleKey"];
 
    
    
    
}




/*
 
 方法一
 View 的 drawRect
 */
- (void)test {
    self.zyy = [[ZYYView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.zyy.center = self.view.center;
    [self.view addSubview:self.zyy];
}

/*
 方法二
 设置layer的delegate 主动调用setNeedsDisplay
 - (void)display  调用代理的 - (void)displayLayer:(CALayer *)layer
 - (void)drawInContext:(CGContextRef)ctx 调用代理的 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx  如果layer的代理是view它在调用 drawrect
 */
- (void)testCustomLayer {
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor brownColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 200, 150);
    layer.position = CGPointMake(100, 100);
    
    layer.delegate = self;
    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
}






//- (void)displayLayer:(CALayer *)layer {
//
//}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    [[UIColor yellowColor]set];
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    CGContextFillPath(ctx);
}


/*
 当在操作UI时，比如改变了frame、更新了UIView/CALayer的层次时，或者手动调用了UIView/CALayer的setNeedsLayout/setNeedsDisplay方法后，这个UIView/CALayer就被标记为待处理，并被提交到一个全局的容器去。
 苹果注册了一个Observer监听BeforeWaiting(即将进入休眠)和Exit(即将退出Loop)事件，回调去执行一个很长的函数：
 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv。
 这个函数里会遍历所有待处理的UIView/CAlayer以执行实际的绘制和调整，并更新UI界面。
 */

- (void)testdelayLayer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.zyy.backgroundColor = [UIColor blueColor];
    });
}


/*
  手动添加符号断点 __IOHIDEventSystemClientQueueCallback
  点击按钮会触发主线程的 RunLoop 的 source1 执行 __IOHIDEventSystemClientQueueCallback ，唤醒下一轮 RunLoop
  我们发现唤醒下一轮RunLoop 之后由 source0 执行 CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION 回调  进而触发 QuartzCore`CA::Transaction::commit() 方法
  Source1在处理任务的时候，有时会跟Source0一起配合，把一些任务分发给Source0去执行。例如刚刚提到的点击事件，先由Source1处理硬件事件，之后Source1将事件包装分发给Source0继续进行处理。
 */


/*
   source0 模块
   * thread #5, name = 'com.apple.uikit.eventfetch-thread', stop reason = breakpoint 2.1
   * frame #0: 0x00007fff212fd048 IOKit`__IOHIDEventSystemClientQueueCallback
     frame #1: 0x00007fff2033fb42 CoreFoundation`__CFMachPortPerform + 157
     frame #2: 0x00007fff20374125 CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__ + 41
     frame #3: 0x00007fff203734cc CoreFoundation`__CFRunLoopDoSource1 + 617
     frame #4: 0x00007fff2036d901 CoreFoundation`__CFRunLoopRun + 2420
     frame #5: 0x00007fff2036ca90 CoreFoundation`CFRunLoopRunSpecific + 562
     frame #6: 0x00007fff20827e31 Foundation`-[NSRunLoop(NSRunLoop) runMode:beforeDate:] + 213
     frame #7: 0x00007fff208280aa Foundation`-[NSRunLoop(NSRunLoop) runUntilDate:] + 72
     frame #8: 0x00007fff25151d1e UIKitCore`-[UIEventFetcher threadMain] + 491
     frame #9: 0x00007fff20850f89 Foundation`__NSThread__start__ + 1009
     frame #10: 0x00007fff6fb094e1 libsystem_pthread.dylib`_pthread_start + 125
     frame #11: 0x00007fff6fb04f6b libsystem_pthread.dylib`thread_start + 15
*/

- (void)testRunloopLayer {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    [btn setTitle:@"666" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dosome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   
}

- (void)dosome {
    self.view.backgroundColor = [UIColor grayColor];
    
}

@end
