//
//  BusinessModel.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

struct ResponseModel: Codable{
    var business: [BusinessModel]?
    
    enum CodingKeys: String, CodingKey{
        case business = "business"
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
    var latitude: String?
    var longitude: String?
    
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
    }
}
