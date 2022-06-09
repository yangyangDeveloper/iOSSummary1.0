//
//  MutexDemo3.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/13.
//

#import "MutexDemo3.h"
#import <pthread/pthread.h>

/*
    cond 条件
 */

/*
 当多条线程执行顺序不定
 我们有线程1依赖线程2完成再去执行时候 就可以使用条件
 */

@interface MutexDemo3 ()
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) pthread_cond_t cond;
@end
@implementation MutexDemo3


- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); // 设置类型为递归锁
        // 初始化锁
        pthread_mutex_init(&_mutex, &attr);
        
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        
        // 初始化条件
        pthread_cond_init(&_cond, NULL);
        
        self.data = [NSMutableArray array];
        
    }
    return self;
}


// 开启2条线程 执行顺序随机
// 业务要求  先添加再删除  可以使用条件锁 控制顺序  

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

// 线程1
// 数组删除元素
- (void)__remove {
    pthread_mutex_lock(&_mutex);
    NSLog(@"__remove begin");
    if (self.data.count == 0) {
        // 进入等待 主动把锁解开
        // 等待pthread_cond_signal  重新加锁
        // 等待条件（进入休眠 放开mutex锁； 被唤醒后 会再次会mutex加锁）
        pthread_cond_wait(&_cond, &_mutex);
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    pthread_mutex_unlock(&_mutex);
}

// 线程2
// 数组添加元素
- (void)__add {
    
    pthread_mutex_lock(&_mutex);
    sleep(1);
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    // 发送信号 然后等解锁之后完 pthread_cond_wait可以加锁
    pthread_cond_signal(&_cond);
    // DO Some
    pthread_mutex_unlock(&_mutex);
    
//    先解锁然后在发送信号   pthread_cond_wait可以立即重新加锁
//    pthread_mutex_unlock(&_mutex);
//    pthread_cond_signal(&_cond);
    
//    // 发送广播 激活所有等待该条件的线程
//    pthread_cond_broadcast(&_cond);
//    // 激活一个等待该条件的线程
//    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    // 销毁锁
    pthread_mutex_destroy(&_mutex);
    // 销毁条件
    pthread_cond_destroy(&_cond);
}

@end
