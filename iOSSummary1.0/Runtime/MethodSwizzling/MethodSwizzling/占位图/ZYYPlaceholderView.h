//
//  ZYYPlaceholderView.h
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYPlaceholderView : UIView
@property (nonatomic, strong) UIView *bgview;
@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, copy) void(^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
