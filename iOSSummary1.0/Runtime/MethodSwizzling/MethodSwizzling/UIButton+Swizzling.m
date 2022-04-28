//
//  UIButton+Swizzling.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "UIButton+Swizzling.h"

@implementation UIButton (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originSel = @selector(sendAction:to:forEvent:);
        SEL swizzlingSel = @selector(zyy_sendAction:to:forEvent:);
        
        Method originMethod = class_getInstanceMethod(class, originSel);
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSel);
        
        BOOL didaddMehod = class_addMethod(class, originSel, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        
        if (didaddMehod) {
            class_replaceMethod(class, swizzlingSel, method_getImplementation(originMethod), method_getImplementation(originMethod));
        }else {
            method_exchangeImplementations(originMethod, swizzlingMethod);
        }
    });
}


- (NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds {
NSTimeInterval tempMilli = miliSeconds;

NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致

NSLog(@"传入的时间戳=%f",seconds);

return [NSDate dateWithTimeIntervalSince1970:seconds];

}

- (void)zyy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    NSLog(@"zyy方法检查到了点击");
    // 如果没有自定义时间间隔，则默认为 0.4 秒
    if (self.zyy_acceptEventInterval <= 0) {
        self.zyy_acceptEventInterval = 0.4;
    }
    
    long long time = NSDate.date.timeIntervalSince1970;  // 获取1970年之后的 毫秒
    NSLog(@"%llu", time);
    NSDate *dat = [self getDateTimeFromMilliSeconds:time];

    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];

    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];

    NSString *date =  [formatter stringFromDate:dat];

    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];

    NSLog(@"\n%@", timeLocal);
    
    
    // 是否小于设定的时间间隔   当前时间 - 上次点击时间 >= 时间间隔
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.zyy_acceptEventTime >= self.zyy_acceptEventInterval);
    
    // 更新上一次点击时间戳
    if (self.zyy_acceptEventInterval > 0) {
        self.zyy_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self zyy_sendAction:action to:target forEvent:event];
    }
}

// 点击间隔
- (NSTimeInterval)zyy_acceptEventInterval {
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

- (void)setZyy_acceptEventInterval:(NSTimeInterval)zyy_acceptEventInterval {
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(zyy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 上次点击时间
- (NSTimeInterval)zyy_acceptEventTime {
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

- (void)setZyy_acceptEventTime:(NSTimeInterval)zyy_acceptEventTime {
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(zyy_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
