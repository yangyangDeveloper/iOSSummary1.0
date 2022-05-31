//
//  ZYYPerson.h
//  Interview-blockMRC循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYYBlock)(void);
@interface ZYYPerson : NSObject
@property (nonatomic, copy) ZYYBlock block;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
