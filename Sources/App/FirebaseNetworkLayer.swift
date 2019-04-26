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
    let environement = OTEnvironment.Production
    
    private init() {
        
    }
    
    func GetAllAsLists(completion: @escaping (_ data: [List])->()) {
        decoder.decode([List].self, fromURL: fetchListsURL()) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("decoding error: \(error.localizedDescription)")
            }
        }
    }
    
    func GetListsAsData(completion: @escaping (_ tasks: Data)->()) {
        let url = fetchListsURL()
        let get = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            completion(data)
        }
        
        get.resume()
    }
    
    func GetTasks(for list: String = "list%201", completion: @escaping (_ tasks: Data)->()) {
        let url = fetchTaskURL(for: list)
        
        let get = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            completion(data)
        }
        
        get.resume()
    }
    
    func SaveList(data: Data, completion: @escaping (_ tasks: Data)->()) {
        if let decodedData = try? self.decoder.decode(List.self, from: data) {
            let listIDString = decodedData.id!
            let url = fetchListURL(for: listIDString)
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            request.httpBody = try! self.encoder.encode(decodedData)
            
            let post = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else {
                    return
                }
                
                print("saved list: \(decodedData.title)")
                
                completion(data)
            }
            post.resume()
        } else {
            print("Could not decode list")
        }
        
    }
    
    func fetchListsURL(env: OTEnvironment? = nil) -> URL {
        var baseURLString: String
        switch env ?? self.environement {
        case .Staging:
            baseURLString = "https://one-thing-staging.firebaseio.com/lists.json"
        case .Production:
            baseURLString = "https://onething-fdfda.firebaseio.com/lists.json"
        }
        
        return URL(string: baseURLString)!
    }
    
    func fetchListURL(for list: String, env: OTEnvironment? = nil) -> URL {
        var baseURLString: String
        switch env ?? self.environement {
        case .Staging:
            baseURLString = "https://one-thing-staging.firebaseio.com/lists/\(list).json"
        case .Production:
            baseURLString = "https://onething-fdfda.firebaseio.com/lists/\(list).json"
        }
        
        return URL(string: baseURLString)!
    }
    
    func fetchTaskURL(for list: String, taskID id:String? = nil, env: OTEnvironment? = nil) -> URL {
        var baseURLString: String
        switch env ?? self.environement {
        case .Staging:
            baseURLString = "https://one-thing-staging.firebaseio.com/lists/\(list)/tasks"
            
        case .Production:
            baseURLString = "https://onething-fdfda.firebaseio.com/lists/\(list)/tasks"
        }
        
        guard let id = id else {
            return URL(string: "\(baseURLString).json")!
        }
        
        return URL(string: "\(baseURLString)/\(id).json")!
        
    }
}

enum OTEnvironment: String {
    case Staging = "https://one-thing-staging.firebaseio.com/lists/list%201/tasks"
    case Production = "https://onething-fdfda.firebaseio.com/lists/list%201/tasks"
}
