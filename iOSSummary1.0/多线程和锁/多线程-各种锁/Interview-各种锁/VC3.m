//
//  VC3.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "VC3.h"
#import "ZYYBaseDemo.h"
#import "OSSpinLockDemo.h"
#import "OS_unfairLockDemo.h"
#import "MutexDemo.h"
#import "MutexDemo2.h"
#import "MutexDemo3.h"
#import "NSLockDemo.h"
#import "NSRecursiveLockDemo.h"
#import "NSConditionDemo.h"
#import "NSConditionLockDemo.h"
#import "SeriaQueue.h"
#import "SemaphoreDemo.h"
#import "SynchronizedDemo.h"

@interface VC3 ()

@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYYBaseDemo *demo = [[SynchronizedDemo alloc] init];
    [demo saleTickets];
    [demo moneyTest];
    //[demo otherTest];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
