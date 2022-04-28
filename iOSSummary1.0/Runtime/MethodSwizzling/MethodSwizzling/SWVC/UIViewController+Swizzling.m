//
//  UIViewController+Swizzling.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originSel = @selector(viewWillAppear:);
        SEL swizzlingSel = @selector(zyy_viewWillAppear:);
        
        Method originMethod = class_getInstanceMethod(class, originSel);
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSel);
        
        BOOL didaddMehod = class_addMethod(class, originSel, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        
        if (didaddMehod) {
            class_replaceMethod(class, swizzlingSel, method_getImplementation(originMethod), method_getImplementation(originMethod));
        }else {
            method_exchangeImplementations(originMethod, swizzlingMethod);
        }
        
    });
}

- (void)zyy_viewWillAppear:(BOOL)animated {
    NSLog(@"调用自己的系统");
    if ( [self isKindOfClass:[UIViewController class]]) {
        NSLog(@"进入页面==%@",[self class]);
    }
    [self zyy_viewWillAppear:animated];
}

@end
