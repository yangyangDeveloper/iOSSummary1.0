//
//  TestAniView.m
//  Interview-UI
//
//  Created by zhangyangyang on 2022/5/30.
//

#import "TestAniView.h"

@implementation TestAniView

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    if([event isEqualToString:@"backgroundColor"]) {
//        NSLog(@"%s", __func__);
//        NSLog(@"%@",event);
        NSLog(@"%@",[super actionForLayer:layer forKey:event]);
        
    }
    return [super actionForLayer:layer forKey:event];
}

@end
