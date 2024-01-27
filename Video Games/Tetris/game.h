#pragma once
#include "grid.h"
#include <raylib.h>
#include <iostream>


class Game
{
public:
    Game();
    Block CreateBlock();
    void MoveBlockKeyPress();
    void MoveLeft();
    void MoveRight();
    void MoveDown();
    void DropDown();
    bool IsBlockOutOfGrid();
    bool IsPositionOutOfGrid(Position item);
    void RotateBlock();
    

    void LockBlock();
    bool IsGridCellFilled();
    void ResetGame();
    int ClearAnyRows();
    bool IsRowFull(int row);
    void MoveRows(int row, int numRow);


    void UpdateScore(int points);
    void DrawScoreBoard();
    void DrawNextBlock();
    void DrawGameOver();

    int SelectDifficulty();

    Grid mainGrid;
    Block currentBlock;
    Block nextBlock;
    bool GameOver;
    int score;
    int difficulty;
private:
    
};