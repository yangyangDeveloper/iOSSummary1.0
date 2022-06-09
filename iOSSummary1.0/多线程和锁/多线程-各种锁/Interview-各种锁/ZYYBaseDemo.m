//
//  ZYYBaseDemo.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "ZYYBaseDemo.h"

@interface ZYYBaseDemo ()

@property (nonatomic, assign) int ticketCount;
@property (nonatomic, assign) int moneyCount;

@end

@implementation ZYYBaseDemo

// 卖票demo
- (void)saleTickets {
    
    self.ticketCount = 30;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 演示汇编代码
//    for (int i = 0; i < 10; i++) {
//        [[[NSThread alloc] initWithTarget:self selector:@selector(__saleTicket) object:nil] start];
//    }
//    return;
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saleTicket];
        }
    });
 
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saleTicket];
        }
    });
}

- (void)__saleTicket {
    int oldTickCount = self.ticketCount;
    //sleep(600); 演示汇编使用
    sleep(0.2);
    oldTickCount--;
    self.ticketCount = oldTickCount;
    NSLog(@"%@ 还剩下%d张票", [NSThread currentThread], oldTickCount);
}

// 存钱取钱demo
- (void)moneyTest {
    
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


// 存钱
- (void)__saveMoney {
    int oldMoneyCount = self.moneyCount;
    sleep(0.2);
    oldMoneyCount += 50;
    self.moneyCount = oldMoneyCount;
    NSLog(@"%@存50 还剩%d元", [NSThread currentThread], oldMoneyCount);
}

// 取钱
- (void)__drawMoney {
    int oldMoneyCount = self.moneyCount;
    sleep(0.2);
    oldMoneyCount -= 20;
    self.moneyCount = oldMoneyCount;
    NSLog(@"%@ 取20 还剩%d元", [NSThread currentThread], oldMoneyCount);
}

- (void)otherTest{}
@end
