//
//  UITableView+Swizzling.h
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Swizzling)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic,   copy) void(^reloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
