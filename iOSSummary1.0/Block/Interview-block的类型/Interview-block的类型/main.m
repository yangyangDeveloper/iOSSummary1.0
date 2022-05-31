//
//  main.m
//  Interview-block的类型
//
//  Created by zhangyangyang on 2022/2/8.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

// __NSGlobalBlock__  NSBlock  NSObject
int b = 7;
void test() {
    
    // 没有访问auto变量 就是globalblock   不用管他访问static和全局变量
    static int a = 6;
    
    void (^block)(void) = ^{
        NSLog(@"hello");
        NSLog(@"%d", a);
        NSLog(@"%d", b);
    };
    NSLog(@"%@",[block class]);
    NSLog(@"%@",[[block class] superclass]);
    NSLog(@"%@",[[[block class] superclass] superclass]);
}

// __NSMallocBlock__  NSBlock  NSObject
void test2() {
    int age = 10;
    // 其实就是 auto int age = 10;
    void (^block)(void) = ^{
        NSLog(@"hello -- %d",age);
    };
    NSLog(@"%@",[block class]);
    NSLog(@"%@",[[block class] superclass]);
    NSLog(@"%@",[[[block class] superclass] superclass]);

}

// __NSStackBlock__ NSBlock NSObject
void test3() {
    int age = 10;
    NSLog(@"%@", [^{ NSLog(@"%d", age);} class]);
    NSLog(@"%@", [[^{ NSLog(@"%d", age);} class] superclass]);
    NSLog(@"%@", [[[^{ NSLog(@"%d", age);} class] superclass] superclass]);
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        test();
    }
    return 0;
}
