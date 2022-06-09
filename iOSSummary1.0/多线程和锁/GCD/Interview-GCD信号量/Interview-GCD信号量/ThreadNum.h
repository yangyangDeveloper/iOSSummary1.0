//
//  ThreadNum.h
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 需要同时执行很多个任务，例如下载 100 首歌曲，很明显我们不能同时开启 100 个子线程去执行下载任务，这时我们就可以利用信号量的特点来控制并发线程的数量
*/

@interface ThreadNum : NSObject

- (void)test;
- (void)test2;
@end

NS_ASSUME_NONNULL_END
