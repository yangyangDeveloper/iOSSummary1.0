//
//  MutexDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "MutexDemo.h"
#import <pthread/pthread.h>

/*
    互斥锁   PTHREAD_MUTEX_NORMAL 
 */
@interface MutexDemo ()
@property (nonatomic, assign) pthread_mutex_t ticketMutex;
@property (nonatomic, assign) pthread_mutex_t moneyMutex;
@end

@implementation MutexDemo

/*
 pthread_mutex_t  有3种类型
#define PTHREAD_MUTEX_NORMAL        0
#define PTHREAD_MUTEX_ERRORCHECK    1  // 错误
#define PTHREAD_MUTEX_RECURSIVE     2  // 递归锁
#define PTHREAD_MUTEX_DEFAULT        PTHREAD_MUTEX_NORMAL  // 默认锁 也就是互斥锁
*/

- (void)__initMutex:(pthread_mutex_t *)mutex {
    
    // 配置锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initMutex:&_ticketMutex];
        [self __initMutex:&_moneyMutex];
    }
    return self;
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__saleTicket {
    pthread_mutex_lock(&_ticketMutex);
    [super __saleTicket];
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    pthread_mutex_destroy(&_moneyMutex);
    pthread_mutex_destroy(&_ticketMutex);
}

@end
