//
//  ZYYView.m
//  Interview-UIView动画原理
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ZYYView.h"

@implementation ZYYView

/*
CALayer的隐式动画如何产生？

当CALayer的属性发生改变，系统会向CALayer读取一个action（既实现了CAAction协议的对象，称为行为）用来执行动画。CALayer返回的action步骤如下：

（1）CALayer判断自己有没有实现了CALayerDelegate协议的代理，如果有，判断该代理是否实现了CALayerDelegate协议的-actionForLayer:forKey方法。如果有实现该方法，调用该方法并返回结果。

（2）如果步骤（1）中，自己没有代理，或者有代理但是代理没有实现-actionForLayer:forKey方法，则CALayer检查其actions字典（该字典是【属性名称：行为】的映射）。如果查找有值，返回结果。

（3）actions字典查找不到，则CALayer检查其style字典（该字典是【属性名称：行为】的映射）。如果查找有值，返回结果。

（4）如果style字典仍然没查找到，则图层直接调用实现了每个属性标准动画行为的方法：-defaultActionForKey:方法。

  【总结】：上述步骤，只要返回非nil，就会中断查找并将值返回。如果返回的是nil，就会接着往下查找。 注意：[NSNull null] 不是nil，返回它会中断查找过程，但是会返回空给系统，系统会依然沿着上述步骤查找动画。

*/



//* 1. if defined, call the delegate method -actionForLayer:forKey:
//* 2. look in the layer's `actions' dictionary
//* 3. look in any `actions' dictionaries in the `style' hierarchy
//* 4. call +defaultActionForKey: on the layer's class




// 控制隐式动画
// 要设置的特殊属性动画，创建并返回一个自定义的动画。其他不需要做特殊动画的属性，直接调用[super actionForLayer:layer forKey:event]返回
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {

    NSLog(@"%s",__func__);
    if ([event isEqualToString:@"backgroundColor"]) {
            //可以任意修改动画
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.duration = 5.0f;
            return animation;
        }
    //对于不需要自定义/修改的动画，直接调用[super actionForLayer:layer forKey:event]返回
    return [super actionForLayer:layer forKey:event];

}



@end
