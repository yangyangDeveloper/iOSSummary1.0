//
//  捕获总结.h
//  Interview-block捕获变量
//
//  Created by zhangyangyang on 2022/2/8.
//


/*
    局部捕获 全局不捕获
 */

// 捕获
void test1() {
    
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


// 不需要捕获
int age_ = 10;
static int height_ = 20;
void test2() {
    void(^block)(void) = ^{
        NSLog(@"a == %d", age_);
        NSLog(@"height == %d", height_);
    };
    
    age_ = 20;
    height_ = 20;
    block();
}


// 捕获
- (void)test3 {
    void(^block)(void) = ^{
        NSLog(@"%d",self);
    };
    block();
}


// 捕获
- (void)test4 {
    void(^block)(void) = ^{
        NSLog(@"%d",_name);
    };
    block();
}

// 捕获
- (void)test4 {
    void(^block)(void) = ^{
        // 假设我写了一个属性 我用 get方法   这样依然会捕获
        NSLog(@"%d",[self name]);
    };
    block();
}
