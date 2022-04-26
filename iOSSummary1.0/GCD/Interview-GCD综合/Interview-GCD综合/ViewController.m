//
//  ViewController.m
//  Interview-GCD综合
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
//    [self test2];
    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
//    [self test7];
}


- (void)test {
    NSLog(@"2");
}

- (void)test1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(test) withObject:nil];
        // objcmsgsend(self, @selecotr(test)) 等价  【self test】
        NSLog(@"3");
    });
}


- (void)test2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        // 这个底层是个定时器timer   也就是 delay多少秒 之后执行 必须依赖runloop才能执行   而gcd创建的子线程 默认没有开启runloop
        // 本质是往runloop中添加定时器 但是子线程runloop没有开启runloop  所以time无效  所以 test函数不会执行
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        NSLog(@"3");
    });
}

- (void)test3 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        // 我们开启runloop
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        NSLog(@"3");
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

// 我们子线程添加一个timer 默认也不会执行  因为runloop没有创建 或者创建没有启动
- (void)test4 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"11111");
        }];
        NSLog(@"3");
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

// 启动runloop
- (void)test5 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"11111");
        }];
        NSLog(@"3");
        // [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode]; 这行代码可以省略 因为timer已经加进去了
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

- (void)test6 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");  // 执行完1 之后  线程就退出了  所以崩溃   需要用runloop保活线程
    }];
    [thread start];
    [self performSelector:@selector(testgogo) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)test7 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");  // 执行完1 之后  线程就退出了  所以崩溃   需要用runloop保活线程
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    // yes 是等 testgogo 执行完 再往下走    no 就是不需要等待 直接往下走
    [self performSelector:@selector(testgogo) onThread:thread withObject:nil waitUntilDone:YES];
    NSLog(@"3");
}


- (void)testgogo {
    NSLog(@"2");
}


/*
 
 
 @interface NSObject (NSThreadPerformAdditions)

 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array;
 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
     // equivalent to the first method with kCFRunLoopCommonModes

 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
     // equivalent to the first method with kCFRunLoopCommonModes
 - (void)performSelectorInBackground:(SEL)aSelector withObject:(nullable id)arg API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

 @end
 
 */

/*
 和runtime 有关系
 
 @protocol NSObject

 - (BOOL)isEqual:(id)object;
 @property (readonly) NSUInteger hash;

 @property (readonly) Class superclass;
 - (Class)class OBJC_SWIFT_UNAVAILABLE("use 'type(of: anObject)' instead");
 - (instancetype)self;

 - (id)performSelector:(SEL)aSelector;
 - (id)performSelector:(SEL)aSelector withObject:(id)object;
 - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

  这几个函数本质是 objcmsgsend
*/


/*
和runloop 有关系

这几个函数 本质是 把timer 加到runloop中
@interface NSObject (NSDelayedPerforming)

- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray<NSRunLoopMode> *)modes;
- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;

@end

 */

/*
 
源码里面 有获取 runloop 而且添加了timer  但是没有启动 runloop
 - (void) performSelector: (SEL)aSelector
           withObject: (id)argument
           afterDelay: (NSTimeInterval)seconds
 {
   NSRunLoop        *loop = [NSRunLoop currentRunLoop];
   GSTimedPerformer    *item;

   item = [[GSTimedPerformer alloc] initWithSelector: aSelector
                          target: self
                        argument: argument
                           delay: seconds];
   [[loop _timedPerformers] addObject: item];
   RELEASE(item);
   [loop addTimer: item->timer forMode: NSDefaultRunLoopMode];
   
 
 }
*/


@end
