//
//  ViewController.swift
//  绘图技巧
//
//  Created by zhangyangyang on 2022/6/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
     
     UIGraphicsBeginImageContextWithOptions
     有时候我们需要在 draw(_:) 之外绘图，UIKit 同样为我们提供了一个创建 context 的便捷方式
     
     UIGraphicsBeginImageContextWithOptions(size, false, 0)
     // your custom drawing code
     UIGraphicsEndImageContext()
     
     三个参数，size 是画布的大小，opaque 是标识视图是否透明，如果为 true，画布的背景就是黑色，反之为透明，最后一个参数是 scale，0 代表适配设备的 scale
     
     */
    // 将颜色绘制为图片
    func imageFromColor(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

