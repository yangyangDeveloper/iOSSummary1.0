//
//  ViewController.swift
//  Interview-Codable协议
//
//  Created by zhangyangyang on 2022/2/23.
//

import UIKit
import CoreLocation

// public typealias Codable = Decodable & Encodable
// Codable swift4出现了Codable协议，只要继承该协议，便可使用系统的模型转换，字典转模型，模型转字典

class BannerModel: Codable {
    var banners: [Banner]?
    var name: String?
}

class Banner: Codable {
    var imgUrl: String?
    var action: String?
}

class ViewController: UIViewController {
    
    func testDicToModel() {
        let dic: [String : Any] = [
            "name" : "张三",
            "age" : 25,
            "money": 10000.00
        ]
        
        let model1 = ZYYDecoder.decode(TestModel.self, param: dic)
        
        let model2 = TestModel.decode(dic)
        
        print(model2?.name)
    }
    
    func testDic2ToModel() {
        let dic: [String : Any] = [
            "name" : "张三",
            "age" : 25,
            "money": 10000.00,
            "id": 9527,
            "books":[
                ["name": "三国演义",
                "price": 99.9],
                ["name": "西游记",
                 "price": 199.9]
            ]
        ]
        
        let model1 = ZYYDecoder.decode(TestModel.self, param: dic)
        
        let model2 = TestModel.decode(dic)
        
        print(model2?.name)
    }
    
    //  只解析 books
    func testArrayToModel() {
        let dic: [String : Any] = [
            "name" : "张三",
            "age" : 25,
            "money": 10000.00,
            "id": 9527,
            "books":[
                ["name": "三国演义",
                "price": 99.9],
                ["name": "西游记",
                 "price": 199.9]
            ]
        ]
        
        if let books = dic["books"] as? [[String:Any]] {
            // 第一种方法
            let model1 = ZYYDecoder.decode(BookModel.self, array: books)
            
            // 第二种方法
            let model2 = [BookModel].decode(books)
            
        }
    }
    
    // json转化model
    func testJsonToModel() {
        let landmarkData = ZYYDecoder.decode(BannerModel.self, filename: "banner.json")
        
    }
    
    
    // 模型转换成字典
    func testModelToDic() {
        
        let dic: [String : Any] = [
            "name" : "张三",
            "age" : 25,
            "money": 10000.00,
            "id": 9527,
            "books":[
                ["name": "三国演义",
                "price": 99.9],
                ["name": "西游记",
                 "price": 199.9]
            ]
        ]
        
        let model1 = TestModel.decode(dic)
        
        
        // 第一种
        if let model = TestModel.decode(dic) {
            let dic = ZYYEncoder.encoder(toDictionary: model);
        }
        
        // 第二种
        if let model = TestModel.decode(dic) {
            let dict = model.encoder()?.toDictionary()
        }
    }
    
    
    // 模型转换json字符串
    func testModelToStr() {
        
        let dic: [String : Any] = [
            "name" : "张三",
            "age" : 25,
            "money": 10000.00,
            "id": 9527,
            "books":[
                ["name": "三国演义",
                "price": 99.9],
                ["name": "西游记",
                 "price": 199.9]
            ]
        ]
        
        let model1 = TestModel.decode(dic)
        
        
        // 第一种
        if let model = TestModel.decode(dic) {
            let str = ZYYEncoder.encoder(toString: model);
            print(str)
        }
        
        // 第二种
        if let model = TestModel.decode(dic) {
            let str = model.encoder()?.toString()
            print(str)
        }
    }
    

    // 模型转换array
    func testModelToArray() {
        
        let dic: [String : Any] = [
            "name" : "张三",
            "age" : 25,
            "money": 10000.00,
            "id": 9527,
            "books":[
                ["name": "三国演义",
                "price": 99.9],
                ["name": "西游记",
                 "price": 199.9]
            ]
        ]
        
        if let books = dic["books"] as? [[String:Any]] {
            
            let model2 = [BookModel].decode(books)
            
            // 第一种
            if let model2 = [BookModel].decode(books) {
                let array = model2.encoder()?.toArrray()
                array.map { item in
                    print(item)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 数据转模型     json 字典  数组  转位data  data转json  json序列化转model
        //testDicToModel()
        //testDic2ToModel()
        //testArrayToModel()
        //testJsonToModel()
        
        // 模型转数据
        //testModelToDic()
        testModelToStr()
        //testModelToArray()
    }
    
    func singleJson() {
        guard let path = Bundle.main.path(forResource: "banner", ofType: "json") else { return }
        let localData = NSData.init(contentsOfFile: path)! as Data
        do {
            let banner = try JSONDecoder().decode(BannerModel.self, from: localData)
            if let banners = banner.banners {
                //self.banners = banners
            }
        } catch {
            debugPrint("banner===ERROR")
        }
    }
}

