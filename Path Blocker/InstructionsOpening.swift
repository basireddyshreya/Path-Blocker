//
//  InstructionsOpening.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 8/9/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionsOpening: SKScene {
    /* UI Connections */
    var buttonNext: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Set UI connections */
        buttonNext = self.childNode(withName: "buttonNext") as! MSButtonNode
        buttonNext.selectedHandler = { [unowned self] in
            self.loadNextPage()
        }
        
    }
    
    func loadNextPage() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = InstructionsWinning(fileNamed:"InstructionsWinning") else {
            print("Could not make GameScene, check the name is spelled correctly")
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
