#include "colors.h"


Color BlockColor(int id) //Returns the Block Color based on the Block id
{   

    switch (id) 
    {
        case 1:
            return RED;
            break;

        case 2:
            return BLUE;
            break;

        case 3:
            return YELLOW;
            break;

        case 4:
            return GREEN;
            break;

        case 5:
            return PURPLE;
            break;   

        case 6:
            return ORANGE;
            break;

        case 7:
            return BEIGE;
            break;  

        default:
            return DARKGRAY;
            break;
    }

}