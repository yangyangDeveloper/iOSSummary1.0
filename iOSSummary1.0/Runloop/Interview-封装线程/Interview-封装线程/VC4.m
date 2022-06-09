//
//  VC4.m
//  Interview-封装线程
//
//  Created by zhangyangyang on 2022/2/3.
//

#import "VC4.h"

typedef void(^DoBlock)(void);
@interface ZYYPerson : NSObject
@property(nonatomic, copy) DoBlock doblock;
- (instancetype)initWithBlock:(DoBlock)block;

@end

@implementation ZYYPerson

- (instancetype)initWithBlock:(DoBlock)block
{
    self = [super init];
    if (self) {
        self.doblock = block;
        self.doblock();
    }
    return self;
}

@end

@interface VC4 ()
@property (nonatomic, strong) ZYYPerson *zyy;
@property (nonatomic, assign) BOOL iSkaixin;
@end

@implementation VC4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"大循环引用测试";
    [self test];
}

// self -> zyy-->block-->self
- (void)test {
    self.zyy = [[ZYYPerson alloc] initWithBlock:^{
        self.iSkaixin = YES;
        
    }];
    self.zyy.doblock();
}

// self ->zyy ->block  X  self   
- (void)test2 {
    __weak typeof(self) weakSelf = self;
    self.zyy = [[ZYYPerson alloc] initWithBlock:^{
        weakSelf.iSkaixin = YES;
    }];
    self.zyy.doblock();
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
