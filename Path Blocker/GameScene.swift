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

enum GameSceneState {
    case gameStart, gameRunning, gameOver
}

class GameScene: SKScene {
    var mazeWall: SKNode!
    var monsterNode: Monster!
    var maze = Maze(gridSize: 10)

    let wallTexture = SKTexture(imageNamed: "mazeWall")
    var tileSize = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */ //THIS IS THE NEW SHIT TO MAKE AN UPDATE FUNCTION, DO I REALLY NEED IT?
    var gameState: GameSceneState = .gameStart // THIS IS NEW FOR PUTTING THE GAMESCENE OF EITHER WINNING OR LOSING
    
    
    func getWallPosition(x : Int, y : Int, side: wallSides) -> CGPoint {
        var position: CGPoint
        
        if side == .downSide {
            //let wall = MazeWall(side: side.down)
            let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
            let xPos = centerTile.x
            let yPos = centerTile.y - CGFloat(tileSize) / 2
            position = CGPoint(x: xPos, y: yPos)
        } else if side == .upSide {
            let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
            let xPos = centerTile.x
            let yPos = centerTile.y + CGFloat(tileSize) / 2
            position = CGPoint(x: xPos, y: yPos)
        } else if side == .leftSide {
            let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
            let xPos = centerTile.x - CGFloat(tileSize) / 2
            let yPos = centerTile.y
            position = CGPoint(x: xPos, y: yPos)
        } else if side == .rightSide {
            let centerTile = ConvertGridPositionToLocationPoint(x: x, y: y)
            let xPos = centerTile.x + CGFloat(tileSize) / 2
            let yPos = centerTile.y
            position = CGPoint(x: xPos, y: yPos)
        } else {
            position = ConvertGridPositionToLocationPoint(x: x, y: y)
        }
        
        return position
    }//end of func get wall position
    
    override func didMove(to view: SKView) {
        /* Set reference to mazeWall node */
        mazeWall = self.childNode(withName: "mazeWall")
        monsterNode = self.childNode(withName: "monster") as! Monster //THIS IS FOR THE MONSTER CLASS WHICH ISNT MADEYET WHOOPS
        
        //FIND THE MAX SIZE OF THE SCREEN
        let screenSize = UIScreen.main.bounds
        let maxWidth = Int(screenSize.width) / 26 //maze.gridSize/2
        let maxHeight = Int(screenSize.height) / 26 //maze.gridSize/2
        tileSize = max(maxWidth, maxHeight)
        
        //going through each cell and checking if it is true in order to place a wall
        for x in 0..<self.maze.gridSize+1 {
            for y in 0..<self.maze.gridSize+1 {
                //here
                //set the value of  location of walls for evey cell
                
                /* if (self.maze.down[x,y]) == true {
                    let wall = SKSpriteNode(texture: wallTexture)
                    wall.name = "mazeWall"
                    wall.position = getWallPosition(x: x, y: y, side: .downSide)
                    wall.size = CGSize(width: tileSize, height: tileSize / 9)
                    self.addChild(wall)
                } */
                if (self.maze.up[x,y]) == true {
                    if x == 0 {
                        //do nothing
                    } else {
                        let wall = SKSpriteNode(texture: wallTexture)
                        wall.name = "mazeWall"
                        wall.position = getWallPosition(x: x, y: y, side: .upSide)
                        wall.size = CGSize(width: tileSize, height: tileSize / 7)
                        self.addChild(wall)
                    }
                }
                /*
                if (self.maze.left[x,y]) == true{
                    let wall = SKSpriteNode(texture: wallTexture)
                    wall.name = "mazeWall"
                    wall.position = getWallPosition(x: x, y: y, side: .leftSide)
                    wall.size = CGSize(width: tileSize / 9, height: tileSize)
                    self.addChild(wall)
                }*/
                if (self.maze.right[x,y]) == true {
                    if y == 0 {
                        //do nothing
                    } else {
                        let wall = SKSpriteNode(texture: wallTexture)
                        wall.name = "mazeWall"
                        wall.position = getWallPosition(x: x, y: y, side: .rightSide)
                        wall.size = CGSize(width: tileSize / 7, height: tileSize)
                        self.addChild(wall)
                    }//end of if statement to check if the walls are being placed in the border
                }//end of placing walls for right walls
                
            }
        }
        
//***************************THIS POINT IS ALL THE MONSTER STUFF BEING PLACED HERE JUST FOR NOW******************************
        monsterNode.tileSize = tileSize
        monsterNode.position = ConvertGridPositionToLocationPoint(x: self.maze.xOpening!, y: self.maze.gridSize+1)
        monsterNode.currentPosition = (x: self.maze.xOpening!, y: self.maze.gridSize+1)
//if gameState == .gameStart {
//if monster is top one then { IDK HOW TO DO THIS PART LMAOOOO
        monsterNode.moveDown()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameScene.moveMonster), userInfo: nil, repeats: true)
        
    }//end of func didMove
    
    func ConvertGridPositionToLocationPoint(x: Int, y: Int) -> (CGPoint) {
        //self.maze.visitedCells[x,y]
        let gridX = x * tileSize + tileSize/2
        let gridY = y * tileSize + tileSize/2
        let locationPoint = CGPoint(x: gridX, y: gridY)
        return (locationPoint)
    }//end of ConvertGridPositionToLocationPoint
    
    func ConvertLocationPointToGridPosition(location: CGPoint) -> (x: Int, y: Int, side: wallSides) {
        var xPoint: CGFloat
        var yPoint: CGFloat
        xPoint = location.x / CGFloat(tileSize)
        yPoint = location.y / CGFloat(tileSize)
        let yPointRemainder = yPoint.truncatingRemainder(dividingBy: 1)
        let xPointRemainder = xPoint.truncatingRemainder(dividingBy: 1)
        var wallSide: wallSides
        
        if yPointRemainder < 0.15 && xPointRemainder < 0.85 && xPointRemainder > 0.15 {
            wallSide = .downSide
        } else if yPointRemainder > 0.85 && xPointRemainder < 0.85 && xPointRemainder > 0.15 {
            wallSide = .upSide
        } else if xPointRemainder < 0.15 && yPointRemainder < 0.85 && yPointRemainder > 0.15 {
            wallSide = .leftSide
        } else if  xPointRemainder > 0.85 && yPointRemainder < 0.85 && yPointRemainder > 0.15 {
            wallSide = .rightSide
        } else {
            wallSide = .noSide
        }//end of if-then
        
        return(Int(xPoint), Int(yPoint), wallSide)
    }//end of func ConvertLocationPointToGridPosition
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!               // Get the first touch
        let location  = touch.location(in: self) //find the location of the touch in the view
        let convertLocation = ConvertLocationPointToGridPosition(location: location)
        
        if convertLocation.side == wallSides.noSide {
            return
        }

        var wallPosition = getWallPosition(x: convertLocation.x, y: convertLocation.y, side: convertLocation.side)
        let nodeAtPoint = atPoint(wallPosition)      //find the node at that location
        
        if nodeAtPoint.name == "mazeWall" {
            let x = convertLocation.x
            let y = convertLocation.y
            var isIncreasing: Bool = true
            var isChangingX: Bool = true
            
//UPDATED THE CODE BELOW TO STOP AT PERPENDICULAR WALLS
            if convertLocation.side == wallSides.downSide {
                self.maze.down[x,y] = false
                self.maze.up[x,y-1] = false
                //self.didMoveVar.wall.removeFromParent()
                //self.removeChildren(in: [self.atPoint(location)])
                if x < self.maze.gridSize && (self.maze.down[x+1,y] == false && (self.maze.right[x,y] == false || self.maze.right[x,y-1] == false)) {
                    //isIncreasing = true
                } else {
                  isIncreasing = false
                }
            } else if convertLocation.side == wallSides.upSide {
                self.maze.up[x,y] = false
                self.maze.down[x,y+1] = false
                if x < self.maze.gridSize && (self.maze.up[x+1,y] == false && (self.maze.right[x,y] == false || self.maze.right[x,y+1] == false)) {
                    //isIncreasing = true
                } else {
                    isIncreasing = false
                }
            } else if convertLocation.side == wallSides.leftSide {
                self.maze.left[x,y] = false
                self.maze.right[x-1,y] = false
                isChangingX = false
                if y < self.maze.gridSize && (self.maze.left[x,y+1] == false && (self.maze.up[x,y] == false || self.maze.up[x-1, y] == false)) {
                    //isIncreasing = true
                } else {
                    isIncreasing = false
                }
            } else if convertLocation.side == wallSides.rightSide {
                self.maze.right[x,y] = false
                self.maze.left[x+1,y] = false
                isChangingX = false
                if y < self.maze.gridSize && (self.maze.right[x,y+1] == false && (self.maze.up[x,y] == false || self.maze.up[x+1, y] == false)) {
                    //isIncreasing = true
                } else {
                    isIncreasing = false
                }
            }//end of finding out which side was tapped on & setting that wall to false & seeing if the wall next to it is false (to know whether to increase/decrease)

            var newX = x
            var newY = y
            if (isIncreasing) {
                while (newX < self.maze.gridSize+1 && newX > 0 && newY < self.maze.gridSize+1 && newY > 0) {
                    if convertLocation.side == wallSides.upSide && (self.maze.up[newX+1,newY] == true || (self.maze.right[newX,newY] == true && self.maze.right[newX,newY+1] == true)) {
                        break
                    } else if convertLocation.side == wallSides.downSide && (self.maze.down[newX+1,newY] == true || (self.maze.right[newX,newY] == true && self.maze.right[newX,newY-1] == true)) {
                        break
                    } else if convertLocation.side == wallSides.leftSide && (self.maze.left[newX,newY+1] == true || (self.maze.up[newX,newY] == true && self.maze.up[newX-1, newY] == true)) {
                        break
                    } else if convertLocation.side == wallSides.rightSide && (self.maze.right[newX,newY+1] == true || (self.maze.up[newX,newY] == true && self.maze.up[newX+1, newY] == true)) {
                        break
                    }//end of breaking out of the loop when there is another wall when trying to move (meaning to stop the wall from moving anymore) for isIncreasing
                    
                    if isChangingX == true {
                        newX += 1
                    } else if isChangingX == false {
                        newY += 1
                    } //end of adding or subtracting 1
                }//end of while loop
          
            } else {
                while (newX < self.maze.gridSize+1 && newX > 0 && newY < self.maze.gridSize+1 && newY > 0) {
                    if convertLocation.side == wallSides.upSide && (self.maze.up[newX-1,newY] == true || (self.maze.right[newX-1,newY] == true && self.maze.right[newX-1,newY+1] == true)) {
                        break
                    } else if convertLocation.side == wallSides.downSide && (self.maze.down[newX-1,newY] == true || (self.maze.right[newX-1,newY] == true && self.maze.right[newX-1,newY-1] == true)) {
                        break
                    } else if convertLocation.side == wallSides.leftSide && (self.maze.left[newX,newY-1] == true || (self.maze.up[newX,newY-1] == true && self.maze.up[newX-1, newY-1] == true)) {
                        break
                    } else if convertLocation.side == wallSides.rightSide && (self.maze.right[newX,newY-1] == true || (self.maze.up[newX,newY-1] == true && self.maze.up[newX+1, newY-1] == true)) {
                        break
                    }//end of breaking out of the loop when there is another wall when trying to move (meaning to stop the wall from moving anymore)
                    
                    if isChangingX == true {
                        newX -= 1
                    } else if isChangingX == false {
                        newY -= 1
                    } //end of adding or subtracting 1
                }//end of while loop

            }//end of if increase vs not increasing statement
          
            
  /*
            if newX == x && newY == y {
                //
            } else {
                if isIncreasing == true && isChangingX == true {
                    newX -= 1
                } else if isIncreasing == false && isChangingX == true {
                    newX += 1
                } else if isIncreasing == true && isChangingX == false {
                    newY -= 1
                } else if isIncreasing == false && isChangingX == false {
                    newY += 1
                } //end of sending the wall back 1
            } //checking if the wall moved or not, and if it did, send it back
             */
/*
                
            while (newX < self.maze.gridSize+1 && newX > 0 && newY < self.maze.gridSize+1 && newY > 0) {
                if convertLocation.side == wallSides.upSide && (self.maze.up[newX,newY] == true || (self.maze.right[newX,newY] == true && self.maze.right[newX,newY+1] == true)) {
                    break
                } else if convertLocation.side == wallSides.downSide && (self.maze.down[newX,newY] == true || (self.maze.right[newX,newY] == true && self.maze.right[newX,newY-1] == true)) {
                    break
                } else if convertLocation.side == wallSides.leftSide && (self.maze.left[newX,newY] == true || (self.maze.up[newX,newY] == true && self.maze.up[newX-1, newY] == true)) {
                    break
                } else if convertLocation.side == wallSides.rightSide && (self.maze.right[newX,newY] == true || (self.maze.up[newX,newY] == true && self.maze.up[newX+1, newY] == true)) {
                    break
                }//end of breaking out of the loop when there is another wall when trying to move (meaning to stop the wall from moving anymore)
                
                if isIncreasing == true && isChangingX == true {
                    newX += 1
                } else if isIncreasing == false && isChangingX == true {
                    newX -= 1
                } else if isIncreasing == true && isChangingX == false {
                    newY += 1
                } else if isIncreasing == false && isChangingX == false {
                    newY -= 1
                } //end of adding or subtracting 1
            }//end of while loop
            
            if newX == x && newY == y {
                //
            } else {
                if isIncreasing == true && isChangingX == true {
                    newX -= 1
                } else if isIncreasing == false && isChangingX == true {
                    newX += 1
                } else if isIncreasing == true && isChangingX == false {
                    newY -= 1
                } else if isIncreasing == false && isChangingX == false {
                    newY += 1
                } //end of sending the wall back 1
            } //checking if the wall moved or not, and if it did, send it back
            
*/
            wallPosition = getWallPosition(x: newX, y: newY, side: convertLocation.side)
            nodeAtPoint.position = wallPosition

            if convertLocation.side == wallSides.downSide {
                self.maze.down[newX, newY] = true
                self.maze.up[newX, newY-1] = true
            } else if convertLocation.side == wallSides.upSide {
                self.maze.up[newX, newY] = true
                self.maze.down[newX, newY+1] = true
            } else if convertLocation.side == wallSides.leftSide {
                self.maze.left[newX, newY] = true
                self.maze.right[newX-1, newY] = true
            } else if convertLocation.side == wallSides.rightSide {
                self.maze.right[newX, newY] = true
                self.maze.left[newX+1, newY] = true
            }//end of setting the new wall as true
            
            /*
            let wallArrays: [wallSides: Grid<Bool>]
            wallArrays[wallSides.downSide] = self.maze.down //etc...
    
            wallArrays[convertLocation.side][newX][newY] = true
             if (wallArrays[convertLocation.side][newX][newY] == true)
            */
            
        }//end of nodeAtPoint = mazeWall if-then statement
    }//end of func touchesBegan
    
    func moveMonster() {
        let currentX = monsterNode.currentPosition.x
        let currentY = monsterNode.currentPosition.y
        var validExits: [wallSides] = []
        
        if self.maze.right[currentX, currentY] == false && monsterNode.entranceSideUsed != wallSides.rightSide {
            validExits.append(wallSides.rightSide)
        }
        if self.maze.left[currentX, currentY] == false && monsterNode.entranceSideUsed != wallSides.leftSide {
            validExits.append(wallSides.leftSide)
        }
        if self.maze.up[currentX, currentY] == false && monsterNode.entranceSideUsed != wallSides.upSide && currentY < self.maze.gridSize {
            validExits.append(wallSides.upSide)
        }
        if self.maze.down[currentX, currentY] == false && monsterNode.entranceSideUsed != wallSides.downSide {
            validExits.append(wallSides.downSide)
        }
        
        var chosenExit: wallSides
        
        if validExits.count == 0 {
            chosenExit = monsterNode.entranceSideUsed
        } else {
            let randomExit = arc4random_uniform(UInt32(validExits.count))
            chosenExit = validExits[Int(randomExit)]
        }
        
        
        if chosenExit == wallSides.rightSide {
            monsterNode.moveRight()
        } else if chosenExit == wallSides.leftSide {
            monsterNode.moveLeft()
        } else if chosenExit == wallSides.upSide {
            monsterNode.moveUp()
        } else if chosenExit == wallSides.downSide {
            monsterNode.moveDown()
        }
        
        if monsterNode.currentPosition == (x: self.maze.finalExit!, y: 0) {
            gameState = .gameStart //KIND OF JUST A FILLER THINGY
        }
    }//end of func moveMonster
    
    override func update(_ currentTime: CFTimeInterval) {
        //CODE
    }
    
}













