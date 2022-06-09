//
//  M5.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/11/27.
//

#ifndef M5_h
#define M5_h


#endif /* M5_h */



int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        Car *car = [[Car alloc] init];
        __block Car *ca = car;
        NSLog(@"ca.retainCount==%ld",ca.retainCount);
        void(^yang)(void) = ^{
            NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
        };
        [ca release];
        yang();
        [yang release];
    }
    return 0;
}


__block NSObject *obj = [NSObject new];
void(^__weak yang)(void) = ^{
    NSLog(@"%@",obj);
};
yang();

struct __Block_byref_obj_0 {
  void *__isa;
__Block_byref_obj_0 *__forwarding;
 int __flags;
 int __size;
 void (*__Block_byref_id_object_copy)(void*, void*);
 void (*__Block_byref_id_object_dispose)(void*);
 NSObject *__strong obj;
};

__attribute__((__blocks__(byref))) __Block_byref_obj_0 obj = {(void*)0,(__Block_byref_obj_0 *)&obj, 33554432, sizeof(__Block_byref_obj_0), __Block_byref_id_object_copy_131, __Block_byref_id_object_dispose_131, ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("new"))};


void(^__attribute__((objc_ownership(weak))) yang)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_obj_0 *)&obj, 570425344));


static void __Block_byref_id_object_copy_131(void *dst, void *src) {
 _Block_object_assign((char*)dst + 40, *(void * *) ((char*)src + 40), 131);
}
static void __Block_byref_id_object_dispose_131(void *src) {
 _Block_object_dispose(*(void * *) ((char*)src + 40), 131);
}



static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    _Block_object_assign((void*)&dst->obj, (void*)src->obj, 8/*BLOCK_FIELD_IS_BYREF*/);
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    _Block_object_dispose((void*)src->obj, 8/*BLOCK_FIELD_IS_BYREF*/);
}
