//
//  URLManager.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

enum URLManager{
    case baseUrl
    case getBusiness
    case getBusinessDetail(String)
    case getBusinessRating(String)
    
    var url: String{
        switch self{
        case .baseUrl:
            return "api.yelp.com/v3/"
        case .getBusiness:
            return "businesses/search"
        case .getBusinessDetail(let id):
            return "businesses/\(id)"
        case .getBusinessRating(let id):
            return "businesses/\(id)/reviews"
        }
    }
}
