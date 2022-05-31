//
//  ZYYPerson.m
//  Interview-block捕获对象释放时机
//
//  Created by zhangyangyang on 2022/2/9.
//

#import "ZYYPerson.h"

@implementation ZYYPerson

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
