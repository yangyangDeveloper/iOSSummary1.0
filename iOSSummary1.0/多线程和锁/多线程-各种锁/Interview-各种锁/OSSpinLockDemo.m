//
//  OSSpinLockDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

/*
   自旋锁 OSSpinLock
   从iOS 10 开始被替换
*/

@interface OSSpinLockDemo ()
@property (assign, nonatomic) OSSpinLock momeyLock;
@property (assign, nonatomic) OSSpinLock ticketLock;
@end

@implementation OSSpinLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.momeyLock = OS_SPINLOCK_INIT;
        self.ticketLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney {
    OSSpinLockLock(&_momeyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_momeyLock);
    
}

- (void)__saveMoney {
    OSSpinLockLock(&_momeyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_momeyLock);
    
}

- (void)__saleTicket {
    OSSpinLockLock(&_ticketLock);
    [super __saleTicket];
    OSSpinLockUnlock(&_ticketLock);
}

@end
