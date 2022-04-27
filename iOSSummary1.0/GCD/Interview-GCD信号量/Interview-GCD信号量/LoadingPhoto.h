//
//  LoadingPhoto.h
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/*
   多个异步操作 线程同步
   异步并发下载3张图片 并将合成 显示到屏幕上
   异步下载图片API(已提供)
 */

@interface LoadingPhoto : NSObject
- (void)downloadImage;
@end

NS_ASSUME_NONNULL_END
