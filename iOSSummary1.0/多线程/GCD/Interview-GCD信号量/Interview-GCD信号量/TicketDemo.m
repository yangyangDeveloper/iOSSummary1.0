//
//  TicketDemo.m
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "TicketDemo.h"

@interface TicketDemo ()
@property (nonatomic, assign) int ticketNum;
@property (nonatomic, strong) dispatch_semaphore_t tickSemphore;
@end

@implementation TicketDemo

// 线程加锁 保证线程安全
- (void)saleTicket {
    self.ticketNum = 20;
    self.tickSemphore = dispatch_semaphore_create(1);
    
    // 模拟火车站1 火车站2
    dispatch_queue_t queue1 = dispatch_queue_create("myqueue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueue2", DISPATCH_QUEUE_SERIAL);
    
    //也可以把block1 和 block2 都加入到 并发队列中
   // dispatch_queue_t queue3 = dispatch_queue_create("myqueue3", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"开始卖票");
    dispatch_async(queue1, ^{
        [self _saleTicket];
    });

    dispatch_async(queue2, ^{
        [self _saleTicket];
    });
    NSLog(@"主线程继续走");
}

// 多个异步结果完成之后 根据结果在处理 然后同步到当前线程
- (void)saleTicket2 {
    self.ticketNum = 20;
    self.tickSemphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t queue1 = dispatch_queue_create("myqueue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueue2", DISPATCH_QUEUE_SERIAL);
    NSLog(@"开始卖票");
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        [self _saleTicket];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue2, ^{
        [self _saleTicket];
        dispatch_group_leave(group);
    });
  
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"all thing finished");
    });
    NSLog(@"主线程继续走");
}

- (void)_saleTicket {
    while (1) {
        dispatch_semaphore_wait(_tickSemphore, DISPATCH_TIME_FOREVER);
        if (self.ticketNum > 0) {
            self.ticketNum -= 1;
            NSLog(@"窗口==%@,剩余票数==%d", [NSThread currentThread], _ticketNum);
            
            [NSThread sleepForTimeInterval:0.2]; // 模拟卖票耗时
        } else {
            NSLog(@"票已卖完");
            dispatch_semaphore_signal(_tickSemphore);
            break;
        }
        dispatch_semaphore_signal(_tickSemphore);
    }
}

@end
