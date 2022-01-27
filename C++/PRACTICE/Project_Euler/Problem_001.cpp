/*

Gene Drumheller

Problem 001

If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.


*/


#include <iostream>

int main() {

    const int MAX = 1000;
    int multOfThree = 3;
    int multOfFive = 5;

    int sum = 0;

    for (int i = 1; multOfFive * i < MAX; i++) {
        sum += multOfFive * i;
    }

    for (int i = 1; multOfThree * i < MAX; i++) {  
        
        if ((multOfThree * i) % 5 != 0)
            sum += multOfThree * i;
    }
    

    std::cout << "Sum = " << sum << std::endl;
        
    return 0; 

}






