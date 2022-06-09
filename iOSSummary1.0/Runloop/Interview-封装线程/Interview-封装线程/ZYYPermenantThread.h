//
//  ZYYPermenantThread.h
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYPermenantThread : NSObject

// 开启一个线程
- (void)run;

// target执行任务
- (void)executeTask:(id)target action:(SEL)action object:(id)object;

// block执行任务
- (void)executeTaskWithBlock:(void(^)(void))task;

// 结束线程
- (void)stop;

@end

NS_ASSUME_NONNULL_END
