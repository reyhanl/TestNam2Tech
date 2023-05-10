//
//  QueryModelExtension.swift
//  Test
//
//  Created by reyhan muhammad on 10/05/23.
//

import Foundation

extension QueryModel{
    func generateQueryItem() -> [URLQueryItem]{
        var items: [URLQueryItem] = []
        if let location = location{
            items.append(.init(name: "location", value: location))
        }
        
        if let longitude = longitude, let latitude = latitude{
            items.append(.init(name: "longitude", value: "\(longitude)"))
            items.append(.init(name: "latitude", value: "\(latitude)"))
        }
        
        if let limit = limit{
            items.append(.init(name: "limit", value: "\(limit)"))
        }
        
        if let sortBy = sortBy{
            items.append(.init(name: "sort_by", value: "\(sortBy)"))
        }
        
        if let offSet = offSet{
            items.append(.init(name: "offset", value: "\(offSet)"))
        }
        
        if let prices = price{
            for price in prices{
                items.append(.init(name: "price", value: "\(price)"))
            }
        }
        
        if let term = term{
            items.append(.init(name: "term", value: term))
        }
        
        return items
    }
}
