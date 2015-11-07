//
//  ViewController.swift
//  SugarCubesMultitouch
//
//  Created by Kyle Fleming on 10/15/15.
//  Copyright © 2015 Symmetry Labs. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var isConnectedLabel: UILabel!
    
    var activeTouches: [UITouch : Touch] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DynamicProperty(object: isConnectedLabel, keyPath: "text") <~
            Server.sharedInstance.connected.producer.map {
                $0 ? "Connected" : "Not Connected"
            }
        
        Server.sharedInstance.connected.producer
        
        Server.sharedInstance.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            activeTouches[touch] = Touch(view: self.view, touch: touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if let existingTouch = activeTouches[touch] {
                existingTouch.update(touch)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            activeTouches.removeValueForKey(touch)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            for touch in touches {
                activeTouches.removeValueForKey(touch)
            }
        } else {
            activeTouches.removeAll()
        }
    }

}

