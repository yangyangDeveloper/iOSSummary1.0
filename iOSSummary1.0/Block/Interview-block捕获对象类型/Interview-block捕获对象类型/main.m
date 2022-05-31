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
        }
        NSLog(@"-------");
        
    }
    return 0;
}
*/

 // 例子2
 //出了第一个{} zyy 对象也没有被释放   如果是MRC 就释放了  mrc下 block不会强引用捕获的对象类型
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
//        }
//
//        NSLog(@"-------");
//
//    }
//    return 0;
//}



// 例子3
// 用了weak之后 ZYYPerson对象提前销毁了  block执行时候 里面就是nil了
//typedef void(^ZYYBlock)(void);
//int main(int argc, char * argv[]) {
//
//   @autoreleasepool {
//       ZYYBlock block;
//
//       {
//           ZYYPerson *zyy = [[ZYYPerson alloc] init];
//           zyy.name = @"zyy";
//           zyy->_city = @"北京";
//
//           //__weak ZYYPerson *weakZyy = zyy;
//           block =  ^{
//               NSLog(@"%@",zyy.name);
//               [zyy dosome];
//           };
//       }
//
//       NSLog(@"-------");
//       block();
//   }
//   return 0;
//}


// 例子4
// 注意一个崩溃问题
// 如果 strongZyy 访问 name的getter方法 如果是nil 就不会发送magsend消息 避免了坏内存访问
// 如果使用strongZyy->_city 会崩溃  

//typedef void(^ZYYBlock)(void);
//int main(int argc, char * argv[]) {
//
//   @autoreleasepool {
//       ZYYBlock block;
//
//       {
//           ZYYPerson *zyy = [[ZYYPerson alloc] init];
//           zyy.name = @"zyy";
//           zyy->_city = @"北京";
//
//           __weak ZYYPerson *weakZyy = zyy;
//           block =  ^{
//               __strong ZYYPerson *strongZyy = weakZyy;
//               // set方法根本没有进去  因为 strongZyy 为nil了
//               NSLog(@"%@",strongZyy.name);
//               NSLog(@"%@",strongZyy->_city);
//               //  dosom不会有输出
//               [strongZyy dosome];
//           };
//       }
//
//       NSLog(@"-------");
//       block();
//
//   }
//   return 0;
//}


//  _Block_object_assign   _Block_object_dispose  一个根据强弱类型对auto变量进行引用计数操作  一个是block释放时候调用的函数



//
//typedef void(^ZYYBlock)(void);
//int main(int argc, char * argv[]) {
//
//    @autoreleasepool {
//
//
//        ZYYPerson *zyy = [[ZYYPerson alloc] init];
//        NSLog(@"%d",CFGetRetainCount((__bridge CFTypeRef)zyy));
//        //  等价代码  auto __strong ZYYPerson *zyy = [[ZYYPerson alloc] init];
//        zyy.name = @"zyy";
//        ZYYBlock zyyblock = ^{
//            NSLog(@"%@",zyy.name);
//            NSLog(@"%d",CFGetRetainCount((__bridge CFTypeRef)zyy));
//        };
//        zyyblock();
//
//    }
//    return 0;
//}


// ARC下 栈block
typedef void(^ZYYBlock)(void);
int main(int argc, char * argv[]) {
  
    @autoreleasepool {
        
        
        ZYYPerson *zyy = [[ZYYPerson alloc] init];
        NSLog(@"%d",CFGetRetainCount((__bridge CFTypeRef)zyy));
        //  等价代码  auto __strong ZYYPerson *zyy = [[ZYYPerson alloc] init];
        zyy.name = @"zyy";
        ^{
            NSLog(@"%@",zyy.name);
            NSLog(@"%d",CFGetRetainCount((__bridge CFTypeRef)zyy));
        }();

        NSLog(@"%@",[^{
            NSLog(@"%@",zyy.name);
            NSLog(@"%d",CFGetRetainCount((__bridge CFTypeRef)zyy));
        } class]);
        
    }
    return 0;
}



/*
 
原本是auto类型的 对象类型 所以捕获进去还是原本类型 ZYYPerson *zyy   默认是__strong 修饰的
如果是staic类型 原本是int类型 捕获进去就是 int *  原本是ZYYPerson *   捕获进去就是 ZYYPerson **  2个星
如果是auto类型  原本是基本数据int  捕获进去就是 int  原本是对象类型ZYYPerson *  捕获进去就是 ZYYPerson *
 
等于有一个 zyy的强指针 指向ZYYPerson对象  只要block在 那么强指针就在 那么ZYYPerson对象 就不会被释放
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  ZYYPerson *zyy;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, ZYYPerson *_zyy, int flags=0) : zyy(_zyy) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
 
 */
