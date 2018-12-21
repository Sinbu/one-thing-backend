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

struct Task: Content, SQLiteUUIDModel, Migration, Parameter {
    var id: UUID?
    var title: String
    var size: String
    var order: Int
    var dateCompleted: Date?
    var owner: String
    
    static func DemoData() -> Task {
        return Task(id: UUID(), title: "task 3", size: "large", order: 3, dateCompleted: nil, owner: "azience@gmail.com")
    }
}

struct List: Content {
    var id: UUID?
    var title: String
    var tasks: [Task]
    var owner: String
    
    static func DemoData() -> List {
        let task1 = Task(id: UUID(), title: "task 1", size: "small", order: 1, dateCompleted: nil, owner: "azience@gmail.com")
        let task2 = Task(id: UUID(), title: "task 2", size: "medium", order: 2, dateCompleted: nil, owner: "azience@gmail.com")
        let task3 = Task(id: UUID(), title: "task 3", size: "large", order: 3, dateCompleted: nil, owner: "azience@gmail.com")
        
        let list = List(id: UUID(), title: "list 1", tasks: [task1,task2,task3], owner: "azience@gmail.com")
        return list
    }
}
