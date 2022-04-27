//
//  LoadingPhoto.m
//  Interview-GCD信号量
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "LoadingPhoto.h"

@implementation LoadingPhoto

// 异步下载图片
- (void)downloadImage:(NSString *)url completionHandler:(void(^)(UIImage * image))completionHandler {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"真正图片下载线程%@",[NSThread currentThread]);
        // 模拟图片下载耗费的时间
        [NSThread sleepForTimeInterval:2];
        
        if (completionHandler) {
            completionHandler([UIImage new]);
        }
    });
}

- (void)downloadImage {
    [self downloadImage1:@"image url 1" image2:@"image url 2" combinedHandler:^(UIImage *combinedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"在主线程中更新 UI");
        });
    }];
}

// 信号量+队列组  来实现线程同步
- (void)downloadImage1: (NSString *)url1 image2:(NSString *)url2 combinedHandler:(void (^)(UIImage *combinedImage))combinedHandler {
    
    NSLog(@"-- all tasks begin --");
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
 
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    __block UIImage *image3 = nil;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"队列组线程1=%@",[NSThread currentThread]);
        NSLog(@"start downloading image1");
        // 假设调用别人封装的异步下载图片的API
        [self downloadImage:@"" completionHandler:^(UIImage *image) {
            image1 = image;
            NSLog(@"image1 finished");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });

    /*
     
     在64位的机器上，intptr_t和uintptr_t分别是long int、unsigned long int的别名；在32位的机器上，intptr_t和uintptr_t分别是int、unsigned int的别名。
     
     */
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"队列组线程2=%@",[NSThread currentThread]);
        NSLog(@"start downloading image2");
        // 假设调用别人封装的异步下载图片的API
        [self downloadImage:@"" completionHandler:^(UIImage *image) {
            image2 = image;
            NSLog(@"image2 finished");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"队列组线程3=%@",[NSThread currentThread]);
        NSLog(@"start downloading image3");
        // 假设调用别人封装的异步下载图片的API
        [self downloadImage:@"" completionHandler:^(UIImage *image) {
            image3 = image;
            NSLog(@"image3 finished");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });

    dispatch_group_notify(group, queue, ^{
        NSLog(@"all task end");
        // 模拟图片合成过程
        [NSThread sleepForTimeInterval:2];
        if (combinedHandler) {
            combinedHandler([UIImage new]);
        }
    });
    
    NSLog(@"主线程继续走");
}

@end
