//
//  ViewController.m
//  Interview-block
//
//  Created by zhangyangyang on 2022/5/5.
//

#import "ViewController.h"
#import "Person.h"

typedef void(^Block)(void);
@interface ViewController ()

@end

@implementation ViewController

/*
  ARC
  1、强指针 + 堆block   保命
  默认 __strong  默认copy
 */
// ARC __NSMallocBlock__  强
- (void)test1 {
    Block block;
    {
        
        Person *p = [[Person alloc] init];
        block = ^{
            NSLog(@"---%@",p);
        };
    }
    
    NSLog(@"-------");
    block();
}

// ARC  __NSMallocBlock__ 弱
- (void)test2 {
    Block block;
    {
        
        Person *p = [[Person alloc] init];
        
        __weak Person *weakp = p;
        block = ^{
            NSLog(@"---%@",weakp);
        };
    }
    
    NSLog(@"-------");
    NSLog(@"%@",[block class]);
    block();
}


// ARC  __NSStackBlock__  直接释放
- (void)test3 {
    Block block;
    {
        
        Person *p = [[Person alloc] init];
        ^{
            NSLog(@"---%@",p);
        }();
        
        // 没有触发copy 所以是栈block
        NSLog(@"%@",[^{
            NSLog(@"---%@",p);
        } class]);
        
        // 主动copy操作 变成堆block
        NSLog(@"%@",[[^{
            NSLog(@"---%@",p);
        }  copy]class]);
    }
    
    NSLog(@"-------");

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self test3];
}

@end
