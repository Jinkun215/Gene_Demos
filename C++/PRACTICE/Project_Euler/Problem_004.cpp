/*


A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.

*/


#include <iostream>
#include <string>


int main() {

    const int MAX = 1000;
    int result = 0;
    int largest = 0;
    
    std::string intStringed;
    bool notPali = true;
    bool firstCopy = false;
    
    for (int i = 1; i < MAX; i++) {
    
    
        for (int j = 1; j < MAX; j++) {
        
            result = i * j;
            intStringed = std::to_string(result);
            
            for (auto it = intStringed.begin(), jt = intStringed.end()-1; it != intStringed.end(), jt != intStringed.begin(); it++, jt--) {
                
                if (*it != *jt) {
                    notPali = true;
                    break;
                }
            
            }
            
            if (notPali)
                notPali = false;
            else {
                if (result > largest)
                    largest = result;
                    
                notPali = false;
            }
        
        }
    }
    
    std::cout << "Largest = " << largest << std::endl;

    return 0;
}


