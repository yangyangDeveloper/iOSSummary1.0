//
//  ViewController.m
//  interview-消息发送机制
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
    ZYYPerson *zyyp = [[ZYYPerson alloc] init];
    // zyyp 就是消息接收者  receiver
    // test就是消息名称
    [zyyp test];
    
    // per称为消息接收者(receiver), test称为消息名称
    // objc_msgSend(per, sel_registerName("test"));
}

@end
