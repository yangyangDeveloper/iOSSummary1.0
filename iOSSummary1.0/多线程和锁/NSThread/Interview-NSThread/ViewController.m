//
//  ViewController.m
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "ViewController.h"
#import "VC1.h"
#import "VC2.h"

/*
   NSthread 使用
    1、通过 alloc 来创建，需要手动开启
    2、通过 detachNewThread 隐式创建并且直接开启
    3、通过 performSelector系列函数  隐式创建来开启
 */

/*

 performSelector系列
 
 // 任意线程执行
 @interface NSObject (NSThreadPerformAdditions) {
    
     // 在主线程上执行操作
     - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
     - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray<NSString *> *)array;
    
     // 后台线程
     - (void)performSelectorInBackground:(SEL)aSelector withObject:(nullable id)arg

     // 在自定义线程上执行操作
     - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array
     - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait
}

 // 在当前线程上执行操作， 相当于 [a fun]   msgsend(a,@selector(fun))
 @interface NSObject {
    - (id)performSelector:(SEL)aSelector;
     - (id)performSelector:(SEL)aSelector withObject:(id)object;
     - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
 }
 
 // 带延迟的
 @interface NSObject (NSDelayedPerforming)

 - (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray<NSRunLoopMode> *)modes;
 - (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
 + (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument;
 + (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;

 @end

 */

/*
 
 
 NSThread 支持 KVO,可以监听到 thread 的执行状态

 isExecuting是否正在执行

 isCancelled是否被取消

 isFinished是否完成

 isMainThread是否是主线程

 threadPriority优先级
 
 */
@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    VC2 *vc1 = [[VC2 alloc] init];
    [self.navigationController pushViewController:vc1 animated:true];
}

@end
