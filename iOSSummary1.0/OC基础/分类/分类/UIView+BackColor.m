//
//  UIView+BackColor.m
//  分类
//
//  Created by zhangyangyang on 2022/1/15.
//

#import "UIView+BackColor.h"
#import <objc/runtime.h>

static const char ZYYBackColorKey = '\0';

@implementation UIView (BackColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    objc_setAssociatedObject(self, &ZYYBackColorKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)backgroundColor {
    return objc_getAssociatedObject(self, &ZYYBackColorKey);
}


@end
