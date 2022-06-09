//
//  NSRecursiveLockDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/13.
//

#import "NSRecursiveLockDemo.h"

/*
   递归锁 NSRecursiveLock 是对 mutex（PTHREAD_MUTEX_RECURSIVE） 的封装
 */

@interface NSRecursiveLockDemo ()
@property (nonatomic, strong) NSRecursiveLock *lock;
@end
@implementation NSRecursiveLockDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)otherTest {
    [self.lock lock];
    NSLog(@"%s",__func__);
    
    static int count = 0;
    if (count < 10) {
        count++;
        [self otherTest];   // 递归调用 需要使用递归锁  否则死锁
    }
    [self.lock unlock];
}

@end

