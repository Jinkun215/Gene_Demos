/*
    This header file contains the definitions of a block.
*/

#include "block.h"



Block::Block() // Constructor
{
    id = 0;
    rotation =  GetRandomValue(0, 3);
    rowOffset = 0;
    columnOffset = 0;
    
}

void Block::DrawBlock() // Draws the position of a block
{
    std::vector<Position> cells = GetPositions();

    for (Position i: cells)
    {
        DrawRectangle(GRID_OFFSET + CELLSIZE * i.column +1 , GRID_OFFSET + CELLSIZE * i.row +1, CELLSIZE-1, CELLSIZE-1, BlockColor(id));
    }
    
}

void Block::DrawBlock(int posX, int posY) // Draws the position of a block with adjusted positions
{
    std::vector<Position> cells = GetPositions();

    for (Position i: cells)
    {
        DrawRectangle(posX + GRID_OFFSET + CELLSIZE * i.column +1 ,  posY + GRID_OFFSET + CELLSIZE * i.row +1, CELLSIZE-1, CELLSIZE-1, BlockColor(id));
    }
    
}

std::vector<Position> Block::GetPositions()     //returns vector of Positions with Position(row, column) adjusted
{
    std::vector<Position> cells = block[rotation];
    std::vector<Position> newCells;
    for (Position i: cells)
    {
        Position newPosition = Position(i.row + rowOffset, i.column + columnOffset); //Adjust the Position by the Offset variables
        newCells.push_back(newPosition);
    }
    return newCells;    
}





void Block::MoveBlock(int x, int y)
{
    columnOffset += x;
    rowOffset += y;
    
}








JBlock::JBlock()    
{
    id = 1;
    block[0] = {Position(0,2), Position(1,2), Position(2,1), Position(2,2)};
    block[1] = {Position(1,0), Position(2,0), Position(2,1), Position(2,2)};
    block[2] = {Position(0,0), Position(0,1), Position(1,0), Position(2,0)};
    block[3] = {Position(0,0), Position(0,1), Position(0,2), Position(1,2)};
    MoveBlock(3,0);    
}

LBlock::LBlock()    
{
    id = 2;
    block[0] = {Position(0,0), Position(1,0), Position(2,0), Position(2,1)};
    block[1] = {Position(0,0), Position(0,1), Position(0,2), Position(1,0)};
    block[2] = {Position(0,1), Position(0,2), Position(1,2), Position(2,2)};
    block[3] = {Position(1,2), Position(2,0), Position(2,1), Position(2,2)};
    MoveBlock(3,0);
}

IBlock::IBlock()
{
    id = 3;
    block[0] = {Position(1,0), Position(1,1), Position(1,2), Position(1,3)};
    block[1] = {Position(0,2), Position(1,2), Position(2,2), Position(3,2)};
    block[2] = {Position(2,0), Position(2,1), Position(2,2), Position(2,3)};
    block[3] = {Position(0,1), Position(1,1), Position(2,1), Position(3,1)};
    if (rotation == 0 || rotation == 2)
        MoveBlock(3,-1);
    else
        MoveBlock(3,0);
}

OBlock::OBlock()
{
    id = 4;
    block[0] = {Position(0,0), Position(0,1), Position(1,0), Position(1,1)};
    block[1] = {Position(0,0), Position(0,1), Position(1,0), Position(1,1)};
    block[2] = {Position(0,0), Position(0,1), Position(1,0), Position(1,1)};
    block[3] = {Position(0,0), Position(0,1), Position(1,0), Position(1,1)};
    MoveBlock(4,0);
}

TBlock::TBlock()
{
    id = 5;
    block[0] = {Position(0,1), Position(1,0), Position(1,1), Position(1,2)};
    block[1] = {Position(0,1), Position(1,1), Position(1,2), Position(2,1)};
    block[2] = {Position(1,0), Position(1,1), Position(1,2), Position(2,1)};
    block[3] = {Position(0,1), Position(1,0), Position(1,1), Position(2,1)};
    MoveBlock(3,0);
}

SBlock::SBlock()
{
    id = 6;
    block[0] = {Position(0,1), Position(0,2), Position(1,0), Position(1,1)};
    block[1] = {Position(0,1), Position(1,1), Position(1,2), Position(2,2)};
    block[2] = {Position(0,1), Position(0,2), Position(1,0), Position(1,1)};
    block[3] = {Position(0,1), Position(1,1), Position(1,2), Position(2,2)};
    MoveBlock(3,0);
}

ZBlock::ZBlock()
{
    id = 7;
    block[0] = {Position(0,0), Position(0,1), Position(1,1), Position(1,2)};
    block[1] = {Position(0,2), Position(1,1), Position(1,2), Position(2,1)};
    block[2] = {Position(0,0), Position(0,1), Position(1,1), Position(1,2)};
    block[3] = {Position(0,2), Position(1,1), Position(1,2), Position(2,1)};
    MoveBlock(3,0);
}