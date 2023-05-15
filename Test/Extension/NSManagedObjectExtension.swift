//
//  NSManagedObjectExtension.swift
//  Test
//
//  Created by reyhan muhammad on 15/05/23.
//

import Foundation
import CoreData

extension NSManagedObject {
    func toDict() -> [String:Any] {
        let keys = Array(entity.attributesByName.keys)
        return dictionaryWithValues(forKeys:keys)
    }
}
