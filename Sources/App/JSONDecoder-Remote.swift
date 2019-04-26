//
//  JSONDecoder-Remote.swift

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, fromString string: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: string) else {
            completion(.failure(NetworkError.InvalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle Error
                completion(.failure(error))
                return
            }
            guard let _ = response else {
                // Handle Empty Response
                completion(.failure(NetworkError.NoResponse))
                return
            }
            guard let data = data else {
                // Handle Empty Data
                completion(.failure(NetworkError.NoData))
                return
            }
            // Handle Decode Data into Model
            
            guard let results = try? JSONDecoder().decode(T.self, from: data) else {
                // Handle Bad Conversion
                completion(.failure(NetworkError.BadConversion))
                return
            }
            
            completion(Result.success(results))
            
            
            }.resume()
    }
    
    func decode<T: Decodable>(_ type: T.Type, fromURL url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle Error
                completion(.failure(error))
                return
            }
            guard let _ = response else {
                // Handle Empty Response
                completion(.failure(NetworkError.NoResponse))
                return
            }
            guard let data = data else {
                // Handle Empty Data
                completion(.failure(NetworkError.NoData))
                return
            }
            // Handle Decode Data into Model
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(results))
                // Handle Bad Conversion
            } catch DecodingError.typeMismatch(let type, let context) {
                    print("\(type) was expected, \(context.debugDescription)")
            } catch let error {
                completion(.failure(error))
            }
            
            
            }.resume()
    }
}

enum NetworkError: Error {
    case InvalidURL
    case NoResponse
    case NoData
    case BadConversion
}
