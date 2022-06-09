//
//  MutexDemo2.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "MutexDemo2.h"
#import <pthread/pthread.h>

/*
    递归锁  PTHREAD_MUTEX_RECURSIVE
*/
@interface MutexDemo2 ()
@property (nonatomic, assign) pthread_mutex_t mutex;
@end
@implementation MutexDemo2


- (void)__initMutex:(pthread_mutex_t *)mutex {
    
    // 递归锁： 允许对同一个线程重复加锁
    // 配置锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
   // pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT); // 把这里改成递归锁 解决下面的死锁
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __initMutex:&_mutex];
    }
    return self;
}

- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s",__func__);
    
    static int count = 0;
    if (count < 10) {
        count++;
        [self otherTest];   // 递归调用 需要使用递归锁  否则死锁
    }
   
    pthread_mutex_unlock(&_mutex);
}

/*
 
 如果是PTHREAD_MUTEX_DEFAULT类型  调用自己 和 调用其他方法  共用一个锁都会死锁  需要用递归锁
- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s",__func__);
    [self otherTest2];  // 这里会出现死锁  PTHREAD_MUTEX_DEFAULT类型
    [self otherTest];   // 这里也会出现死锁 PTHREAD_MUTEX_DEFAULT类型
    pthread_mutex_unlock(&_mutex);
}
 
 - (void)otherTest2 {
     pthread_mutex_lock(&_mutex);
     NSLog(@"%s",__func__);
     pthread_mutex_unlock(&_mutex);
 }
 
*/

- (void)dealloc {
    NSLog(@"%s",__func__);
    pthread_mutex_destroy(&_mutex);
}

@end
