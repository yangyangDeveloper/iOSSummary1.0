//
//  ZYYThread.h
//  Interview04-Runloop线程保活
//
//  Created by zhangyangyang on 2022/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYThread : NSThread {
    @public
    NSString * _name;
}
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) void(^doblock)(void);
@end

NS_ASSUME_NONNULL_END
