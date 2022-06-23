//
//  ZYYWeakTarget.h
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYWeakTarget : NSProxy
@property (nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
