//
//  NSConditionLockDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/13.
//

#import "NSConditionLockDemo.h"

/*
 NSConditionLock 是对 NSCondition的进一步封装
 可以设置线程的依赖
 
 2个API很牛逼 可以通过cond值来实现线程依赖
 - (void)lockWhenCondition:(NSInteger)condition;
 - (BOOL)tryLockWhenCondition:(NSInteger)condition;
 
 */

@interface NSConditionLockDemo ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSConditionLock *conditionLock;

@end

@implementation NSConditionLockDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1]; // 初始化条件值为1
        
        //self.conditionLock = [[NSConditionLock alloc] init]; // init方法 默认 condition为0
        self.data = [NSMutableArray array];
    }
    return self;
}

// 开启3条线程 执行顺序随机  使用NSConditionLock 实现线程依赖
- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__one) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__two) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__three) object:nil] start];
}

// 线程1
- (void)__one {
    //[self.conditionLock lock];// lock是暴力加锁 不看condition值  只要能拿到锁 他就加锁
    [self.conditionLock lockWhenCondition:1];    // cond值为1时候条件成立  而初始化cond刚好为1 拿到锁 进行加锁
    NSLog(@"__one");
    sleep(1);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"主线程");
    });
    [self.conditionLock unlockWithCondition:2]; // 解锁之后设置cond值为2
}

// 线程2
- (void)__two {
    [self.conditionLock lockWhenCondition:2];  // cond值为2时候条件成立 他才能拿到锁进行加锁
    sleep(1);
    NSLog(@"__two");
    [self.conditionLock unlockWithCondition:3]; // 解锁之后设置cond值为3
}

// 线程3
- (void)__three {
    [self.conditionLock lockWhenCondition:3];  // cond值为3时候条件成立 他才能拿到锁进行加锁
    sleep(1);
    NSLog(@"__three");
    [self.conditionLock unlock];
}

@end

