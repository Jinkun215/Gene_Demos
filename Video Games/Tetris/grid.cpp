/*
    This header file contains the definitions related to the grid.
*/

#include "grid.h"

Grid::Grid()    // Constructor.  Set Value of grid to 0.
{
    for (int rows = 0; rows < ROWSIZE; ++rows)
        for (int columns = 0; columns < COLUMNSIZE; ++columns)
            grid[rows][columns] = 0;
}

void Grid::DrawGrid()   // Draw Background Grid.
{
    for (int rows = 0; rows < ROWSIZE; ++rows)
        for (int columns = 0; columns < COLUMNSIZE; ++columns)
        {
            DrawRectangle(GRID_OFFSET + columns * CELLSIZE+1, GRID_OFFSET + rows * CELLSIZE+1, CELLSIZE-1, CELLSIZE-1, BlockColor(grid[rows][columns]));
        }
    
    
}

void Grid::ChangeGridValue(Position cells, int id)
{
    grid[cells.row][cells.column] = id;
}
