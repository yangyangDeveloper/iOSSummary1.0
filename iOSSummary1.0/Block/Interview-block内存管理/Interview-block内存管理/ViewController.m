//
//  ViewController.m
//  Interview-block内存管理
//
//  Created by zhangyangyang on 2022/2/9.
//

#import "ViewController.h"
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface Person : NSObject
@property(nonatomic, strong)NSString *name;
@end

@implementation Person

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test5];
}

// 栈block   ARC下栈block会对auto变量强引用     alloc1次  栈block持有1次
- (void)test1 {
    typedef void (^ __weak ZYBlock)();
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        NSLog(@"block之前%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        obj.name = @"yang";
        block = ^{
            NSLog(@"----------%@",obj.name);
        };
        NSLog(@"----------%@",[block class]);
        block();
        NSLog(@"block之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
    }
    
}

// case2 堆block  alloc1次  栈1次 堆1次  一共3次
- (void)test2 {
    typedef void (^ZYBlock)();
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        NSLog(@"block之前%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        obj.name = @"yang";
        block = ^{
            NSLog(@"----------%@",obj.name);
        };
        NSLog(@"----------%@",[block class]);
        NSLog(@"block之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
    }
    block();
}



// case3 block1次 栈1次 堆1次 共3次   出作用域之后  zyBlock2持有1次  共1次
- (void)test3 {
    typedef void (^ZYBlock)();
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        NSLog(@"block之前%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        obj.name = @"yang";
        block = ^{
            NSLog(@"----------%@",obj.name);
            NSLog(@"block被copy之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        };
        NSLog(@"----------%@",[block class]);
        NSLog(@"block之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
    }
    //block();
    void(^zyBlock2)() = [block copy];
    zyBlock2();
}

// ARC下不允许 copy一个栈指针在外面再去用  这种情况会崩溃
- (void)test4 {
    typedef void (^__weak ZYBlock)();
    void(^zyBlock2)() ;
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        NSLog(@"block之前%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        obj.name = @"yang";
        block = [^{
            NSLog(@"----------%@",obj.name);
            NSLog(@"block被copy之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        } copy];
        NSLog(@"----------%@",[block class]);
        NSLog(@"block之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        block();
    }
    block();
}


// 可以这么用 用一个堆block接一下
- (void)test5 {
    typedef void (^__weak ZYBlock)();
    void(^zyBlock2)() ;
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        NSLog(@"block之前%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        obj.name = @"yang";
        block = ^{
            NSLog(@"----------%@",obj.name);
            NSLog(@"出了函数作用域之后 obj引用计数为%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        };
        NSLog(@"----------%@",[block class]);
        NSLog(@"block之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
        zyBlock2 = [block copy];
        NSLog(@"block被copy之后%ld", CFGetRetainCount((__bridge  CFTypeRef)(obj)));
    }
    zyBlock2();
}

@end
