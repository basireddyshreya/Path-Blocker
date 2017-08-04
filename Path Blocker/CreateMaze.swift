//
//  CreateMaze.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/19/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation
import SpriteKit


// Class representing a Maze
class Maze {
    // Walls. [x,y] is true if there is a wall up/right/down/left of [x,y]
    var up      :Grid<Bool>
    var right   :Grid<Bool>
    var down    :Grid<Bool>
    var left    :Grid<Bool>
    
    // Visited cells
    var visitedCells :Grid<Bool>
    
    var gridSize = 10
    
    /*var xEntrance: UInt32
    var exit: UInt32
    var yEntrance: UInt32*/
    
    var xOpening: Int?
    var yOpening: Int?
    var finalExit: Int?

    /**
     Init method.
     
     :param: gridSize Int indicating the width and hight of the maze in number of cells, with width = height = gridSize
     :param: screenSize Int indicating the width and hight of the view, with width = height = screenSize
     */
    
    //init(gridSize: Int, xEntrance: UInt32, exit: UInt32, yEntrance: UInt32) {
    init(gridSize: Int) {
        /*self.xEntrance = xEntrance
        self.exit = exit
        self.yEntrance = yEntrance*/
        
        visitedCells = Grid<Bool>(rows: (gridSize+2), columns: (gridSize+2), defaultValue: false)
        up = Grid<Bool>(rows: (gridSize+2), columns: (gridSize+2), defaultValue: true)
        right = Grid<Bool>(rows: (gridSize+2), columns: (gridSize+2), defaultValue: true)
        down = Grid<Bool>(rows: (gridSize+2), columns: (gridSize+2), defaultValue: true)
        left = Grid<Bool>(rows: (gridSize+2), columns: (gridSize+2), defaultValue: true)
        
        
        // Initialize perimeter as already visited
        for x in 0..<gridSize+2 {
            visitedCells[x,0] = true
            visitedCells[x,gridSize+1] = true
        }
        
        for y in 0..<gridSize+2 {
            visitedCells[0,y] = true
            visitedCells[gridSize+1,y] = true
        }
        
        dropWalls(x: 1, y:1, gridSize: gridSize)
        
        //createOpenings(xEntrance: xEntrance, exit: exit, yEntrance: yEntrance)
        createOpenings()

    }
    
    /**
     Visit every cell in the maze grid by picking a random unvisited cell each time. "Drop" the
     wall between the source and the destination node by marking the appropriate position in the
     corresponding wall grids as false.
     
     :param: x Int x position in the grid of the destination node
     :param: y Int y position in the grid of the destination node
     :param: gridSize Int indicating the width and hight of the maze in number of cells, with width = height = gridSize
     */
    func dropWalls(x:Int, y:Int, gridSize: Int) {
        visitedCells[x,y] = true;
        
        // Loop while we have unvisited cells
        while (!visitedCells[x,y + 1] || !visitedCells[x + 1,y] || !visitedCells[x,y - 1] || !visitedCells[x - 1,y]) {
            
            // Choose a random destination cell
            while (true) {
                let r =  UInt32(arc4random()) % 4
                if (r == 0 && !visitedCells[x,y + 1]) {
                    up[x,y] = false
                    down[x,y + 1] = false
                    dropWalls(x: x, y: y + 1, gridSize:gridSize)
                    break
                } else if (r == 1 && !visitedCells[x + 1,y]) {
                    right[x,y] = false
                    left[x + 1, y] = false
                    dropWalls(x: x + 1, y: y, gridSize:gridSize)
                    break
                } else if (r == 2 && !visitedCells[x,y - 1]) {
                    down[x,y] = false
                    up[x,y - 1] = false
                    dropWalls(x: x, y: y - 1, gridSize:gridSize)
                    break
                } else if (r == 3 && !visitedCells[x - 1,y]) {
                    left[x,y] = false
                    right[x - 1,y] = false
                    dropWalls(x: x - 1, y: y, gridSize:gridSize)
                    break
                }
                
                
            }//end of while true
        }//end of while visited cells
    }//end of func drop walls
    
    //func createOpenings(xEntrance: UInt32, exit: UInt32, yEntrance: UInt32) {
    func createOpenings() { //-> Int {
        //Create random entrances and a random exit
        let xEntrance = arc4random_uniform(UInt32(gridSize-1)) + 1
        let exit = arc4random_uniform(UInt32(gridSize-2)) + 1
        let yEntrance = arc4random_uniform(UInt32(gridSize-3)) + 3
    
        xOpening = Int(xEntrance)
        yOpening = Int(yEntrance)
        finalExit = Int(exit)
        
        up[Int(xEntrance),gridSize] = false
        up[Int(exit),0] = false
        right[gridSize, Int(yEntrance)] = false
        //TRY TO FIGURE OUT A WAY TO HAVE THE LEFT OR RIGHT Y WALLS??
        
        // Open up the start and end
        //up[1,gridSize] = false
        //down[1,gridSize] = false
        //up[gridSize,1] = false
        //down[gridSize,1] = false
        
        //return Int(xEntrance)
    }//end of func createOpenings


}



// *******************************************************************************************************



/*

class Maze {
    // Walls. [x,y] is true if there is a wall up/right/down/left of [x,y]
    var up      :Grid<Bool>
    var right   :Grid<Bool>
    var down    :Grid<Bool>
    var left    :Grid<Bool>
    
    
    // Visited cells
    var visitedCells :Grid<Bool>
    
    //Size of maze
    var gridSize = 10
    
    //    // View on which we will draw our maze
    //    var view:UIView!
// ************NOT USING THIS UNTIL ACTUALLY NEEDING THE VIEW TO DRAW)**************
    
    /**
     Init method.
     Changed from original bc gridSize is set (15) and no parameters taken in for that; also grid size isn't + 2
     */

    init() {
        visitedCells = Grid<Bool>(rows: (gridSize), columns: (gridSize), defaultValue: false)
        up = Grid<Bool>(rows: (gridSize), columns: (gridSize), defaultValue: true)
        right = Grid<Bool>(rows: (gridSize), columns: (gridSize), defaultValue: true)
        down = Grid<Bool>(rows: (gridSize), columns: (gridSize), defaultValue: true)
        left = Grid<Bool>(rows: (gridSize), columns: (gridSize), defaultValue: true)
        
        // Initialize perimeter as already visited
        //CREATES THE OUTER WALLS
        for x in 0..<gridSize{
            visitedCells[x,0] = true
            visitedCells[x,gridSize-1] = true
            //do i subtract plus one or not?
            //ADDING 1 DOESNT WORK, NEIHER DOES LEAVING IT ALONE
        }
        
        for y in 0..<gridSize {
            visitedCells[0,y] = true
            visitedCells[gridSize-1,y] = true
            //do i subtract plus one or not?
            //ADDING ONE DOESN'T WORK EITHER RIP, NEITHER DOES LEAVING IT ALONE
        }

        dropWalls(x: 0, y: 0)
//TRIED CHANGING IT TO 0, 0 from 1, 1
        
    }//end of initializers
    
    

    
    /**
     Visit every cell in the maze grid by picking a random unvisited cell each time. "Drop" the
     wall between the source and the destination node by marking the appropriate position in the
     corresponding wall grids as false.
     
     :param: x Int x position in the grid of the destination node
     :param: y Int y position in the grid of the destination node
     :param: gridSize Int indicating the width and hight of the maze in number of cells, with width = height = gridSize
     
     */

/*    func dropWalls(x:Int, y:Int) {
        visitedCells[x,y] = true
        var visitedAbove: Bool? = nil
        var visitedDown: Bool? = nil
        var visitedRight: Bool? = nil
        var visitedLeft: Bool? = nil
        
        if y + 1 < gridSize {
            visitedAbove = visitedCells[x, y + 1]
        }
        if y - 1 >= 0 {
            visitedDown = visitedCells[x, y - 1]
        }
        if x + 1 < gridSize {
            visitedRight = visitedCells[x + 1, y]
        }
        if x - 1 >= 0 {
            visitedLeft = visitedCells[x - 1, y]
        }
//change to an if statement that is checkingbefprehand that x !< 0 and >gridsize (same for y)
        // Continue to loop as long as there are unvisited cells
        while ((visitedAbove != nil && !visitedAbove!) || (visitedRight != nil && !visitedRight!) || (visitedDown != nil && !visitedDown!) || (visitedLeft != nil && !visitedLeft!)) {
        //for x in 0..<gridSize {
            // Choose a random destination cell
            while (true) {
            //for y in 0..<gridSize {
                let rValue =  UInt32(arc4random()) % 4
                if (rValue == 0 && visitedAbove != nil && !visitedAbove!) {
                    up[x,y] = false
                    down[x,y + 1] = false
                    dropWalls(x: x, y: y + 1)
                    break
                } else if (rValue == 1 && visitedRight != nil && !visitedRight!) {
                    right[x,y] = false
                    left[x + 1, y] = false
                    dropWalls(x: x + 1, y: y)
                    break
                } else if (rValue == 2 && visitedDown != nil && !visitedDown!) {
                    down[x,y] = false
                    up[x,y - 1] = false
                    dropWalls(x: x, y: y - 1)
                    break
                } else if (rValue == 3 && visitedLeft != nil && !visitedLeft!) {
                    left[x,y] = false
                    right[x - 1,y] = false
                    dropWalls(x: x - 1, y: y)
                    break
                } else if visitedAbove != false || visitedLeft != false || visitedDown != false || visitedRight != false {
                    for x in 0..<gridSize {
                        for y in 0..<gridSize {
                            if visitedCells[x, y] == false {
                                dropWalls(x: x, y: y)
                            }
                        }
                    }
                    break
                } //end of If-then statement for seeing remainder of random value
            }//end of chosing a random destination cell
        }//end of looping through unvisited cells
//    ******************DOESN'T CRASH BUT DOESN'T SHOW MAZE, ONLY GRID*****************************
        
    }//end of Func dropWalls
*/
    
    
    
/*  func dropWalls(x: Int, y: Int) {
        visitedCells[x,y] = true
        //change to an if statement that is checkingbefprehand that x !< 0 and >gridsize (same for y)
        // Continue to loop as long as there are unvisited cells
        for x in 0..<gridSize {
            // Choose a random destination cell
            for y in 0..<gridSize {
                let rValue =  UInt32(arc4random()) % 4
                if (rValue == 0 && !visitedCells[x,y + 1]) {
                    up[x,y] = false
                    down[x,y + 1] = false
                    dropWalls(x: x, y: y + 1)
                    break
                } else if (rValue == 1 && !visitedCells[x + 1,y]) {
                    right[x,y] = false
                    left[x + 1, y] = false
                    dropWalls(x: x + 1, y: y)
                    break
                } else if (rValue == 2 && !visitedCells[x,y - 1]) {
                    if y > 0 && x >= 0 {
                        down[x,y] = false
                        up[x,y - 1] = false
                        dropWalls(x: x, y: y - 1)
                        break
                    }
                } else if (rValue == 3 && !visitedCells[x - 1,y]) {
                    if x > 0 && y >= 0 {
                        left[x,y] = false
                        right[x - 1,y] = false
                        dropWalls(x: x - 1, y: y)
                        break
                    }
                }//end of If-then statement for seeing remainder of random value
            }//end of chosing a random destination cell
        }//end of looping through unvisited cells
  }//end of func DropWalls
*/
//    **************** ORIGINAL CODE THAT CRASHED ******************
    
    
    
 

    func dropWalls (x: Int, y: Int) {
        for x in 0..<gridSize {
            // Choose a random destination cell
            for y in 0..<gridSize {
                let rValue =  UInt32(arc4random()) % 4
                print(rValue)
                if (rValue == 0 && y + 1 < gridSize) {
                    up[x,y] = false
                    down[x,y + 1] = false
                } else if (rValue == 1 && x + 1 < gridSize) {
                    right[x,y] = false
                    left[x + 1, y] = false
                } else if (rValue == 2 && y - 1 >= 0) {
                    down[x,y] = false
                    up[x,y - 1] = false
                } else if (rValue == 3 && x - 1 >= 0) {
                    left[x,y] = false
                    right[x - 1,y] = false
                } //end of If-then statement for seeing remainder of random value
            }//end of chosing a random destination cell
        }//end of looping through unvisited cells
        
        //Create random entrances and a random exit
        let xEntrance = UInt32(arc4random_uniform(UInt32(gridSize - 1))) //CHANGED THIS TO 14 FROM 15
        let exit = UInt32(arc4random_uniform(UInt32(gridSize - 1))) //CHANGED THIS TO 14 FROM 15
        visitedCells[Int(xEntrance),0] = false
        visitedCells[Int(exit),gridSize-1] = false
        
        let yEntrance = UInt32(arc4random_uniform(UInt32(gridSize - 3)))
        visitedCells[gridSize-1, Int(yEntrance)] = false
        //TRY TO FIGURE OUT A WAY TO HAVE THE LEFT OR RIGHT Y WALLS??
     }//end of Func drop Walls
// ******************* WORKED AND SHOWED AN ACTUAL MAZE WITHOUT CRASHING *******************

    
    
    func moveWalls() {
        //if user taps a wall, wall moves to the open space next to it (down/right space)
        //if wall is down or up
        //if right is blocked by an existing wall, move left
        //if same wall next to it/connected wall by cell is tapped, that wall moves in same direction
        //else if left is blocked, wall moves right
        //if same wall next to it/connected wall by cell is tapped, that wall moves in same direction
        //else if wall is left or right
        //if down is blocked by an existing wall, move up
        //if same wall next to it/connected wall by cell is tapped, that wall moves in same direction
        //else if up is blocked, wall moves down
        //if same wall next to it/connected wall by cell is tapped, that wall moves in same direction
    }//end of func moveWalls
 
} // end of Maze Class

*/

