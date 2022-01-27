/*

Gene Drumheller

Problem 003



The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

*/


#include <iostream>
#include <vector>


int main() {

    unsigned long GIVEN_NUMBER = 600851475143;
    std::vector<unsigned long> factorStorage;
    std::vector<unsigned long> primeStorage;
    bool nonprime = false;
    
    
    //ESSENTIAL the i * i < GIVEN_NUMBER part GREATLY speeds up the process
    //because when N = a * b, it's also N = b * a.  So you only need to find the halfway point,
    //also known as the square root of N.
    
    
    for (int i = 2; i < (GIVEN_NUMBER/2)+1 && i * i < GIVEN_NUMBER; i++)
            if (GIVEN_NUMBER % i == 0) {
                factorStorage.push_back(i);
               // if (GIVEN_NUMBER/i != i)
                //    factorStorage.push_back(i);
            }
    
    
    /*     UNCOMMENT TO SEE FACTOR VALUES
    for (auto it = factorStorage.begin(); it != factorStorage.end(); it++)
        std::cout << "Factor = " << *it << std::endl;
      
    */
    
    
    for (auto it = factorStorage.begin(); it != factorStorage.end(); it++) {
    
        for (int j = 2; j < (*it/2)+1; j++)  {
        
            if (*it % j == 0 || *it % 2 == 0) {
                nonprime = true;
                break; //not prime
                
            }
  
           
            
        }
    
        if (nonprime == true)
            nonprime = false; //reset flag
        else {
            primeStorage.push_back(*it);
            nonprime = false; //reset flag
        }
            
            
        
    }
    
    for (auto it = primeStorage.begin(); it != primeStorage.end(); it++)
        std::cout << "Prime = " << *it << std::endl;


    return 0;
}

//Finding prime isn't the issue, it's finding factors


