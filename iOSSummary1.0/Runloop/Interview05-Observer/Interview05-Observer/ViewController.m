//
//  ViewController.m
//  Interview05-Observer
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
}


void observeRunloopActicities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"进入");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"将要处理timer");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"将要处理source");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"即将休眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"被唤醒");
            break;
        case kCFRunLoopExit:
            NSLog(@"推出");
            break;
        default:
            break;
    }
}

// 观察runloop 状态
- (void)test1 {
    
    // 创建 observer
    CFRunLoopObserverRef observer =  CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunloopActicities, NULL);
    
    // 添加observer 到runloop中
    // 系统人家自己也加了一大堆observer  这里我们也加observer  所以 observer  其实是 observers 是个数组
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 释放
    CFRelease(observer);

}

/*
 
 去 appdeledate里面监测 是最准确的 这里少一次 kCFRunLoopEntry -- kCFRunLoopDefaultMode
 2022-02-03 17:09:29.010220+0800 Interview05-Observer[42569:3677041] kCFRunLoopExit-- kCFRunLoopDefaultMode
 2022-02-03 17:09:29.010467+0800 Interview05-Observer[42569:3677041] kCFRunLoopEntry -- UITrackingRunLoopMode
 2022-02-03 17:09:29.163775+0800 Interview05-Observer[42569:3677041] kCFRunLoopExit-- UITrackingRunLoopMode
 2022-02-03 17:09:29.163971+0800 Interview05-Observer[42569:3677041] kCFRunLoopEntry -- kCFRunLoopDefaultMode
 */
// 观察 model 切换时runloop 状态
- (void)test2 {

    // 创建 observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopEntry -- %@", mode);
                CFRelease(mode);
                break;
            }

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

/*
 2022-02-03 16:58:45.180491+0800 Interview05-Observer[41583:3650284] kCFRunLoopBeforeSources
 2022-02-03 16:58:45.183017+0800 Interview05-Observer[41583:3650284] -[ViewController touchesBegan:withEvent:]
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"%s",__func__);
}

@end
