//
//  Person.h
//  内存管理
//
//  Created by zhangyangyang on 2022/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
{
    NSString * _name;
}
- (void)setName:(NSString *)name;
- (NSString *)name;

//@property (nonatomic, retain) NSString *name;
@end

NS_ASSUME_NONNULL_END
