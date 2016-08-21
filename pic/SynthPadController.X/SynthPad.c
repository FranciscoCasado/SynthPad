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
    unsigned int counter_wave_select = 0;
    unsigned char config=0,spbrg=0,baudconfig=0,i=0;
    while(1){
        
        // Check Switches
        checkSwitches();
        updateSwitches(matrix1);
        updateSwitches(matrix0);
        
        // Do Something 
        
        if( state == state_both ){
            displayBoth();
            // State change
            if (isPressed[16] == 1){
                counter_clone++;
            }
            else{
                counter_clone = 0;
            }
            if (counter_clone == 30){
                sunnyDay(matrix1);
                delay(10000);
                blackOut(matrix1);
                counter_clone = 0;

                WriteMIDICommand(0xC0,0x01,0x00);
                state = state_wave_select;
            }
            // Do something
            /*
            if (button_state[2] == 1 & button_state_past[2] == 0){
                WriteMIDICommand(0x90,0x47,0x48);
            }
            else if (button_state[2] == 0 & button_state_past[2] == 1){
                WriteMIDICommand(0x80,0x47,0x48);
            }
             */
        }
        else if( state == state_clone1 ){
            clone1to0();
            if (isPressed[0] == 1){
                counter_both++;
            }
            else{
                counter_both = 0;
            }
            if (counter_both == 30){
                sunnyDay(matrix0);
                delay(10000);
                blackOut(matrix0);
                counter_both = 0;
                state = state_both;
            }

        }
        else if ( state == state_wave_select ){
            if (justPressed[16] == 1) { //Saw
                WriteMIDICommand( 0xC0, 0x02, 0x00);
                setDisplaySaw();
                counter_wave_select = 0;
            }
            else if (justPressed[17] == 1){ //Tri
                WriteMIDICommand( 0xC0, 0x01, 0x00);
                setDisplayTri();
                counter_wave_select = 0;
            }
            else if (justPressed[18] == 1){
                WriteMIDICommand( 0xC0, 0x03, 0x00);
                setDisplaySine();
                counter_wave_select = 0;
            }
            else if (justPressed[19] == 1){
                WriteMIDICommand( 0xC0, 0x00, 0x00);
                setDisplaySquare();
                counter_wave_select = 0;
            }
            // TimeOut
            if (counter_wave_select == 200){
                clrDisplayBuffer();
                counter_wave_select = 0;
                state = state_both;
            }
            counter_wave_select++;
            displayBoth();
        }
                
        // One of the most important instructions
        delay(1000);    // Do not remove!!
        }
                      
}