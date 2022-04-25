//
//  ZYYObject.m
//  KVO
//
//  Created by zhangyangyang on 2022/1/15.
//

#import "ZYYObject.h"

@implementation ZYYObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _num = 0;
    }
    return self;
}

- (void)increase {
    _num += 1;
}


/*
   手动触发kvo
   直接修改成员变量的值不会触发kvo  需要我们主动调用 willchange  didchange
 */
- (void)increase2 {
    [self willChangeValueForKey:@"num"];
    _num += 1;
    [self didChangeValueForKey:@"num"];
}

/*
 
 NSKVONotifying_ZYYObject 类中 setter方法的实现
 系统触发kvo  派生类NSKVONotifying_ZYYObject 插入2行代码 willChangeValueForKey didChangeValueForKey

 - (void)setNum:(int)num {
     [self willChangeValueForKey:@"num"];
     // 调用父类实现  也就是原类的实现
     [super setNum:num];
     [self didChangeValueForKey:@"num"];
 }

 */


/*
  KVC实现原理
  先查找set方法 _set方法
  accessInstanceVariablesDirectly 是否为yes  默认为yes
  查找_key _iskey  key  iskey 这些变量 找到直接赋值
  找不到调用 setvalueforUndefinedkey / valueForUndefinedKey  抛出异常
 */
- (void)setNum:(int)num {
    printf("kvc调用");
    _num = num;
}

// 默认yes
+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

// 重写防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"设置%@错误",key);
}

// 重写防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"获取%@错误",key);
    return nil;
}

@end
