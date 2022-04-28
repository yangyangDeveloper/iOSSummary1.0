//
//  ZYYPerson.h
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import <Foundation/Foundation.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@class Person;

@interface ZYYPerson : Person
- (void)test;
@end

NS_ASSUME_NONNULL_END
