//
//  ZYYPerson.m
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import "ZYYPerson.h"

@implementation ZYYPerson

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)dosome {
    NSLog(@"5555");
}

@end
