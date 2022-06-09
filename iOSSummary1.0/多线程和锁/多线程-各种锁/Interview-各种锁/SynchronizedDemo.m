//
//  SynchronizedDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/14.
//

#import "SynchronizedDemo.h"

/*
 @synchronized 也可以实现线程同步   会根据传入的 @synchronized（参数） 去寻找他对应的mutex递归锁
 */
@implementation SynchronizedDemo
/*
  如果外面就一个对象 这里面用self  和 【self class】 都行
  如果外面有多个实例对象  这里用 类对象 【self class】
  本质要保证 一个对象关联的是同一把锁   所以要保证 save和draw方法 是同一个对象  也就能保证是同一把锁
 */
- (void)__saveMoney {
    @synchronized (self) {   // objc_sync_enter
        [super __saveMoney];
    } // objc_sync_exit
}

- (void)__drawMoney {
    @synchronized (self) {
        [super __drawMoney];
    }
}

// 自己怼一个唯一的对象  本质是获取底层维护的一个 递归锁表 每一个对象都有一个锁
- (void)__saleTicket {
    
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    @synchronized (lock) {
        [super __saleTicket];
    }
}

// 底层是怼mutex 递归锁的封装  所以他本身也是递归锁 支持递归调用
- (void)otherTest {
    
    @synchronized ([self class]) {
        NSLog(@"3");
        [self otherTest];
    }
}
@end
