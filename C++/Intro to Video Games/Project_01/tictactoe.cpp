// Gene Drumheller
// 

#include <iostream>
#include <vector>

int main(){

	std::vector<std::vector<int> > gameGrid{{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
	
	int user_input_x = 0;
	int user_input_y = 0;
	int currentPlayer = 1;  
	int value_stored = 0;
	int total = 0;
	int total_inputs = 0;

	
	
	while (true) {
			
		// Asks Players for their inputs.  Player 1 = 1, Player 2 = -1
		//When a column or row or diagonol sum equal to 3, player 1 win.  If equal to -3, player 2 wins.
		top_player: 
			std::cout << "Player " << currentPlayer << "'s Turn.  Enter coordinates (x, y): ";
			std::cin >> user_input_x >> user_input_y;
			if (user_input_x < 0 || user_input_x > 2) {
				std::cout << "x is an invalid input!" << std::endl;
				goto top_player;
			}
			if (user_input_y < 0 || user_input_y > 2) {
				std::cout << "y is an invalid input!" << std::endl;
				goto top_player;
			}
			
			if (gameGrid[user_input_x][user_input_y] == 0) {
				(currentPlayer == 1) ? gameGrid[user_input_x][user_input_y] = 1:gameGrid[user_input_x][user_input_y] = -1;
				total_inputs++;
				
			}
			else {
				value_stored = gameGrid[user_input_x][user_input_y];
				std::cout << "Occupied by " << ((value_stored == 1) ? "Player 1" : "Player 2") << ". Pick a another location" << std::endl;
				goto top_player;
			}
				
		//Display text based graphics
		for (int i = 0; i <= 2; i++) {
			std::cout << std::endl;
			for (int j = 0; j <= 2; j++){
				if (gameGrid[i][j] == 1)
					std::cout << "X";
				else if (gameGrid[i][j] == -1)
					std::cout << "O";
				else
					std::cout << "-";
				
				std::cout << " ";
			}
		}
		std::cout << std::endl;
		
		
		//Check win condition
		for (int i = 0; i <= 2; i++) {
			for (int j = 0; j <= 2; j++) {
				total += gameGrid[i][j];
				if (j == 2) {
					if (total == 3){
						std::cout << "\n\nPlayer 1 Wins!!" << std::endl;
						return 0;
					}
					else if (total == -3) {
						std::cout << "\n\nPlayer 2 Wins!!" << std::endl;
						return 0;
					}
					total = 0;
				}
			}
		}
		
		//Check win condition
		for (int i = 0; i <= 2; i++) {
			for (int j = 0; j <= 2; j++) {
				total += gameGrid[j][i];
				if (j == 2) {
					if (total == 3){
						std::cout << "\n\nPlayer 1 Wins!!" << std::endl;
						return 0;
					}
					else if (total == -3) {
						std::cout << "\n\nPlayer 2 Wins!!" << std::endl;
						return 0;
					}
					total = 0;
				}
			}
		}
		
		//Check win condition
		total = gameGrid[0][0] + gameGrid[1][1] + gameGrid[2][2];
			if (total == 3){
				std::cout << "\n\nPlayer 1 Wins!!" << std::endl;
				return 0;
			}
			else if (total == -3) {
				std::cout << "\n\nPlayer 2 Wins!!" << std::endl;
				return 0;
			}
			total = 0;
			
		total = gameGrid[0][2] + gameGrid[1][1] + gameGrid[2][0];
			if (total == 3){
				std::cout << "\n\nPlayer 1 Wins!!" << std::endl;
				return 0;
			}
			else if (total == -3) {
				std::cout << "\n\nPlayer 2 Wins!!" << std::endl;
				return 0;
			}
			total = 0;
		
		//Change player
		(currentPlayer == 1) ? currentPlayer++:currentPlayer--;
		
		//Draw condition
		if (total_inputs == 9) {
			std::cout << "\n\nDRAW GAME" << std::endl;
			return 0;
		}
		
	}

} //end main()