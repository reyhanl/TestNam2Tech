//
//  NetworkManager.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import Foundation

class NetworkManager{
    static var shared = NetworkManager()
    
    private func request<T: Decodable>(method: HTTPMethod, contentType: ContentType, data: Data?, url: String, queryItems: [URLQueryItem], completion: @escaping((Result<T, Error>) -> Void)){
        var components = URLComponents()
        components.queryItems = queryItems
        components.path = URLManager.baseUrl.url + url
        components.scheme = "https"
        guard let url = components.url else{completion(.failure(CustomError.callApiFailBecauseURLNotFound));return}
        print("error: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "accept")
        if let apiKey = UserDefaults.standard.value(forKey: "apiKey"){
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
            }
            guard let data = data else{
                completion(.failure(CustomError.apiReturnNoData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 && httpResponse.statusCode >= 200 else{
                completion(.failure(CustomError.somethingWentWrong))
                return
            }
//            print(httpResponse)
            var decoder = JSONDecoder()
            do{
                var model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            }catch{
                print(String(describing: error))
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchBusiness(model: QueryModel, completion: @escaping((Result<ResponseModel, Error>) -> Void)){
        let encoder = JSONEncoder()
        do{
            var data = try encoder.encode(model)
            let queryItems = model.generateQueryItem()
            request(method: .get, contentType: .formUrlEncoded, data: nil, url: URLManager.getBusiness.url, queryItems: queryItems) { (result: Result<ResponseModel, Error>) in
                completion(result)
            }
        }catch{
            completion(.failure(error))
        }
    }
    
    func fetchBusinessDetail(id: String, completion: @escaping((Result<BusinessModel, Error>) -> Void)){
        let encoder = JSONEncoder()
        print(id)
        request(method: .get, contentType: .formUrlEncoded, data: nil, url: URLManager.getBusinessDetail(id).url, queryItems: []) { (result: Result<BusinessModel, Error>) in
            completion(result)
        }
    }
    
    func fetchBusinessRating(id: String, completion: @escaping((Result<RatingResponseModel, Error>) -> Void)){
        let items: [URLQueryItem] = [
            .init(name: "limit", value: "\(20)")
        ]
        request(method: .get, contentType: .formUrlEncoded, data: nil, url: URLManager.getBusinessRating(id).url, queryItems: items) { (result: Result<RatingResponseModel, Error>) in
            completion(result)
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
    case somethingWentWrong
}
