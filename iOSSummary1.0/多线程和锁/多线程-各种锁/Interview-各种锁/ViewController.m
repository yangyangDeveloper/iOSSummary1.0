//
//  ViewController.m
//  Interview-各种锁
//
//  Created by zhangyangyang on 2022/2/11.
//

#import "ViewController.h"

@interface ViewController ()

@end

/*
    多条线程访问读写 同一条数据  会出现 线程安全隐患  需要使用线程同步技术 也就是加锁
 
    误区：
    1、看到多线程就加锁
    2、多线程都是读取某一条数据 没有写的操作   不需要加锁
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
