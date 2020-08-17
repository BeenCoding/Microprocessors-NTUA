/* Third Exercise Set 4 microprocessors
 * Created: 23/5/2020 6:25:11
 * Author: Team65 (03117711,03117715,03117070)
 * A program that makes some operations when SW0-3 are pressed.
 * SW0 - SW3 are read from PINA
 * SW0: right cyclic move
 * SW1: left cyclic move
 * SW2: move the ON led to LSB
 * SW3: move the ON led to MSB
 */

#include <avr/io.h>

int main(void)
{
    // Init PORTB as output
    DDRB = 0xFF;
    // Init PORTA as input
    DDRA = 0x00;
    //Init PORTB to 1, so as the led0 of portb is turned on.
    PORTB = 0x01;
    while (1) {
        //If SW0 is on then make cyclic move(right)
        if ((PINA & 0x01) == 1) {
            //while SW0 is pressed do nothing.
            while ((PINA & 0x01) == 1);
            //if PORTB is equal to 1 then turn on the Led7 else do right shift
            (PORTB == 1) ? (PORTB = 128) : (PORTB = PORTB >> 1);
        }
        //If SW1 is on then make cyclic move(left)
        if ((PINA & 0x02) == 2) {
            //while SW1 is pressed do nothing.
            while ((PINA & 0x02) == 2);
            //if PORTB is equal to 128 then turn on the Led0 else do left shift
            (PORTB == 128) ? (PORTB = 1) : (PORTB = PORTB << 1);
        }
        //If SW2 is on then turn on LSB Led (led0)
        if ((PINA & 0x04) == 4) {
            //while SW2 is pressed do nothing.
            while ((PINA & 0x04)== 4);
            //make PORTB equal to 1, so as led0 is turned on
            PORTB = 0x01;
        }
        //If SW3 is on then turn on MSB Led (led7)
        if ((PINA & 0x08) == 8) {
            //while SW3 is pressed do nothing.
            while ((PINA & 0x08) == 8);
            //make PORTB equal to 128(0x80), so as led7 is turned on
            PORTB = 0x80;
        }
    }
}
