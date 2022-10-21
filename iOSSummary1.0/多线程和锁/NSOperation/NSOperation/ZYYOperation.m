//
//  ZYYOperation.m
//  NSOperation
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "ZYYOperation.h"

/*
 自定义的Operation  默认都是同步操作
 当main()方法执行完毕，即Operation任务结束,Operation的几种状态，我们是不需要关心的  最后执行完 系统会设置为 finished。
 Operation类中还提供了cance（）的方法，所以在Operation执行的时候需要判断是否已经取消了，因为取消操作可能在开始之前就执行了，也可能在任务执行过程中，所以代码中需要加入isCancelled的判断。
 重写 main  就是同步操作

 
 Operation对象默认以同步方式执行，也就是说，在调用start方法的线程中执行任务。但是，由于OperationQueue为非并发操作提供线程，所以大多数Operation仍然是异步运行的。但是，如果我们手动使用Operation，不用OperationQueue，并且仍然希望它们异步运行，则必须采取适当的操作来确保能够做到这一点。我们可以通过将Operation对象定义为并发操作来实现这一点。
可以重写 start方法 同时需要考虑 cancle问题  整个过程记得维护 几种状态
 
 */
@implementation ZYYOperation

- (void)main {
    NSLog(@"%s",__func__);
    if (self.isCancelled) {
        return;;
    }
    
    NSLog(@"Start executing mainThread: %@, currentThread: %@",  [NSThread mainThread], [NSThread currentThread]);
    for (int i = 0; i < 2; i++) {
        if (self.isCancelled) return;
        sleep(4);
        NSLog(@"loop=%@", @(i + 1));
    }
    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
