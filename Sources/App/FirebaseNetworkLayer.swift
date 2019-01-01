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
    let environement = OTEnvironment.Production.rawValue
    
    private init() {
        
    }
    
    func GetTasks(completion: @escaping (_ tasks: Data)->()) {
        let url = URL(string: "\(environement).json")!
        
        let get = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            completion(data)
        }
        
        get.resume()
    }
    
    func SaveTasks(data: Data, completion: @escaping (_ tasks: Data)->()) {
        if var decodedData = try? self.decoder.decode(Task.self, from: data) {
            let url:URL
            if let id = decodedData.id {
                url = URL(string: "\(environement)/\(id).json")!
            } else {
                decodedData.id = UUID().uuidString
                url = URL(string: "\(environement)/\(decodedData.id!).json")!
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            request.httpBody = try! self.encoder.encode(decodedData)
            
            let post = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else {
                    return
                }
                
                print("saved")
                
                completion(data)
            }
            post.resume()
        }
        
        if let decodedData = try? self.decoder.decode([Task].self, from: data) {
            var countOfTasks = decodedData.count
            
            for task in decodedData {
                let url = URL(string: "\(environement)/\(task.id!).json")!
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                
                request.httpBody = try! self.encoder.encode(task)
                
                let post = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    guard let data = data else {
                        return
                    }
                    countOfTasks -= 1
                    print("saved. Count: \(countOfTasks)")
                    if (countOfTasks <= 0) {
                        print("saved all")
                        completion(data)
                    }
                }
                post.resume()
            }
            
            
            
            
        }
    
    }
}

enum OTEnvironment: String {
    case Staging = "https://one-thing-staging.firebaseio.com/lists/list%201/tasks"
    case Production = "https://onething-fdfda.firebaseio.com/lists/list%201/tasks"
}
