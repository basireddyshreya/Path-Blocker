//
//  GameScene.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/19/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//


import SpriteKit
import GameplayKit
import AudioToolbox
import AVFoundation

enum wallSides {
    case upSide, downSide, leftSide, rightSide, noSide
}

enum GameSceneState {
    case gameStart, gameRunning, gameOver
}

enum WinState {
    case win, lose
}

class GameScene: SKScene {
    var mazeWall: SKNode!
    var buttonRestart: MSButtonNode!
    var buttonMenu: MSButtonNode!
    var buttonPause: MSButtonNode!
    var monsterNode: Monster!
    var monsterArray: [Monster] = []
    var maze = Maze(gridSize: 10)
    let wallTexture = SKTexture(imageNamed: "mazeWall")
    var tileSize = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var gameState: GameSceneState = .gameStart
    var winState: WinState = .win
    var countdown: Int = 60
    var startingCountdown: Int = 3
    var countdownLabel: SKLabelNode!
    var startingCountdownLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var gameBeginsLabel: SKLabelNode!
    var youWinLabel: SKLabelNode!
    var player: AVAudioPlayer?
    var leftFlag: SKNode!
    var rightFlag: SKNode!
    var sideExitFlagArray: [SKNode] = []
    var pauseMenuActive = false

    
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
        
        if pauseMenuActive == true {
            pauseMenuActive = false
            return
        }
        
        mazeWall = self.childNode(withName: "mazeWall")
        let monsterNode = self.childNode(withName: "monster") as! Monster
        countdownLabel = childNode(withName: "countdownLabel") as! SKLabelNode
        startingCountdownLabel = childNode(withName: "startingCountdownLabel") as! SKLabelNode
        gameOverLabel = childNode(withName: "gameOverLabel") as! SKLabelNode
        gameBeginsLabel = childNode(withName: "gameBeginsLabel") as! SKLabelNode
        youWinLabel = childNode(withName: "youWinLabel") as! SKLabelNode
        scene?.isPaused = false
        leftFlag = self.childNode(withName: "leftFlag")
        rightFlag = self.childNode(withName: "rightFlag")

        
//***************************THIS POINT IS ALL THE BUTTON RESTART STUFF DAMN******************************
        buttonRestart = self.childNode(withName: "buttonRestart") as! MSButtonNode
        buttonRestart.selectedHandler = { [unowned self] in
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
        }//end of button selection handler
        
        buttonMenu = self.childNode(withName: "buttonMenu") as! MSButtonNode
        buttonMenu.selectedHandler = { [unowned self] in
            
            let skView = self.view as SKView!
        
            let scene = MainMenu(fileNamed:"MainMenu") as MainMenu!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }//end of button selection handler
        
        buttonPause = self.childNode(withName: "buttonPause") as! MSButtonNode
        buttonPause.selectedHandler = { [unowned self] in
            self.pauseMenuActive = true
            
            let skView = self.view as SKView!
            
            let scene = PauseMenu(fileNamed:"PauseMenu") as PauseMenu!
            
            scene?.gameSceneObject = self
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
            
            
        }//end of button selection handler


        
        buttonRestart.state = .MSButtonNodeStateHidden
        buttonMenu.state = .MSButtonNodeStateHidden
        gameOverLabel.isHidden = true
        youWinLabel.isHidden = true
        
//*************************FIND THE MAX SIZE OF THE SCREEN************************************
        let screenSize = UIScreen.main.bounds
        let maxWidth = Int(screenSize.width) / 24 //maze.gridSize/2
        let maxHeight = Int(screenSize.height) / 24 //maze.gridSize/2
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
        
        startingCountdownLabel.text = String(startingCountdown)
        countdownLabel.text = String(countdown)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameStartCountDown), userInfo: nil, repeats: true)
        
        
//***************************THIS POINT IS ALL THE MONSTER STUFF WHOOO******************************
        
         monsterNode.tileSize = tileSize
         
         monsterArray.append(monsterNode)
         monsterArray[0].position = ConvertGridPositionToLocationPoint(x: self.maze.xOpening!, y: self.maze.gridSize+1)
         monsterArray[0].currentPosition = (x: self.maze.xOpening!, y: self.maze.gridSize+1)
         
         let newMonster = monsterNode.copy() as! Monster
         newMonster.tileSize = tileSize
         monsterArray.append(newMonster)
         addChild(newMonster)
         monsterArray[1].position = ConvertGridPositionToLocationPoint(x: self.maze.gridSize+1, y: self.maze.yOpening!)
         monsterArray[1].currentPosition = (x: self.maze.gridSize+1, y: self.maze.yOpening!)
        
        rightFlag.position = ConvertGridPositionToLocationPoint(x: self.maze.finalExit!+1, y: 0)
        leftFlag.position = ConvertGridPositionToLocationPoint(x: self.maze.finalExit!-1, y: 0)

        let newLeftFlag = leftFlag.copy() as! SKNode
        addChild(newLeftFlag)
        sideExitFlagArray.append(newLeftFlag)
        let secondNewLeftFlag = leftFlag.copy() as! SKNode
        addChild(secondNewLeftFlag)
        sideExitFlagArray.append(secondNewLeftFlag)
        sideExitFlagArray[0].position = ConvertGridPositionToLocationPoint(x: 0, y: self.maze.sideExit!+1)
        sideExitFlagArray[1].position = ConvertGridPositionToLocationPoint(x: 0, y: self.maze.sideExit!-1)
        

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
        if gameState == .gameOver || gameState == .gameStart {
            return
        }
        
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
            
            if convertLocation.side == wallSides.upSide && (self.maze.up[x+1,y] == true || (self.maze.right[x,y] == true && self.maze.right[x,y+1] == true)) && (self.maze.up[x-1,y] == true || (self.maze.right[x-1,y] == true && self.maze.right[x-1,y+1] == true)) {
                playInvalidWallSound()
            } else if convertLocation.side == wallSides.downSide && (self.maze.down[x+1,y] == true || (self.maze.right[x,y] == true && self.maze.right[x,y-1] == true)) && (self.maze.down[x-1,y] == true || (self.maze.right[x-1,y] == true && self.maze.right[x-1,y-1] == true)) {
                playInvalidWallSound()
            } else if convertLocation.side == wallSides.leftSide && (self.maze.left[x,y+1] == true || (self.maze.up[x,y] == true && self.maze.up[x-1, y] == true)) && (self.maze.left[x,y-1] == true || (self.maze.up[x,y-1] == true && self.maze.up[x-1, y-1] == true)) {
                playInvalidWallSound()
            } else if convertLocation.side == wallSides.rightSide && (self.maze.right[x,y+1] == true || (self.maze.up[x,y] == true && self.maze.up[x+1, y] == true)) && (self.maze.right[x,y-1] == true || (self.maze.up[x,y-1] == true && self.maze.up[x+1, y-1] == true)) {
                playInvalidWallSound()
            }

            
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
    
    func moveMonster(timer: Timer) {
        if gameState == .gameOver || pauseMenuActive == true {
            return
        }
        
        let monster = monsterArray[timer.userInfo as! Int]
        
        let currentX = monster.currentPosition.x
        let currentY = monster.currentPosition.y
        var validExits: [wallSides] = []
        
        if self.maze.right[currentX, currentY] == false && monster.entranceSideUsed != wallSides.rightSide && currentX != self.maze.gridSize {
            validExits.append(wallSides.rightSide)
        }
        if self.maze.left[currentX, currentY] == false && monster.entranceSideUsed != wallSides.leftSide {
            validExits.append(wallSides.leftSide)
        }
        if self.maze.up[currentX, currentY] == false && monster.entranceSideUsed != wallSides.upSide && currentY < self.maze.gridSize {
            validExits.append(wallSides.upSide)
        }
        if self.maze.down[currentX, currentY] == false && monster.entranceSideUsed != wallSides.downSide {
            validExits.append(wallSides.downSide)
        }
        
        var chosenExit: wallSides = .noSide //I ADDED A DEFAULT AS NO SIDE BUT IDK IF THAT WORKS
        
        if validExits.count == 0 {
            if self.maze.up[currentX, currentY] == true && self.maze.down[currentX, currentY] == true && self.maze.right[currentX, currentY] == true && self.maze.left[currentX, currentY] == true {
                return //make only one monster pause but the other one moves
            } else {
                chosenExit = monster.entranceSideUsed
            }
        } else {
            let randomExit = arc4random_uniform(UInt32(validExits.count))
            chosenExit = validExits[Int(randomExit)]
        }
        
        
        if chosenExit == wallSides.rightSide {
            monster.moveRight()
        } else if chosenExit == wallSides.leftSide {
            monster.moveLeft()
        } else if chosenExit == wallSides.upSide {
            monster.moveUp()
        } else if chosenExit == wallSides.downSide {
            monster.moveDown()
        }
        
        if monster.currentPosition == (x: self.maze.finalExit!, y: 1) {
            self.winState = .lose
            let delay = SKAction.wait(forDuration: 0.45)
            monster.run(delay) {
                monster.moveDown()
                self.gameState = .gameOver
            }
        } else if monster.currentPosition == (x: 1, y: self.maze.sideExit!) {
            self.winState = .lose
            let delay = SKAction.wait(forDuration: 0.45)
            monster.run(delay) {
                monster.moveLeft()
                self.gameState = .gameOver
            }

        }
    }//end of func moveMonster
    
   func updateCountDown() {
        if gameState == .gameOver || pauseMenuActive == true {
            return
        }
        countdown -= 1
        countdownLabel.text = String(countdown)
    }//end of func updateCountDown
    
    func playInvalidWallSound() {
        let url = Bundle.main.url(forResource: "beep", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func gameStartCountDown() {
        if gameState == .gameRunning || pauseMenuActive == true {
            return
        }
        
        startingCountdown -= 1
        startingCountdownLabel.text = String(startingCountdown)
        
        if startingCountdown == 0 {
            changeGameState()
            runTheGame()
        }
    }//end of func updateCountDown
    
    func changeGameState() {
        gameState = .gameRunning
    }
    
    func runTheGame() {
        if gameState == .gameRunning {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
        
            monsterArray[0].moveDown()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameScene.moveMonster(timer:)), userInfo: 0, repeats: true)
            
            monsterArray[1].moveLeft()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameScene.moveMonster(timer:)), userInfo: 1, repeats: true)
        }
    }//end of func run the game

    
    override func update(_ currentTime: CFTimeInterval) {
        if countdown == 0 {
            gameState = .gameOver
        }
        
        if gameState == .gameOver {
            buttonRestart.state = .MSButtonNodeStateActive
            buttonMenu.state = .MSButtonNodeStateActive
            buttonPause.state = .MSButtonNodeStateHidden
            if winState == .win {
                youWinLabel.isHidden = false
            } else {
                gameOverLabel.isHidden = false
            }
        }
        
        if gameState == .gameRunning {
            startingCountdownLabel.isHidden = true
            gameBeginsLabel.isHidden = true
            buttonPause.state = .MSButtonNodeStateActive
        }
    }//end of update func
    
}













