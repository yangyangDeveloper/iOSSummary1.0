//
//  ZYYWeakTarget.m
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "ZYYWeakTarget.h"

@implementation ZYYWeakTarget

- (instancetype)initWithTarget:(id)target {
    return _target;
}

+ (instancetype)proxyTarget:(id)target {
    return [[ZYYWeakTarget alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

@end
