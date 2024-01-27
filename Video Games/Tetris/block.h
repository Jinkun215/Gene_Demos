/*
    This header file contains the declaration related to the Block.
*/

#pragma once
#include "position.h"
#include "colors.h"
#include <map>
#include <vector>
#include <raylib.h>
#include <iostream>


class Block
{
public:
    Block();
    void DrawBlock();
    void DrawBlock(int posX, int posY);
    std::vector<Position> GetPositions();
    void MoveBlock(int x, int y);


        
    std::map<int, std::vector<Position>> block;
    int id;
    int rotation;
    int rowOffset;
    int columnOffset;
    
};

class JBlock: public Block{
public:
    JBlock();


};

class LBlock: public Block{
public:
    LBlock();

};

class IBlock: public Block{
public:
    IBlock();

};

class OBlock: public Block{
public:
    OBlock();

};

class TBlock: public Block{
public:
    TBlock();

};

class SBlock: public Block{
public:
    SBlock();

};

class ZBlock: public Block{
public:
    ZBlock();

};

