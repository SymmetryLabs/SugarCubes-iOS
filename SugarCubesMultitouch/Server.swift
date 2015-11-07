//
//  Server.swift
//  SugarCubesMultitouch
//
//  Created by Kyle Fleming on 10/15/15.
//  Copyright © 2015 Symmetry Labs. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift
import ReactiveCocoa

class Server {
    
    class var sharedInstance : Server {
        struct Static {
            static let instance = Server()
        }
        return Static.instance
    }
    
    var connected = MutableProperty<Bool>(false)
    
    let socket = SocketIOClient(socketURL: "192.168.2.89:8723",
        options: [.Path("/socket.io"),
            .ReconnectWait(5),
            .Log(true)
        ])
    // 192.168.2.89
    // Kyles-MacBook-Pro.local
    // Bens-MacBook-Pro.local
    
    func start() {
        socket.on("connect") {data, ack in
            self.connected.value = true
        }
        
        socket.on("disconnect") {data, ack in
            self.connected.value = false
        }
        
        socket.on("reconnect") {data, ack in
            self.connected.value = false
        }
        
        socket.on("error") {data, ack in
            self.connected.value = false
        }
        
        socket.connect()
    }
    
    func addTouch(touch: Touch) {
        socket.emit("addTouch",  touch.id,
            touch.throttledLocation.x,
            touch.throttledLocation.y,
            touch.throttledSpeed);
    }
    
    func updateTouch(touch: Touch) {
        socket.emit("updateTouch", touch.id,
            touch.throttledLocation.x,
            touch.throttledLocation.y,
            touch.throttledSpeed);
    }
    
    func removeTouch(touch: Touch) {
        socket.emit("removeTouch", touch.id);
    }
    
}