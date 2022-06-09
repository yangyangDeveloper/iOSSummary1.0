//
//  M2.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/11/27.
//

#ifndef M2_h
#define M2_h

NSObject *og = [NSObject new];
void(^block1)(void) = ^ {
    NSLog(@"%@",og);
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  NSObject *og;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, NSObject *_og, int flags=0) : og(_og) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};


static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    _Block_object_assign((void*)&dst->og, (void*)src->og, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    _Block_object_dispose((void*)src->og, 3/*BLOCK_FIELD_IS_OBJECT*/);}
