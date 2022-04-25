//
//  ZYYPerson.m
//  interview-消息转发机制
//
//  Created by zhangyangyang on 2022/4/24.
//

#import "ZYYPerson.h"
#import "ZYYCat.h"

@implementation ZYYPerson

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        // return [ZYYCat class];  返回类对象 就是让同名的类方法取响应
        // return [[ZYYCat alloc] init];
        return nil;  // 返回nil 继续往下走
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 自由度更高
/*
    1、 可以玩参数 返回值
    2、 可以类方法和实例方法都调用
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"调用");
//    [anInvocation invokeWithTarget:[[ZYYCat alloc] init]];
//    [anInvocation invokeWithTarget:[ZYYCat class]];
    
    // 更好的写法  加一个判断
    SEL selector = [anInvocation selector];
    ZYYCat *cat = [[ZYYCat alloc] init];
    if ([cat respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:cat];
    }
}

@end
