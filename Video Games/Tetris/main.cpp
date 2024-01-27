#include "game.h"
#include <raylib.h>

int autoMoveDownFrames = 30; // 30 frames = 0.5 seconds
int recordFrames = 0;

int gameDifficulty = 0;


int main () {

    InitWindow(FULL_WINDOW_WIDTH, FULL_WINDOW_HEIGHT, "TETRIS CLONE");    //Create Window and Title
    SetTargetFPS(60);   //Set FPS for all users to 60 frame per second

    //Grid grid = Grid();
    //JBlock blk = JBlock();

    Game game = Game();
    
    while (!WindowShouldClose() && gameDifficulty == 0)
    {
        BeginDrawing();
        ClearBackground(LIGHTGRAY);
        gameDifficulty = game.SelectDifficulty();
        EndDrawing();

    }

    switch (gameDifficulty)
    {
        case 1:
            autoMoveDownFrames = 30;
            break;
        case 2:
            autoMoveDownFrames = 20;
            break;
        case 3:
            autoMoveDownFrames = 10;
        case 4:
            autoMoveDownFrames = 5;
    }


    while (!WindowShouldClose()) // main Game Loop
    {
        BeginDrawing();

        ClearBackground(LIGHTGRAY);


        ++recordFrames;
        if (recordFrames == autoMoveDownFrames)
        {
            game.MoveDown();
            recordFrames = 0;
        }
        game.mainGrid.DrawGrid();
        game.DrawScoreBoard();
        game.DrawNextBlock();
        game.MoveBlockKeyPress();
        game.currentBlock.DrawBlock();

       if (game.GameOver)
       {
            game.ResetGame();
       }
        EndDrawing();
    }

    CloseWindow();  // Close Window
    return 0;   // Exit Program

}