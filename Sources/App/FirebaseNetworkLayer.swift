//
//  FirebaseNetworkLayer.swift
//  App
//
//  Created by Sina Yeganeh on 12/31/18.
//

import Foundation

struct FirebaseNetworkLayer {
    static var shared = FirebaseNetworkLayer()
    let encoder = JSONEncoder()
    // let apiKey = OTSecurity.apiKey
    let decoder = JSONDecoder()
    
    private init() {
        
    }
    
    func GetTasks(completion: @escaping (_ tasks: Data)->()) {
        let url = URL(string: OTEnvironment.Staging.rawValue)!
        
        let get = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            completion(data)
        }
        
        get.resume()
    }
    
    func SaveTasks(data: Data, completion: @escaping (_ tasks: Data)->()) {
        if var decodedData = try? decoder.decode(Task.self, from: data) {
            
            let url = URL(string: OTEnvironment.Staging.rawValue)!
            
            decodedData.id = UUID().uuidString
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! encoder.encode(decodedData)
            
            let post = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else {
                    return
                }
                
                print("saved")
                
                completion(data)
            }
            post.resume()
        }
    }
}

enum OTEnvironment: String {
    case Staging = "https://one-thing-staging.firebaseio.com/lists/list%201/tasks.json"
    case Production = "https://onething-fdfda.firebaseio.com/lists/list%201/tasks.json"
}
