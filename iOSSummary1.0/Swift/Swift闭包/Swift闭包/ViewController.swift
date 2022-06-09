//
//  ViewController.swift
//  Swift闭包
//
//  Created by zhangyangyang on 2022/2/18.
//

import UIKit

// Swift 中 @ 开头通常代表着 Attribute

class ViewController: UIViewController {

    // 定义一个数组用于存储闭包类型
    var completionHandlers: [(Int, Int) -> Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 调用
        exec(v1: 10, v2: 20) {
            $0 + $1
        }
        
        exec2(v1: 10, v2: 20) {
            $0 + $1
        }
        
        // logIfTrue(predicate: () -> Bool)
        logIfTrue { 1 < 2 }
        
        // 即在调用原本的 func 时，可以省略 Closure 参数的大括号
        logIfTrueWithAutoclosure(1 < 2)
    }

    // 尾随闭包   尾随闭包是一个被书写在函数调用括号外面(后面)的闭包表达式
    // 将一个很长的闭包表达式作为函数的最后一个实参
    // fn 就是一个尾随闭包参数
    func exec(v1: Int, v2: Int, fn: (Int, Int) -> Int) {
        let t =  fn(v1, v2)
        print(t)
    }
    
    // 逃逸闭包 闭包调用逃离了函数的作用域  闭包有可能在函数结束后调用 需要通过@escaping声明
    func exec2(v1: Int, v2: Int, fn: @escaping (Int, Int) -> Int) {
        completionHandlers.append(fn)

    }
    
    // 正常调用  logIfTrue { 1 < 2 }
    func logIfTrue(_ predicate: () -> Bool) {
        if predicate() {
            print("True")
        }
    }
    
    // 自动闭包 该 Closure 必须为无参，返回值可有可无  logIfTrueWithAutoclosure(1 < 2)  他省略了 大括号
    func logIfTrueWithAutoclosure(_ predicate: @autoclosure () -> Bool) {
        if predicate() {
            print("True")
        }
    }
}


