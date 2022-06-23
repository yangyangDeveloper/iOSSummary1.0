//
//  AppDelegate.m
//  APP生命周期
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 
 APP的5种状态
 
 未运行（Not running）
 程序没启动

 未激活（Inactive）
 程序在前台运行，不过没有接收到事件。
 一般每当应用要从一个状态切换到另一个不同的状态时，中途过渡会短暂停留在此状态。
 唯一在此状态停留时间比较长的情况是：当用户锁屏时，或者系统提示用户去响应某些（诸如电话来电、有未读短信等）事件的时候。

 激活（Active）
 程序在前台运行而且接收到了事件。这也是前台的一个正常的模式

 后台（Backgroud）  嗯一次home键
 程序在后台而且能执行代码，大多数程序进入这个状态后会在在这个状态上停留一会。时间到之后会进入挂起状态(Suspended)。有的程序经过特殊的请求后可以长期处于Backgroud状态

 挂起（Suspended）
 程序在后台不能执行代码。系统会自动把程序变成这个状态而且不会发出通知。当挂起时，程序还是停留在内存中的，当系统内存低时，系统就把挂起的程序清除掉，为前台程序提供更多的内存。
 
 */

// app启动开始加载
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    NSLog(@"%s",__func__);
    return YES;
}

// 未运行状态进入运行状态
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s",__func__);
    return YES;
}

// 当应用即将进入前台运行时调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

// 当应用即将进从前台退出时调用
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

// 当应用开始在后台运行的时候调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

// 当程序从后台将要重新回到前台（但是还没变成Active状态）时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

// 当前应用即将被终止，在终止前调用的函数, 通常是用来保存数据和一些退出前的清理工作, 如果应用当前处在suspended，此方法不会被调用, 最长运行时限为5秒
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

// 关闭iOS13 对ipadod 多界面的兼容  生命周期 走老的一套 
//#pragma mark - UISceneSession lifecycle
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


/*
 1、程序启动：状态由Not running -> Inactive -> Active
 willFinishLaunchingWithOptions
 didFinishLaunchingWithOptions
 applicationDidBecomeActive
 
 2、点击home键|锁屏：由Active -> Inactive -> Backgroud
 applicationWillResignActive
 applicationDidEnterBackground
 
 3、重新进入前台：Backgroud -> Inactive -> Active applicationWillEnterForeground
 -[AppDelegate applicationWillEnterForeground:]
 applicationDidBecomeActive
 
 
 4、在前台，双击home键，手动杀掉APP：Active -> Inactive -> Backgroud -> end
 applicationWillResignActive
 applicationDidEnterBackground
 applicationWillTerminate
 
 ** 当URL到达时，如果你的应用没在正在运行，则会被启动并且移到前台运行以打开URL
 application:didFinishLaunchingWithOptions:
 application:openURL:sourceApplication:
 applicationDidBecomeActive

 ** 当URL到达时，如果你的应用正在background运行或被suspended，它将会被移到前台以打开URL
 applicationWillEnterForeground
 application:openURL:sourceApplication:
 applicationDidBecomeActive
 */

@end
