//
//  GameScene.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/19/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//


import SpriteKit
import GameplayKit

enum wallSides {
    case upSide, downSide, leftSide, rightSide, noSide
}

class GameScene: SKScene {
    var mazeWall: SKNode!
    var monsterNode: SKNode! //THIS IS FOR THE MONSTER CLASS WHICH ISNT MADEYET WHOOPS
    var maze = Maze(gridSize: 10)
    //var maze = Maze()
    let wallTexture = SKTexture(imageNamed: "mazeWall") //NEW CODE!
    var backgroundColorCustom = UIColor(red: 255, green: 244, blue: 231, alpha: 4.0)
    var tileSize = 0
    
    override func didMove(to view: SKView) {
        /* Set reference to mazeWall node */
        mazeWall = self.childNode(withName: "mazeWall")
        monsterNode = self.childNode(withName: "monster") //THIS IS FOR THE MONSTER CLASS WHICH ISNT MADEYET WHOOPS
        
        //FIND THE MAX SIZE OF THE SCREEN
        let screenSize = UIScreen.main.bounds
        let maxWidth = Int(screenSize.width) / 27 //maze.gridSize/2
        let maxHeight = Int(screenSize.height) / 27 //maze.gridSize/2
        tileSize = max(maxWidth, maxHeight)
        
        //going through each cell and checking if it is true in order to place a wall
        for x in 1..<self.maze.gridSize+1 {
            for y in 1..<self.maze.gridSize+1 {
                //here
                //set the value of  location of walls for evey cell
                if (self.maze.down[x,y]) == true {
                    //NEW CODE
                    //let wall = MazeWall(side: side.down)
                    let wall = SKSpriteNode(texture: wallTexture)
                    let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
                    let xPos = centerTile.x
                    let yPos = centerTile.y - CGFloat(tileSize) / 2
                    wall.position = CGPoint(x: xPos, y: yPos)
                    wall.size = CGSize(width: tileSize, height: tileSize / 9)
                    self.addChild(wall)
                }
                
                if (self.maze.up[x,y]) == true {
                    let wall = SKSpriteNode(texture: wallTexture)
                    let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
                    let xPos = centerTile.x
                    let yPos = centerTile.y + CGFloat(tileSize) / 2
                    wall.position = CGPoint(x: xPos, y: yPos)
                    wall.size = CGSize(width: tileSize, height: tileSize / 9)
                    self.addChild(wall)
                }
                
                if (self.maze.left[x,y]) == true{
                    let wall = SKSpriteNode(texture: wallTexture)
                    let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
                    let xPos = centerTile.x - CGFloat(tileSize) / 2
                    let yPos = centerTile.y
                    wall.position = CGPoint(x: xPos, y: yPos)
                    wall.size = CGSize(width: tileSize / 9, height: tileSize)
                    self.addChild(wall)

                }
                if (self.maze.right[x,y]) == true {
                    let wall = SKSpriteNode(texture: wallTexture)
                    let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
                    let xPos = centerTile.x + CGFloat(tileSize) / 2
                    let yPos = centerTile.y
                    wall.position = CGPoint(x: xPos, y: yPos)
                    wall.size = CGSize(width: tileSize / 9, height: tileSize)
                    self.addChild(wall)
                }
            }
        }
    }//end of func didMove
    
    func ConvertGridPositionToLocationPoint(x: Int, y: Int) -> (CGPoint) {
        //self.maze.visitedCells[x,y]
        let gridX = x * tileSize + tileSize/2
        let gridY = y * tileSize + tileSize/2
        let locationPoint = CGPoint(x: gridX, y: gridY)
        return (locationPoint)
    }
    
    func ConvertLocationPointToGridPosition(location: CGPoint) -> (x: Int, y: Int, side: wallSides) {
        var xPoint: CGFloat
        var yPoint: CGFloat
        xPoint = location.x / CGFloat(tileSize)
        yPoint = location.y / CGFloat(tileSize)
        let yPointRemainder = yPoint.truncatingRemainder(dividingBy: 1)
        let xPointRemainder = xPoint.truncatingRemainder(dividingBy: 1)
        var wallSide: wallSides
        
        if yPointRemainder < 0.2 && xPointRemainder < 0.8 && xPointRemainder > 0.2 {
            wallSide = .downSide
        } else if yPointRemainder > 0.8 && xPointRemainder < 0.8 && xPointRemainder > 0.2 {
            wallSide = .upSide
        } else if xPointRemainder < 0.2 && yPointRemainder < 0.8 && yPointRemainder > 0.2 {
            wallSide = .leftSide
        } else if  xPointRemainder > 0.8 && yPointRemainder < 0.8 && yPointRemainder > 0.2 {
            wallSide = .rightSide
        } else {
            wallSide = .noSide
        }//end of if-then
        
        return(Int(xPoint), Int(yPoint), wallSide)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //actually user tapping a wall
        //send a message that the wall has been tapped
        let touch = touches.first!              // Get the first touch
        let location  = touch.location(in: self) //find the location of the touch in the view
        let nodeAtPoint = atPoint(location) //find the node at that location
        if nodeAtPoint.name == "mazeWall" {
            let convertLocation = ConvertLocationPointToGridPosition(location: location)
            //self.removeChildren(in: [self.atPoint(location)])
            if convertLocation.side == wallSides.downSide {
                //code
            }
        }//end of nodeAtPoint = mazeWall if-then statement
    }
    
}

















/* steps to do this:
 1) create a wall in spriteKit
 2) connect wall to code in the Maze class
 3) create a function in which when a cell side is true, the wall is dropped in that position
 4) somehow make touches began release a signal that alerts the MoveWalls function in the Maze class
 5) actually move the frickin walls
 */
