//
//  ZYYPlaceholderView.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/29.
//

#import "ZYYPlaceholderView.h"

@implementation ZYYPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.bgview.center = self.center;
    self.bgview.backgroundColor = [UIColor redColor];
    [self addSubview:self.bgview];
    
    self.tipBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgview.frame.origin.y + 100, 100, 40)];
    [self.tipBtn setTitle:@"无数据" forState:UIControlStateNormal];
    [self.tipBtn setBackgroundColor:[UIColor grayColor]];
    [self.tipBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.tipBtn];
    
}

- (void)click:(id)sender {
    NSLog(@"点击按钮");
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

@end
