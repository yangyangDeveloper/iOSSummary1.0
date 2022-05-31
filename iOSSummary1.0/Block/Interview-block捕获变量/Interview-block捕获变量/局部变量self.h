//
//  person.h
//  Interview-block捕获变量
//
//  Created by zhangyangyang on 2022/2/8.
//

// 会捕获self

struct __ZYYPerson__test_block_impl_0 {
  struct __block_impl impl;
  struct __ZYYPerson__test_block_desc_0* Desc;
  ZYYPerson *self;
  __ZYYPerson__test_block_impl_0(void *fp, struct __ZYYPerson__test_block_desc_0 *desc, ZYYPerson *_self, int flags=0) : self(_self) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __ZYYPerson__test_block_func_0(struct __ZYYPerson__test_block_impl_0 *__cself) {
    ZYYPerson *self = __cself->self; // bound by copy
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_ZYYPerson_a5158d_mi_0,self);
}


static void __ZYYPerson__test_block_copy_0(struct __ZYYPerson__test_block_impl_0*dst, struct __ZYYPerson__test_block_impl_0*src) {_Block_object_assign((void*)&dst->self, (void*)src->self, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __ZYYPerson__test_block_dispose_0(struct __ZYYPerson__test_block_impl_0*src) {_Block_object_dispose((void*)src->self, 3/*BLOCK_FIELD_IS_OBJECT*/);}


static struct __ZYYPerson__test_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __ZYYPerson__test_block_impl_0*, struct __ZYYPerson__test_block_impl_0*);
  void (*dispose)(struct __ZYYPerson__test_block_impl_0*);
} __ZYYPerson__test_block_desc_0_DATA = { 0, sizeof(struct __ZYYPerson__test_block_impl_0), __ZYYPerson__test_block_copy_0, __ZYYPerson__test_block_dispose_0};


static void _I_ZYYPerson_test(ZYYPerson * self, SEL _cmd) {
    void(*block)(void) = ((void (*)())&__ZYYPerson__test_block_impl_0((void *)__ZYYPerson__test_block_func_0, &__ZYYPerson__test_block_desc_0_DATA, self, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
}
