//
//  ZYYPerson.m
//  interview-动态方法解析
//
//  Created by zhangyangyang on 2022/4/24.
//

#import "ZYYPerson.h"
#import "ZYYCat.h"
#import <objc/runtime.h>

@implementation ZYYPerson

- (void)test {
    NSLog(@"%s",__func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if(sel == @selector(run)) {
        
        Method method = class_getInstanceMethod(self, @selector(test));
        
        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
        
        //等价
        //class_addMethod(self, sel, method_getImplementation(method), "v@:");
        
        // 返回YES代表有动态添加方法  其实这里返回NO，也是可以的，返回YES只是增加了一些打印
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
@end
