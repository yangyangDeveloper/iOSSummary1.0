//
//  main.m
//  Interview-block捕获变量
//
//  Created by zhangyangyang on 2022/2/8.
//

//#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*
   block变量捕获机制
   1、 block会捕获局部变量   全局变量不需要捕获
   2、 局部变量如果是 static类型 是地址传递  如果是auto类型 是值传递
 
   为什么局部变量会捕获 全局不需要捕获呢？
   因为是跨函数访问 跨作用域访问  局部变量出函数作用域就没有了  所以block 需要捕获局部变量  也就是 封装函数执行上下文了
*/


/*
  self 是局部变量 不是全局变量
  方法里面用的self 是外界对象调用函数时候传递进来的 可以是 person1对象 person2对象  他不是全局变量
 */



// 为了保存函数执行上下文 block会捕获局部变量
void test() {
    
    // 局部变量 分 static 和 auto
    
    // auto int a = 10;  auto 默认会帮我们加上  我们不用写
    int a = 10;
    
    static int height = 10;
    
    // block 捕获的是当前a的值
    void(^block)(void) = ^{
        NSLog(@"a == %d", a);
        NSLog(@"height == %d", height);
    };
    
    a = 20;
    height = 20;
    block();
}



int age_ = 10;
static int height_ = 20;
// 全部变量不需要捕获
void test2() {
    void(^block)(void) = ^{
        NSLog(@"a == %d", age_);
        NSLog(@"height == %d", height_);
    };
    
    age_ = 20;
    height_ = 20;
    block();
}


int main(int argc, char * argv[]) {
    //test()
    test2();
    
    return 0;
}





