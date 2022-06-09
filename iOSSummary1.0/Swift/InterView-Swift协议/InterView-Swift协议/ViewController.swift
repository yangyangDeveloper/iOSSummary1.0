//
//  ViewController.swift
//  InterView-Swift协议
//
//  Created by zhangyangyang on 2022/2/23.
//

import UIKit

// 遵循Equatable协议，重载==方法
class StreetAddress: Equatable {

    let number: String
    let street: String
    let unit: String?
    
    init(_ number: String, _ street: String, unit: String? = nil) {
        self.number = number
        self.street = street
        self.unit = unit
    }
    
    public static func == (lhs: StreetAddress, rhs: StreetAddress) -> Bool {
        // 需要比较的值
        return lhs.number == rhs.number && lhs.street == rhs.street
    }
}

struct GridPoint: Hashable {
    var x: Int
    var y: Int
    
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
         return lhs.x == rhs.x && lhs.y == rhs.y
     }

    // 实现改法替代hashvalue
    func hash(into hasher: inout Hasher) {
         hasher.combine(x)
         hasher.combine(y)
     }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //testEquatable()
        testHashable2()
    }

    //*对象的比较
    //原本比较的是两者的内存地址是一样的，很多时候这显然满足不了我们的需求，通过实现Equatable协议的方法，我们可以满足我们的需求，比较出两个对象属性值相等的情况
    func testEquatable() {
        let addresses = [StreetAddress("1490", "建国路"),
                         StreetAddress("2119", "人民路"),
                         StreetAddress("1400", "花园路")]
        let home = StreetAddress("1400", "16th Street")
        print(addresses.contains(home))   //去掉Equatable  会报错
    }
    
    func testHashable() {
        let home = StreetAddress("1400", "16th Street")
        //let addressset: Set = [home]  //  没有遵守Hashable  所以不允许进入集合
    }
    
    func testHashable2() {
        // 遵守了Hashable 所以可以放入set    swift中的基本类型 比如 string  int  都默认遵守了 Hashable协议
        var tappedPoints: Set = [GridPoint(x: 2, y: 3), GridPoint(x: 4, y: 1)]
        let nextTap = GridPoint(x: 0, y: 1)
        let newTap = GridPoint(x: 1, y: 1)
        
        if tappedPoints.contains(nextTap) {
            print("Already tapped at (\(nextTap.x), \(nextTap.y)).")
        } else {
            tappedPoints.insert(nextTap)
            print("New tap detected at (\(nextTap.x), \(nextTap.y)).")
        }
        
        // 作为字典key使用
        let dict = [newTap: "888", nextTap: "666"]
        print(dict[newTap])
    }
    
}

