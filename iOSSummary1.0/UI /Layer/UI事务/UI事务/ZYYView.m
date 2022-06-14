//
//  ZYYView.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "ZYYView.h"

@implementation ZYYView

- (void)updateContents {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t layerQueue = dispatch_queue_create("zyy", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(layerQueue, ^{
       
        [[NSThread currentThread] setName:@"zyy_thread"];
        [NSThread sleepForTimeInterval:1];
        
        UIImage *image = [UIImage imageNamed:@"me"];
        weakSelf.layer.backgroundColor = [UIColor redColor].CGColor;
        //weakSelf.layer.contents = (__bridge  id)image.CGImage;
        
        [CATransaction commit];
        NSLog(@"变色");
        [CATransaction setCompletionBlock:^{
            NSLog(@"currentthread=%@", [NSThread currentThread]);
        }];
    });
}

@end
