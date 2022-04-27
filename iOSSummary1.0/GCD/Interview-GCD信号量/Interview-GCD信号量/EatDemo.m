//
//  EatDemo.m
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "EatDemo.h"

@interface EatDemo ()
@property (nonatomic, assign) int surplusCount;
@property (nonatomic, strong) dispatch_semaphore_t eatSemaphore;
@end

@implementation EatDemo

- (void)eatBun {
    self.surplusCount = 20;
    self.eatSemaphore = dispatch_semaphore_create(1);
    // 创建并发队列 三个人吃包子同时执行，互不影响
    dispatch_queue_t queue = dispatch_queue_create("com.jarypan.gcdsummary.eatqueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 3 个人开始吃包子
    dispatch_async(queue, ^{
        NSLog(@"线程1==%@",[NSThread currentThread]);
        [self peopleEat:1];
    });
    dispatch_async(queue, ^{
        NSLog(@"线程2==%@",[NSThread currentThread]);
        [self peopleEat:2];
    });
    dispatch_async(queue, ^{
        NSLog(@"线程3==%@",[NSThread currentThread]);
        [self peopleEat:3];
    });
}

// 三个人吃包子耗时不一样
- (void)peopleEat:(int)people {
    while (YES) {
        if (self.surplusCount > 0) {
            // 拿包子
            [self getTheSteamedStuffedBun];
            NSLog(@"people %d start eating, surplusCount is %ld", people, (long)self.surplusCount);
            [NSThread sleepForTimeInterval:people/10.0]; // 吃包子的时间因人而异 模拟吃包子（耗时操作）
        } else {
            NSLog(@"所有包子已吃完");
            dispatch_semaphore_signal(self.eatSemaphore);
            break;
        }
    }
}

// 拿包子
- (void)getTheSteamedStuffedBun {
    dispatch_semaphore_wait(self.eatSemaphore, DISPATCH_TIME_FOREVER);
    self.surplusCount--;
    dispatch_semaphore_signal(self.eatSemaphore);
}

@end
