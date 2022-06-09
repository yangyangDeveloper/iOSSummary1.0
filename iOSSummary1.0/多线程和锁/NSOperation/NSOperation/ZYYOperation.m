//
//  ZYYOperation.m
//  NSOperation
//
//  Created by zhangyangyang on 2022/4/27.
//

#import "ZYYOperation.h"

@implementation ZYYOperation

- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }
}

@end
