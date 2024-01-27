#include "game.h"

Game::Game() {
    currentBlock = CreateBlock();
    nextBlock = CreateBlock();
    GameOver = false;
    score = 0;
    difficulty = 0;

}

Block Game::CreateBlock()
{
    int randValue = GetRandomValue(1, 7);

    if (randValue == 1)
    {
        JBlock jblk = JBlock();
        return jblk;
    }
    else if (randValue == 2)
    {
        LBlock lblk = LBlock();
        return lblk;
    }
    else if (randValue == 3)
    {
        IBlock iblk = IBlock();
        return iblk;
    }
    else if (randValue == 4)
    {
        OBlock oblk = OBlock();
        return oblk;
    }
    else if (randValue == 5)
    {
        TBlock tblk = TBlock();
        return tblk;
    }
    else if (randValue == 6)
    {
        SBlock sblk = SBlock();
        return sblk;
    }
    else 
    {
        ZBlock zblk = ZBlock();
        return zblk;
    }


}



void Game::MoveBlockKeyPress()
{
    if (IsKeyPressed(KEY_LEFT))
    {
        MoveLeft();
    }
    else if (IsKeyPressed(KEY_RIGHT))
    {
        MoveRight();
    }
    else if (IsKeyPressed(KEY_DOWN))
    {
        MoveDown();
        if (!GameOver)
            UpdateScore(1);
    }
    else if (IsKeyPressed(KEY_UP))
    {
        RotateBlock();
    }
    else if (IsKeyPressed(KEY_SPACE))
    {
        DropDown();
    }
}

void Game::MoveLeft()
{
    if (!GameOver) 
    {
        currentBlock.MoveBlock(-1, 0);
        if (IsBlockOutOfGrid() || IsGridCellFilled())
        {
            currentBlock.MoveBlock(1,0);
        }
    }
}

void Game::MoveRight()
{
    if (!GameOver)
    {
        currentBlock.MoveBlock(1, 0);
        if (IsBlockOutOfGrid() || IsGridCellFilled())
        {
            currentBlock.MoveBlock(-1,0);
        }
    }   
}

void Game::MoveDown()
{
    if (!GameOver)
    {
        currentBlock.MoveBlock(0, 1);
        if (IsBlockOutOfGrid() || IsGridCellFilled())
        {
            currentBlock.MoveBlock(0,-1);
            LockBlock();
        }
    }
}

void Game::DropDown()
{
    if (!GameOver)
    {
        while (!IsBlockOutOfGrid() && !IsGridCellFilled())
        {
            currentBlock.MoveBlock(0, 1);
            UpdateScore(1);
        }
        currentBlock.MoveBlock(0,-1);
        LockBlock();

    }

}


bool Game::IsBlockOutOfGrid()
{
    std::vector<Position> cells = currentBlock.GetPositions();   //vector of positions (x1, y1), (x2, y2), (x3, y3), (x4, y4)
    for (Position item: cells)
    {
        if (IsPositionOutOfGrid(item))
            return true;
    }
    return false;
}

bool Game::IsPositionOutOfGrid(Position item)
{
    if (item.column < 0 || item.column >= COLUMNSIZE)
        return true;
    else if (item.row >= ROWSIZE)
        return true;
    else   
        return false;
}

void Game::RotateBlock()
{
    if (!GameOver)
    {
        if (currentBlock.rotation == 0)
        {
            currentBlock.rotation = 1;
            if (IsBlockOutOfGrid() || IsGridCellFilled())
                currentBlock.rotation = 0;
        }
        else if (currentBlock.rotation == 1)
        {
            currentBlock.rotation = 2;
            if (IsBlockOutOfGrid() || IsGridCellFilled())
                currentBlock.rotation = 1;
        }
        else if (currentBlock.rotation == 2)
        {
            currentBlock.rotation = 3;
            if (IsBlockOutOfGrid() || IsGridCellFilled())
                currentBlock.rotation = 2;
        }
        else if (currentBlock.rotation == 3)
        {
            currentBlock.rotation = 0;
            if (IsBlockOutOfGrid() || IsGridCellFilled())
                currentBlock.rotation = 3;
        }

    }
    
}


void Game::LockBlock()
{
    std::vector<Position> cells = currentBlock.GetPositions();
    for (Position items: cells)
    {
        mainGrid.ChangeGridValue(items, currentBlock.id);   //Update Grid value to Block ID to paint the block onto the grid
    }

    int points = ClearAnyRows();
    UpdateScore(points);

    currentBlock = nextBlock;
    nextBlock = CreateBlock();

    if (IsGridCellFilled())
        GameOver = true;

}

bool Game::IsGridCellFilled()
{
    std::vector<Position> cells = currentBlock.GetPositions();
    for (Position items: cells)
    {
        if (mainGrid.grid[items.row][items.column] != 0)
            return true;
    }
    return false;
}

void Game::ResetGame()
{
    DrawGameOver();
    if (IsKeyPressed(KEY_ENTER))
    {
        GameOver = false;
        mainGrid = Grid();
        currentBlock = nextBlock;
        nextBlock = CreateBlock();
        
    }
}

int Game::ClearAnyRows()
{
    int fullRows = 0;
    int mostBottomFullRow = 0;
    //Check for any full rows
    for (int r = 0; r < ROWSIZE; r++)
    {
        if (IsRowFull(r))   //increase count of full rows
        {
            ++fullRows;
            mostBottomFullRow = r;

        }
    }

    //move the rows to the full row, thereby clearing that row
    //set the previous location to all 0
    if (fullRows > 0)
    {
        for (int r = mostBottomFullRow; r > 0 ; r--)
        {
            if (r - fullRows < 0)
                break;
            MoveRows(r, fullRows);
            
        }
    }

    if (fullRows == 1)
        return 100;
    else if (fullRows == 2)
        return 300;
    else if (fullRows == 3)
        return 600;
    else if (fullRows == 4)
        return 1000;
    else
        return 0;
}

bool Game::IsRowFull(int row)
{
    
    for (int c = 0; c < COLUMNSIZE; c++)
    {
        if (mainGrid.grid[row][c] == 0 )
            return false;
    }
    return true;
}

void Game::MoveRows(int row, int numRow)
{
    for (int c = 0; c < COLUMNSIZE; c++)
    {
        mainGrid.grid[row][c] = mainGrid.grid[row-numRow][c];
        mainGrid.grid[row-numRow][c] = 0;
        
    }
}

void Game::UpdateScore(int points)
{
    score += points;
}

void Game::DrawScoreBoard()
{
    DrawRectangle(2*GRID_OFFSET + GRID_WIDTH, 6*GRID_OFFSET, SCOREBOARD_WIDTH, SCOREBOARD_HEIGHT, WHITE);
    DrawText("SCORE", 425, 20, 36, BLACK);
    DrawText(TextFormat("%d", score), 425, 75, 48, BLACK);
}

void Game::DrawNextBlock()
{
    DrawText("NEXT", 425, 200, 36, BLACK);
    DrawRectangle(2*GRID_OFFSET + GRID_WIDTH, 24*GRID_OFFSET, SCOREBOARD_WIDTH, 3*SCOREBOARD_HEIGHT, WHITE);

    nextBlock.DrawBlock(320, 300);
}

void Game::DrawGameOver()
{
    
    DrawText("GAME OVER", 420, 500, 36, BLACK);
    DrawText("Press 'Enter'", 420, 540, 24, BLACK);
    DrawText("to restart", 420, 565, 24, BLACK);
    DrawText("Thanks for Playing!", 415, 780, 14, BLACK);
    DrawText("Tetris Clone by Gene Drumheller.", 415, 795, 14, BLACK);
    
}

int Game::SelectDifficulty()
{
    DrawText("SELECT DIFFICULTY:", 20, 60, 36, BLACK);
    DrawText("EASY - 1", 20, 100, 36, BLACK);
    DrawText("MEDIUM - 2", 20, 140, 36, BLACK);
    DrawText("HARD - 3", 20, 180, 36, BLACK);
    DrawText("VERY HARD - 4", 20, 220, 36, BLACK);

    if (IsKeyPressed(KEY_ONE))
        difficulty = 1;
    else if (IsKeyPressed(KEY_TWO))
        difficulty = 2;
    else if (IsKeyPressed(KEY_THREE))
        difficulty = 3;
    else if (IsKeyPressed(KEY_FOUR))
        difficulty = 4;

    return difficulty;
}