//
//  Cells.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/24/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation

/*class Cell {
    
    /*
    var posXUp: CGPoint()
    var posXDown: CGPoint()
    var posXRight: CGPoint()
    var posXLeft: CGPoint()
    var posYUp: CGPoint()
    var posYDown: CGPoint()
    var posYRight : CGPoint()
    var posXLeft : CGPoint()
 */
    
    var locationX: Int
    var locationY: Int
    
    var up: Grid<Bool>
    var down: Grid<Bool>
    var left: Grid<Bool>
    var right: Grid<Bool>
    
    func convert(location: CGPoint) -> (x: Int, y: Int) {
        //let blah....
        return (locationX, locationY)
    }
}
    func convertGridCellToLocationPoint(x: Int, y: Int) -> (location: CGPoint) {
        return (locationX, locationY)
    }
 
 */



