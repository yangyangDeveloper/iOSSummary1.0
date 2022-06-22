//
//  ViewController.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "ViewController.h"
#import "ZYYView.h"
#import "VC1.h"

#import "ZYYObject.h"

@interface ViewController ()
@property(nonatomic, strong) ZYYView *zyyview;
@end

@implementation ViewController

void observeRunloopActicities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"即将处理timer");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"即将处理Sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"即将休眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"被唤醒");
            break;
        case kCFRunLoopExit:
            NSLog(@"退出");
            break;
        default:
            break;
    }
}

// 观察runloop 状态
- (void)test {
    
    // 创建 observer
    CFRunLoopObserverRef observer =  CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunloopActicities, NULL);
    
    // 添加observer 到runloop中
    // 系统人家自己也加了一大堆observer  这里我们也加observer  所以 observer  其实是 observers 是个数组
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 释放
    CFRelease(observer);

}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self test];
    
    //[self.zyyview updateContents];
    
    
    
   // [self test];
}

// 等主线程runloop休眠 点击屏幕  souce1  转 source0  唤醒主线程runloop 进入新的一个周期  提交上一个周期的图层变化， 为什么屏幕能看到黄色 这是上一个周期的代码？
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.zyyview updateContentsInsubThreads];
    NSLog(@"666");
    
    VC1 *vc = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc animated:true];
    
    //[ZYYObject threadForDispatch];
    
    //[self.zyyview updateContents];
}

@end
