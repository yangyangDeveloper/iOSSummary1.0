//
//  UIButton+Swizzling.h
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Swizzling)

// 重复点击间隔
@property (nonatomic, assign) NSTimeInterval zyy_acceptEventInterval;
//@property (nonatomic, assign) NSTimeInterval zyy_acceptEventTime;

@end

NS_ASSUME_NONNULL_END
