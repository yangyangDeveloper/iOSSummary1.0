//
//  ZYYBaseDemo.h
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYBaseDemo : NSObject

- (void)saleTickets;
- (void)moneyTest;
- (void)otherTest;

// 暴漏给子类
- (void)__saleTicket;
- (void)__saveMoney;
- (void)__drawMoney;
@end

NS_ASSUME_NONNULL_END
