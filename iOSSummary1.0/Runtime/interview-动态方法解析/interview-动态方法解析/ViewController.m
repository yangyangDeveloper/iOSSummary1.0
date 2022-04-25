//
//  ViewController.m
//  interview-动态方法解析
//
//  Created by zhangyangyang on 2022/4/24.
//

#import "ViewController.h"
#import "ZYYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 有run 有test 只实现了 test
    ZYYPerson *zyyp = [[ZYYPerson alloc] init];
    [zyyp run];
}

@end
