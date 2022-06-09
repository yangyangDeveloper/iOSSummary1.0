//
//  VC2.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "VC2.h"
#import "ZYYThread.h"
@interface VC2 ()
@property (nonatomic, strong) ZYYThread *thread;
@property (nonatomic, assign) BOOL isStoped;
@end

@implementation VC2

// vc -> thread -> block ->vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isStoped = NO;
    __weak VC2 *weakself = self;
    ZYYThread *thread = [[ZYYThread alloc] initWithBlock:^{
        //[self run5];
        
//        NSLog(@"%s %@", __func__, [NSThread currentThread]);
//        // 添加 source、 timer objserver
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        
        // 如果self被释放了  那么就是nil了 那么会进入继续来一次循环
        // 下面的CFRunLoopStop(CFRunLoopGetCurrent())代码会停止当前的 runmode
        //  然后代码回到while条件 判断是否再次进入  这时候虽然我们设置了yes 不让他进入 但是weaself 自己都是nil了 所以还是会进去循环，那么其实我们runloop并没有真正的停止 还在跑圈 所以不会释放 所以我们需要判断下 weakself是不是nil
        while (!weakself.isStoped && weakself) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"end");
        
        
    }];
    // 有循环引用
    // ZYYThread *thread = [[ZYYThread alloc] initWithTarget:self selector:@selector(run5) object:nil];
    [thread start];
    self.thread = thread;
}

- (void)run3 {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 添加 source、 timer objserver
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    
    // 用来开启一个无限的循环
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"end ---");

    /* [[NSRunLoop currentRunLoop] run]相当于  内部会无线的调用
     
    while (1) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:【】];
    }
     
     这种停止是没办法停止 run3 中的  [[NSRunLoop currentRunLoop] run];
     [[NSRunLoop currentRunLoop] run]; 是开启一个无限的循环
     [[NSRunLoop currentRunLoop] run]; 内部会无限的调用  [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:<#(nonnull NSDate *)#>];
     CFRunLoopStop 只是停止了当前的一次 但是run 有继续吊了一次
    */
}

- (void)run4 {
    
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 添加 source、 timer objserver
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    // 这种执行一次就结束了
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}

- (void)run5 {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 添加 source、 timer objserver
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];

    while (!self.isStoped) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSLog(@"end");
}


// 模拟需要重复干的事情
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!self.thread) return;
    
    // yes 就是 等 @selector执行完 再走下面的
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:YES];
    NSLog(@"111");  /// 111 是主线程执行的   但是前面的 yes 要求等他执行完 在往下走
}

// 真正干活 常驻子线程需要执行的任务
- (void)test {
    NSLog(@"%s %@",__func__, [NSThread currentThread]);
}


// 点击停止 runloop
- (IBAction)stop {
  
    if (!self.thread) return;
        
    NSLog(@"调用关闭");
    // 这里最好用 yes  因为实在delloc里面调用的  如果是 no 就代表 释放和performSelector 同时执行  那么可能会崩溃
    // 设置为no 就是 等 performSelector 执行完  在接着回去走 delloc里面的释放
    [self performSelector:@selector(stopRunloop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopRunloop {
    
    // 设置要结束runloop
    self.isStoped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc {
    [self stop];
    NSLog(@"%s",__func__);
}

@end
