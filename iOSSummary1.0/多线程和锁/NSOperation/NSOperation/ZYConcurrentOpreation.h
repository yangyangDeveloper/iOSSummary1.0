//
//  ZYConcurrentOpreation.h
//  NSOperation
//
//  Created by zhangyangyang on 2022/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 [operation cancel]
 start前  start检查iscancelled为yes 直接设置 isfinished 为true  不执行main
 start后， opreation一旦开始执行 默认会一直执行到操作为止  只是标志位iscancelled 被设置为yes
 但是我们可以自定义opreation 利用iscancelled这个标识位 来实现真正的取消
 在main方法中 定期检查 isCancelled 属性  看外界是否取消， 如果收到取消那就可以及时推出
*/

@interface ZYConcurrentOpreation : NSOperation

@end

NS_ASSUME_NONNULL_END
