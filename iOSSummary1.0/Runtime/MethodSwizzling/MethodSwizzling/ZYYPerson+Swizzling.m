//
//  ZYYPerson+Swizzling.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "ZYYPerson+Swizzling.h"
#import <objc/runtime.h>

@implementation ZYYPerson (Swizzling)

/*

1、 应该只在 +load 中执行 Method Swizzling
2、 Method Swizzling 在 +load 中执行时，不要调用 [super load]
3、 Method Swizzling 应该总是在 dispatch_once 中执行
  Method Swizzling 不是原子操作
4、使用 Method Swizzling 后要记得调用原生方法的实现
 */


/*
 + load 方法的调用规则为：

 先调用主类，按照编译顺序，顺序地根据继承关系由父类向子类调用；
 再调用分类，按照编译顺序，依次调用；
 + load 方法除非主动调用，否则只会调用一次。
 
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 当前类
        Class class = [self class];
        
        
        SEL carSel = @selector(car);
        SEL womenSel = @selector(women);
        
        
        Method carMethod = class_getInstanceMethod(class, carSel);
        Method womenMehtod = class_getInstanceMethod(class, womenSel);
        

        // 如果当前类没有 car方法的imp  说明car方法是从父类方法继承过来的
        // 需要在当前类题那家一个 car的实现
        // 但是用替换方法 women 去实现它
        BOOL didaddMethod = class_addMethod(class, carSel, method_getImplementation(womenMehtod), method_getTypeEncoding(womenMehtod));

        if (didaddMethod) {
            // women方法实现 替换成 car方法实现
            NSLog(@"添加方法");
            class_replaceMethod(class, womenSel, method_getImplementation(carMethod), method_getTypeEncoding(carMethod));
        } else {
            // 添加失败 说明包含car方法实现  直接交换2个方法实现
            method_exchangeImplementations(carMethod, womenMehtod);
        }
    
    });
}

- (void)test2 {
    [self car];
    [self women];
}

//- (void)car {
//    NSLog(@"car");
//}

- (void)women {
    NSLog(@"women");
}

@end
