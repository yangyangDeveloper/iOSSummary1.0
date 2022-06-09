//
//  NSConditionDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/13.
//

#import "NSConditionDemo.h"
/*
  NSCondition是对 mutex + cond的封装 
*/

@interface NSConditionDemo ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSCondition *condition;
@end

@implementation NSConditionDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
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
    [self.condition lock];
    NSLog(@"__remove begin");
    if (self.data.count == 0) {
        // 进入等待 主动把锁解开
        // 等待pthread_cond_signal  重新加锁
        // 等待条件（进入休眠 放开mutex锁； 被唤醒后 会再次会mutex加锁）
        [self.condition wait];
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    [self.condition unlock];
}

// 线程2
// 数组添加元素
- (void)__add {
    [self.condition lock];
    sleep(1);
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    // 发送信号 然后等解锁之后完 pthread_cond_wait可以加锁
    [self.condition signal];
    //[self.condition broadcast];
    // DO Some
    [self.condition unlock];
}

@end
