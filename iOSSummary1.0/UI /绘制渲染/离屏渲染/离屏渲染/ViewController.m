//
//  ViewController.m
//  离屏渲染
//
//  Created by zhangyangyang on 2022/6/20.
//

/*
  画家算法
  离屏渲染 当前屏幕渲染
  
  正常绘制： 从后往前 一个图层一个图层绘制 绘制一个丢一个
  离屏渲染： 绘制的图层不能丢弃 需要保存 最后统一应用裁剪处理
 */


/*
 操作3图层 圆角不一定触发离屏
 
 contents = nil
 背景色、
 边框、
 背景色+边框
 加上圆角+裁剪  别管yes no  都不会触发
 
 contents设置了内容
 背景色、
 边框、
 背景色+边框
 再加上圆角+裁剪，设置 yes 就会触发离屏渲染
 */

/*
 离屏渲染性能瓶颈
 1、创建其他上下文
 2、上下文切换
 */

/*
 圆角 + masksToBounds
 只会默认设置 backgroundColor 和 border 的圆角，而不会设置 content 的圆角, 除非同时设置了 layer.masksToBounds 为 true
 如果只是设置了 cornerRadius 而没有设置 masksToBounds，由于不需要叠加裁剪，此时是并不会触发离屏渲染的。
 而当设置了裁剪属性的时候，由于 masksToBounds 会对 layer 以及所有 subLayer 的 content 都进行裁剪，所以不得不触发离屏
 
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    //view
//    [self testv1];
//    [self testv2];
//    [self testv3];
//    [self testv4];
//    [self testv5];
    
    // btn
   // [self testb3];
   // [self testb2];
    
    // imageview
   // [self testi1];
    //  [self testi2];
    // [self testi3];
      [self testi4];

    // label
//    [self testla1];
}

- (void)testv1 {
    UIView *cview = [[UIView alloc] initWithFrame:CGRectMake(50, 20, 100, 100)];
    cview.backgroundColor = [UIColor orangeColor];
    cview.layer.cornerRadius = 50;
    cview.layer.borderColor = [UIColor greenColor].CGColor;
    cview.layer.borderWidth = 3;
    cview.layer.masksToBounds = YES;
    [self.view addSubview:cview];
    cview.clipsToBounds = YES;
}

- (void)testv2 {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(180, 20, 100.0, 100.0)];
    // 背景图层
    //view1.backgroundColor = [UIColor redColor];
    
    // 边框图层
    view1.layer.borderColor = [UIColor greenColor].CGColor;
    view1.layer.borderWidth = 3;
    
    // content图层
    view1.layer.contents = (__bridge id)[UIImage imageNamed:@"btnimage"].CGImage;
    
    // 设置圆角
    view1.layer.cornerRadius = 100.0;
    // 设置裁剪
    view1.layer.masksToBounds = YES;
    //view1.clipsToBounds = YES;
    [self.view addSubview:view1];
}

// 间接设置 view的 content 图层
- (void)testv3 {
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
    // 背景图层
    view1.backgroundColor = UIColor.redColor;
    // 边框图层
    view1.layer.borderWidth = 2.0;
    view1.layer.borderColor = UIColor.blackColor.CGColor;
    
    // 设置圆角
    view1.layer.cornerRadius = 100.0;
    // 设置裁剪
    view1.clipsToBounds = YES;
    
    // 子视图
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100.0, 100.0)];
    
    // 下面3个任何一个属性 都能离屏渲染
    // 背景图层
    view2.backgroundColor = UIColor.blueColor;
    
    // 内容图层
    view2.layer.contents = (__bridge id)([UIImage imageNamed:@"btnimage"].CGImage);
    
    // 边框图层
    view2.layer.borderWidth = 2.0;
    view2.layer.borderColor = UIColor.blackColor.CGColor;
    
    [view1 addSubview:view2];
    view1.center = self.view.center;
    [self.view addSubview:view1];
}

// 直接设置 view的 content图层
- (void)testv4 {
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(180, 20, 100.0, 100.0)];
    // 背景图层
    //view1.backgroundColor = [UIColor redColor];
    
    // 边框图层
    view1.layer.borderColor = [UIColor greenColor].CGColor;
    view1.layer.borderWidth = 3;
  
    // content图层
    view1.layer.contents = (__bridge id)[UIImage imageNamed:@"btnimage"].CGImage;
    
    // 设置圆角
    view1.layer.cornerRadius = 100.0;
    
    // 设置裁剪
    view1.layer.masksToBounds = YES;
    view1.clipsToBounds = YES;
    [self.view addSubview:view1];
}

- (void)testv5 {
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(180, 20, 100.0, 100.0)];
    // 背景图层
    view1.backgroundColor = [UIColor redColor];
    
    // 边框图层
    view1.layer.borderColor = [UIColor greenColor].CGColor;
    view1.layer.borderWidth = 3;
  
    
    // content图层
    view1.layer.contents = (__bridge id)[UIImage imageNamed:@"btnimage"].CGImage;
    
    // 设置圆角
    view1.layer.cornerRadius = 50.0;  // 只会默认设置 backgroundColor 和 border 的圆角，而不会设置 content 的圆角, 除非同时设置了 layer.masksToBounds 为 true
    
    // 设置裁剪
    // view1.layer.masksToBounds = YES;   // 触发离屏渲染的原因
    // 如果只是设置了 cornerRadius 而没有设置 masksToBounds，由于不需要叠加裁剪，此时是并不会触发离屏渲染的。而当设置了裁剪属性的时候，由于 masksToBounds 会对 layer 以及所有 subLayer 的 content 都进行裁剪，所以不得不触发离屏渲染
   
    view1.clipsToBounds = YES;
    [self.view addSubview:view1];
}

#pragma mark  btn 3种场景

// content为空 不触发
- (void)testb1 {
    // 按钮不存在背景图
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    // 背景图层
    btn2.backgroundColor = [UIColor redColor];
    btn2.frame = CGRectMake(100, 250, 60, 60);
    
    [self.view addSubview:btn2];
    
    btn2.clipsToBounds = YES;
    btn2.layer.cornerRadius = 30;
}

// content 存在  btn image的时候 默认会创建一个imageview 所以这里有多图层 一个是btn 一个imageview 所以触发
- (void)testb2 {
    // 按钮存在背景图
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 160, 60, 60);
    [self.view addSubview:btn];
    
    // content图层
    [btn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
    
    // 裁切圆角
    btn.layer.cornerRadius = 30;
    btn.clipsToBounds = YES;
}

//  content存在 但是直接修改的是imageview的图层  所以不会触发离屏
- (void)testb3 {
    
    // 按钮存在背景图
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  
    // 打开关闭 都不触发离屏渲染 因为下面的裁切和他没关系
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(100, 160, 60, 60);
    
    [self.view addSubview:btn];
    
    // content图层
    [btn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
    
    // 裁切圆角
    btn.imageView.layer.cornerRadius = 30;
    btn.imageView.clipsToBounds = YES;
}


#pragma mark  imageview 2种场景

// content 为空
- (void)testi1 {
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 340, 60, 60)];
    
    // 背景图层
    imageview.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageview];
    
    // 边框图层
    imageview.layer.borderColor = [UIColor greenColor].CGColor;
    imageview.layer.borderWidth = 3;

    imageview.layer.cornerRadius = 30;
    imageview.clipsToBounds = YES;
}

// content不为空
- (void)testi2 {
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 340, 60, 60)];
    [self.view addSubview:imageview];
    
    // content图层
    imageview.image = [UIImage imageNamed:@"me"];
    imageview.layer.cornerRadius = 30;
    imageview.clipsToBounds = YES;
}

// content不为空 + 边框 + 背景色  3图层     圆角 + clipsToBounds
- (void)testi3 {
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 340, 60, 60)];
    
    // 背景图层
    imageview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imageview];
    
    // 边框图层
    imageview.layer.borderColor = [UIColor greenColor].CGColor;
    imageview.layer.borderWidth = 3;
    
    // content图层
    imageview.image = [UIImage imageNamed:@"me"];
    imageview.layer.cornerRadius = 30;
    imageview.clipsToBounds = YES;
}

// content不为空 + 边框 + 背景色 但是不进行clipsToBounds
- (void)testi4 {
   
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 430, 60, 60)];
 
    // 背景图层
    imageview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imageview];
    
    // 边框图层
    imageview.layer.borderColor = [UIColor greenColor].CGColor;
    imageview.layer.borderWidth = 3;
    
    // content图层
    imageview.image = [UIImage imageNamed:@"me"];
    imageview.layer.cornerRadius = 30;
}

- (void)testla1 {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 100, 40)];
    label.text = @"我是事实";
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor orangeColor];
    label.layer.opacity = 0.5;
    label.layer.allowsGroupOpacity = YES;
    [self.view addSubview:label];
}

@end
