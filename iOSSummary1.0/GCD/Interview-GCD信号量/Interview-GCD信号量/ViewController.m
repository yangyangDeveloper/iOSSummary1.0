//
//  ViewController.m
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/26.
//

#import "ViewController.h"
#import "TicketDemo.h"
#import "EatDemo.h"
#import "ThreadNum.h"
#import "LoadingPhoto.h"

/*

 信号量应用
 1、保证线程安全、线程加锁。
 2、线程同步
 （1）、单个异步操作的结果同步使用到当前线程
 （2）、有多个异步操作需要执行，并且当所有操作完成后需要根据各个操作的结果来执行其他任务
 3、线程并发数量控制
 
 dispatch_semaphore_signal {
    value = value + 1
    释放1个信号
 }
 
 dispatch_semaphore_wait {
   value = value - 1
   等待
 }
 
 */


/*
 
 停车场剩余4个车位，那么即使同时来了四辆车也能停的下。如果此时来了五辆车，那么就有一辆需要等待。

 信号量的值就相当于剩余车位的数目，dispatch_semaphore_wait函数就相当于来了一辆车，dispatch_semaphore_signal就相当于走了一辆车。
 
 停车位的剩余数目在初始化的时候就已经指明了（dispatch_semaphore_create（long value）），

 调用一次dispatch_semaphore_signal，剩余的车位就增加一个；调用一次dispatch_semaphore_wait剩余车位就减少一个；

 当剩余车位为0时，再来车（即调用dispatch_semaphore_wait）就只能等待。
 有可能同时有几辆车等待一个停车位。有些车主没有耐心，给自己设定了一段等待时间，这段时间内等不到停车位就走了，如果等到了就开进去停车。而有些车主就像把车停在这，所以就一直等下去。
 
 */


/*
 
 dispatch_semaphore_wait  如果value大于0 则继续往下执行 并将value-1
                          否则 阻塞当前线程并等待timeout后再往下执行  timeout设置成 DISPATCH_QUEUE_CONCURRENT  代表永远
                               如果等待期间 value的值被dispatch_semaphore_signal 函数+1  且dispatch_semaphore_wait所在的线程获取到了信号量（可能被其他线程抢走） 则继续往下执行 并将信号量-1
            
 dispatch_semaphore_signal
 当返回值为0时候 代表当前没有线程等待其处理的信号量
 当返回值不为0时 表示当前有（一个或者多个） 线程等待其处理的信号量 并且该函数唤醒了一个等待的线程（优先级、 随机）

*/

@interface ViewController ()

@property (nonatomic, strong) TicketDemo *ticket;
@property (nonatomic, strong) EatDemo *eat;
@property (nonatomic, strong) ThreadNum *threadnum;
@property (nonatomic, strong) LoadingPhoto *downloadPhone;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testTicket];
    //[self testEatBun];
    //[self testThreadNum];
    //[self testDownloadImage];
    [self test];
}

// 保证线程安全、线程加锁。
- (void)testTicket {
    _ticket = [[TicketDemo alloc] init];
    [_ticket saleTicket];
   // [_ticket saleTicket2];
}

// 保证线程安全、线程加锁。
- (void)testEatBun {
    _eat = [[EatDemo alloc] init];
    [_eat eatBun];
}

// 线程并发数量控制
- (void)testThreadNum {
    _threadnum = [[ThreadNum alloc] init];
    [_threadnum test];
    //[_threadnum test2];
}

// 线程同步 有多个异步操作需要执行，并且当所有操作完成后需要根据各个操作的结果来执行其他任务
- (void)testDownloadImage {
    _downloadPhone = [[LoadingPhoto alloc] init];
    [_downloadPhone downloadImage];
}

// 线程同步  单个异步操作的结果同步使用到当前线程
- (void)test {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"当前线程===%@",[NSThread currentThread]);
        dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, DISPATCH_QUEUE_CONCURRENT);
        dispatch_semaphore_t st = dispatch_semaphore_create(0);
        
        __block int number = 0 ;
        
        dispatch_async(queue, ^{
            NSLog(@"当前线程===%@",[NSThread currentThread]);
            number = 100;
            [NSThread sleepForTimeInterval:3];  // 模拟耗时操作
            dispatch_semaphore_signal(st);
        });
        dispatch_semaphore_wait(st, DISPATCH_TIME_FOREVER);  // dispatch_semaphore_signal 执行前， dispatch_semaphore_wait使信号量 为 -1   线程不允许往下走   nslog 不执行
        NSLog(@"number==%d", number);
    });
    NSLog(@"主线程继续走");
   
}
@end
