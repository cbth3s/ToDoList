//
//  ApiManager.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import Foundation

class ApiManager {
    
    static func fetchItems(completion: @escaping (Result<[ItemModel], Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dummyjson.com"
        urlComponents.path = "/todos"
        
        guard let url = urlComponents.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
