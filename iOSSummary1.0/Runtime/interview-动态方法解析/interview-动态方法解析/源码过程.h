//
//  源码过程.h
//  interview-动态方法解析
//
//  Created by zhangyangyang on 2022/4/24.
//

IMP lookUpImpOrForward(Class cls, SEL sel, id inst,
                       bool initialize, bool cache, bool resolver) {
    
    
    runtimeLock.lock();
    // 第一阶段 消息发送阶段
    。。。
    
    // 来到这里，进入第二阶段，动态方法解析阶段,而且要求没有动态解析过
      if (resolver  &&  !triedResolver) {
          runtimeLock.unlock();
          _class_resolveMethod(cls, sel, inst);
          runtimeLock.lock();
          // Don't cache the result; we don't hold the lock so it may have
          // changed already. Re-do the search from scratch instead.
          triedResolver = YES; //动态解析过，标记设为YES
          // 回到查找缓存的地方开始查找，缓存中没有加过，这次去查找，可以再方法列表中查到
          goto retry;
      }
    
    。。。。
    
    // 来到这里，说明进入第三阶段，消息转发阶段
       imp = (IMP)_objc_msgForward_impcache;
       cache_fill(cls, sel, imp, inst);
    
    runtimeLock.unlock();
    
    return imp;
}



// 动态方法解析阶段
void _class_resolveMethod(Class cls, SEL sel, id inst)
{
    if (! cls->isMetaClass()) { //如果不是元类对象
        // try [cls resolveInstanceMethod:sel]
        _class_resolveInstanceMethod(cls, sel, inst);
    }
    else { // 是元类对象
        // try [nonMetaClass resolveClassMethod:sel]
        // and [cls resolveInstanceMethod:sel]
        _class_resolveClassMethod(cls, sel, inst);
        if (!lookUpImpOrNil(cls, sel, inst,
                            NO/*initialize*/, YES/*cache*/, NO/*resolver*/))
        {
            _class_resolveInstanceMethod(cls, sel, inst);
        }
    }
}


// 系统默认的resolveClassMethod和resolveInstanceMethod默认返回NO

+ (BOOL)resolveClassMethod:(SEL)sel {
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
}



