//
//  ApiService.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import Foundation

protocol ApiServiceProtocol {
    mutating func get(url: URL)
    func callApi<T: Decodable>(model: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

struct ApiService: ApiServiceProtocol {
    private var url = URL(string: "")
    mutating func get(url: URL) {
        self.url = url
    }
    
    func callApi<T>(model: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let url = self.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
//            let response = response as? HTTPURLResponse
//            print(response?.statusCode)
//            print("error \(error)")
            if let successData = data {
                
                if let jsonString = String(data: successData, encoding: .utf8) {
                    print("✅ JSON Response:\n\(jsonString)")
                }
                
                do {
                    let modelData =  try JSONDecoder().decode(T.self, from: successData)
                    return completion(.success(modelData))
                } catch let error {
                    print("decode fail")
                    return completion(.failure(error))
                }
            }
        }.resume()
    }
}
