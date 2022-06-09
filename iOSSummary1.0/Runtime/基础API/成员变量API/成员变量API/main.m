//
//  main.m
//  成员变量API
//
//  Created by zhangyangyang on 2022/1/29.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZYYPerson.h"
#import <objc/runtime.h>

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        
        ZYYPerson *zyy = [[ZYYPerson alloc] init];
        object_getClass(zyy)
        
        
        // 获取成员变量信息
        Ivar nameIvar = class_getInstanceVariable([ZYYPerson class], "_name");
        // 输出信息
        ivar_getName(nameIvar);
        ivar_getTypeEncoding(nameIvar);
        NSLog(@"%s %s", ivar_getName(nameIvar), ivar_getTypeEncoding(nameIvar));
        
        // 修改成员变量的值
        object_setIvar(zyy, nameIvar, @"yangyang");
        object_getIvar(zyy, nameIvar);
        NSLog(@"%@", object_getIvar(zyy, nameIvar));
        NSLog(@"%@", zyy->_name);
        
        // age是int类型
        Ivar ageIvar = class_getInstanceVariable([ZYYPerson class], "_age");
        // object_setIvar(zyy, ageIvar, @10);   不能用 nsnumber 给 int
        object_setIvar(zyy, ageIvar, (__bridge id)(void *)10);
        NSLog(@"%d", object_getIvar(zyy, ageIvar));
        
    
        //NSLog(@"%d", zyy->_age);
        
        
        // 获取成员变量数量
        unsigned int count;
        Ivar *ivars = class_copyIvarList([ZYYPerson class], &count);
        
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
            
        }
        
        // 注意销毁这个对象
        free(ivars);
        
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
