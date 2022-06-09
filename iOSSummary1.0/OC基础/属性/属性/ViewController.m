//
//  ViewController.m
//  属性
//
//  Created by zhangyangyang on 2022/1/15.
//

#import "ViewController.h"

@interface ViewController ()

// 首先这个对 mutable 对象 进行copy 是深copy   会开启新空间
// 另外copy返回的都是不可变对象
// 如果复制过来的是NSMutableArray copy之后是NSArray
// 如果复制过来的是NSArray copy之后是NSArray
// 如果删除操作 会崩溃

@property(copy) NSMutableArray *array;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}


@end
