//
//  PauseMenu.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 8/7/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation
import SpriteKit

class PauseMenu: SKScene {
    /* UI Connections */
    var buttonExitToHome: MSButtonNode!
    var buttonContinueGame: MSButtonNode!
    var gameSceneObject: GameScene?
    
    override func didMove(to view: SKView) {
        /* Set UI connections */
        buttonExitToHome = self.childNode(withName: "buttonExitToHome") as! MSButtonNode
        buttonExitToHome.selectedHandler = { [unowned self] in
            self.loadMainMenu()
        }
        buttonContinueGame = self.childNode(withName: "buttonContinueGame") as! MSButtonNode
        buttonContinueGame.selectedHandler = { [unowned self] in
            self.loadGame()
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
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        if let scene = gameSceneObject {
            skView.presentScene(scene)
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
        //scene.isPaused = false

    }
}

