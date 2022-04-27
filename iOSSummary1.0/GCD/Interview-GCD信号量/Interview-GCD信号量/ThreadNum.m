//
//  ThreadNum.m
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "ThreadNum.h"

@implementation ThreadNum

// 线程并发量控制
- (void)test {
    
    // 异步下载任务
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"线程==%@",[NSThread currentThread]);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(4);
        
        dispatch_queue_t queue = dispatch_queue_create("loadingSongQueue", DISPATCH_QUEUE_CONCURRENT);
        
        // 100首歌曲下载
        for(int i = 0; i < 100; i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            dispatch_async(queue, ^{
                NSLog(@"task%d begin -- %@", i, [NSThread currentThread]);
                [NSThread sleepForTimeInterval:0.2]; // 模拟耗时操作
                NSLog(@"task%d end", i);
                
                dispatch_semaphore_signal(semaphore);
            });
        }
    });
    
    NSLog(@"主线程继续走");
}

@end
