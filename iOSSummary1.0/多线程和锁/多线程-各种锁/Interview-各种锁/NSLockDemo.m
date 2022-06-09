//
//  NSLockDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/13.
//

#import "NSLockDemo.h"

/*
 互斥锁 NSLock 是对 mutex（PTHREAD_MUTEX_DEFAULT） 的封装
 */
@interface NSLockDemo ()
@property (strong, nonatomic) NSLock *momeyLock;
@property (strong, nonatomic) NSLock *ticketLock;
@end

@implementation NSLockDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.momeyLock = [[NSLock alloc] init];
        self.ticketLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)__drawMoney {
    [self.momeyLock lock];
    [super __drawMoney];
    [self.momeyLock unlock];
}

- (void)__saveMoney {
    [self.momeyLock lock];
    [super __saveMoney];
    [self.momeyLock unlock];
    
}

- (void)__saleTicket {
    [self.ticketLock lock];
    [super __saleTicket];
    [self.ticketLock unlock];
}

@end
