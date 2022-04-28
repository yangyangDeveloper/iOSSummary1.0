//
//  ZYYPerson.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "ZYYPerson.h"
#import <objc/runtime.h>


@implementation ZYYPerson

- (void)test {
    [self swizzlingMethod];
    [self run];
    [self eat];
}

- (void)run {
    NSLog(@"run");
}

- (void)eat {
    NSLog(@"eat");
}

- (void)swizzlingMethod {
    Class class = [self class];
    SEL runSel = @selector(run);
    SEL eatSel = @selector(eat);
    Method runMethod = class_getInstanceMethod(class, runSel);
    Method eatMethod = class_getInstanceMethod(class, eatSel);
    method_exchangeImplementations(runMethod, eatMethod);
}

@end
