//
//  VC3.m
//  图层绘制
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "VC3.h"
#import "KCView.h"

@interface VC3 ()

@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义图层绘制";
    KCView *view = [[KCView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor= [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
    [self.view addSubview:view];
    
}



@end
