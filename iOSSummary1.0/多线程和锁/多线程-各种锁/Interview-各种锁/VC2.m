//
//  VC2.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "VC2.h"
#import "ZYYBaseDemo.h"
#import "OSSpinLockDemo.h"

@interface VC2 ()

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    ZYYBaseDemo *demo = [[ZYYBaseDemo alloc] init];
//    [demo saleTickets];
    
    
    // 自旋锁
    ZYYBaseDemo *demo = [[OSSpinLockDemo alloc] init];
    [demo saleTickets];
    
    //[self doThreads];
    
}

// 不是看到多线程就tm加锁呀 这种没有相互影响的读写操作  加个毛的锁
- (void)doThreads {
    for (int i = 0; i++ ; i< 10) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (int) test {
    int a = 60;
    int c = 40;
    return c;
}

@end
