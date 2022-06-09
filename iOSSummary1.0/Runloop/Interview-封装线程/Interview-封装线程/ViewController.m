//
//  ViewController.m
//  Interview-封装线程
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

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
