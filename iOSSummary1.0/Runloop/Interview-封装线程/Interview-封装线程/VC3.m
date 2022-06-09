//
//  VC3.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "VC3.h"
#import "ZYYThread.h"



@interface VC3 ()
@property (nonatomic, strong) ZYYThread *thread;
@property (nonatomic, assign) BOOL isStop;

@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    // 这里其实是有循环引用的 但是当线程执行完之后 线程会销毁 然后
    self.isStop = NO;
    [self test3];
}

- (void)test {
    
    NSLog(@"retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)(self)));
    
    // 注意：target会被强引用  只有线程 exits 后才会释放   而线程默认情况下是执行完任务就会exits 然后释放对target的强引用
    // 线程此刻只是 exits退出 并没有销毁
    // 当self被线程释放之后  self被释放 然后线程才会跟着释放
    self.thread = [[ZYYThread alloc] initWithTarget:self selector:@selector(run3) object:nil];
    
    NSLog(@"2222retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)(self)));
    
    [self.thread start];
    

}

- (void)dosome {
    NSLog(@"%s",__func__);
}

// 单纯的run1 任务执行完 线程就会 exits 会释放对target的强引用 所以不会循环引用  系统帮我们做了
// 这个地方 虽然 self->thread->block->self  是构成了循环引用，但是不需要用weak  引用线程在执行完任务就exits状态 会释放对self的强引用 所以闭环自动打破
- (void)test2 {
    self.thread = [[ZYYThread alloc] initWithBlock:^{
        [self run1];
    }];
    [self.thread start];
}

// 而下面代码一直跑runloop 所以线程不会退出 也就不会释放 target 所以vc 也就不会释放
- (void)test3 {
    self.thread = [[ZYYThread alloc] initWithBlock:^{
        [self run2];
    }];
    [self.thread start];
    
    __weak VC3 *weakse = self;
    self.thread.doblock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakse.thread->_name = @"zyy";
            weakse.thread.city = @"北京";
            [weakse dosome];
        });
    };
}


- (void)run1 {
    NSLog(@"%s",__func__);
}

- (void)run2 {
    NSLog(@"%s",__func__);
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    while (self.isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)(self)));
    
    [super viewWillDisappear:animated];
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end


