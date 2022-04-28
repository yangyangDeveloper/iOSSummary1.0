//
//  ZYYPerson+Swizzling.h
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "ZYYPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYYPerson (Swizzling)
- (void)test2;
@end

NS_ASSUME_NONNULL_END
