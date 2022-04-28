//
//  ViewController.m
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "ViewController.h"

/*
 
 @interface NSObject (NSThreadPerformAdditions) {
    
     // 在主线程上执行操作
     - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
     - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray<NSString *> *)array;


     // 在指定线程上执行操作
     - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array
     - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait
     
 }

 // 在当前线程上执行操作，调用 NSObject 的 performSelector:相关方法
 
 @interface NSObject {
    - (id)performSelector:(SEL)aSelector;
     - (id)performSelector:(SEL)aSelector withObject:(id)object;
     - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
 }
 
 还有一个变种 带延迟的
 @interface NSObject (NSDelayedPerforming)

 - (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray<NSRunLoopMode> *)modes;
 - (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
 + (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument;
 + (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;

 @end




 
 */
@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadTest];
}

- (void)downloadTest {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.imageView.center = self.view.center;
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    [self downloadImageOnSubThread];
}
/**
  * 创建一个线程下载图片
  */
- (void)downloadImageOnSubThread {
    // 在创建的子线程中调用downloadImage下载图片
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

- (void)downloadImage {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 1. 获取图片 imageUrl
    NSURL *imageUrl = [NSURL URLWithString:@"https://ysc-demo-1254961422.file.myqcloud.com/YSC-phread-NSThread-demo-icon.jpg"];
    
    // 2. 从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    // 通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];
    
    // 3. 回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
    
    [self performSelector:<#(nonnull SEL)#> withObject:<#(nullable id)#> afterDelay:<#(NSTimeInterval)#>]
}

- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 赋值图片到imageview
    self.imageView.image = image;
}

@end
