//
//  VC1.m
//  多线程-读写安全
//
//  Created by zhangyangyang on 2022/2/14.
//

#import "VC1.h"
#import <pthread/pthread.h>

/*
    pthread_rwlock_t
 */

@interface VC1 ()
@property(assign, nonatomic) pthread_rwlock_t lock;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    pthread_rwlock_init(&_lock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i<10; i++) {
        dispatch_async(queue, ^{
            [self read];
        });
        
        dispatch_async(queue, ^{
            [self write];
        });
    }
}

- (void)read {
    pthread_rwlock_rdlock(&_lock);
    NSLog(@"read");
    pthread_rwlock_unlock(&_lock);
}

- (void)write {
    pthread_rwlock_wrlock(&_lock);
    NSLog(@"write");
    sleep(1);
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc {
    pthread_rwlock_destroy(&_lock);
}

@end
