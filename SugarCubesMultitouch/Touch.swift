//
//  Touch.swift
//  SugarCubesMultitouch
//
//  Created by Kyle Fleming on 10/15/15.
//  Copyright © 2015 Symmetry Labs. All rights reserved.
//

import Foundation
import UIKit

class Touch {
    
    let id = NSUUID().UUIDString
    var enabled = true
    var view: UIView
    var location = CGPointZero
    var prevTime: NSTimeInterval
    var speed: CGFloat = 0
    
    var throttledLocation = CGPointZero
    var throttledSpeed: CGFloat = 0
    
    init(view: UIView, touch: UITouch) {
        self.view = view
        self.prevTime = touch.timestamp
        self.location = normalizedLocation(view, touch: touch)
        self.throttledLocation = location
        Server.sharedInstance.addTouch(self)
    }
    
    deinit {
        Server.sharedInstance.removeTouch(self)
    }
    
    func update(touch: UITouch) {
        let newLocation = normalizedLocation(view, touch: touch)
        let dv = distance(location, b: newLocation)
        location = newLocation
        
        let dt = CGFloat(touch.timestamp - prevTime)
        prevTime = touch.timestamp
        
        let lambda = (dt>0.2) ? 1 : (dt/0.2)
        speed = lambda * CGFloat(dv / dt) + (1-lambda) * speed
        
        
        if (distance(location, b: throttledLocation) > 0.05 || abs(speed - throttledSpeed) > 0.2) {
            throttledLocation = location
            throttledSpeed = speed
            Server.sharedInstance.updateTouch(self)
        }
    }
    
    func normalizedLocation(view: UIView, touch: UITouch) -> CGPoint {
        return normalizedPoint(touch.locationInView(view), size: view.frame.size)
    }
    
    func normalizedPoint(point: CGPoint, size: CGSize) -> CGPoint {
        return CGPointMake(point.x / size.width, 1 - point.y / size.height)
    }
    
    func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt(pow(a.x-b.x,2) + pow(a.y-b.y,2));
    }
    
}