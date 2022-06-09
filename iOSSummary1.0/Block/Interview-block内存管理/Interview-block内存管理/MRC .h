//
//  MRC .h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/12/4.
//


@interface Person : NSObject
@property(nonatomic, strong)NSString *name;
@end

@implementation Person

- (void)dealloc {
    NSLog(@"%s",__func__);
    [super dealloc];
}
@end



// case1  栈block
// obj 是 strong 修饰，但是并没有被 block 强引用  生成的中间block对象 不会auto变量产生强引用不retain

- (void)test1 {
    typedef void (^ZYBlock)();
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        obj.name = @"yang";
        block = ^{
            NSLog(@"----------%@",obj.name);
        };
        NSLog(@"----------%@",[block class]);
        block();
        [obj release];
    }
}

----------__NSStackBlock__
----------yang
-[Person dealloc]

// case2 栈block崩溃
- (void)test2 {
    typedef void (^ZYBlock)();
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        obj.name = @"yang";
        block = ^{
            NSLog(@"----------%@",obj.name);
        };
        NSLog(@"----------%@",[block class]);
        [obj release];
    }
    block();
}

输出

崩溃

// case3 copy栈block  解决崩溃  但是没有释放obj  堆block还持有obj一次
- (void)test3 {
    typedef void (^ZYBlock)();
    ZYBlock block;
    {
        Person *obj = [[Person alloc] init];
        obj.name = @"yang";
        block = [^{
            NSLog(@"----------%@",obj.name);
        } copy];
        NSLog(@"----------%@",[block class]);
        NSLog(@"前%ld",obj.retainCount);  //obj = 2
        [obj release];  // obj-1
        NSLog(@"后%ld",obj.retainCount);  //obj = 1
    }
    block();
    [block release];  // 这里 堆block释放  然后 obj 在收到一条release消息  obj retaincout 变成了0  也就释放了  
}
----------__NSMallocBlock__
前2
后1
----------yang
-[Person dealloc]
