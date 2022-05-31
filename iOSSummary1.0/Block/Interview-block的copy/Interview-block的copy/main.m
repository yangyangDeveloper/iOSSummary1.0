//
//  main.m
//  Interview-block的copy
//
//  Created by zhangyangyang on 2022/2/8.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*
 block 的copy
 ARC下 编译器会根据一下情况自动把栈上的block  赋值到堆上
 
 block作为函数返回值
 讲block赋值给__strong指针时
 block作为cocoa API中 方法名带usingblock的方法参数时
 block作为gcd的api方法参数时 
 */

typedef void (^ZYYBlock)(void);

// MRC下 这样很危险  因为返回的是一个栈block
//ZYYBlock myblock() {
//    int a = 10;
//    ZYYBlock block =  ^{
//        NSLog(@"%d", a);
//        NSLog(@"------");
//    };
//    return block;
//}


// ARC下 block 作为函数返回值时候 会自动copy
ZYYBlock myblock() {
    int a = 10;
    return ^{
        NSLog(@"%d", a);
        NSLog(@"------");
    };
}

// 讲block赋值给__strong指针时候
// ARC下 只要有强指针指向block  block就会自动copy

ZYYBlock myblock2() {
    int a = 10;
    
    // 这里 block2变量是个强指针 指向等号右边的block
    ZYYBlock block2 =  ^{
        NSLog(@"%d", a);
        NSLog(@"------");
    };
    NSLog(@"%@", [block2 class]);
    
    // 比如这个block 就是没有强指针指向他  他就是 栈block  __NSMallocBlock__
    NSLog(@"%@",[^{
        NSLog(@"%d", a);
        NSLog(@"------");
    } class]);
    
    return block2;
}


// ARC 下 他回自动帮我们加上copy
//ZYYBlock myblock() {
//    int a = 10;
//    ZYYBlock block =  ^{
//    NSLog(@"%d", a);
//        NSLog(@"------");
//    };
//    return [block copy];
//}

//block作为cocoa API中 方法名带usingblock的方法参数时  ARC 会自动copy
void test2() {
    
    NSArray *array = @[];

    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
    }];
}

// block作为gcd的api方法参数时 ARC 会自动copy
void test3() {
    NSObject *obj = [[NSObject alloc] init];  // 1
    NSLog(@"retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)(obj)));
    
    // block会自动 copy到堆
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",obj);
    });
    
    NSLog(@"retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)(obj)));  // 3
}


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        
//        ZYYBlock block = myblock();
//        block();
//        // ARC下帮我们copy了block 所以类型是  __NSMallocBlock__
//        NSLog(@"%@", [block class]);
//
//
//        ZYYBlock block2 = myblock2();
//        block2();
        
        test2();
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return 0;
}
