//
//  ViewController.m
//  Interview-GCD死锁
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/*
   死锁条件 （串行 + sync）
    1、 当前是串行队列
    2、 使用sync函数
    3、 往当前这个串行队列添加任务 就会卡主当前串行队列 出现死锁
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self test1];
   //[self test2];
//    [self test3];
   // [self test4];
//   [self test5];
   //[self test6];
   // [self test7];
   // [self test8];
    //[self test9];
    [self test10];
}

/*
 
  主队列   任务2 test1 ---》
  队列循环等待  主队列是串行队列  任务必须一个个执行  任务2必须依赖test1 执行完 才能执行。 而test1里面包含 任务2 任务2要求立即去执行 有返回值才会执行完。
*/
- (void)test1 {
    NSLog(@"任务1");
    // 当前串行队列是 dispatch_get_main_queue
    // 现在又使用sync往当前串行队列添加任务就会队列死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"任务2");
//    });
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}

// 主队列任务 无论同步函数还是异步函数 都不会开启新线程 都是需要放到主线程执行的
- (void)test3 {
   NSLog(@"任务1");
    // 当前队列是 dispatch_get_main_queue
    // 使用是async 所以没有队列死锁
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}


/*
 1、当前上下文队列是主队列 test2在主队列
 2、任务2 在自定义的串行队列里面 不会死锁
 */
- (void)test2 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务1");
   
    // 使用sync 但是添加的队列是 自己的queue  所以没有 队列死锁
    dispatch_sync(queue, ^{
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}



- (void)test4 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务1");
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
        // 从这里开始队列死锁
        // 当前队列是 串行队列 queue
        // 当前串行队列是 queue   又往当前串行队列添加任务  队列死锁
        dispatch_sync(queue, ^{
            
            NSLog(@"%@", [NSThread currentThread]);
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
}


- (void)test5 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2 = dispatch_queue_create("myQueue2", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务1");
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
        // 当前队列是 串行队列 queue
        // 当前串行队列是queue  但是使用sync 添加的队列是queue2 所以不会队列死锁
        dispatch_sync(queue2, ^{
            NSLog(@"%@", [NSThread currentThread]);
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
}


- (void)test6 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2 = dispatch_queue_create("myQueue2", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"任务1");
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
        
        // 当前队列是 串行队列 queue
        // 当前串行队列是queue  但是使用sync 添加的队列是queue2 而且是并行队列  所以不会队列死锁
        dispatch_sync(queue2, ^{
            NSLog(@"%@", [NSThread currentThread]);
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
}


- (void)test7 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"任务1");
    NSLog(@"%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
        // 当前队列是 并行队列 queue
        // 所以不会队列死锁
        dispatch_sync(queue, ^{
            NSLog(@"%@", [NSThread currentThread]);
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
}


- (void)test8 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
}

- (void)test9 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        // 开启子线程
        NSLog(@"1");
        [self performSelector:@selector(test) withObject:nil];
        // objcmessagesend(self, @selecotr(test)) 等价  【self test】
        NSLog(@"3");
    });
}


- (void)test10 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        // 开启子线程
        // 底层是 runloop + timer
        // 子线程 runloop没有开启  timer不会执行
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        NSLog(@"3");
    });
}

- (void)test {
    NSLog(@"2");
}
@end
