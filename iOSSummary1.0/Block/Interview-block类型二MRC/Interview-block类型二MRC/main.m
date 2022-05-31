//
//  main.m
//  Interview-block类型二MRC
//
//  Created by zhangyangyang on 2022/2/8.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


void(^block)(void);

// block的数据在栈内存分布 出了test2之后 里面的数据就乱了  所以访问 a  是个随机值
void test2() {
    int a = 100;
    block = ^{
        NSLog(@"a===%d",a);
    };
    NSLog(@"%@",[block class]);
}

// 调用一下 copy操作 block的数据会被copy一份到堆上面 所以 block变量类型变成了 __NSMallocBlock__
/*
    global block  copy之后  什么都不做
    stack  block  copy之后  从栈复制到堆
    malloc block  copy之后  引用计数+1
 */
void test3() {
    int a = 100;
    block = [^{
        NSLog(@"a===%d",a);
    } copy];

    NSLog(@"%@",[block class]);
    
    // 注意我们要释放堆上内存
    [block release];
}


int c = 7;

int main(int argc, char * argv[]) {

    @autoreleasepool {
        
//        int a = 10;
//        static int b = 6;
//
//        // 只要没有访问auto变量 他就是 Global类型block 存放在全局区
//        void(^block1)(void) = ^{
//            NSLog(@"hello");
//            NSLog(@"%d",c);
//            NSLog(@"%d",b);
//        };
//        NSLog(@"%@",[block1 class]);
//
//        // 只要访问了auto变量 他就是__NSStackBlock__ 存放在栈
//        void(^block2)(void) = ^{
//            NSLog(@"hello");
//            NSLog(@"%d",a);
//        };
//        NSLog(@"%@",[block2 class]);
        
        
        test3();
        block();
    }
    return 0;
}



