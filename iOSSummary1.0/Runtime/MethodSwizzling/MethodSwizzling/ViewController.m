//
//  ViewController.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/28.
//

#import "ViewController.h"
#import "ZYYPerson.h"
#import "ZYYPerson+Swizzling.h"
#import "UIButton+Swizzling.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self test1];
    //[self testCategory];
    [self testBtnClick];
}

- (void)test1 {
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    [zyy test2];
}


- (void)testCategory {
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    [zyy test2];
}

- (void)testBtnClick {
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 100, 100)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"6666" forState:UIControlStateNormal];
    //btn.center = self.view.center;
    [self.view addSubview:btn];
    btn.zyy_acceptEventInterval = 4;
    [btn addTarget:self action:@selector(dosome:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dosome:(id)sender {
    NSLog(@"点击按钮");
}
@end
