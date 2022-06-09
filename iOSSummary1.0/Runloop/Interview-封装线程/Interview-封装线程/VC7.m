//
//  VC7.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "VC7.h"
#import "ZYYPermenantThread_C.h"

@interface VC7 ()
@property (nonatomic, strong) ZYYPermenantThread_C *thread;
@end

@implementation VC7

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用c封装常驻线程";
    
    ZYYPermenantThread_C *zythread = [[ZYYPermenantThread_C alloc] init];
    self.thread = zythread;
    [self.thread run];
}

- (IBAction)stop:(id)sender {
    [self.thread stop];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 两种使用方式
    __weak typeof(self) weakSelf = self;
    [self.thread executeTaskWithBlock:^{
        [weakSelf test];
    }];
    
    // 也可以使用target
    // [self.thread executeTask:self action:@selector(gogo) object:nil];
}

// 子线程需要执行的任务
- (void)test {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (void)dealloc {
   NSLog(@"%s",__func__);
}
@end
