//
//  main.m
//  Interview-_block修饰符
//
//  Created by zhangyangyang on 2022/2/9.
//

#import <Foundation/Foundation.h>


typedef void(^ZYYBlock)(void);

/*
 
 struct __main_block_impl_0 {
   struct __block_impl impl;
   struct __main_block_desc_0* Desc;
   NSMutableArray *__strong array;
   __Block_byref_obj_1 *obj; // by ref
   __Block_byref_a_0 *a; // by ref
 };
 
 struct __Block_byref_obj_1 {
   void *__isa;
 __Block_byref_obj_1 *__forwarding;
  int __flags;
  int __size;
  void (*__Block_byref_id_object_copy)(void*, void*);
  void (*__Block_byref_id_object_dispose)(void*);
  NSObject *__strong obj;
 };
 
 */

// 0x0000600001d75980 + 24个字节 也就是0x18
// p/x 0x0000600001d75980+0x18  =  0x600001d75998
struct __Block_byref_a_0 {
    void *__isa; // 8
    struct __Block_byref_a_0 *__forwarding;  // 8
    int __flags;  //4
    int __size;   // 4
    int a;  //外界用的a的地址就是这个
};

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(void);
    void (*dispose)(void);
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    struct __Block_byref_a_0 *a; // by ref
};


int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        __block int a = 10 ;
        
        //__block NSObject *obj = [[NSObject alloc] init];
        
        NSMutableArray *array = [NSMutableArray array];
        ZYYBlock block = ^{
//            [array addObject:@"123"];
//            obj = nil;
            NSLog(@"%d", a);
        };
        block();
        
        struct __main_block_impl_0 *blockImpl = (__bridge struct __main_block_impl_0 *)block;
        NSLog(@"%p",&a);
        // 其实这个地址 就是__block变量对象结构体体中成员变量 a 的地址  也就是内部最深层的地址
    }
    return 0;
}
