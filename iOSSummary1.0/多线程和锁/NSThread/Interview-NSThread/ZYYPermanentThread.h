//
//  ZYYPermanentThread.h
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/6/23.
//

#import <Foundation/Foundation.h>

 /*
  开启一轮
  while (weakSelf && !weakSelf.isStop) {
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
  }
  
  停止一轮runloop
  self.isStop = YES;
  CFRunLoopStop(CFRunLoopGetCurrent());
  
  系统的 run  等于下面
  while(1) {
     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
  }
  */

NS_ASSUME_NONNULL_BEGIN

@interface ZYYPermanentThread : NSObject

// 开启
- (void)run;

// 结束
- (void)stop;

// target执行任务
- (void)executeTask:(id)target action:(SEL)action object:(id)object;

// block执行任务
- (void)executeTaskWithBlock:(void(^)(void))task;

@end

NS_ASSUME_NONNULL_END
