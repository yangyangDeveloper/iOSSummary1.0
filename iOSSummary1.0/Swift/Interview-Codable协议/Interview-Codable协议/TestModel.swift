//
//  TestModel.swift
//  Interview-Codable协议
//
//  Created by zhangyangyang on 2022/2/23.
//

import Foundation


//struct TestModel: Decodable {
//    var name: String?
//    var age: Int?
//    var money: Double?
//}


//struct TestModel: Decodable, Encodable {
//    var name: String?
//    var age: Int?
//    var money: Double?
//    var id: Int?
//    var books:[BookModel]?
//}
//
//struct BookModel: Decodable, Encodable {
//    var name: String?
//    var price: Double?
//}



struct TestModel: Codable {
    var name: String?
    var age: Int?
    var money: Double?
    var id: Int?
    var books:[BookModel]?
}

struct BookModel: Codable {
    var name: String?
    var price: Double?
}

