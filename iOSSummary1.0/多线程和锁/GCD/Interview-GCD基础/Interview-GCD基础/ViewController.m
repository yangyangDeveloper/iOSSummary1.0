//
//  ViewController.m
//  Interview-GCD基础
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/*
    同步异步： 决定是否有开启线程的能力
    并发串行队列： 决定任务执行的顺序
     串行：fifo
     并行：可以一次从队列中拿出多个 可以交叉执行 不需要按照顺序
*/


/*
  队列类型
  
 并发队列；
 系统：dispatch_get_global_queue
 自定义：DISPATCH_QUEUE_CONCURRENT
 
 串行队列：
 系统： 主队列
 自定义：DISPATCH_QUEUE_SERIAL
 
 */


/*
       并发队列     自己创建串行队列    主队列
 同步  不开启线程    不开启线程         不开启线程
      串行执行      串行执行          串行执行
 
 异步  开启线程      开启线程         不开启线程
      并发执行      串行执行         串行执行
 */



/*
 
  主队列和主线程
 
  主队列的任务一定是在主线程上执行
  但是主线程可以执行其他队列中的任务
 */


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
//    [self test7];
    //[self test8];
    [self test9];
}

- (void)test9 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@", [NSThread currentThread]);
            NSLog(@"%d", i);
        });
    }
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier%@", [NSThread currentThread]);
        NSLog(@"任务barrier");
    });
//
    dispatch_async(queue, ^{
        NSLog(@"dispatch_async%@", [NSThread currentThread]);
        NSLog(@"任务2");
    });
}

// 主线程 执行 主队列的test3 执行到一半  去自定义的串行队列中 拿到任务2
// dispatch_sync 决定拿到任务在主线程执行任务2 而且是立即执行
// 所以主线程 去执行任务2  当执行完任务2 然后接着执行 主队列test3剩下的任务3
- (void)test1 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务1");
    dispatch_sync(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}

// 主线程执行任务1 发现dispatch_async 函数  不要求立即返回  主线程就接着执行任务3
// dispatch_async具备开启线程的能力  看是自定义的串行队列  那么就开启一个新线程 去从 串行队列中  拿出来一个任务   去执行
- (void)test2 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务1");
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}

- (void)test3 {
    
    // 全局区 唯一
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue1 = dispatch_get_main_queue();
    
    // 堆区
    dispatch_queue_t queue2 = dispatch_queue_create("myserQueue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("myserQueue3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue4 = dispatch_queue_create("myserQueue4", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"%p %p %p %p %p", queue,queue1, queue2,queue3,queue4);
}

- (void)test4 {
    // 全局区 唯一
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
    
    // 堆区
    dispatch_queue_t queue2 = dispatch_queue_create("myconQueue2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3 = dispatch_queue_create("myconQueue3", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue4 = dispatch_queue_create("myconQueue4", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"%p %p %p %p %p", queue,queue1, queue2,queue3,queue4);
}



// 并发队列 随机执行
- (void)test5 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"线程1= %@",[NSThread currentThread]);
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"线程2= %@",[NSThread currentThread]);
        NSLog(@"2");
    });
}

// 并发队列 交替执行
- (void)test6 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 并发队列 不需要考虑 加入的顺序  如果内容比较多可以交替执行
    dispatch_async(queue, ^{
        NSLog(@"线程1= %@",[NSThread currentThread]);
        NSLog(@"1");
        for (int i = 0; i< 20; i++) {
            NSLog(@"我是线程1中%d",i);
        }
    });
    
    dispatch_async(queue, ^{
        NSLog(@"线程2= %@",[NSThread currentThread]);
        NSLog(@"2");
        for (int i = 0; i< 20; i++) {
            NSLog(@"我是线程2中的%d",i);
        }
    });
}

// 并发队列  异步+ 同步
- (void)test7 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 并发队列 不需要考虑 加入的顺序  如果内容比较多可以交替执行
    dispatch_async(queue, ^{
        NSLog(@"线程1= %@",[NSThread currentThread]);
        for (int i = 0; i< 20; i++) {
            NSLog(@"我是线程1中%d",i);
        }

    });
    
    dispatch_sync(queue, ^{
        NSLog(@"6");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"线程2= %@",[NSThread currentThread]);
        for (int i = 0; i< 20; i++) {
            NSLog(@"我是线程2中的%d",i);
        }
    });
}


// 并发队列  异步 + 同步（延迟）
- (void)test8 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 并发队列 不需要考虑 加入的顺序  如果内容比较多可以交替执行
    dispatch_async(queue, ^{
        NSLog(@"线程1= %@",[NSThread currentThread]);
        for (int i = 0; i< 20; i++) {
            NSLog(@"我是线程1中%d",i);
        }

    });
    
    dispatch_sync(queue, ^{
        sleep(1);
        NSLog(@"6");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"线程2= %@",[NSThread currentThread]);
        for (int i = 0; i< 20; i++) {
            NSLog(@"我是线程2中的%d",i);
        }
    });
}


@end
