//
//  ZYYPermenantThread.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "ZYYPermenantThread.h"


@interface ZYThread : NSThread

@end

@implementation ZYThread

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end


@interface ZYYPermenantThread ()
@property (nonatomic, strong) ZYThread *thread;
@property (nonatomic, assign) BOOL isStop;
@end

@implementation ZYYPermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStop = NO;
        __weak typeof(self) weakSelf = self;
        self.thread = [[ZYThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStop) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}

- (void)run {
    if (!self.thread)  return;
    [self.thread start];
}

- (void)executeTaskWithBlock:(void (^)(void))task {
    if (!self.thread || !task)  return;
    [self performSelector:@selector(__executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)executeTask:(id)target action:(SEL)action object:(id)object {
    if (!self.thread || !target || !action)  return;
    [target performSelector:action onThread:self.thread withObject:object waitUntilDone:NO];
}

- (void)stop {
    if (!self.thread)  return;
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

#pragma mark - private methods

- (void)__stop {
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)__executeTask:(void (^)(void))task {
    task();
}

- (void)dealloc {
    [self stop];
    NSLog(@"%s",__func__);
}

@end
