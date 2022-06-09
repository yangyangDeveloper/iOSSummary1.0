//
//  VC1.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "VC1.h"
#import <libkern/OSAtomic.h>

/*
    OSSpinLock  自旋锁
    不释放cpu资源 一直轮训
    相当于 while(解锁了没有);
    
 
    OSSpinLockLock(&_moneyLock);
    走到这里会先判断 是否已经加锁 如果加锁了 就一直等待  while     如果没有加锁 自己先进行加锁
    while(锁没有解开)；
    
 */


/*
 
    thread 1  优先级高
    thread 2
    thread 3
 
    如果最开始是thread2进来 发现没有加锁 自己加锁 刚好cpu进行线程时间切换轮转调度
    假设thread1 优先级高  cpu给的时间切片时间长 但是因为已经被上锁了  所以 thread1 一直在执行  但是没有执行完  而cpu想等到thread1 执行完 再分配给其他线程 这样就容易死锁
 */
@interface VC1 ()
@property (nonatomic, assign) int ticketCount;
@property (nonatomic, assign) int moneyCount;
@property (nonatomic, assign) OSSpinLock ticketLock;
@property (nonatomic, assign) OSSpinLock moneyLock;

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self saleTickets];
    [self moneyTest];
}

// 卖票demo
- (void)saleTickets {
    
    _ticketLock = OS_SPINLOCK_INIT;
    
    self.ticketCount = 30;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicket];
        }
    });
 
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicket];
        }
    });
}

- (void)saleTicket {
    
    OSSpinLockLock(&_ticketLock);
    int oldTickCount = self.ticketCount;
    sleep(0.2);
    oldTickCount--;
    self.ticketCount = oldTickCount;
    NSLog(@"%@ 还剩下%d张票", [NSThread currentThread], oldTickCount);
    OSSpinLockUnlock(&_ticketLock);
}


// 存钱取钱demo
- (void)moneyTest {
    
    _moneyLock = OS_SPINLOCK_INIT;
    self.moneyCount = 100;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __drawMoney];
        }
    });
}

// 如果是跨方法  这几个方法同一时间只能有一个方法执行 那么这几个方法要共用一把锁

// 存钱
- (void)__saveMoney {
    OSSpinLockLock(&_moneyLock);
    int oldMoneyCount = self.moneyCount;
    sleep(0.2);
    oldMoneyCount += 50;
    self.moneyCount = oldMoneyCount;
    NSLog(@"%@存50 还剩%d元", [NSThread currentThread], oldMoneyCount);
    OSSpinLockUnlock(&_moneyLock);
}

// 取钱
- (void)__drawMoney {
    // 假设有线程来到这里 发现 锁被加上了  那么他就会 自旋等待  忙等  不退出 不休眠 一直 while循环 轮训 是否已经解锁     当其他地方完成之后 解锁了  这里才会进去。
    OSSpinLockLock(&_moneyLock);
    int oldMoneyCount = self.moneyCount;
    sleep(0.2);
    oldMoneyCount -= 20;
    self.moneyCount = oldMoneyCount;
    NSLog(@"%@ 取20 还剩%d元", [NSThread currentThread], oldMoneyCount);
    OSSpinLockUnlock(&_moneyLock);
}

@end

/*
 
 取钱线程 先抢到了资源  他加锁 然后走完 在解锁     存钱线程 处于忙等状态  一直轮训
2022-02-11 16:31:55.916414+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩80元
2022-02-11 16:31:55.916642+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩60元
2022-02-11 16:31:55.916802+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩40元
2022-02-11 16:31:55.916975+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩20元
2022-02-11 16:31:55.917155+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩0元
2022-02-11 16:31:55.917312+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩-20元
2022-02-11 16:31:55.917493+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩-40元
2022-02-11 16:31:55.917617+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩-60元
2022-02-11 16:31:55.917773+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩-80元
2022-02-11 16:31:55.917915+0800 Interview-各种锁[54141:2382850] <NSThread: 0x600002b1a6c0>{number = 7, name = (null)} 取20 还剩-100元
2022-02-11 16:31:55.919796+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩-50元
2022-02-11 16:31:55.919940+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩0元
2022-02-11 16:31:55.928280+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩50元
2022-02-11 16:31:55.928477+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩100元
2022-02-11 16:31:55.928654+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩150元
2022-02-11 16:31:55.928813+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩200元
2022-02-11 16:31:55.929007+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩250元
2022-02-11 16:31:55.929155+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩300元
2022-02-11 16:31:55.929290+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩350元
2022-02-11 16:31:55.929440+0800 Interview-各种锁[54141:2382855] <NSThread: 0x600002b2a840>{number = 6, name = (null)}存50 还剩400元
*/


/*
 
 存钱线程 先抢到了资源  他加锁 然后走完 在解锁     取钱线程 处于忙等状态  一直轮训
 2022-02-11 16:32:39.664625+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩150元
 2022-02-11 16:32:39.664850+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩200元
 2022-02-11 16:32:39.664997+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩250元
 2022-02-11 16:32:39.665144+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩300元
 2022-02-11 16:32:39.665303+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩350元
 2022-02-11 16:32:39.665502+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩400元
 2022-02-11 16:32:39.665684+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩450元
 2022-02-11 16:32:39.665901+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩500元
 2022-02-11 16:32:39.666052+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩550元
 2022-02-11 16:32:39.666247+0800 Interview-各种锁[54202:2384276] <NSThread: 0x600002378280>{number = 3, name = (null)}存50 还剩600元
 2022-02-11 16:32:39.667997+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩580元
 2022-02-11 16:32:39.668144+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩560元
 2022-02-11 16:32:39.679178+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩540元
 2022-02-11 16:32:39.679364+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩520元
 2022-02-11 16:32:39.679524+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩500元
 2022-02-11 16:32:39.679688+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩480元
 2022-02-11 16:32:39.679829+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩460元
 2022-02-11 16:32:39.679958+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩440元
 2022-02-11 16:32:39.680096+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩420元
 2022-02-11 16:32:39.680233+0800 Interview-各种锁[54202:2384270] <NSThread: 0x60000237c480>{number = 6, name = (null)} 取20 还剩400元
 */
