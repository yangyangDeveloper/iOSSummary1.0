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
 
 * 1. if defined, call the delegate method -actionForLayer:forKey:
 * 2. look in the layer's `actions' dictionary
 * 3. look in any `actions' dictionaries in the `style' hierarchy
 * 4. call +defaultActionForKey: on the layer's class


当CALayer的属性发生改变，系统会向CALayer读取一个action（既实现了CAAction协议的对象，称为行为）用来执行动画。CALayer返回的action步骤如下：

（1）CALayer判断自己有没有实现了CALayerDelegate协议的代理，如果有，判断该代理是否实现了CALayerDelegate协议的-actionForLayer:forKey方法。如果有实现该方法，调用该方法并返回结果。

（2）如果步骤（1）中，自己没有代理，或者有代理但是代理没有实现-actionForLayer:forKey方法，则CALayer检查其actions字典（该字典是【属性名称：行为】的映射）。如果查找有值，返回结果。

（3）actions字典查找不到，则CALayer检查其style字典（该字典是【属性名称：行为】的映射）。如果查找有值，返回结果。

（4）如果style字典仍然没查找到，则图层直接调用实现了每个属性标准动画行为的方法：-defaultActionForKey:方法。

  【总结】：上述步骤，只要返回非nil，就会中断查找并将值返回。如果返回的是nil，就会接着往下查找。 注意：[NSNull null] 不是nil，返回它会中断查找过程，但是会返回空给系统，系统会依然沿着上述步骤查找动画。
  UIkit利用这一点 在动画块外 返回 NUll   在动画块内 返回非空
  UIivew禁止了自己layer的默认的隐式动画
 
*/


/*
 控制隐式动画
 要设置的特殊属性动画，创建并返回一个自定义的动画。其他不需要做特殊动画的属性，直接调用[super actionForLayer:layer forKey:event]返回
 
 CABasicAnimation->CAPropertyAnimation->CAAnimation<NSSecureCoding, NSCopying, CAMediaTiming, CAAction>
*/

/*
 
 2022-06-20 16:35:35.810513+0800 隐式动画[16653:1320878] bounds - <null>
 2022-06-20 16:35:35.810720+0800 隐式动画[16653:1320878] opaque - <null>
 2022-06-20 16:35:35.810863+0800 隐式动画[16653:1320878] position - <null>
 2022-06-20 16:35:35.811023+0800 隐式动画[16653:1320878] backgroundColor - <null>
 2022-06-20 16:35:35.811534+0800 隐式动画[16653:1320878] opaque - <null>
 2022-06-20 16:35:35.822363+0800 隐式动画[16653:1320878] onOrderIn - <null>
 */
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {

    NSLog(@"%@ - %@",event, [super actionForLayer:layer forKey:event] );
    
    // 自定义layer的动画属性
    if ([event isEqualToString:@"backgroundColor"]) {
            //返回遵守action的动画类
            // CABasicAnimation正确的实现了CAAction协议  calyer会用这个对象生成一个CAAnimation 并加到自己身上进行动画
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.duration = 5.0f;
            return animation;
        }
    //对于不需要自定义/修改的动画，直接调用[super actionForLayer:layer forKey:event]返回
    return [super actionForLayer:layer forKey:event];
}

/*
 被标记为Animatable
 ```
 bounds
 opaque
 position
 backgroundColor
 contents
 onOrderIn
 其他
 ...
 
 如果一个属性被标记为Animatable，那么它具有以下两个特点：

 1、直接对它赋值可能产生隐式动画；
 2、我们的CAAnimation的keyPath可以设置为这个属性的名字。
 */
@end
