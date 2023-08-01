//
//  Codable+YJ.swift
//  YJKit
//
//  Created by yjzheng on 2023/8/1.
//

import Foundation

public protocol YJCoadble: Codable {
    func toDict() -> [String: Any]?
    func toData() -> Data?
    func toString() -> String?
}

public extension YJCoadble {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

    func toDict() -> [String: Any]? {
        if let data = toData() {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                return nil
            }
        } else {
            debugPrint("model to data error")
            return nil
        }
    }

    func toString() -> String? {
        if let data = toData(), let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            return nil
        }
    }
}
