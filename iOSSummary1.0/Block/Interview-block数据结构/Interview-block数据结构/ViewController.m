//
//  ViewController.m
//  Interview-block数据结构
//
//  Created by zhangyangyang on 2022/2/8.
//

#import "ViewController.h"
// #define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

static struct __ViewController__viewDidLoad_block_desc_0 {
  size_t reserved;
  size_t Block_size;
};

struct __ViewController__viewDidLoad_block_impl_0 {
  struct __block_impl impl;
  struct __ViewController__viewDidLoad_block_desc_0* Desc;
  int a;
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ^{
        NSLog(@"this is block1");
    };
    
    ^{
        NSLog(@"this is block2");
    }();
    
    //   等号左边            =   等号右边 
    //  定义一个myblock变量   =   把右边的block存起来
    int a = 10;
    void (^myblock)(void) = ^{
        NSLog(@"%d",a);
        NSLog(@"this is block3");
        NSLog(@"this is block3");
        NSLog(@"this is block3");
    };
    
    // 分析下block结构
    struct __ViewController__viewDidLoad_block_impl_0 *blockStruct = (__bridge struct __ViewController__viewDidLoad_block_impl_0 *)myblock;
    
    myblock();
    
}



@end
