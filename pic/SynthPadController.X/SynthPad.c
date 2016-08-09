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
    
    
    while(1){
        // Matrices communication        
        
        for(int i = 0; i < 4; i++){
            switches_past[i] = switches[i];
        }
        ReadSwitches(matrix1);
        for(int i = 0; i < 16 ; i++){
            char x = ( buttonLUT[i] >> 4 ) & 0x0f;
            char y = ( buttonLUT[i] & 0x0f );
            char b0 = bit(switches_past[x],y);
            char b1 = bit(switches[x],y);
            if( b1 != b0 ){
                button_state[i] = ~button_state[i];
                if( button_state[i] == 0xff){
                    setLED(matrix0,i);
                    // insert send command for UART
                    
                } else {
                    clrLED(matrix0,i);
                }
            }
        }
        display(matrix0);
        display(matrix1);
        delay(1000);    // Do not remove!!
              
    }
    
}

