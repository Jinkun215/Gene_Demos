/*

A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,

a2 + b2 = c2
For example, 32 + 42 = 9 + 16 = 25 = 52.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.

*/

#include <iostream>

int main() {

	unsigned SEEKING_SUM = 1000;
	
	unsigned actual_sum = 0;
	unsigned triplet_A = 3;
	unsigned triplet_B = 4;
	unsigned triplet_C = 5;

	while ((triplet_A + triplet_B + triplet_C != SEEKING_SUM) || ((triplet_A * triplet_A) + (triplet_B * triplet_B) != (triplet_C * triplet_C))) {
		
		triplet_C++; 
		
		if (triplet_C == SEEKING_SUM-1) {
			triplet_C = 5;
			
			
			triplet_B++;
			
			if (triplet_B == SEEKING_SUM-1) {
				triplet_B = 4;
				
				
				triplet_A++;				
				
			}
			
		}
			

		
	}
	
	std::cout << triplet_A << " " << triplet_B << " " << triplet_C << std::endl;
	std::cout << "Product = " << triplet_A * triplet_B * triplet_C << std::endl;

	return 0;
}

	//Answer 31875000


