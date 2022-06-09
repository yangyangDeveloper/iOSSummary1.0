//
//  ZTTPerson+Eat.h
//  分类
//
//  Created by zhangyangyang on 2022/1/19.
//

#import "ZTTPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTTPerson (Eat) <NSCoding>
@property (nonatomic, strong) NSString *str;
@property (nonatomic, assign) int age;

- (void)eat;
- (void)eat2;
+ (void)gogo;

@end

NS_ASSUME_NONNULL_END
