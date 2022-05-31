//
//  main.m
//  Interview-block捕获对象类型
//
//  Created by zhangyangyang on 2022/2/8.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZYYPerson.h"




// 例子1
/* 出了 {} zyy 对象被释放
int main(int argc, char * argv[]) {
   
    @autoreleasepool {
        
        {
            ZYYPerson *zyy = [[ZYYPerson alloc] init];
            zyy.name = @"zyy";
            [zyy release];
        }
        NSLog(@"-------");
        
    }
    return 0;
}
*/

 // 例子2
 // mrc下 block不会强引用捕获的对象类型 除了括号ZYYPerson对象就会被释放  和ARC下不一样
//typedef void(^ZYYBlock)(void);
//int main(int argc, char * argv[]) {
//
//    @autoreleasepool {
//        ZYYBlock block;
//
//        {
//            ZYYPerson *zyy = [[ZYYPerson alloc] init];
//            zyy.name = @"zyy";
//            block =  ^{
//                NSLog(@"%@",zyy.name);
//            };
//            [zyy release];
//        }
//
//        NSLog(@"-------");
//
//    }
//    return 0;
//}


// 例子3
// 如果想保住ZYYPerson对象的命  可以调用下copy  讲栈block copy到堆
// MRC
// 栈block 是不会保住ZYYPerson对象的命
// 如果是堆block它是有能力保住ZYYPerson对象的命的（也就是他会插入一行 retain代码）  换成ARC 也就是会强引用对象  MRC 没有强引用这个说法 只有 retain保下命 release释放
// 如果堆block释放了 他会自动对ZYYPerson对象进行一次release操作

typedef void(^ZYYBlock)(void);
int main(int argc, char * argv[]) {
   
    @autoreleasepool {
        ZYYBlock block;
        ZYYPerson *zyy;
        
        {
            zyy = [[ZYYPerson alloc] init];
            NSLog(@"block 之前  %zd",zyy.retainCount);  // 1
            zyy.name = @"zyy";
            block =  [^{
                NSLog(@"%@",zyy.name);
            } copy];
            // copy 本质 是 对 [zyy  retain]了  保住了zyy的命   MRC 没有强引用这个说法 之后 retain保下命 release释放
            NSLog(@"block 之后  %zd",zyy.retainCount);   // 2  再次说明 copy操作 本质是对堆block retain了一次 zyy对象  保住了命
            [zyy release];
        }
        NSLog(@"作用域之外 %zd",zyy.retainCount);
        NSLog(@"-------");
        
        block();
        [block release]; // 堆block 不relase  zyy对象就不会被释放  这个release 会自动调用 一次 [zyy release];
        
    }

    return 0;
}

