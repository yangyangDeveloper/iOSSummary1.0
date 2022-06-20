//
//  ViewController.m
//  基础整理
//
//  Created by zhangyangyang on 2022/6/20.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 回调函数
    test();
    
    // 结构体
    testStuct();
}

/*
    函数指针  数组指针  本质是指针
    指针数组  元素是指针
    整形数组  元素是整形
  字符串数组  元素是字符串
 
    函数指针的作用
    1、 调用函数
    2、 作为函数的参数传递 回调函数
 
 
    指针函数
    本质是一个函数，只不过函数返回值为某一类型的指针。 外面必须用同类型的变量来接收
    int* sum(int a,int b);
    int *sum(int a,int b);
*/

- (void)testShow {
    
    /*
    //指针指向整形数
    int *a;
    
    //指针的指针 指向整形数
    int **a;
    
    // 一个有10个整形数的数组
    int a[10];

    // 指针数组 存储的元素都是指针
    int *a[10];  一个有10个指针的数组 其中指针是指向一个整形数的

    // 数组指针  指向数组的指针
    int (*a)[10];   一个指向有10个整形数数组的指针

    // 函数指针  指向函数的指针
    int (*a) (int);  （该函数的类型是参数int 返回值int ）

    // 存放了 10个 函数指针的 数组
    int (*a[10]) (int);  一个有10个指针的数组  里面的指针是指向一个函数 该函数 返回值是int 返回值是int
     
    */
}

/*
 函数指针的应用 --》 回调函数
 回调函数是由别人的函数执行时调用你实现的函数。
 */

int add_ret() ;

int add(int a , int b , int (*add_value)())
{
    return (*add_value)(a,b);
}

void test(void) {
    int sum = add(3,4,add_ret);
    printf("sum:%d",sum);
}

int add_ret(int a , int b)
{
    return a+b ;
}


/*
 
 * C语言 不能继承  C++的Struct就是class 可以继承
 * C必须到处加 stuct关键字  C++ 不用
 
 
 C中
 c语言中 struct Student 和在一起 才能表示一个结构体类型
 1）MyStruct 变量名；
 2）struct tagMyStruct 变量名；


 C++中：
 1）MyStruct 变量名；
 2）struct tagMyStruct 变量名；
 3）tagMyStruct 变量名；
 
 
 */

typedef struct tagMyStruct{
    int iNum;
    long lLength;
} MyStruct;

void testStuct(void) {
    MyStruct stu1;
    struct tagMyStruct stu2;
}

@end

