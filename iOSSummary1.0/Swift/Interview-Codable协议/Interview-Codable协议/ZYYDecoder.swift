//
//  ZYYDecoder.swift
//  Interview-Codable协议
//
//  Created by zhangyangyang on 2022/2/23.
//

import Foundation

/*
 
 open func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
 */
struct ZYYDecoder {
    
    //转换模型(单个)
    public static func decode<T>(_ type:T.Type, param: [String:Any]) ->T?  where T: Decodable {
        
        guard let jsonData = self.getJsonData(with: param) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(T.self, from: jsonData) else {
            return nil
        }
        return model
    }
    
    //转换模型(多个)
    public static func decode<T>(_ type:T.Type, array: [[String:Any]]) -> [T]? where T: Decodable {
        guard let data = self.getJsonData(with: array) else {
            return nil
        }
        guard let models = try? JSONDecoder().decode([T].self, from: data) else {
            return nil
        }
        return models
    }
    
    
    public static func decode<T> (_ type:T.Type, filename: String) -> T? where T: Decodable {
        let data:Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch  {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let t = try JSONDecoder().decode(T.self, from: data)
            return t
        } catch  {
            fatalError("Couldn't parse \(filename) as \([T].self):\n\(error)")
        }
    }
    
    
    //  把字典和数组转化为json
    public static func getJsonData(with param: Any) -> Data?  {
        
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}


extension Decodable {
    
    /// dictionary->模型 eg:  Model.decode(dic)
    public static func decode(_ dictionary: [String:Any]) -> Self? {
        guard let data = self.getJsonData(with: dictionary) else {
            return nil
        }
        guard let model = try?JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }
    
    /// array->模型 eg:[Model].decode(array)
    public static func decode(_ array: [[String:Any]]) -> Self? {
        guard let data = self.getJsonData(with: array) else {
            return nil
        }
        
        guard let model = try?JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }
    
    /*

     如果是单个，则 Model.decode(json)

     如果是多个，则 [Model].decode(json)

     */
    // JSON->模型
//    public static func decode(_ json: JSON) ->Self? {
//
//        guard let data = try? json.rawData() else {
//            return nil
//        }
//        guard let model = try?JSONDecoder().decode(Self.self, from: data) else {
//            return nil
//        }
//        return model
//    }
    
    
   
    
    
    public static func getJsonData(with param:Any) -> Data?  {
        
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}
