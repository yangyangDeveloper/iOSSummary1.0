//
//  VC2.m
//  多线程-读写安全
//
//  Created by zhangyangyang on 2022/2/14.
//

#import "VC2.h"
/*
 dispatch_barrier_async
 */
@interface VC2 ()
@property(nonatomic, strong) dispatch_queue_t queue;
@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<10  ; i++) {
         [self read];
         //[self write];
    }
}

// 假设读取内容需要1s才能读取完   这里可以一次多个线程 都进去读取
- (void)read {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"read");
    });
}

// 写一次需要1s的话  那么只有一次写完之后  全部执行完 才能允许下一个线程进来     一次执行一个模块的代码 成为原子性操作
- (void)write {
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"write");
    });
}

@end

/*
 
 假设写需要1s   每次写 都需要全部完成 而且之允许一次
 2022-02-14 17:04:51.175814+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:52.180033+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:53.183717+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:54.188810+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:55.192508+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:56.196060+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:57.198940+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:58.202356+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:04:59.205658+0800 多线程-读写安全[18404:311637] write
 2022-02-14 17:05:00.210649+0800 多线程-读写安全[18404:311637] write
 
 */


/*
 假设读需要1s  每次读 都不需要执行完 其他线程也可以进来 大家一起读
 
 2022-02-14 17:07:50.423530+0800 多线程-读写安全[18614:315512] read
 2022-02-14 17:07:50.423530+0800 多线程-读写安全[18614:315510] read
 2022-02-14 17:07:50.423530+0800 多线程-读写安全[18614:315514] read
 2022-02-14 17:07:50.423530+0800 多线程-读写安全[18614:315511] read
 2022-02-14 17:07:50.423530+0800 多线程-读写安全[18614:315509] read
 2022-02-14 17:07:50.423538+0800 多线程-读写安全[18614:315517] read
 2022-02-14 17:07:50.423530+0800 多线程-读写安全[18614:315515] read
 2022-02-14 17:07:50.423577+0800 多线程-读写安全[18614:315562] read
 2022-02-14 17:07:50.423577+0800 多线程-读写安全[18614:315560] read
 2022-02-14 17:07:50.423582+0800 多线程-读写安全[18614:315561] read
 
 */
