#include <iostream>
#include <cmath>
using namespace std;

#DEFINE BITS 8

int main(){
	
	int counterZeros=0,n;
	
	for (int j = 0; j < 256; j ++){
		n = j;
		int binary[BITS];
		
		for (int k = 0; k<BITS; k++)
			binary[k] = 0;
			
		for(int i=0; n>0; i++) 
		{    
			binary[i] = n%2;    
			n = n/2;
		}
		
		for(int l = 0 ; l < BITS ; l ++)
			if(binary[l] == 0) counterZeros++;
		
	}
	cout<< "HERE IS THE RESULT "<<counterZeros<<endl;
}




