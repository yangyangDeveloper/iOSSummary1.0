//
//  ViewController.m
//  Interview-GCD队列组
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self test];
    //[self test2];
    //[self test3];
    //[self test4];
    //[self test5];
}

//  dispatch_group_notify 能保证前面执行完 再走后面
// 异步并发执行 任务1  和 任务2  最后回到主线程执行任务3
- (void)test {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务1--%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务2--%@", [NSThread currentThread]);
        }
    });

    
    dispatch_group_notify(group, queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务3--%@", [NSThread currentThread]);
            }
        });
    });
    
//    等价上面的代码
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//       for (int i = 0; i<5; i++) {
//            NSLog(@"任务3--%@", [NSThread currentThread]);
//        }
//    });
}


// 异步执行任务1 任务2  执行完之后  在异步执行 任务3 任务4
- (void)test2 {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务1--%@", [NSThread currentThread]);
        }
    });
    
 
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务2--%@", [NSThread currentThread]);
        }
    });

    
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务3--%@", [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务4--%@", [NSThread currentThread]);
        }
    });
}

// 当使用队列组时候  如果 里面嵌套的是其他异步代码 线程组有乱了
- (void)test3 {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务1--%@", [NSThread currentThread]);
            }
            NSLog(@"线程1");
        });
    });
    
    dispatch_group_async(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务2--%@", [NSThread currentThread]);
            }
            NSLog(@"线程2");
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"结束");
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务3--%@", [NSThread currentThread]);
            }
        });
    });
    
}

// 使用 dispatch_group_enter dispatch_group_leave
- (void)test4 {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务1--%@", [NSThread currentThread]);
            }
            NSLog(@"线程1");
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务2--%@", [NSThread currentThread]);
            }
            NSLog(@"线程2");
            dispatch_group_leave(group);
        });
    });


    dispatch_group_notify(group, queue, ^{
        NSLog(@"结束");
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务3--%@", [NSThread currentThread]);
            }
        });
    });
    
}

// test4 等价 test5   dispatch_group_async 可以移除
- (void)test5 {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务1--%@", [NSThread currentThread]);
        }
        NSLog(@"线程1");
        dispatch_group_leave(group);
    });
    
    /*
    dispatch_group_async(group, queue, ^{
        
    });
    */
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"任务2--%@", [NSThread currentThread]);
        }
        NSLog(@"线程2");
        dispatch_group_leave(group);
    });
    
    /*
    dispatch_group_async(group, queue, ^{
    
    });
    */

    dispatch_group_notify(group, queue, ^{
        NSLog(@"结束");
        dispatch_sync(dispatch_get_main_queue(), ^{
            for (int i = 0; i<5; i++) {
                NSLog(@"任务3--%@", [NSThread currentThread]);
            }
        });
    });
}

@end
