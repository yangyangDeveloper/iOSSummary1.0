//
//  main.m
//  Interview-启动优化
//
//  Created by zhangyangyang on 2022/2/4.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


/*
 从 main 函数开始执行，到第一个界面显示，期间一般做以下任务：

1  执行 AppDelegate 的代理方法，主要是 didFinishLaunchingWithOptions
2  初始化 Window，初始化基础的 ViewController 结构
2  获取数据(Local DB／Network)，展示给用户。
 
 优化：

 1 使用代码绘制 UI，减少或者不用 xib 和 storyboard

 2 延迟初始化和加载不必要的 UIViewController 和 View。

     比如 UITabBarController 有四个 Item，在启动的时候尽量只初始化首页的页面，其它 Item 页面先用空 VC 占位。而且首页的内容中不必要的内容也可以先不初始化，做成懒加载形式，在用户确实需要查看和使用时再初始化。

 3 对于确实需要启动时使用但又比较耗时的事物放倒后台处理，如果涉及到 UI 则在处理完成后把刷新任务放回主线程。

     日志功能，日志往往涉及到 DB 操作；
     文件读取，比如读取本地存储的省份城市区县文件和图片处理；
     大量的计算，比如图片处理，比较大的 json 数据转 Model；
 4 能延迟初始化的尽量延迟初始化
    三方 SDK 初始化，比如 Crash 统计，分享之类的，可以等到第一次调用再去初始化。
 */

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


/*
    删除无用的方法和类
    合并 Category 和功能类似的类
    多用 Swift Structs
    用 initialize 替代 load
    减少使用 c/c++ 的 __atribute__((constructor))
 */
