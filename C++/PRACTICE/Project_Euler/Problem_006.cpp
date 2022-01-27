/*
The sum of the squares of the first ten natural numbers is,

    1^2 + 2^2 + ... + 10^2 = 385

The square of the sum of the first ten natural numbers is,

    (1 + 2 + ... + 10)^2 = 55^2 = 3025

Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is

.   3025 - 385 = 2640

Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.





*/


#include <iostream>

int main() {

    unsigned long sumSquared = 0;
    unsigned long squaredSum = 0;
    int MAX = 100;
    
    for (int i = 1; i <= 100; i++) {
    
        squaredSum += i * i;
        sumSquared += i;  
    
    
    }
    sumSquared = sumSquared * sumSquared;
    
    std::cout << "Result = " << sumSquared - squaredSum << std::endl;

    return 0;
}



















