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
    
    wss.get() { ws, req in
        clients.append(ws)
        print("Client connected")
        FirebaseNetworkLayer.shared.GetTasks { data in
            print("sent data")
            ws.send(data)
        }
        
        ws.onText { ws, text in
            print("on Text")
            if (text == "clients") {
                ws.send("clients connected \(clients.count)")
            }
        }
        
        ws.onBinary { ws, data in
            print("on binary")
            FirebaseNetworkLayer.shared.SaveTasks(data: data) { data in
                print("saved data")
                FirebaseNetworkLayer.shared.GetTasks { data in
                    for client in clients {
                        client.send(data)
                    }
                }
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


