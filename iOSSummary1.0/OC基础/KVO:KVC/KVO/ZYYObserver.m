//
//  ZYYObserver.m
//  KVO
//
//  Created by zhangyangyang on 2022/1/15.
//

#import "ZYYObserver.h"
#import "ZYYObject.h"

@implementation ZYYObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[ZYYObject class]] && [keyPath isEqualToString:@"num"]) {
        // 获取新值
        NSNumber *num = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"num is %@", num);
    }
}
@end
