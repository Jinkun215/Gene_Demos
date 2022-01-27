/*



By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

What is the 10 001st prime number?


*/


#include <iostream>


int main() {
    
    int MAX = 10001;
    int count = 4;
    int currentPrime = 7;
    bool notPrime = false;
    
    
    for (int i = 8; count < MAX; i++) {
    
        for (int j = 3; j < i; j++) {
        
            if (i % j == 0) {
                notPrime = true;
                break;
            }
        
        }
        
        if (notPrime) {
            notPrime = false;
        }
        else {
            count++;
            currentPrime = i;
            notPrime = false;     
            std::cout << count << " : " << currentPrime << std::endl;   
        }
        
        
    
    }
    

    



    return 0;
}


// ANSWER = 104743








