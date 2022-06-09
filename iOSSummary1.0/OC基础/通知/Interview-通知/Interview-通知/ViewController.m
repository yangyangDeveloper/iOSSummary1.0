//
//  ViewController.m
//  Interview-通知
//
//  Created by zhangyangyang on 2022/2/18.
//

#import "ViewController.h"

/*
 多线程 通知问题
 NSNotification接受线程是基于发送消息的线程的
 如果你发送的消息不在主线程，接受消息就会自动在子线程中执行（不管你在主线程或者是子线程中注册消息）
 在你收到消息通知的时候，注意选择你要执行的线程。如果在子线程中发送消息，则需要重定向到主线程中执行任务（比如刷新UI）
*/


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testTheadNotication];
    [self testMainThread];
}

// 测试多线程通知的问题  主线程注册的 但是在子线程执行的
- (void)testTheadNotication {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dosomething) name:@"testsubthread" object:nil];
}

// 收到通知在执行线程执行 （主线程）
- (void)testMainThread {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"testsubthread" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSLog(@"执行通知线程%@",[NSThread currentThread]);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程发送通知%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testsubthread" object:nil];
        
    });
}

- (void)dosomething {
    NSLog(@"执行通知线程%@",[NSThread currentThread]);
}

@end
