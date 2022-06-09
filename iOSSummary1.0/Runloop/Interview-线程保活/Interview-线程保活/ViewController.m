//
//  ViewController.m
//  Interview-线程保活
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "ViewController.h"
#import "ZYYThread.h"

@interface ViewController ()
@property (nonatomic, strong) ZYYThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZYYThread *thread = [[ZYYThread alloc] initWithTarget:self selector:@selector(run3) object:nil];
    [thread start];
    self.thread = thread;
}

// 线程执行完run 函数里面的任务就死了
// 来while 死循环 确实线程不会死，但是线程也不会执行新的任务的。  这种阻塞不是我们要的
- (void)run {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // while (1);
}

// 我们借助runloop 来让线程保活
// 结果还是不行
// run 底层调用的是   - (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;    没有 source timer observer  所以model会退出
- (void)run2 {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"end ---");
}

// 发现 end 被阻塞了 成功了   线程没有销毁  线程休眠了
- (void)run3 {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 添加 source、 timer objserver
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"end ---");
}

// 模拟需要重复干的事情
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // yes 就是 等 @selector执行完 再走下面的
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:YES];
    NSLog(@"111");  /// 111 是主线程执行的   但是前面的 yes 要求等他执行完 在往下走
}

// 真正干活 常驻子线程需要执行的任务
- (void)test {
    NSLog(@"%s %@",__func__, [NSThread currentThread]);
}

@end
