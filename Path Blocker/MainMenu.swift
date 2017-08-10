//
//  MainMenu.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/31/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    /* UI Connections */
    var buttonPlay: MSButtonNode!
    var buttonHowToPlay: MSButtonNode!
    var buttonCredits: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Set UI connections */
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        buttonPlay.selectedHandler = { [unowned self] in
            self.loadGame()
        }
        
        buttonHowToPlay = self.childNode(withName: "buttonHowToPlay") as! MSButtonNode
        buttonHowToPlay.selectedHandler = { [unowned self] in
            self.loadInstructions()
        }
        
        buttonCredits = self.childNode(withName: "buttonCredits") as! MSButtonNode
        buttonCredits.selectedHandler = { [unowned self] in
            self.loadCreditsPage()
        }

    }
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene(fileNamed:"GameScene") else {
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
    
    func loadInstructions() {
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = InstructionsOpening(fileNamed:"InstructionsOpening") else {
            print("Could not make InstructionsOpening, check the name is spelled correctly")
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
    
    func loadCreditsPage() {
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = Credits(fileNamed:"Credits") else {
            print("Could not make InstructionsOpening, check the name is spelled correctly")
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
