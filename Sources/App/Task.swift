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
    var priority: String
    var order: Int
}
