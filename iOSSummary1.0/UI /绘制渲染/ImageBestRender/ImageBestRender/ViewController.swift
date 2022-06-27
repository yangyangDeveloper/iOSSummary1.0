//
//  ViewController.swift
//  ImageBestRender
//
//  Created by zhangyangyang on 2022/6/24.
//

import UIKit

class ViewController: UIViewController {
    var iv:UIImageView!
   //https://images-na.ssl-images-amazon.com/images/I/51f-7KjjFeL._SX317_BO1,204,203,200_.jpg

    let murl =  URL.init(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Ff%2F538e968b049a2.jpg&refer=http%3A%2F%2Fpic1.win4000.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1658634053&t=8ef95a2c99957de79b886287e8a07502")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iv = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300))
        self.iv.center = self.view.center
        self.iv.backgroundColor = UIColor.red
        self.view.addSubview(self.iv)
//        let mimage = try! UIImage.init(data: Data.init(contentsOf: murl!))
//        iv.image = mimage
        
        let downsimage = downsample(imageAt: murl!, to: self.view.bounds.size, scale: 1.0)
        iv.image = downsimage
    }
    
    func downsample(imageAt imageuil: URL, to pointsize: CGSize, scale:CGFloat)-> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageuil as CFURL, imageSourceOptions)
        
        let maxDimensionInPixels = max(pointsize.width, pointsize.height) * scale
        
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                         kCGImageSourceShouldCacheImmediately: true,
                                   kCGImageSourceCreateThumbnailWithTransform: true,
                                          kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        guard let downsampleimage = CGImageSourceCreateThumbnailAtIndex(imageSource!, 0, downsampleOptions) else { return nil }
        
        return UIImage.init(cgImage: downsampleimage)
    }
}

