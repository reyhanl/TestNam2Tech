//
//  BusinessModel.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

struct ResponseModel: Codable{
    var businesses: [BusinessModel]?
    
    enum CodingKeys: String, CodingKey{
        case businesses = "businesses"
    }
}
struct BusinessModel: Codable{
    var id: String?
    var alias: String?
    var name: String?
    var imageUrl: String?
    var isClosed: Bool?
    var url: String?
    var reviewCount: Int?
    var categories: [CategoryModel]?
    var rating: Float?
    var coordinates: CoordinateModel?
    var transaction: [TransactionModel]?
    var price: String?
    var location: AddressModel?
    var phone: String?
    var displayPhone: String?
    var distance: Float?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case alias = "alias"
        case name = "name"
        case imageUrl = "image_url"
        case isClosed = "is_closed"
        case reviewCount = "review_count"
        case categories = "categories"
        case rating = "rating"
        case coordinates = "coordinates"
        case transaction = "transaction"
        case price = "price"
        case location = "location"
        case phone = "phone"
        case displayPhone = "display_phone"
        case distance = "distance"
    }
}

enum TransactionModel: Codable{
    case delivery
    case pickup
}

struct CoordinateModel: Codable{
    var latitude: Float?
    var longitude: Float?
    
    enum CodingKeys: String, CodingKey{
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct CategoryModel: Codable{
    var alias: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey{
        case alias = "alias"
        case title = "title"
    }
}

struct AddressModel: Codable{
    var address1: String?
    var address2: String?
    var addres3: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var state: String?
    var displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey{
        case address1 = "address1"
        case address2 = "address2"
        case addres3 = "addres3"
        case city = "city"
        case zipCode = "zipCode"
        case country = "country"
        case state = "state"
        case displayAddress = "displayAddress"
    }
}

struct QueryModel: Codable{
    var location: String?
    var latitude: Float?
    var longitude: Float?
    var term: String?
    var radius: String?
    var categories: [String]?
    var locale: String?
    var price: [Int]?
    var openNow: Bool?
    var sortBy: String?
    var limit: Int?
    var offSet: Int?
    
    enum CodingKeys: String, CodingKey{
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
        case term = "term"
        case radius = "radius"
        case categories = "categories"
        case locale = "locale"
        case price = "price"
        case openNow = "open_now"
        case sortBy = "sort_by"
        case limit = "limit"
        case offSet = "offset"
    }
    
    init(location: String? = nil, latitude: Float? = nil, longitude: Float? = nil, term: String? = nil, radius: String? = nil, categories: [String]? = nil, locale: String? = nil, price: [Int]? = nil, openNow: Bool? = nil, sortBy: String? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.term = term
        self.radius = radius
        self.categories = categories
        self.locale = locale
        self.price = price
        self.openNow = openNow
        self.sortBy = sortBy
        self.limit = limit
        self.offSet = offset
    }
}

enum SortBy{
    case ascending
    case decending
}

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
