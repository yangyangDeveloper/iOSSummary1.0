//
//  ZYYObject.h
//  UI事务
//
//  Created by zhangyangyang on 2022/6/22.
//

#import <Foundation/Foundation.h>
#import "ZYYThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYYObject : NSObject

+ (ZYYThread *)threadForDispatch;

@end

NS_ASSUME_NONNULL_END
