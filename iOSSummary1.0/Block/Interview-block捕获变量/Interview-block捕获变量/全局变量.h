//
//  全局变量.h
//  Interview-block捕获变量
//
//  Created by zhangyangyang on 2022/2/8.
//

// 全局变量 block不用去捕获 直接去访问

int age_ = 10;
static int height_ = 20;

struct __test2_block_impl_0 {
  struct __block_impl impl;
  struct __test2_block_desc_0* Desc;
  __test2_block_impl_0(void *fp, struct __test2_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __test2_block_func_0(struct __test2_block_impl_0 *__cself) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_main_994956_mi_2, age_);
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_main_994956_mi_3, height_);
}

static struct __test2_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __test2_block_desc_0_DATA = { 0, sizeof(struct __test2_block_impl_0)};

void test2() {
    void(*block)(void) = ((void (*)())&__test2_block_impl_0((void *)__test2_block_func_0, &__test2_block_desc_0_DATA));

    age_ = 20;
    height_ = 20;
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
}

int main(int argc, char * argv[]) {
    test2();
    return 0;
}


