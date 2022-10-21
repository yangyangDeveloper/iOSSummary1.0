//
//  Block.h
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TestBlock)(void);

@interface NBBlock: NSObject

@property (copy, nonatomic) TestBlock nbblock;

- (void)addBlock:(TestBlock)block;
- (void)nb;
@end

NS_ASSUME_NONNULL_END
