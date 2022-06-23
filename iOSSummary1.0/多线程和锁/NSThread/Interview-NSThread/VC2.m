//
//  VC2.m
//  Interview-NSThread
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "VC2.h"
#import "ZYYPermanentThread.h"

// 常驻子线程 下载图片  点击屏幕 杀死常驻线程.  页面离开 杀死常驻线程
@interface VC2 ()
@property (nonatomic, strong) ZYYPermanentThread * perthread;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testPermanentThread];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    __weak typeof(self) weakSelf = self;
    [self.perthread executeTaskWithBlock:^{
        [weakSelf downloadImage];
    }];
}

// 常驻线程下载图片
- (void)testPermanentThread {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.imageView.center = self.view.center;
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    
    ZYYPermanentThread *t = [[ZYYPermanentThread alloc] init];
    self.perthread = t;
    [self.perthread run];
}

// 常驻线程需要执行的任务
- (void)downloadImage {
    NSLog(@"current thread -- %@", [NSThread currentThread]);

    // 1. 获取图片 imageUrl
    NSURL *imageUrl = [NSURL URLWithString:@"https://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_5.jpg"];

    // 2. 从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    // 通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];

    // 3. 回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
    NSLog(@"666");
}

- (void)refreshOnMainThread:(UIImage *)image {
    self.imageView.image = image;
}

- (void)dealloc {
    [self.perthread stop];
    NSLog(@"%s", __func__);
}
@end
