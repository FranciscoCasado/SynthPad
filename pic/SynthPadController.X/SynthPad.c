/* 
 * File:   i2c_test.c
 * Author: PC4-Electronica
 *
 * Created on 18 de mayo de 2016, 06:58 PM
 */
#define USE_OR_MASKS
#include <p18f4550.h>
#include <xc.h> // Absolutely needed for XC8 compiler
#include <stdio.h>  // Are you working with printing messages?
#include <stdlib.h>  // Are you using any of the standard c library functions?
#include <ctype.h>  // Are you processing ASCII chars?
#include <math.h>  // Are you going to be using these relatively slow math functions?
#include <plib.h>
#include "synthpad.h"

/*
 * 
 */
#pragma config FOSC = XT_XT
#pragma config FCMEN = OFF
#pragma config BORV = 3
#pragma config WDT = OFF
#pragma config CPB = OFF
#pragma config CPD = OFF

void main(void){

    // Initialize by setting al registers needed
    Init();
    OpenI2C(MASTER,SLEW_OFF);
    SSPADD=0x09; //100kHz Baud clock(9) @4MHz

    // Turn all LEDs off
    blackOut(matrix0);
    blackOut(matrix1);

    
    // Start matrices
    TurnMatrixOn( matrix0 );
    TurnMatrixOn( matrix1 );
    setBlinkRate( matrix0, Blink_OFF );
    setBlinkRate( matrix1, Blink_OFF );
    setBrightness( matrix0, 12 );
    setBrightness( matrix1, 4 );
    
    CloseI2C();

    PORTD = 255;
    delay();
    PORTD = 0;
    delay();
    PORTD = 255;
    delay();
    PORTD = 0;          
    OpenI2C(MASTER,SLEW_OFF);
    while(1){
        // Matrices communication
        //setLED(matrix0,i);
        
        PORTD = 0x80;
        for(int i = 0; i < 4; i++){
            switches_past[i] = switches[i];
        }
        PORTD = 0x40;
        ReadSwitches(matrix1);
        PORTD = 0x20;
        for(int i = 0; i < 16 ; i++){
            char x = ( buttonLUT[i] >> 4 ) & 0x0f;
            char y = ( buttonLUT[i] & 0x0f );
            char b0 = bit(switches_past[x],y);
            char b1 = bit(switches[x],y);
            if( b1 != b0 ){
                button_state[i] = ~button_state[i];
            }
            if( button_state[i] == 0xff){
                setLED(matrix0,i);
            } else {
                clrLED(matrix0,i);
            }
        }
        display(matrix0);
        delay();
              
    }
    CloseI2C();
    
}
