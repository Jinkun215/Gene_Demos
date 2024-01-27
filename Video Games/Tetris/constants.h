/*
    This header file contains the constant ints that set the sizes of cells, grids, and windows
*/

#pragma once

const int CELLSIZE = 40;   // default at 40
const int COLUMNSIZE = 10; // default at 10
const int ROWSIZE = 20;    // default at 20

const int GRID_WIDTH = CELLSIZE * COLUMNSIZE + 1;  //default at 401.  Must be 10 times larger than CELLSIZE to fit 10 columns of cells, plus 1 for visual spacing.
const int  GRID_HEIGHT = CELLSIZE * ROWSIZE + 1;    //default at 801.  Must be 20 times larger than CELLSIZE to fit 20 rows of cells, plus 1 for visual spacing.

const int MAX_ROTATION = 3;    // ammount block can rotate before resetting

const int FULL_WINDOW_WIDTH = int((GRID_WIDTH - 1) * 1.6);    //default at 640
const int FULL_WINDOW_HEIGHT = (GRID_HEIGHT - 1) + 20;        //default at 820

const int GRID_OFFSET = 10;

const int SCOREBOARD_WIDTH = FULL_WINDOW_WIDTH - (GRID_WIDTH -1) - (3 * GRID_OFFSET); //default at 210
const int SCOREBOARD_HEIGHT = FULL_WINDOW_HEIGHT / 10;  //default at 82

