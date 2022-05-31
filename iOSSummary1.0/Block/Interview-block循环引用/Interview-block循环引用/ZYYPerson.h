//
//  ZYYPerson.h
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYYBlock)(void);
@interface ZYYPerson : NSObject {
    @public
    NSString *_city;
}

@property (copy, nonatomic) ZYYBlock block;
@property (copy, nonatomic) NSString *name;
@end

NS_ASSUME_NONNULL_END
