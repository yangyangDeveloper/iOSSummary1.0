//
//  ViewController.m
//  NSOperation
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "ViewController.h"
#import "ZYYOperation.h"
#import "ZYConcurrentOpreation.h"

@interface ViewController ()
@property (nonatomic, assign) int ticketSurplusCount;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation ViewController

/*
 opreation
 
 NSInvocationOperation
 NSBlockOperation
 自定义并发Operation
 自定义非并发Operation
 
 1、NSBlockOperation、NSInvocationOperation 都实在是当前线程执行 同步操作 卡当前线程
 2、NSBlockOperation 是管理并发操作的  （前提是 你添加的block个数要多，系统才会开启新线程）
 3、自定义线程  start  main 方法     需要重写  isfinished  isexcuting  这些状态
 
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // [self inOp];
    // [self blockOp];
    //[self blockOpAddBlocks];
    
    //[self useCustomOperation];
    [self asyncOpQueue];
    //[self operation];

    //[self setMaxConcurrentOperationCount];
    //[self addDependency];
    //[self communication];
    //[self initTicketStatusSave];
}

- (void)operation {
    
    
    /*
     主线程
    [self useInvocationOperation];
    [self useBlockOperation];
    [self useCustomOperation];
    */
    
    /*
     子线程
     [NSThread detachNewThreadSelector:@selector(useInvocationOperation) toTarget:self withObject:nil];
     [NSThread detachNewThreadSelector:@selector(useBlockOperation) toTarget:self withObject:nil];
     [NSThread detachNewThreadSelector:@selector(useCustomOperation) toTarget:self withObject:nil];
     */
}


/**
 * 使用子类 NSInvocationOperation
 */
- (void)inOp {
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];

    // 2.调用 start 方法开始执行操作
    [op start];
}

- (void)task1 {
    for (int i = 0; i < 2; i++) {
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
    }
}

/*
   NSBlockOperation  单任务  就在当前线程执行 没有开启新线程
 */
- (void)blockOp {

    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block = ---%@", [NSThread currentThread]);
        sleep(3);
        
    }];
    
    //  NSOperation已经添加到NSOperationQueue后在调用这个方法或者先调用了这个方法然后再把NSOperation添加到NSOperationQueue都是错误的。  和queue不能同时存在。
    [op2 start];
}


/*
 NSBlockOperation 封装多任务添加到 NSBlockOperation 会自动开启新线程 开启的线程数系统决定
 blockop + 额外blocks
 因为addExecutionBlock 追加过多
 1、addExecutionBlock之间线程不一样
 2、addExecutionBlock 和 blockOperationWithBlock 线程也不一样
 3、blockOperationWithBlock没有在当前线程执行
 */
- (void)blockOpAddBlocks {

    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"6---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"7---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"8---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.调用 start 方法开始执行操作
    [op start];
}

/*
 
 1: 同步执行：只需要重写 main 函数（要线程执行的代码），系统执行完main 函数后会自动将该Operation从队列中移除；
 2、异步执行：重写 start 函数和要管理的状态，如结束状态（isFinished）；
 
*/

/*
    同步调用 只需要重写main方法  不需要放到queue里吗
    1、可能发生cancle  如果是是在start之前发生的cancle  交给start方法去判断
    2、如果是start已经调用了main  在执行main时候 发现了cancle  需要自己做一下判断iscancleid标识位
    3、最后完成任务 记得标记 isfinised 标志位
 */
- (void)useCustomOperation {
    // 1.创建 YSCOperation 对象
    //NSLog(@"")
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    ZYYOperation *op = [[ZYYOperation alloc] init];
    // 2.调用 start 方法开始执行操作
    [op cancel];
    [op start];
    NSLog(@"66666");
}

/*
 queue 异步  如果queue添加自定义的op  那么op需要重写 start 和 main方法
 最大操作数 默认-1
 设置1 就是串行队列
 设置2 就是并发队列
*/
- (void)asyncOpQueue {
    // 使用queue 就代表异步执行  设置最大操作数来决定是 串行队列还是 并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    ZYConcurrentOpreation *op = [[ZYConcurrentOpreation alloc] init];
    ZYConcurrentOpreation *op2 = [[ZYConcurrentOpreation alloc] init];

    [queue addOperation:op];
    [queue addOperation:op2];
    
    sleep(10);
    NSLog(@"%@",queue.operations);
//
//    [op2 cancel];
//    [op cancel];
}


// 设置依赖
- (void)dependency {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    ZYConcurrentOpreation *op1 = [[ZYConcurrentOpreation alloc] init];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block = ---%@", [NSThread currentThread]);
        sleep(3);
        
    }];
    [op1 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}


// 设置依赖2
- (void)addDependency {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.添加依赖
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2

    // 4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}


/*
 最大操作数默认-1
 设置1 串行队列
 设置2 以上就是并发队列
     如果设置2 就是最多执行2个op  当有一个op执行完毕以后，会执行其他的op
     op执行完需要把自己表计为 finised  让出位置
 开启线程数量是由系统决定的，不需要我们来管理  只关心操作 不关系线程
 */

- (void)setMaxConcurrentOperationCount {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.设置最大并发操作数
   // queue.maxConcurrentOperationCount = 1; // 串行队列
    queue.maxConcurrentOperationCount = 2; // 并发队列
   //  queue.maxConcurrentOperationCount = 8; // 并发队列

    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSLog(@"目前queue=%d",queue.operationCount);
    
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSLog(@"目前queue=%d",queue.operationCount);
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
  
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}


/**
 * 线程间通信
 */
- (void)communication {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    // 2.添加操作
    [queue addOperationWithBlock:^{
        // 异步进行耗时操作
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }

        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些 UI 刷新等操作
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
}

// NSOpreation非线程的安全：使用 NSLock 加锁
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程

    self.ticketSurplusCount = 50;
    self.lock = [[NSLock alloc] init];  // 初始化 NSLock 对象

    // 1.创建 queue1,queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketSafe];
    }];
    [queue1 addOperation:op1];
    
    
    // 2.创建 queue2,queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;  // 最大操作数为1 相当于串行队列
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketSafe];
    }];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
        // 加锁
        [self.lock lock];

        if (self.ticketSurplusCount > 0) {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 窗口:%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }

        // 解锁
        [self.lock unlock];

        if (self.ticketSurplusCount <= 0) {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

@end
