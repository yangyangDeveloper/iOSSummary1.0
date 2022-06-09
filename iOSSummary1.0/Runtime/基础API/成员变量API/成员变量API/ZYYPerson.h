//
//  ZYYPerson.h
//  成员变量API
//
//  Created by zhangyangyang on 2022/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYPerson : NSObject {
    @public  // 加上publc 默认外界不可访问
    int _age;
    NSString * _name;
    
    int _weight;
}

@end

NS_ASSUME_NONNULL_END
