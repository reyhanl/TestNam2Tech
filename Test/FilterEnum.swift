//
//  FilterEnum.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

enum Filter{
    case nearMe
    case priceAscending(Bool)
    case distanceAscending(Bool)
    
    var displayValue: String{
        switch self{
        case .nearMe:
            return "Near me"
        case .priceAscending(_):
            return "Price"
        case .distanceAscending(_):
            return "Distance"
        }
    }
}
