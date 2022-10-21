//
//  Block.m
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/9/30.
//

#import "NBBlock.h"

@implementation NBBlock

- (void)addBlock:(TestBlock)block {
    self.nbblock = block;
    NSLog(@"555551111");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.nbblock) {
            self.nbblock();
        }
    });
}

- (void)nb {
    NSLog(@"nb");
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
