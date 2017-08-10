//
//  Credits.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 8/9/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation
import SpriteKit

class Credits: SKScene {
    var buttonExitToHome: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Set UI connections */
        buttonExitToHome = self.childNode(withName: "buttonExitToHome") as! MSButtonNode
        buttonExitToHome.selectedHandler = { [unowned self] in
            self.loadMainMenu()
        }
    }
    
    func loadMainMenu() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = MainMenu(fileNamed:"MainMenu") else {
            print("Could not make MainMenu, check the name is spelled correctly")
            return
        }
        
        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFit
        
        /* Show debug */
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        
        /* 4) Start game scene */
        skView.presentScene(scene)
    }

    
}
