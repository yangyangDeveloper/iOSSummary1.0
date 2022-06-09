//
//  ZYYEncoder.swift
//  Interview-Codable协议
//
//  Created by zhangyangyang on 2022/2/23.
//

import Foundation

struct ZYYEncoder {

    public static func encoder<T>(toString model: T) -> String? where T: Encodable {

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else {
            return nil
        }

        guard let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonStr
    }

    public static func encoder<T>(toDictionary model: T) -> [String:Any]? where T: Encodable {

        let encoder = JSONEncoder()

        encoder.outputFormatting = .prettyPrinted

        guard let data = try? encoder.encode(model) else {

            return nil

        }

        guard let dict = try?JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] else{

            return nil

        }

        return dict

    }

}


extension Encodable {

    public func encoder() ->Data? {

        let ecd = JSONEncoder()

        ecd.outputFormatting = .prettyPrinted

        return try?  ecd.encode(self)

    }

}

extension Data {

    ///Data->Dictionary

    public func toDictionary() -> [String:Any]?  {

        return try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as?  [String:Any]

    }

    ///Data->String

    public func toString() ->String? {

        return String(data:self, encoding: .utf8)

    }

    ///Data->JSON

   ///本人使用了SwiftyJSON，如未使用SwiftyJSON，请注释或删除以下方法

//    public func toJSON() ->JSON?  {
//
//        return JSON(data:self)
//
//    }

    ///Data->Array

    public func toArrray() -> [Any]? {

        return try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [Any]

    }

}
