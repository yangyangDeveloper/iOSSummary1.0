//
//  M1.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/11/27.
//

#ifndef M1_h
#define M1_h


__block int a = 30;
void(^block1)(void) = ^ {
    NSLog(@"%d",a);
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_a_0 *a; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_a_0 *_a, int flags=0) : a(_a->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

struct __Block_byref_a_0 {
  void *__isa;
__Block_byref_a_0 *__forwarding;
 int __flags;
 int __size;
 int a;
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};


static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    _Block_object_assign((void*)&dst->a, (void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    _Block_object_dispose((void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);
}


NSObject *ojc = [NSObject new];
__block NSObject *obj = ojc;
NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ojc)));
NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(obj)));
void(^__weak yang)(void) = ^{
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ojc)));
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(obj)));
};
yang();

void(^yang2)(void) = ^{
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ojc)));
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(obj)));
};
yang2();


NSObject *yang = [NSObject new];
NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
void(^__weak block1)(void)= ^ {
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
};
block1();
void(^block2)(void)= ^ {
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
};
block2();
void(^block3)(void)= [block1 copy];
block3();


NSObject *yang = [NSObject new];
NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
void(^__weak block1)(void)= ^ {
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
};
block1();
void(^block2)(void)= ^ {
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
};
block2();
void(^block3)(void)= [block1 copy];
block3();




struct __Block_byref_age_0 {
  void *__isa;
__Block_byref_age_0 *__forwarding;
 int __flags;
 int __size;
 void (*__Block_byref_id_object_copy)(void*, void*);
 void (*__Block_byref_id_object_dispose)(void*);
 NSObject *age;
};

