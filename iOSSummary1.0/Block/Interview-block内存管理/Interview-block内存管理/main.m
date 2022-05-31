//
//  main.m
//  Interview-block内存管理
//
//  Created by zhangyangyang on 2022/2/9.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

struct __Block_byref_object_0 {
    void *__isa;
    struct __Block_byref_object_0 *__forwarding;
    int __flags;
    int __size;
    void (*__Block_byref_id_object_copy)(void*, void*);
    void (*__Block_byref_id_object_dispose)(void*);
    NSObject *__strong object;
};

// dst 是 __Block_byref_object_0的地址  + 40 就是找到 NSObject *__strong object 的地址   传递进去  让assign函数判断  object函数 对 NSObject对象到底是强还是弱引用  很明显这里捕获的是__strong 所以是强引用
// __Block_byref_id_object_copy_131 函数 是 __Block_byref_object_0 copy时候触发的   而block的copy会触发 __block变量的copy
// 这里其实就是确定 第二根指针到底是强还是弱
static void __Block_byref_id_object_copy_131(void *dst, void *src) {
 _Block_object_assign((char*)dst + 40, *(void * *) ((char*)src + 40), 131);
}

static void __Block_byref_id_object_dispose_131(void *src) {
 _Block_object_dispose(*(void * *) ((char*)src + 40), 131);
}



// 这一对函数其实是block自己的   block copy时候会调用  dst 是block的首地址
// 这里其实就是确定 第一根指针的过程 到底是强还是弱
//static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
//    _Block_object_assign((void*)&dst->object, (void*)src->object, 8/*BLOCK_FIELD_IS_BYREF*/);
//}
//
//void __main_block_dispose_0(struct __main_block_impl_0*src) {
//    _Block_object_dispose((void*)src->object, 8/*BLOCK_FIELD_IS_BYREF*/);
//}



struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    struct __Block_byref_object_0 *object; // by ref
};

struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
};



typedef void(^ZYYBlock)(void);

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        
        //__block int a = 10;
        __block NSObject *object = [[NSObject alloc] init];
        ZYYBlock block = ^{
            NSLog(@"%p",object);
            //NSLog(@"%d", a);
        };
        block();
        
        struct __main_block_impl_0 *blockImpl = (__bridge struct __main_block_impl_0 *)block;
        
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}



// struct __main_block_impl_0 {
//   struct __block_impl impl;
//   struct __main_block_desc_0* Desc;
//   NSObject *__strong object;  //  这里捕获的 是 strong 就是强 捕获的weak 就是弱
//   __Block_byref_a_0 *a; // by ref  直接强引用
// };
//
//  copy调用 __main_block_copy_0函数
// static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
//
//      根据捕获的修饰符 是__strong  还是__weak  来决定是否强引用
//     _Block_object_assign((void*)&dst->object, (void*)src->object, 3/*BLOCK_FIELD_IS_OBJECT*/);
//
//      // 对__block变量直接强引用
//     _Block_object_assign((void*)&dst->a, (void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);
//  }


