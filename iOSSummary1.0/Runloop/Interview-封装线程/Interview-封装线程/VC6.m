//
//  VC6.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "VC6.h"
#import "ZYYPermenantThread.h"

@interface VC6 ()
@property (nonatomic, strong) ZYYPermenantThread *thread;
@end

@implementation VC6

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ZYYPermenantThread *zythread = [[ZYYPermenantThread alloc] init];
    self.thread = zythread;
    [self.thread run];
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

- (void)gogo {
    [self test];
}

- (IBAction)stop:(id)sender {
    [self.thread stop];
}

// 子线程需要执行的任务
- (void)test {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (void)dealloc {
   NSLog(@"%s",__func__);
}

@end
