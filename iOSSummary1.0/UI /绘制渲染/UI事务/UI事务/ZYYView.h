//
//  ZYYView.h
//  UI事务
//
//  Created by zhangyangyang on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYYView : UIView
- (void)updateContents;
- (void)updateContentsInsubThreads;

@end

NS_ASSUME_NONNULL_END
