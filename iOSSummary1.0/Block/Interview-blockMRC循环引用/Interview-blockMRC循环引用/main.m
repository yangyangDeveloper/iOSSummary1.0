//
//  main.m
//  Interview-blockMRC循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZYYPerson.h"


/*
 MRC下 解决block循环引用
1、 __unsafe_unretained
2、 __block   block可以不调用
 */
// 这个有疑惑
void test() {
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    
    zyy.name = @"zyy";
    // 使用 copy关键字  所以 block变量是指向堆block的
    zyy.block = ^{
        NSLog(@"%@",zyy.name);
    };
    NSLog(@"zyycount==%zd",zyy.retainCount);
    [zyy release];
    NSLog(@"%@",[zyy.block class]);
    zyy.block();
    [zyy.block release];
}


void test1() {
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    
    zyy.name = @"zyy";
    // 使用 copy关键字  所以 block变量是指向堆block的
    zyy.block = [^{
        NSLog(@"%@",zyy.name);
    } copy];   // copy 操作时候 retain
    NSLog(@"zyycount==%zd",zyy.retainCount);
    [zyy release];
    NSLog(@"%@",[zyy.block class]);
    zyy.block();
    [zyy.block release];
}


void test2() {
    
    __unsafe_unretained ZYYPerson *zyy = [[ZYYPerson alloc] init];  // 1
    
    zyy.name = @"zyy";
    // 使用 copy关键字  所以 block变量是指向堆block的
    zyy.block = [^{
        NSLog(@"%@",zyy.name);
    } copy];  // copy 操作时候 不 retain
    NSLog(@"zyycount==%zd",zyy.retainCount);  // 1
    zyy.block();
    NSLog(@"%@",[zyy.block class]);
    [zyy release];
}


void test3() {
     ZYYPerson *zyy = [[ZYYPerson alloc] init];  // 1
    __block ZYYPerson *blockzyy = zyy;
    
    zyy.name = @"zyy";
    // 使用 copy关键字  所以 block变量是指向堆block的
    zyy.block = [^{
        NSLog(@"%@",blockzyy.name);
    } copy];  // copy 操作 这时候是2根指针  mrc下的 __block 变量 不会对 zyy对象进行retain
    NSLog(@"zyycount==%zd",zyy.retainCount);  // 1
    //zyy.block();
    NSLog(@"%@",[zyy.block class]);
    [zyy release];
    
}
int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
      
        test3();
       // return UIApplicationMain(argc, argv, nil, appDelegateClassName);
    }
    
}
