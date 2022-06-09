//
//  SemaphoreDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/14.
//

#import "SemaphoreDemo.h"

#define SemaphoreBegin \
static dispatch_semaphore_t semaphore;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
    semaphore = dispatch_semaphore_create(1);\
});\
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);



@interface SemaphoreDemo ()
@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (strong, nonatomic) dispatch_semaphore_t ticketsemaphore;
@property (strong, nonatomic) dispatch_semaphore_t moneysemaphore;
@end

@implementation SemaphoreDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(5);
        self.ticketsemaphore = dispatch_semaphore_create(1);
        self.moneysemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)otherTest {
    for (int i = 0; i < 20 ; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

//  也就是说 dispatch_semaphore_wait 和 dispatch_semaphore_signal 2个组合起来 可以设置线程最大并发数
//  相当于 NSOperationQueue 的  maxConcurrentOperationCount 属性
- (void)test {
    // 如果信号量的值 >0  就让信号量的值减1 然后继续执行下面的代码
    // 如果信号量的值 <=0 就会休眠等待（等待时候为 forever）  一直到信号量的值变成>0 就让信号量的值减少1 然后继续往下执行代码。
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"%@",[NSThread currentThread]);
    
    // 让信号量的值+1
    dispatch_semaphore_signal(self.semaphore);
}

- (void)__drawMoney {
    // DISPATCH_TIME_NOW 就是立即判断 如果不是 继续往下走
    // DISPATCH_TIME_FOREVER 就是如果不是 就一直等待 一直等到有信号量了再往下走
    dispatch_semaphore_wait(self.moneysemaphore, DISPATCH_TIME_FOREVER);
    [super __drawMoney];
    dispatch_semaphore_signal(self.moneysemaphore);
}

- (void)__saveMoney {
    dispatch_semaphore_wait(self.moneysemaphore, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.moneysemaphore);
}

- (void)__saleTicket {
    dispatch_semaphore_wait(self.ticketsemaphore, DISPATCH_TIME_FOREVER);
    [super __saleTicket];
    dispatch_semaphore_signal(self.ticketsemaphore);
}


// 介绍一下小技巧

// 如果每个方法需要独立使用自己的一把锁  可以把 信号量写到这里面
- (void)test1 {
    // static dispatch_semaphore_t semaphore = 0  符合c语法
    // static dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);  不符合c语法
    //注意这里 不能跟 alloc init create 等函数 因为 static 修饰变量 之后更静态初始化的值  方法属于动态的
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    // do some

    dispatch_semaphore_signal(semaphore);
}

// 也可以用宏定义
- (void)test2 {
    SemaphoreBegin
    
    // do  some
    
    SemaphoreEnd
}

// 如果多个方法公用一个 semaphore  可以写成属性
- (void)test3 {
    
    
}

@end
