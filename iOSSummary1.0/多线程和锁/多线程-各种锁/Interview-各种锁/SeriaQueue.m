//
//  SeriaQueue.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/14.
//

#import "SeriaQueue.h"

/*
  除了锁之外 gcd的 sync 同步  串行队列 也可以实现线程按照顺序执行
 */

@interface SeriaQueue ()
@property (strong, nonatomic) dispatch_queue_t testQueue;
@end

@implementation SeriaQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        self.testQueue = dispatch_queue_create(@"myQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

// 如果我忘记解锁了 os_unfair_lock_unlock   就会出现死锁
- (void)__drawMoney {
    dispatch_sync(self.testQueue, ^{
        [super __drawMoney];
    });
}

- (void)__saveMoney {
    dispatch_sync(self.testQueue, ^{
        [super __saveMoney];
    });
}

- (void)__saleTicket {
    dispatch_sync(self.testQueue, ^{
        [super __saleTicket];
    });
}

@end

