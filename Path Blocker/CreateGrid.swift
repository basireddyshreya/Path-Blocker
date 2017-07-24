//
//  CreateGrid.swift
//  Path Blocker
//
//  Created by Shreya Basireddy on 7/19/17.
//  Copyright © 2017 Shreya Basireddy. All rights reserved.
//

import Foundation

// Class representing a grid, where elements can be accessed using [x,y] subscript syntax

class Grid<T> {
    var matrixGrid:[T]
    var rows:Int
    var columns:Int
    
    init(rows:Int, columns:Int, defaultValue:T) {
        self.rows = rows
        self.columns = columns
        matrixGrid = Array(repeating:defaultValue,count:(rows*columns))
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(col:Int, row:Int) -> T {
        get{
            assert(indexIsValidForRow(row: row, column: col), "Index out of range: ".appendingFormat("(%d, %d)", row, col))
            return matrixGrid[Int(columns * row + col)]
        }
        set{
            assert(indexIsValidForRow(row: row, column: col), "Index out of range: ".appendingFormat("(%d, %d)", row, col))
            matrixGrid[(columns * row) + col] = newValue
        }
    }
}
