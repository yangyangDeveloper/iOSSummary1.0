//
//  源码.h
//  interview-消息发送机制
//
//  Created by zhangyangyang on 2022/4/24.
//

IMP _class_lookupMethodAndLoadCache3(id obj, SEL sel, Class cls)
{
    
    return lookUpImpOrForward(cls, sel, obj,
                              YES/*initialize*/, NO/*cache*/, YES/*resolver*/);
}


IMP lookUpImpOrForward(Class cls, SEL sel, id inst,
                       bool initialize, bool cache, bool resolver)
{
    IMP imp = nil;
    bool triedResolver = NO; //是否动态解析过的标记
    runtimeLock.assertUnlocked();
    if (cache) {
        imp = cache_getImp(cls, sel);
        if (imp) return imp;
    }
    runtimeLock.lock();
    checkIsKnownClass(cls);

    if (!cls->isRealized()) {
        realizeClass(cls);
    }

    if (initialize  &&  !cls->isInitialized()) {
        runtimeLock.unlock();
        _class_initialize (_class_getNonMetaClass(cls, inst));
        runtimeLock.lock();
    }

    
 retry:
    runtimeLock.assertLocked();

    // 这里先查缓存，虽然前面汇编里面已经查过了。但是有可能动态添加，导致缓存有更新
    imp = cache_getImp(cls, sel);
    //如果查到了，就直接跳转到最后
    if (imp) goto done;
    //来到这里，说明缓存没有
    // Try this class's method lists.
    { // 查找方法列表
        Method meth = getMethodNoSuper_nolock(cls, sel);
        if (meth) {
            log_and_fill_cache(cls, meth->imp, sel, inst, cls);
            imp = meth->imp;
            //如果查到了，就直接跳转到最后
            goto done;
        }
    }

    // Try superclass caches and method lists.
    { //查找父类的缓存和方法列表
        unsigned attempts = unreasonableClassCount();
        // for循环层层向上找
        for (Class curClass = cls->superclass;
             curClass != nil;
             curClass = curClass->superclass)
        {
            // Halt if there is a cycle in the superclass chain.
            if (--attempts == 0) {
                _objc_fatal("Memory corruption in class list.");
            }
            
            // Superclass cache.
            // 父类缓存
            imp = cache_getImp(curClass, sel);
            if (imp) {
                if (imp != (IMP)_objc_msgForward_impcache) {
                    // 如果父类缓存有，也要缓存一份到自己的缓存中
                    log_and_fill_cache(cls, imp, sel, inst, curClass);
                    //跳转到最后
                    goto done;
                }
                else {
                    break;
                }
            }
            
            // Superclass method list. 查找父类方法列表
            Method meth = getMethodNoSuper_nolock(curClass, sel);
            if (meth) {
                /// 如果父类方法列表有，也要缓存一份到自己的缓存中
                log_and_fill_cache(cls, meth->imp, sel, inst, curClass);
                imp = meth->imp;
                //如果查到了，就跳转到最后
                goto done;
            }
        }
    }

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

    // No implementation found, and method resolver didn't help.
    // Use forwarding.
    
    // 来到这里，说明进入第三阶段，消息转发阶段
    imp = (IMP)_objc_msgForward_impcache;
    cache_fill(cls, sel, imp, inst);

 done:
    runtimeLock.unlock();
    // 返回方法地址
    return imp;
}
