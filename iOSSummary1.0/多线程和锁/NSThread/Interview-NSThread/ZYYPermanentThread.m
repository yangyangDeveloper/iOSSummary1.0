//
//  ZYYPermanentThread.m
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "ZYYPermanentThread.h"
#import "ZYYThread.h"

@interface ZYYPermanentThread ()
@property (nonatomic, strong) ZYYThread *thread;
@property (nonatomic, assign) BOOL isStop;
@end

@implementation ZYYPermanentThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStop = NO;
        
        __weak typeof(self) weakSelf = self;
        self.thread = [[ZYYThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            
            while (weakSelf && !weakSelf.isStop) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}

- (void)run {
    if (!self.thread) { return; }
    [self.thread start];
}

- (void)executeTaskWithBlock:(void (^)(void))task {
    if (!self.thread || !task)  return;
    [self performSelector:@selector(_executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)executeTask:(id)target action:(SEL)action object:(id)object {
    if (!self.thread || !target || !action)  return;
    NSLog(@"%@",self.thread);
    [target performSelector:action onThread:self.thread withObject:object waitUntilDone:NO];
}

- (void)stop {
    if (!self.thread) { return; }
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

#pragma mark - private methods
- (void)_executeTask:(void(^)(void))task {
    NSLog(@"8888");
    task();
}

- (void)__stop {
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc {
    [self stop]; // 等stop方法执行完 在继续往下走
    NSLog(@"%s", __func__);
}
@end
