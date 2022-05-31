//
//  main1.cpp
//  Interview-block捕获变量
//
//  Created by zhangyangyang on 2022/2/8.
//


// 局部变量 auto类型  传递的是值

struct __test_block_impl_0 {
  struct __block_impl impl;
  struct __test_block_desc_0* Desc;
  int a;
  __test_block_impl_0(void *fp, struct __test_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __test_block_func_0(struct __test_block_impl_0 *__cself) {
   int a = __cself->a; // bound by copy
   NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_main_888159_mi_0, a);
}

static struct __test_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __test_block_desc_0_DATA = { 0, sizeof(struct __test_block_impl_0)};


void test() {
    int a = 10;

    // block 内部 接受的是a 的值
    void(*block)(void) = ((void (*)())&__test_block_impl_0((void *)__test_block_func_0, &__test_block_desc_0_DATA, a));

    a = 20;
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
}

int main(int argc, char * argv[]) {

    test();

    return 0;
}
static struct IMAGE_INFO { unsigned version; unsigned flag; } _OBJC_IMAGE_INFO = { 0, 2 };


