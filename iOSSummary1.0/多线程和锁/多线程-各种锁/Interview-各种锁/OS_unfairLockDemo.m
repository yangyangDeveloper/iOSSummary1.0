//
//  OS_unfairLockDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "OS_unfairLockDemo.h"
#import "ZYYBaseDemo.h"
#import <os/lock.h>

/*
   从iOS 10 开始  替代OSSpinLock  属于低级锁 互斥锁 会真正的休眠
 */

@interface OS_unfairLockDemo ()
@property (assign, nonatomic) os_unfair_lock momeyLock;
@property (assign, nonatomic) os_unfair_lock ticketLock;
@end

@implementation OS_unfairLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.momeyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

// 如果我忘记解锁了 os_unfair_lock_unlock   就会出现死锁
- (void)__drawMoney {
    os_unfair_lock_lock(&_momeyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_momeyLock);
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_momeyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_momeyLock);
    
}

- (void)__saleTicket {
    os_unfair_lock_lock(&_ticketLock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_ticketLock);
}


@end
