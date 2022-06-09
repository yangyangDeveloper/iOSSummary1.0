//
//  VC5.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "VC5.h"
#import "ZYYThread.h"

@interface VC5 ()
@property (nonatomic, strong) ZYYThread *thread;
@property (nonatomic, assign) BOOL isStop;
@end

@implementation VC5

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最终写法";
    self.isStop = NO;
    
    __weak typeof(self) weakSelf = self;
    self.thread = [[ZYYThread alloc] initWithBlock:^{
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (!weakSelf.isStop && weakSelf) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"end");
    }];
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self doSomething];
}

- (IBAction)startwork:(id)sender {
    [self doSomething];
}

- (void)doSomething {
    if (!self.thread)  return;
    [self performSelector:@selector(dojump) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)dojump {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (IBAction)closeRunloop:(id)sender {
    [self stopRunloop];
}

- (void)stopRunloop {
    if (!self.thread)  return;
    [self performSelector:@selector(stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stop {
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc {
    [self stopRunloop];
    NSLog(@"%s",__func__);
}

@end
