//
//  ZYYUITableview+ReloadDataSwizzling.h
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/29.
//

#import "ZYYUITableview.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYYUITableview (ReloadDataSwizzling)
@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic,   copy) void(^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
