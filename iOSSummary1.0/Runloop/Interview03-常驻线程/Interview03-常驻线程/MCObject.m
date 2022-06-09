//
//  MCObject.m
//  Interview03-常驻线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "MCObject.h"
#import <objc/runtime.h>

@implementation MCObject

static NSThread *thread = nil;
static BOOL runAlways = YES;

+ (NSThread *)threadForDispatch {
    if (thread == nil) {
        @synchronized (self) {
            if (thread == nil) {
                thread = [[NSThread alloc] initWithTarget:self selector:@selector(runRequest) object:nil];
                [thread setName:@"com.zyy.thread"];
                [thread start];
            }
        }
    }
    return thread;
}

+ (void)runRequest {
    
    
    CFRunLoopSourceContext context = {0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
    
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    
    // 创建runloop 同时想runloop的 defaultmodel下面添加source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    // 如果可以运行
    while (runAlways) {
        @autoreleasepool {
            // 令当前runloop运行在defaultmodel下面
            // 1.0e10代表持续到遥远未来  true代表事件被处理完之后 是否立即返回
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
        }
    }
    
    // 某一时机 静态变量 runAlways = no 时  可以保证 跳出runloop, 线程退出
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}

@end
