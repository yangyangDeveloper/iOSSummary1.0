//
//  ZYYView.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "ZYYView.h"

@implementation ZYYView

/*

 CATransaction会捕获CALayer的变化，包括任何的渲染属性，把这些都提交到一个中间态
 然后在当前Runloop进入休眠或结束前，会发出Observer 消息。这是一种runloop消息类型，跟通知的方式类似，会通知观察者，这时Core Animation会把这些CALayer的变化提交给GPU绘制
 
 
 CATransaction会对 begin和commit内部的变化进行捕获
 子线程需要加上 begin commit
 主线程不需要加  默认在修改的时候创建一个新的事物 并且在下一次runloop迭代时候提交
 
 // 默认0.25s
 [CATransaction begin];
 _testLayer.backgroundColor = [UIColor blueColor].CGColor;
 [CATransaction commit];
*/

// 子线程
- (void)updateContentsInsubThreads {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t layerQueue = dispatch_queue_create("zyy", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(layerQueue, ^{
        NSLog(@"currentthread=%@", [NSThread currentThread]);
        [[NSThread currentThread] setName:@"zyy_thread"];
        [NSThread sleepForTimeInterval:2];
        UIImage *image = [UIImage imageNamed:@"me"];
        [CATransaction begin];
        weakSelf.layer.backgroundColor = [UIColor redColor].CGColor;
        weakSelf.layer.contents = (__bridge  id)image.CGImage;
        [CATransaction commit];
        NSLog(@"变色");
        [CATransaction setCompletionBlock:^{
            NSLog(@"currentthread=%@", [NSThread currentThread]);
        }];
    });
}

// 主线程
- (void)updateContents {
    NSLog(@"currentthread=%@", [NSThread currentThread]);
    UIImage *image = [UIImage imageNamed:@"me"];
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer.contents = (__bridge  id)image.CGImage;
    [CATransaction setCompletionBlock:^{
        NSLog(@"currentthread=%@", [NSThread currentThread]);
    }];
}


/*

 伪代码
 
 //生成一个新的事务并返回
 [CATransaction newTransaction];
 
 {   //这一段是layer修改背景色内部的逻辑
     setBackgroundColor{
         
         //获取当前的CATransaction，并把修改提供给它
         CATransaction *currentTrans = [CATransaction getCurrentTransaction];
         [currentTrans addLayerChange:self forKey:@"backgroundColor"];
     }
 }
 
 //提交layer变化并移除当前的事务
 [CATransaction commitLayerChanges];
 [CATransaction removeCurrentTransaction];
 
 
 全局的栈来管理CATransaction：
 事务1-->事务2开启-->layer修改-->事务2提交结束-->回到事务1
 
 begin的时候，新建一个CATransaction，push放到栈顶
 然后获取当前CATransaction的时候呢，就取栈顶元素就可以
 commit的时候，pop栈顶元素。并且把layer的变化提交。
 */

@end
