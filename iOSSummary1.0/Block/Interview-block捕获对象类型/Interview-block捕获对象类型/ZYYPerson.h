//
//  ZYYPerson.h
//  Interview-block捕获对象类型
//
//  Created by zhangyangyang on 2022/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYPerson : NSObject {
    @public
    NSString *_city;
}
@property (nonatomic, copy) NSString *name;
- (void)dosome;
@end

NS_ASSUME_NONNULL_END
