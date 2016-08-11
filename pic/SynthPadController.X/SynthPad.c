/* 
 * File:   i2c_test.c
 * Author: SynthPad Development Team
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

    // Initialize by setting all registers needed
    Init();
    
    unsigned char state = state_both;
    unsigned int counter_clone = 0;
    unsigned int counter_both = 0;
    while(1){
        
        // Check Switches
        checkSwitches();
        updateSwitches(matrix0);
        updateSwitches(matrix1);
        
        // Do Something        
        
        if( state == state_both ){
            displayBoth();
            if (button_state[16] == 1 & button_state_past[16] == 1){
                counter_clone++;
            }
            else{
                counter_clone = 0;
            }
            if (counter_clone == 30){
                OpenI2C(MASTER,SLEW_OFF);
                sunnyDay(matrix1);
                delay(10000);
                blackOut(matrix1);
                CloseI2C();
                counter_clone = 0;
                state = state_clone1;
            }
        }
        else if( state == state_clone1 ){
            clone1to0();
            if (button_state[0] == 1 & button_state_past[0] == 1){
                counter_both++;
            }
            else{
                counter_both = 0;
            }
            if (counter_both == 30){
                OpenI2C(MASTER,SLEW_OFF);
                sunnyDay(matrix0);
                delay(10000);
                blackOut(matrix0);
                CloseI2C();
                counter_both = 0;
                state = state_both;
            }
        }
                
        // One of the most important instructions
        delay(1000);    // Do not remove!!
        }
                      
}