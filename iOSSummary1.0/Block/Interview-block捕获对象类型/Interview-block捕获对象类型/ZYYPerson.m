//
//  ZYYPerson.m
//  Interview-block捕获对象类型
//
//  Created by zhangyangyang on 2022/2/8.
//

#import "ZYYPerson.h"

@implementation ZYYPerson

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)dosome {
    NSLog(@"%s",__func__);
}

- (void)setName:(NSString *)name {
    NSLog(@"set方法");
    _name = name;
}
@end
