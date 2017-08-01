//
//  Monsters.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/20/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

//made the monster node part of the monster class!!!!!!!!!!

class Monster: SKSpriteNode {
    var lastPosition: (x: Int, y: Int) = (1, 1)
    var currentPosition: (x: Int, y: Int) = (1, 1)
    var entranceSideUsed: wallSides = wallSides.noSide
    var tileSize = 25
    //var entranceOpeningTop:
    //var entraceOpeningSide:
    //var exit
    
    
    func moveLeft() {
        lastPosition = currentPosition
        self.run(SKAction.move(by: CGVector(dx: tileSize * -1, dy: 0), duration: 0.4))
        currentPosition.x = currentPosition.x-1
        entranceSideUsed = wallSides.rightSide
    }
    
    func moveRight() {
        lastPosition = currentPosition
        self.run(SKAction.move(by: CGVector(dx: tileSize, dy: 0), duration: 0.4))
        currentPosition.x = currentPosition.x+1
        entranceSideUsed = wallSides.leftSide
    }
    
    func moveUp() {
        lastPosition = currentPosition
        self.run(SKAction.move(by: CGVector(dx: 0, dy: tileSize), duration: 0.4))
        currentPosition.y = currentPosition.y+1
        entranceSideUsed = wallSides.downSide
    }
    
    func moveDown() {
        lastPosition = currentPosition
        self.run(SKAction.move(by: CGVector(dx: 0, dy: tileSize * -1), duration: 0.4))
        currentPosition.y = currentPosition.y-1
        entranceSideUsed = wallSides.upSide
    }
    
    
    
    func monsterRun() {
        //monster starts running
        //sets current position as cell it is in
            //monsterNode.position = currentPosition!
        //converts position point to cell
            //let convertLocation = ConvertLocationPointToGridPosition(location: location) //2nd location = position
        //checks which cells in the wall are true
            //
        //marks the false walls as possible entrances & finds which entrance is entranceSideUsed
        //deletes entranceSideUsed as possible choice so that monster doesnt go back in there
        //randomly chooses between remaining & marks chosen entrance as entranceSideUsed
        //marks current position as lastPosition
        //goes through entrance
    }
    
     
 
    
}//end of the Monster class
