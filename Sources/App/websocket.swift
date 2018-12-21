//
//  websocket.swift
//  App
//
//  Created by Sina Yeganeh on 12/19/18.
//
// Routees needed:
// Post - New task
// Put - Update existing task
// Get - Specific Task
// Get - All tasks

import Vapor

public func websocket(_ wss: NIOWebSocketServer) throws {
    var clients: [WebSocket] = []
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var allTasks = [Task]()
    
    wss.get() { ws, req in
        clients.append(ws)
        print("Client connected")
        // print(req.http.headers.description)
        
        _ = Task.query(on: req).all().map({ tasks in
            allTasks = tasks
            let data = try! encoder.encode(allTasks)
            ws.send(data)
            return
        })
        
        ws.onText { ws, text in
            print("on Text")
            if (text == "task") {
                let data = try! encoder.encode(Task.DemoData())
                ws.send(data)
            }
            if (text == "clients") {
                ws.send("clients connected \(clients.count)")
            }
            if (text == "list") {
                let allTasksData = try! encoder.encode(allTasks)
                for client in clients {
                    client.send(allTasksData)
                }
            }
            if (text == "listself") {
                let allTasksData = try! encoder.encode(allTasks)
                ws.send(allTasksData)
            }
        }
        
        ws.onBinary { ws, data in
            print("on Binary")
            let data = try? decoder.decode(Task.self, from: data)
            if let task = data {
                _ = task.save(on: req).map({ task in
                    Task.query(on: req).all().map({ tasks in
                        allTasks = tasks
                        let allTasksData = try! encoder.encode(allTasks)
                        for client in clients {
                            client.send(allTasksData)
                        }
                    })
                })
            }
        }
        
        ws.onCloseCode { wsErrorCode in
            print("on close code")
        }
        
        _ = ws.onClose.map({
            print("Client Disconnected")
            ws.close()
            clients = clients.filter({ socket -> Bool in
                socket.isClosed == false
            })
        })
        
        
    }
    
}


