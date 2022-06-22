//
//  ZYYObject.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/22.
//

#import "ZYYObject.h"
#import "ZYYThread.h"
#import <objc/runtime.h>

@implementation ZYYObject

static ZYYThread *thread = nil;
static BOOL runAlways = YES;

+ (ZYYThread *)threadForDispatch {
    if (thread == nil) {
        @synchronized (self) {
            if (thread == nil) {
                thread = [[ZYYThread alloc] initWithTarget:self selector:@selector(runRequest) object:nil];
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
