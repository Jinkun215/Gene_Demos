/*



2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?


*/

#include <iostream>

int main() {

    int results = 0;
    bool notDivisible = true;

    
    for (int i = 2520; ;i++) {
    
        for (int j = 20; j > 1; j--) {
        
            if (i % j != 0) {
                notDivisible = true;
                break;
            }

        }
        
        if (notDivisible)
            notDivisible = false;
        else {
            results = i;
            break;
        }
    
    }

    std::cout << "Smallest = " << results << std::endl;
}
