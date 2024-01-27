/*
    This header file contains the declaration related to the grid.
*/

#pragma once
#include "block.h"
#include <raylib.h>
#include <vector>


class Grid 
{
public:
    Grid();
    void DrawGrid();
    void ChangeGridValue(Position cells, int id);
    int grid[ROWSIZE][COLUMNSIZE];
private:
    
    

};