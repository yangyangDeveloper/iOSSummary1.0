//
//  ZYConcurrentOpreation.m
//  NSOperation
//
//  Created by zhangyangyang on 2022/10/21.
//

#import "ZYConcurrentOpreation.h"

@interface ZYConcurrentOpreation ()
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isExecuting) BOOL finished;
@end

@implementation ZYConcurrentOpreation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)init {
    if (self = [super init]) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (void)start {
    NSLog(@"func %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), [NSThread mainThread], [NSThread currentThread]);
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        NSLog(@"start中 Cancelled成功");
        return;
    }
    
    //没有取消则异步开启任务
    [self willChangeValueForKey:@"isExecuting"];
    
    // 重写了 start和mian 会认为你是需要并发操作
    // 在并发操作中，stat方法负责以异步地方式开启NSOperation。无论是创建新的线程还是使用异步函数，都要在start方法里完成。
    
    [NSThread detachNewThreadSelector:@selector(ok) toTarget:self withObject:nil];
    _executing = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)ok {
    @try {
        NSLog(@"func %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), [NSThread mainThread], [NSThread currentThread]);
        
        sleep(1);
        
        if (self.isCancelled) {
            [self willChangeValueForKey:@"isFinished"];
            _finished = YES;
            [self didChangeValueForKey:@"isFinished"];
            NSLog(@"main中 Cancelled成功");
            return;
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        _executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        _finished  = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        NSLog(@"Finish  %@", NSStringFromSelector(_cmd));
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

@end
