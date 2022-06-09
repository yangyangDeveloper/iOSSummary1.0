//
//  M0.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/11/27.
//

#ifndef M0_h
#define M0_h


#endif /* M0_h */
@interface Car : NSObject
@end

@implementation Car
- (void)dealloc {
    [super dealloc];
    NSLog(@"car delloc");
}
@end

// 栈
- (void)t1 {
    Car *car = [[Car alloc] init];
    __block Car *ca =  car;
    NSLog(@"ca.retainCount==%ld",ca.retainCount);
    NSLog(@"car.retainCount==%ld",car.retainCount);
    void(^yang)(void) = ^{
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(car)));
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
    };
   yang();
}
2021-11-27 16:13:50.311250+0800 03_内存管理[65778:39000542] ca.retainCount==1
2021-11-27 16:13:50.311776+0800 03_内存管理[65778:39000542] car.retainCount==1
2021-11-27 16:13:50.311928+0800 03_内存管理[65778:39000542] 1
2021-11-27 16:13:50.312048+0800 03_内存管理[65778:39000542] 1



// 堆
- (void)t1 {
    Car *car = [[Car alloc] init];
    __block Car *ca =  car;
    NSLog(@"ca.retainCount==%ld",ca.retainCount);
    NSLog(@"car.retainCount==%ld",car.retainCount);
    void(^yang)(void) = [^{
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(car)));
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
    } copy];
   yang();
}
2021-11-27 16:12:36.622377+0800 03_内存管理[65422:38997358] ca.retainCount==1
2021-11-27 16:12:36.622976+0800 03_内存管理[65422:38997358] car.retainCount==1
2021-11-27 16:12:36.623090+0800 03_内存管理[65422:38997358] 2
2021-11-27 16:12:36.623224+0800 03_内存管理[65422:38997358] 2


ARC

// 栈
- (void)arc1 {
    Car *car = [[Car alloc] init];
    __block Car *ca =  car;
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(car)));
    void(^__weak yang)(void) = ^{
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(car)));
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
    };
    yang();
}

2021-11-27 16:09:17.142534+0800 04-捕获变量[64428:38988943] 2
2021-11-27 16:09:17.143129+0800 04-捕获变量[64428:38988943] 2
2021-11-27 16:10:02.225314+0800 04-捕获变量[64428:38988943] 3
2021-11-27 16:10:02.225576+0800 04-捕获变量[64428:38988943] 3
2021-11-27 16:10:02.225839+0800 04-捕获变量[64428:38988943] car delloc


// 堆
- (void)arc2 {
    Car *car = [[Car alloc] init];
    __block Car *ca =  car;
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(car)));
    void(^yang)(void) = ^{
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(car)));
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(ca)));
    };
    yang();
}
2021-11-27 16:10:27.150239+0800 04-捕获变量[64781:38991881] 2
2021-11-27 16:10:27.150687+0800 04-捕获变量[64781:38991881] 2
2021-11-27 16:10:31.608705+0800 04-捕获变量[64781:38991881] 4
2021-11-27 16:10:31.608888+0800 04-捕获变量[64781:38991881] 4
2021-11-27 16:10:31.609187+0800 04-捕获变量[64781:38991881] car delloc


void *_Block_copy(const void *arg) {
    struct Block_layout *aBlock;

    if (!arg) return NULL;
    
    // The following would be better done as a switch statement
    aBlock = (struct Block_layout *)arg;
    if (aBlock->flags & BLOCK_NEEDS_FREE) {
        // latches on high
        latching_incr_int(&aBlock->flags);
        return aBlock;
    }
    else if (aBlock->flags & BLOCK_IS_GLOBAL) {
        return aBlock;  // gbobal 直接返回
    }
    else {
        // Its a stack block.  Make a copy.    // 如果是栈block  进行copy
        size_t size = Block_size(aBlock);
        
        // 1、 malloc分配内存区域
        struct Block_layout *result = (struct Block_layout *)malloc(size);
        if (!result) return NULL;
        
        // 2、 然后复制size大小的数据到新的block中   memmove是把一块数据 全部一一复制   result 是堆上新区间首地址  aBlock是老区间首地址
        memmove(result, aBlock, size); // bitcopy first
#if __has_feature(ptrauth_calls)
        // Resign the invoke pointer as it uses address authentication.
        result->invoke = aBlock->invoke;

#if __has_feature(ptrauth_signed_block_descriptors)
        if (aBlock->flags & BLOCK_SMALL_DESCRIPTOR) {
            uintptr_t oldDesc = ptrauth_blend_discriminator(
                    &aBlock->descriptor,
                    _Block_descriptor_ptrauth_discriminator);
            uintptr_t newDesc = ptrauth_blend_discriminator(
                    &result->descriptor,
                    _Block_descriptor_ptrauth_discriminator);

            result->descriptor =
                    ptrauth_auth_and_resign(aBlock->descriptor,
                                            ptrauth_key_asda, oldDesc,
                                            ptrauth_key_asda, newDesc);
        }
#endif
#endif
        // reset refcount
        result->flags &= ~(BLOCK_REFCOUNT_MASK|BLOCK_DEALLOCATING);    // XXX not needed
        
        //将flag设置为BLOCK_NEEDS_FREE Malloc   将flag加2，表示引用计数加1
        result->flags |= BLOCK_NEEDS_FREE | 2;  // logical refcount 1
        
        // 处理其他数据
        _Block_call_copy_helper(result, aBlock);
        
        
        // Set isa last so memory analysis tools see a fully-initialized object.
        // isa置为_NSConcreteMallocBlock
        result->isa = _NSConcreteMallocBlock;
        
        // 返回帮我们copy的新的堆block
        return result;
    }
}


void _Block_object_assign(void *destArg, const void *object, const int flags) {
    const void **dest = (const void **)destArg;
    switch (os_assumes(flags & BLOCK_ALL_COPY_DISPOSE_FLAGS)) {
      case BLOCK_FIELD_IS_OBJECT:   // 3
        /*******
        id object = ...;
        [^{ object; } copy];
        ********/

        _Block_retain_object(object);
        *dest = object;
        break;

      case BLOCK_FIELD_IS_BLOCK:
        /*******
        void (^object)(void) = ...;
        [^{ object; } copy];
        ********/

        *dest = _Block_copy(object);
        break;
    
      case BLOCK_FIELD_IS_BYREF | BLOCK_FIELD_IS_WEAK:
      case BLOCK_FIELD_IS_BYREF:   // BLOCK_FIELD_IS_BYREF    =  8,
        /*******
         // copy the onstack __block container to the heap
         // Note this __weak is old GC-weak/MRC-unretained.
         // ARC-style __weak is handled by the copy helper directly.
         __block ... x;
         __weak __block ... x;
         [^{ x; } copy];
         ********/

        *dest = _Block_byref_copy(object);
        break;
        
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_OBJECT:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_BLOCK:
        /*******
         // copy the actual field held in the __block container
         // Note this is MRC unretained __block only.
         // ARC retained __block is handled by the copy helper directly.
         __block id object;
         __block void (^object)(void);
         [^{ object; } copy];
         ********/

        *dest = object;
        break;

      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_OBJECT | BLOCK_FIELD_IS_WEAK:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_BLOCK  | BLOCK_FIELD_IS_WEAK:
        /*******
         // copy the actual field held in the __block container
         // Note this __weak is old GC-weak/MRC-unretained.
         // ARC-style __weak is handled by the copy helper directly.
         __weak __block id object;
         __weak __block void (^object)(void);
         [^{ object; } copy];
         ********/

        *dest = object;
        break;

      default:
        break;
    }
}
