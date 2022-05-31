//
//  ZYYPerson.m
//  Interview-block捕获变量
//
//  Created by zhangyangyang on 2022/2/8.
//

#import "ZYYPerson.h"

@implementation ZYYPerson

// 会捕获self
// - (void)test(ZYYPerson * self, SEL _cmd)
- (void)test {
    void(^block)(void) = ^{
        NSLog(@"%d",self);
    };
    block();
}

// 会捕获self
- (void)test2 {
    void(^block)(void) = ^{
        NSLog(@"%d",_name);
        
        // 等价下面这行  先拿到self 在用偏移 找到 name
        // 所以会捕获
        // NSLog(@"%d",self->_name);
    };
    block();
}
@end
