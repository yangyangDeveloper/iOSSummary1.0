//
//  ZYYPermenantThread_C.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "ZYYPermenantThread_C.h"

@interface ZYYPermenantThread_C ()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ZYYPermenantThread_C

- (instancetype)init
{
    self = [super init];
    if (self) {
 
        self.thread = [[NSThread alloc] initWithBlock:^{
            
            // 创建上下文
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
            
            CFRelease(source);
            
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
       
//            while (weakSelf && !weakSelf.isStop) {
//                // 第3个参数 returnAfterSourceHandled  设置为true 代表执行完source 就退出当前loop
//                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
            
                  // 对应oc的方法 根本没有第三个参数 可以去设置    而c语言提供了设置
                  // [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            }
            
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
