//
//  ZYYPerson.m
//  Interview-blockMRC循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import "ZYYPerson.h"

@implementation ZYYPerson

- (void)dealloc {
    [super dealloc];
    NSLog(@"%s",__func__);
}
@end
