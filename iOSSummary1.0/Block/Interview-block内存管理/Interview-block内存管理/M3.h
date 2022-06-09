//
//  M3.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/11/27.
//

#ifndef M3_h
#define M3_h


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        
        __block int age = 10;
        
        NSObject *yang = [NSObject new];
        
        __weak NSObject *yang2 = yang;
        
        __block NSObject *yang3 = [NSObject new];
        
        __block __weak NSObject *yang4 = [NSObject new];
       
        void(^yangblock)(void) = ^{
            NSLog(@"%d", age);
            NSLog(@"%@", yang);
            NSLog(@"%@", yang2);
            NSLog(@"%@", yang3);
            NSLog(@"%@", yang4);
        };
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}




struct __Block_byref_age_0 {
  void *__isa;
__Block_byref_age_0 *__forwarding;
 int __flags;
 int __size;
 int age;
};

struct __Block_byref_yang3_1 {
  void *__isa;
__Block_byref_yang3_1 *__forwarding;
 int __flags;
 int __size;
 void (*__Block_byref_id_object_copy)(void*, void*);
 void (*__Block_byref_id_object_dispose)(void*);
 NSObject *__strong yang3;
};

struct __Block_byref_yang4_2 {
  void *__isa;
__Block_byref_yang4_2 *__forwarding;
 int __flags;
 int __size;
 void (*__Block_byref_id_object_copy)(void*, void*);
 void (*__Block_byref_id_object_dispose)(void*);
 NSObject *__weak yang4;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  NSObject *__strong yang;
  NSObject *__weak yang2;
  __Block_byref_age_0 *age; // by ref
  __Block_byref_yang3_1 *yang3; // by ref
  __Block_byref_yang4_2 *yang4; // by ref
    
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, NSObject *__strong _yang, NSObject *__weak _yang2, __Block_byref_age_0 *_age, __Block_byref_yang3_1 *_yang3, __Block_byref_yang4_2 *_yang4, int flags=0) : yang(_yang), yang2(_yang2), age(_age->__forwarding), yang3(_yang3->__forwarding), yang4(_yang4->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_age_0 *age = __cself->age; // bound by ref
  __Block_byref_yang3_1 *yang3 = __cself->yang3; // bound by ref
  __Block_byref_yang4_2 *yang4 = __cself->yang4; // bound by ref
  NSObject *__strong yang = __cself->yang; // bound by copy
  NSObject *__weak yang2 = __cself->yang2; // bound by copy
}
