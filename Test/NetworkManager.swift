//
//  NetworkManager.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

class NetworkManager{
    static var shared = NetworkManager()
    
    func request<T: Decodable>(method: HTTPMethod, contentType: ContentType, data: Data?, url: String, queryItems: [URLQueryItem], completion: @escaping((Result<T, Error>) -> Void)){
        var components = URLComponents()
        components.queryItems = queryItems
        components.path = url
        components.scheme = "https"
        guard let url = components.url else{completion(.failure(CustomError.callApiFailBecauseURLNotFound));return}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
            }
            guard let data = data else{
                completion(.failure(CustomError.apiReturnNoData))
                return
            }
            var decoder = JSONDecoder()
            do{
                var model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            }catch{
                completion(.failure(error))
            }
        }
    }
}

enum HTTPMethod: String{
    case get
    case post
}

enum ContentType: String{
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

enum CustomError: Error{
    case callApiFailBecauseURLNotFound
    case apiReturnNoData
}
