//
//  ViewController.m
//  获取类
//
//  Created by zhangyangyang on 2022/1/30.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "ZYYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // instance对象
    ZYYPerson *zyy = [[ZYYPerson alloc] init];
    NSLog(@"%p",zyy);
    
    // 类对象
   
    Class cls1 = [zyy class];
    Class cls2 = [ZYYPerson class];
    Class cls3 = objc_getClass("ZYYPerson");
    Class cls4 = object_getClass(zyy);
    NSLog(@"%p %p %p %p", cls1, cls2, cls3, cls4);
    
    // 元类对象
    Class cls5 = object_getClass([ZYYPerson class]);
    Class cls6 = object_getClass(cls5);
    NSLog(@"%p %p", cls5, cls6);
}

/*
 
    + (Class)class  - (Class)class
    2个class 方法 返回的都是类对象
        1、 如果是instache对象调用 就返回类对象
        2、 如果是类对象就返回自身
    objc_getClass 传入字符串类名  返回对应的类对象
    
    object_getClass  接受一个id类型
        1、如果是 instance类型  return 类对象
        2、如果是类对象  retrun 元类对象
        3、如果是元类对象  retrun 元类根元类
        4、如果是NSObject对象 return  元类根元类
*/

@end
