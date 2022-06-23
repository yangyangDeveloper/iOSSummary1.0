//
//  VC1.m
//  定时器循环
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "VC1.h"
#import "ZYYWeakTarget.h""

/*
    CADisplayLink定时器  NStimer定时器
    nstimer受runloop影响 精度不高   出实话Api比较多  还提供了block消除target和timer的循环引用
    link和屏幕刷新率保持一次  每当屏幕显示内容刷新结束时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息  比timer精度高
 */
@interface VC1 ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // NSTimer
    [self createTimer];
    // [self createblockTimer];
    // [self weakTimer];
    
    // CADisplayLink
    //[self createDisplayLink];
    //[self weakDisplayLink];
}

/*
  
  调用创建方法后，target对象的计数器会加1，直到执行完毕，自动减1。
  如果是repeats = yes，就必须手动关闭
  如果repeats 为no可以不执行释放方法
 */

// 如果是循环执行 需要配合 viewDidDisappear 主动打破循环
- (void)createTimer {
    NSLog(@"前%ld", CFGetRetainCount((__bridge CFTypeRef)self));
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(doSome) userInfo:nil repeats:true];
    NSLog(@"后%ld", CFGetRetainCount((__bridge CFTypeRef)self));
    NSLog(@"6666");
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    // fire 第一次会立即触发  不等1秒之后了
    [timer fire];
    // distantFuture 暂停定时器
    timer.fireDate = [NSDate distantFuture];
    self.timer = timer;
}

- (void)createblockTimer {
    // 系统用 block得形式 解决了 timer 和 target的循环引用， 但是需要注意 block自己的循环引用
    // 这是解决block自己的循环引用的
    __weak typeof(self) weakself = self;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakself doSome];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}

- (void)weakTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:[ZYYWeakTarget proxyWithTarget:self] selector:@selector(doSome) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}

// target 和 link 会循环引用  需要借助 invalidate
- (void)createDisplayLink {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(doSome)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    // 暂停
    link.paused = YES;
    self.link = link;
}

// 使用weak 直接不让循环引用发生
- (void)weakDisplayLink {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:[ZYYWeakTarget proxyWithTarget:self] selector:@selector(doSome)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    // 暂停
    link.paused = YES;
    self.link = link;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 开启link
    self.link.paused = NO;
    
    // 开启timer
    self.timer.fireDate = [NSDate date];
}

static int count = 0;
- (void)doSome {
    count += 1;
    NSLog(@"%d", count);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if(self.timer && self.timer.isValid) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if(self.link) {
//        // invalidate 从runloop中移除  释放对target得引用
//        [self.link invalidate];
//        self.link = nil;
//    }
//}

@end
