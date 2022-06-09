//
//  AppDelegate.m
//  Interview05-Observer
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


/*
 2022-02-03 17:12:27.265531+0800 Interview05-Observer[42812:3682316] kCFRunLoopEntry -- kCFRunLoopDefaultMode
 2022-02-03 17:12:36.061875+0800 Interview05-Observer[42812:3682316] kCFRunLoopExit-- kCFRunLoopDefaultMode
 2022-02-03 17:12:36.062096+0800 Interview05-Observer[42812:3682316] kCFRunLoopEntry -- UITrackingRunLoopMode
 2022-02-03 17:12:36.764190+0800 Interview05-Observer[42812:3682316] kCFRunLoopExit-- UITrackingRunLoopMode
 2022-02-03 17:12:36.764794+0800 Interview05-Observer[42812:3682316] kCFRunLoopEntry -- kCFRunLoopDefaultMode
 
 */
- (void)test {
    
    // 创建 observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopEntry -- %@", mode);
                CFRelease(mode);
                break;
            }
//            case kCFRunLoopBeforeWaiting: {
//                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
//                NSLog(@"kCFRunLoopBeforeWaiting -- %@", mode);
//                CFRelease(mode);
//                break;
//            }
//            case kCFRunLoopAfterWaiting: {
//                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
//                NSLog(@"kCFRunLoopAfterWaiting  -- %@",mode);
//                CFRelease(mode);
//                break;
//            }
            case kCFRunLoopExit: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopExit-- %@", mode);
                CFRelease(mode);
                break;
            }
                
            default:
                break;
        }
    });
    
    // 添加observer 到runloop中
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 释放
    CFRelease(observer);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self test];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
