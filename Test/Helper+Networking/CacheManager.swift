//
//  CacheManager.swift
//  Test
//
//  Created by reyhan muhammad on 10/05/23.
//

import Foundation

class CacheManager{
    
    static var cacheData: [String:Data] = [:]
    
    static func saveData(key: String, data: Data){
        cacheData[key] = data
    }
    
    static func loadData(key: String) -> Data?{
        return cacheData[key]
    }
}
