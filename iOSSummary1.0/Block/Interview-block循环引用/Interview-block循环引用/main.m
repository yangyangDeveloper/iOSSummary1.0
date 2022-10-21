//
//  main.m
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZYYPerson.h"

/*
 默认
 struct __main_block_impl_0 {
   struct __block_impl impl;
   struct __main_block_desc_0* Desc;
   ZYYPerson *__strong zyy;
   __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, ZYYPerson *__strong _zyy, int flags=0) : zyy(_zyy) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 
 
 使用weak
 struct __main_block_impl_0 {
   struct __block_impl impl;
   struct __main_block_desc_0* Desc;
   ZYYPerson *__weak weakZyy;
   __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, ZYYPerson *__weak _weakZyy, int flags=0) : weakZyy(_weakZyy) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 */


// ARC 解决循环引用 可以使用
// 1、__weak
// 2、__unsafe_unretained
// 3、__block 加block调用 加对象设置nil 这种方式

void test() {
    
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    
    // __weak ZYYPerson *weakZyy = zyy;
    __unsafe_unretained ZYYPerson *unsafe_unretainedZyy = zyy;
   // typeof(type)是个编译器特性 就是你不需要关心 zyy是什么类型  用它原本的类型 就行  他原本类型就是 ZYYPerson *   所以两行代码等价
   // __weak typeof(zyy) weakZyy = zyy;
   
   // __weak 和 __unsafe_unretained
   // 都是弱指针 不进行 retain
   // 当对象释放后 weak修饰的指针变量会从一个地址 变成nil
   // __unsafe_unretained 修饰的指针变量 里面的值还是 地址 也即是指针存储的地址值不会变  如果再次去访问  不安全  但是他性能高呀 不需要在对象释放时候 遍历所有weak表 置为nil
    
   
    zyy.name = @"zyy";
    zyy.block = ^{
        NSLog(@"%@",unsafe_unretainedZyy.name);
    };
    zyy.block();
}

// 加 __block 形成3脚  讲第二根指针设置为nil   zyy其实是 __block变量里面的 zyy指针 把这根指针设置为nil  就断开了
// 缺点是 block必须执行 而且第二个指针需要设置nil  否则内存不会释放 一直内存泄露
void test2() {
    __block ZYYPerson *zyy = [[ZYYPerson alloc] init];
    zyy.name = @"zyy";
    zyy.block = ^{
        NSLog(@"%@",zyy.name);
        zyy = nil;
    };
    zyy.block();
}

void test3() {
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    __weak typeof(zyy) weakZyy = zyy;
    
    zyy.name = @"zyy";
    zyy->_city = @"beijing";
    zyy.block = ^{
        __strong typeof(weakZyy) strongZyy = weakZyy;
        NSLog(@"%@",strongZyy->_city); // 这种用法很危险  如果 weakZyy 是nil了 那么 strongZyy 也是nil 那么后面 nil->_city 就崩溃了 而其他的 都是msgsend发送消息如果会 nil 就自动return了 不会崩溃
        
        NSLog(@"%@",strongZyy.name);
    };
    zyy.block();
}


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {

        //test3();
        //NSLog(@"111111");
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

