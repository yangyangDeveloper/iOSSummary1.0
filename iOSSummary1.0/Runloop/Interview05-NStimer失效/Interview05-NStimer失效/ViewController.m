//
//  ViewController.m
//  Interview05-NStimer失效
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test2];
   
}

// runloop 当前只能运行一种model模式
// scheduledTimerWithTimeInterval默认 是吧 timer 加入到了 defaultmodel下  所以滚动下model中的 timer里面 没有这个timer 所以不执行
- (void)test1 {
    
    static int i = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%d", ++i);
    }];
}

/*
 struct _CFRunloop {
    pthread_t _pthread;
    CFMutableSetRef _commonModes;     // 能装进来的都是 具备 common通用属性的model 系统的NSDefaultRunLoopMode和UITrackingRunLoopMode在里面
    CFMutableSetRef _commonModeItems: // 添加到commmodes下的  timer observer source 都在这里面
    CFMutableSetRef _modes;           // 装到这里面的是 所有的model 大概有5个
    CFRunloopModeRef _currentMode;    // 当前runloopmodel
 }
*/


- (void)test2 {
    static int i = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%d", i++);
    }];
    
    // 加入默认
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    // 加入滚动
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    // 写2行是不是费事  苹果提供了一个NSRunLoopCommonModes
    // NSRunLoopCommonModes不是真正的model 是一个占位 是一个标记  runloop并不会切换到这个模式下运行
    // 里面存放的是 具有CommonMode属性的model 系统内置了NSDefaultRunLoopMode UITrackingRunLoopMode 都属于CommonMode
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

@end
