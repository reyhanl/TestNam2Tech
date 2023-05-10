//
//  FilterEnum.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

enum Filter{
    case nearMe
    case distanceAscending(Bool)
    case cheap
    case quiteCheap
    case expensive
    case superExpensive
    
    var displayValue: String{
        switch self{
        case .nearMe:
            return "Near me"
        case .distanceAscending(_):
            return "Distance"
        case .cheap:
            return "$"
        case .quiteCheap:
            return "$$"
        case .expensive:
            return "$$$"
        case .superExpensive:
            return "$$$$"
        }
    }
}

enum SortBy{
    case ascending
    case decending
}
