/* Second Exercise Set 4 microprocessors
 * Created: 23/5/2020 5:30:14
 * Author: Team65 (03117711,03117715,03117070)
 * A program that makes the following two logical functions:
 * F0 = (AB' + BC'D)'
 * F1 = (A + C)(B + D)
 * and prints the output to the 2 LSBs of PORTA
 * the inputs A,B,C,D are read from the PORTB(0-3).
 
 * -------------------------------------
 * OUTPUT With A = 1,B = 0,C = 1,D = 1
 * F0 = 0 (shown in BIT0 of PortA)
 * F1 = 1 (shown in BIT1 of PortA)
 * -------------------------------------
 
 * -------------------------------------
 * OUTPUT With A = 0,B = 0,C = 0,D = 0
 * F0 = 1 (shown in BIT0 of PortA)
 * F1 = 0 (shown in BIT1 of PortA)
 * -------------------------------------
 
 * -------------------------------------
 * OUTPUT With A = 0,B = 1,C = 1,D = 0
 * F0 = 1 (shown in BIT0 of PortA)
 * F1 = 1 (shown in BIT1 of PortA)
 * -------------------------------------
 */

#include <avr/io.h>
char A,B,C,D,F0,F1;

int main(void) {
    DDRA = 0xFF;							//A as output
    DDRB = 0x00;							//B as input 

    while (1) {
        A = PINB & 0x01;					//A is the first bit of PINB
        B = PINB & 0x02;					//B is the second bit of PINB
        B = B >> 1;							//Right shift B, so its on bit0 as B
        C = PINB & 0x04;					//C is the third bit of PINB
        C = C >> 2;							//Right shift C, so its on bit0 as C
        D = PINB & 0x08;					//D is the fourth bit of PINB
        D = D >> 3;							//Right shift D, so its on bit0 as D
        F0 = !((A & (!B))|(B & (!C) & D));	//Definition of F0 and F1, using not operator(!),
        F1 = ((A | C) & (B | D));			//bitwise or(|), and bitwise and(&)
        F1 = F1 << 1;						//Left shift F1 so as the answer is on bit1
        PORTA = F0 + F1;					//Add both results to PORTA(F0+F1), to print the output
    }
}