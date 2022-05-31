//
//  数据结构.h
//  Interview-block数据结构
//
//  Created by zhangyangyang on 2022/2/8.
//

/*
    1、 匿名函数
    2、 block类型强制转化
    3、 捕获 auto变量  传入的是地址 还是 值
 */

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};


static struct __ViewController__viewDidLoad_block_desc_2 {
  size_t reserved;
  size_t Block_size;
};


struct __ViewController__viewDidLoad_block_impl_2 {
  struct __block_impl impl;
  struct __ViewController__viewDidLoad_block_desc_2* Desc;
  int a;
};


//  block执行逻辑的函数   就是那个匿名函数
static void __ViewController__viewDidLoad_block_func_2(struct __ViewController__viewDidLoad_block_impl_2 *__cself) {
    int a = __cself->a; // bound by copy
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_ViewController_66b9c4_mi_2,a);
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_ViewController_66b9c4_mi_3);
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_ViewController_66b9c4_mi_4);
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_zm_558cwfjs099fbm2r8kxg8wt00000gt_T_ViewController_66b9c4_mi_5);
}

// block对象结构体
struct __ViewController__viewDidLoad_block_impl_2 {
  struct __block_impl impl;
  struct __ViewController__viewDidLoad_block_desc_2* Desc;
  int a;
  __ViewController__viewDidLoad_block_impl_2(void *fp, struct __ViewController__viewDidLoad_block_desc_2 *desc, int _a, int flags=0) : a(_a) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};


static struct __ViewController__viewDidLoad_block_desc_2 {
  size_t reserved;
  size_t Block_size;
} __ViewController__viewDidLoad_block_desc_2_DATA = { 0, sizeof(struct __ViewController__viewDidLoad_block_impl_2)};


static void _I_ViewController_viewDidLoad(ViewController * self, SEL _cmd) {
    int a = 10;
    // 定义block变量
    void (*myblock)(void) = &__ViewController__viewDidLoad_block_impl_2(__ViewController__viewDidLoad_block_func_2, &__ViewController__viewDidLoad_block_desc_2_DATA, a));
    
    // 执行block
    //((void (*)(__block_impl *))((__block_impl *)myblock)->FuncPtr)((__block_impl *)myblock);
    myblock->FuncPtr(myblock);
    
    
    /*
      类型强转
      ((__block_impl *)myblock)
      block类型是__ViewController__viewDidLoad_block_impl_2 强转为 __block_impl 类型
      因为 __ViewController__viewDidLoad_block_impl_2 结构体 和 __block_impl 结构体的首地址相同
     
     struct __ViewController__viewDidLoad_block_impl_2 {
       struct __block_impl impl;
       ....
     }
      因为impl 是当前 __ViewController__viewDidLoad_block_impl_2 第一个成员  说明impl的内存地址 就是 __ViewController__viewDidLoad_block_impl_2的内存地址
      
     
    */
    
   
    
}



