//
//  ViewController.m
//  Interview-block捕获对象释放时机
//
//  Created by zhangyangyang on 2022/2/9.
//

#import "ViewController.h"
#import "ZYYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// ZYYPerson什么时候销毁 就看使用强引用的block 什么时候释放  那么ZYYPerson 也就跟着释放
// GCD中的block 都会自动进行copy  也就是把栈block  copy到堆上   然后捕获auto变量对象类型


//// 点击之后3秒释放zyy
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ZYYPerson *zyy = [[ZYYPerson alloc] init];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"1---%@", zyy);
//    });
//    NSLog(@"%s",__func__);
//}

// 点击之后立即释放zyy
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ZYYPerson *zyy = [[ZYYPerson alloc] init];
//
//    __weak ZYYPerson *weakzyy = zyy;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"1---%@", weakzyy);
//    });
//    NSLog(@"%s",__func__);
//}

// 点击之后 3s 释放zyy
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZYYPerson *zyy = [[ZYYPerson alloc] init];

    __weak ZYYPerson *weakzyy = zyy;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"1---%@", weakzyy);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"1---%@", zyy);

        });
    });
    NSLog(@"%s",__func__);
}

@end
