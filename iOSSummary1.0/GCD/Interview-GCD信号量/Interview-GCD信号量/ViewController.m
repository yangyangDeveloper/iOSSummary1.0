//
//  ViewController.m
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/26.
//

#import "ViewController.h"

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
@property (nonatomic, assign) int surplusCount;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self test];
    //[self test2];
    //[self test3];
    //[self test4];
    [self nb];
}


/*
   多个异步操作 线程同步
   异步并发下载3张图片 并将合成 显示到屏幕上
   异步下载图片API(已提供)
 */

// 异步下载图片
- (void)downloadImage:(NSString *)url completionHandler:(void(^)(UIImage * image))completionHandler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"真正图片下载线程%@",[NSThread currentThread]);
        // 模拟图片下载耗费的时间
        [NSThread sleepForTimeInterval:2];
        
        if (completionHandler) {
            completionHandler([UIImage new]);
        }
    });
}

- (void)test {
    [self downloadImage1:@"image url 1" image2:@"image url 2" combinedHandler:^(UIImage *combinedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"在主线程中更新 UI");
        });
    }];
}


- (void)nb {
    
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i< 5; i++) {
            dispatch_async(queue, ^{
                [self downloadImage:@"" completionHandler:^(UIImage *image) {
                    [NSThread sleepForTimeInterval:2];
                    NSLog(@"image finished");
                    dispatch_semaphore_signal(semaphore);
                }];
            });
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"刷新UI");
        });
    });
   
    NSLog(@"主线程继续走");
    
}


// 信号量+队列组  来实现线程同步
- (void)downloadImage1: (NSString *)url1 image2:(NSString *)url2 combinedHandler:(void (^)(UIImage *combinedImage))combinedHandler {
    
    NSLog(@"-- all tasks begin --");
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
 
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    __block UIImage *image3 = nil;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"队列组线程1=%@",[NSThread currentThread]);
        NSLog(@"start downloading image1");
        // 假设调用别人封装的异步下载图片的API
        [self downloadImage:@"" completionHandler:^(UIImage *image) {
            image1 = image;
            NSLog(@"image1 finished");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });

    /*
     
     在64位的机器上，intptr_t和uintptr_t分别是long int、unsigned long int的别名；在32位的机器上，intptr_t和uintptr_t分别是int、unsigned int的别名。
     
     */
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"队列组线程2=%@",[NSThread currentThread]);
        NSLog(@"start downloading image2");
        // 假设调用别人封装的异步下载图片的API
        [self downloadImage:@"" completionHandler:^(UIImage *image) {
            image2 = image;
            NSLog(@"image2 finished");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"队列组线程3=%@",[NSThread currentThread]);
        NSLog(@"start downloading image3");
        // 假设调用别人封装的异步下载图片的API
        [self downloadImage:@"" completionHandler:^(UIImage *image) {
            image3 = image;
            NSLog(@"image3 finished");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"all task end");
        // 模拟图片合成过程
        [NSThread sleepForTimeInterval:2];
        if (combinedHandler) {
            combinedHandler([UIImage new]);
        }
    });
    
    NSLog(@"主线程继续走");
}

/*
 需要同时执行很多个任务，例如下载 100 首歌曲，很明显我们不能同时开启 100 个子线程去执行下载任务，这时我们就可以利用信号量的特点来控制并发线程的数量
*/

// 线程并发量控制
- (void)test2 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程==%@",[NSThread currentThread]);
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(4);
        
        for(int i = 0; i < 100; i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            dispatch_async(queue, ^{
                NSLog(@"task%d begin -- %@", i, [NSThread currentThread]);
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"task%d end", i);
                dispatch_semaphore_signal(semaphore);
            });
        }
    });
}

- (void)test3 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue",DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(4);
    for (NSInteger i = 0; i < 15; i++) {
        dispatch_async(serialQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(concurrentQueue, ^{
                NSLog(@"thread:%@开始执行任务%d",[NSThread currentThread],(int)i);
                sleep(1);
                NSLog(@"thread:%@结束执行任务%d",[NSThread currentThread],(int)i);
                dispatch_semaphore_signal(semaphore);});
        });
    }
    NSLog(@"主线程...!");
}


- (void)test4 {
    // 初始化包子数量
    self.surplusCount = 20; // 最开始剩余的包子的数量为 20 个
        
    // 初始化信号量
    self.semaphore = dispatch_semaphore_create(1);
        
    // 创建并发线程，三个人吃包子同时执行，互不影响
    dispatch_queue_t queue = dispatch_queue_create("com.jarypan.gcdsummary.eatqueue", DISPATCH_QUEUE_CONCURRENT);
        
    // 3 个人开始吃包子
    dispatch_async(queue, ^{
        NSLog(@"线程1==%@",[NSThread currentThread]);
        [self peopleEat:1];
        //[self eat];
    });
    dispatch_async(queue, ^{
        NSLog(@"线程2==%@",[NSThread currentThread]);
        [self peopleEat:2];
        //[self eat];
    });
    dispatch_async(queue, ^{
        NSLog(@"线程3==%@",[NSThread currentThread]);
        [self peopleEat:3];
        //[self eat];
    });
}

// 模拟吃包子 不考虑线程安全
- (void)eat {
    while (YES) {
        if (self.surplusCount > 0) {
            self.surplusCount--;
            NSLog(@"start eating, surplusCount is %ld", (long)self.surplusCount);
            [NSThread sleepForTimeInterval:0.1]; // 模拟吃包子（耗时操作）
        } else {
            NSLog(@"所有包子已吃完");
            break;
        }
    }
}

// 三个人吃包子耗时不一样
- (void)peopleEat:(int)people {
    while (YES) {
        if (self.surplusCount > 0) {
            // 拿包子
            [self getTheSteamedStuffedBun];
            NSLog(@"people %d start eating, surplusCount is %ld", people, (long)self.surplusCount);
            [NSThread sleepForTimeInterval:people/10.0]; // 吃包子的时间因人而异
        } else {
            NSLog(@"所有包子已吃完");
            break;
        }
    }
}
// 拿包子
- (void)getTheSteamedStuffedBun {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    self.surplusCount--;
    dispatch_semaphore_signal(self.semaphore);
}

@end
