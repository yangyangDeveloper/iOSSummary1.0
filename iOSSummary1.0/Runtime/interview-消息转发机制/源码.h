//
//  源码.h
//  interview-消息转发机制
//
//  Created by zhangyangyang on 2022/4/24.
//

IMP lookUpImpOrForward(Class cls, SEL sel, id inst,
                       bool initialize, bool cache, bool resolver) {
    
    
    runtimeLock.lock();
    // 第一阶段 消息发送阶段
    。。。
    
    // 第二阶段，动态方法解析阶段

    // 来到这里，说明进入第三阶段，消息转发阶段
       imp = (IMP)_objc_msgForward_impcache;
       cache_fill(cls, sel, imp, inst);
    
    runtimeLock.unlock();
    
    return imp;
}


STATIC_ENTRY __objc_msgForward_impcache

// No stret specialization.
b    __objc_msgForward

END_ENTRY __objc_msgForward_impcache

    
ENTRY __objc_msgForward

adrp    x17, __objc_forward_handler@PAGE
// 这里进去之后，不开源了
ldr    p17, [x17, __objc_forward_handler@PAGEOFF]
TailCallFunctionPointer x17
... 还有很多代码



跟到 ___forwarding___之后就不开源了

伪代码
// 两个参数：前者为被转发消息的栈指针 IMP ，后者为是否返回结构体
int __forwarding__(void *frameStackPointer, int isStret) {
   id receiver = *(id *)frameStackPointer;
   SEL sel = *(SEL *)(frameStackPointer + 8);
   const char *selName = sel_getName(sel);
   Class receiverClass = object_getClass(receiver);
   
   // 调用 forwardingTargetForSelector:
   // 进入 备援接收 主要步骤
   if (class_respondsToSelector(receiverClass, @selector(forwardingTargetForSelector:))) {
       // 获得方法签名
       id forwardingTarget = [receiver forwardingTargetForSelector:sel];
       // 判断返回类型是否正确
       if (forwardingTarget && forwardingTarget != receiver) {
           if (isStret == 1) {
               int ret;
               objc_msgSend_stret(&ret,forwardingTarget, sel, ...);
               return ret;
           }
           return objc_msgSend(forwardingTarget, sel, ...);
       }
   }
   
   // 僵尸对象
   const char *className = class_getName(receiverClass);
   const char *zombiePrefix = "_NSZombie_";
   size_t prefixLen = strlen(zombiePrefix); // 0xa
   if (strncmp(className, zombiePrefix, prefixLen) == 0) {
       CFLog(kCFLogLevelError,
             @"*** -[%s %s]: message sent to deallocated instance %p",
             className + prefixLen,
             selName,
             receiver);
       <breakpoint-interrupt>
   }
   
   // 调用 methodSignatureForSelector 获取方法签名后再调用 forwardInvocation
   // 进入消息转发系统
   if (class_respondsToSelector(receiverClass, @selector(methodSignatureForSelector:))) {
       NSMethodSignature *methodSignature = [receiver methodSignatureForSelector:sel];
       // 判断返回类型是否正确
       if (methodSignature) {
           BOOL signatureIsStret = [methodSignature _frameDescriptor]->returnArgInfo.flags.isStruct;
           if (signatureIsStret != isStret) {
               CFLog(kCFLogLevelWarning ,
                     @"*** NSForwarding: warning: method signature and compiler disagree on struct-return-edness of '%s'.  Signature thinks it does%s return a struct, and compiler thinks it does%s.",
                     selName,
                     signatureIsStret ? "" : not,
                     isStret ? "" : not);
           }
           if (class_respondsToSelector(receiverClass, @selector(forwardInvocation:))) {
               // 传入消息的全部细节信息
               NSInvocation *invocation = [NSInvocation _invocationWithMethodSignature:methodSignature frame:frameStackPointer];
               
               [receiver forwardInvocation:invocation];
               
               void *returnValue = NULL;
               [invocation getReturnValue:&value];
               return returnValue;
           } else {
               CFLog(kCFLogLevelWarning ,
                     @"*** NSForwarding: warning: object %p of class '%s' does not implement forwardInvocation: -- dropping message",
                     receiver,
                     className);
               return 0;
           }
       }
   }
   
   SEL *registeredSel = sel_getUid(selName);
   
   // selector 是否已经在 Runtime 注册过
   if (sel != registeredSel) {
       CFLog(kCFLogLevelWarning ,
             @"*** NSForwarding: warning: selector (%p) for message '%s' does not match selector known to Objective C runtime (%p)-- abort",
             sel,
             selName,
             registeredSel);
   }  // doesNotRecognizeSelector，主动抛出异常
   // 表明未能得到处理
   else if (class_respondsToSelector(receiverClass,@selector(doesNotRecognizeSelector:))) {
       [receiver doesNotRecognizeSelector:sel];
   }
   else {
       CFLog(kCFLogLevelWarning ,
             @"*** NSForwarding: warning: object %p of class '%s' does not implement doesNotRecognizeSelector: -- abort",
             receiver,
             className);
   }
   
   // The point of no return.
   kill(getpid(), 9);
}



在源码中forwardingTargetForSelector系统默认返回nil

+ (id)forwardingTargetForSelector:(SEL)sel {
    return nil;
}

- (id)forwardingTargetForSelector:(SEL)sel {
    return nil;
}

