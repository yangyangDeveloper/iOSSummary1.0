//
//  TicketDemo.h
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import <Foundation/Foundation.h>

/*
 1、线程加锁 线程安全
 2、多个异步操作 线程同步
 */
NS_ASSUME_NONNULL_BEGIN

@interface TicketDemo : NSObject

- (void)saleTicket;

- (void)saleTicket2;

@end

NS_ASSUME_NONNULL_END
