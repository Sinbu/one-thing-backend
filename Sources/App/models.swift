//
//  Task.swift
//  App
//
//  Created by Sina Yeganeh on 10/10/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Task: Content {
    var id: String?
    var title: String
    var size: String
    var order: Int
    var dateCompleted: Date?
    var owner: String
    
    static func DemoData() -> Task {
        return Task(id: UUID().uuidString, title: "task 3", size: "large", order: 3, dateCompleted: nil, owner: "azience@gmail.com")
    }
    
}

struct List: Content {
    var id: String?
    var title: String
    var tasks: [String:Task]
    var owner: String
}
