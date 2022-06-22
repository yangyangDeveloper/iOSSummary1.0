//
//  VC1.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/22.
//

#import "VC1.h"
#import "ZYYView.h"
#import "ZYYThread.h"

@interface VC1 ()
@property (nonatomic, strong) ZYYView *zyyview;
@property (nonatomic, strong) ZYYThread *thread;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zyyview = [[ZYYView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.zyyview.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.zyyview];
    
    ZYYThread *thread = [[ZYYThread alloc] initWithTarget:self selector:@selector(run3) object:nil];
    [thread start];
    self.thread = thread;
}

- (void)run3 {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 添加 source、 timer objserver
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"end ---");
}

// 1、临时子线程 修改UI
/*
  layer并不会立即就进行更新。而是等到子线程退出时才会进行更新、此时会有不可预估的时间延迟 几秒或者几分钟
 _pthread_tsd_cleanup->Transaction::release_thread->Transaction::commit()->commit方法中对layer的修改才会被提交到GPU进行绘制
 */
- (void)test {
    dispatch_queue_t zyyQueue = dispatch_queue_create("zyy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(zyyQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"休眠结束");
        self.zyyview.layer.backgroundColor = [UIColor blueColor].CGColor;
        NSLog(@"变色");

    });
}

// 2、临时子线程 修改UI 显示调用ca commit
/*
   显示的调用Transaction::commit()方法 在commit方法中对layer的修改会被提交到GPU进行绘制、此时layer会立即更新、不会出现延迟
   
 */
- (void)test2 {
    dispatch_queue_t zyyQueue = dispatch_queue_create("zyy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(zyyQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"休眠结束");
    
        [CATransaction begin];
//        UIImage *image = [UIImage imageNamed:@"me"];
//        self.zyyview.layer.contents = (__bridge id)image.CGImage;
        [CATransaction commit];
        //self.zyyview.layer.backgroundColor = [UIColor blueColor].CGColor;
        NSLog(@"变色");
        
        // 临时子线程 没有开启runloop 所以 CompletionBlock并不会在commit之后被调用 ，调用时机是系统对当前线程进行回收之时  可以添加断点 _pthread_tsd_cleanup
        [CATransaction setCompletionBlock:^{
            NSLog(@"currentthread=%@", [NSThread currentThread]);
        }];
        
        // 以上的整个过程都不会唤醒mainrunloop、更不会引起main runloop的运行状态变化
    });
}

//  常驻子线程修改layer属性
- (void)test3 {
    
    UIButton *btn = [[UIButton alloc] init];
    btn.imageView.layer.cornerRadius = 100.0;
    btn.imageView.clipsToBounds = YES;
    
    [self observer_zyyThreadRunloop];
    [NSThread sleepForTimeInterval:2];
    NSLog(@"休眠结束");
    [CATransaction begin];
    UIImage *image = [UIImage imageNamed:@"me"];
    self.zyyview.layer.contents = (__bridge id)image.CGImage;
    //  子线程的runloop 会先退出 再重新进入
    [CATransaction commit];
    
    [CATransaction begin];
    self.zyyview.layer.backgroundColor = [UIColor yellowColor].CGColor;
    //  子线程的runloop 会先退出 再重新进入
    [CATransaction commit];
    
    NSLog(@"gogogo");
//    [CATransaction setCompletionBlock:^{
//        NSLog(@"currentthread=%@", [NSThread currentThread]);
//    }];
    
    //  当前现在再次开启runloop  1进入 -》2beforetimer 。。 32   beforewaiting
    {
        [self performSelector:@selector(donothing) withObject:nil afterDelay:10];
        [self performSelector:@selector(updatelayer) withObject:nil afterDelay:20];
        
    }
   
   // _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv
   // 注意点
   // 当前线程的 runloop 状态变为 BeforeWaiting 或者 Exit 时、在回调的'CA::Transaction::observer_callback'方法中并不是每次都会调用'CA::Transaction::commit'方法
   // 如果存放 layer 属性更改的容器中没有元素、那么在执行回调函数'CA::Transaction::observer_callback'的方法中就不会再调用'CA::Transaction::commit'方法了
}

- (void)donothing {
    NSLog(@"%s", __func__);
}


- (void)updatelayer {
    NSLog(@"%s", __func__);
    self.zyyview.layer.backgroundColor = [UIColor orangeColor].CGColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   // [self test];
    [self test2];
    // 常驻线程
    //[self performSelector:@selector(test3) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}



void observeRunloopActicities1(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"Runloop进入");
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
            NSLog(@"Runloop退出");
            break;
        default:
            break;
    }
}

// 观察runloop 状态
- (void)observer_zyyThreadRunloop {
    
    NSLog(@"currentthread=%@", [NSThread currentThread]);
    NSLog(@"当前runloop");
    
    // 创建 observer
    CFRunLoopObserverRef observer =  CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunloopActicities1, NULL);
    
    // 添加observer 到runloop中
    // 系统人家自己也加了一大堆observer  这里我们也加observer  所以 observer  其实是 observers 是个数组
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    
    // 释放
    CFRelease(observer);

}

@end
