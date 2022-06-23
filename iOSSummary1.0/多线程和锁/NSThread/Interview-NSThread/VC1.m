//
//  VC1.m
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "VC1.h"
#import "ZYYWeakTarget.h"
#import "ZYYThread.h"

@interface VC1 ()

@property (nonatomic, strong) ZYYThread *myThread;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 线程能执行完
    //[self runTargetThread];
    //[self runBlockThread];
    
    [self threadMemoryLeak2];
}

# pragma mark  临时线程
/*
 
  1、 线程执行完会退出 释放对target的强引用
  2、 vc释放 对thread  发送 release
  3、 线程最终释放
 */
- (void)runTargetThread {
    ZYYThread * thread =  [[ZYYThread alloc] initWithTarget:self selector:@selector(doSome) object:nil];
    [thread start];
    self.myThread = thread;
}

- (void)doSome {
    NSLog(@"%s", __func__);
}


/*
  1、线程执行完退出 使用block方式创建线程 不对self 强引用
  2、使用__weak 是针对block API的
  3、vc销毁 对线程发送 release  随后线程释放
 */
- (void)runBlockThread {
    __weak typeof(self) weakSelf = self;
    ZYYThread *thread = [[ZYYThread alloc] initWithBlock:^{
        NSLog(@"%@",weakSelf);
    }];
    [thread start];
    self.myThread = thread;
}


# pragma mark  常驻线程

/*
    runloop一直持有线程  线程任务永远没有执行结束   线程强引用target   所以线程和target 都不会释放
    解决方法是要 想办法停止runloop  让线程能够执行完成
 */
- (void)threadMemoryLeak {
    ZYYThread * thread =  [[ZYYThread alloc] initWithTarget:self selector:@selector(doRuntimeSome) object:nil];
    [thread start];
    self.myThread = thread;
}

- (void)doRuntimeSome {
    NSLog(@"%s", __func__);
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}



/*
    线程 不持有 target   target可以正常释放  但是线程不会释放
    runloop一直持有->线程
 */
- (void)threadMemoryLeak2 {
    __weak typeof(self) weakSelf = self;
    ZYYThread *thread = [[ZYYThread alloc] initWithBlock:^{
        NSLog(@"%@",weakSelf);
        NSLog(@"%s", __func__);
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }];
    [thread start];
    self.myThread = thread;
}


- (void)downloadTest {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.imageView.center = self.view.center;
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    //[self downloadImageOnSubThread];
    //[self threadMemoryLeak];
}

/**
  * 创建一个线程下载图片
  */
- (void)downloadImageOnSubThread {
    // 在创建的子线程中调用downloadImage下载图片
    self.myThread =  [[ZYYThread alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    [self.myThread start];
   // [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
    
}



// 如果thread 很快执行完了 他会主动释放target 不会构成死循环 如果加了 runloop  线程执行不完，不会释放target 一直强引用target
// block方法 可以解决 thead和target的循环关系  但是要注意 block自己的循环引用
- (void)threadMemoryLeak3 {
    __weak typeof(self) weakSelf = self;
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"%@",weakSelf);
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }];
    [thread start];
    self.myThread = thread;
}


// NSRunLoop 的 run 方法是无法停止的，它专门用于开启一个永不销毁的线程
// 线程强持有self  self得不到释放。 会造成内存泄漏
// 控制器释放问题  线程释放问题
- (void)downloadImage {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    

    // 1. 获取图片 imageUrl
    NSURL *imageUrl = [NSURL URLWithString:@"https://ysc-demo-1254961422.file.myqcloud.com/YSC-phread-NSThread-demo-icon.jpg"];
    
    // 2. 从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    // 通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];
    
    // 3. 回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
    
    NSLog(@"666");
    //[self performSelector:(nonnull SEL) withObject:<#(nullable id)#> afterDelay:<#(NSTimeInterval)#>]
}

- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    // 赋值图片到imageview
    self.imageView.image = image;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end







