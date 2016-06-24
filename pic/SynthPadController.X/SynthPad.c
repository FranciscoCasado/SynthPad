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
#pragma config FCMEN = OFF                                 // OR this way
#pragma config BORV = 3
#pragma config WDT = OFF
#pragma config CPB = OFF
#pragma config CPD = OFF

void main(void){

    // Initialize by setting al registers needed
    initialize();
    
    unsigned char sync_mode, slew, add0, add1;

    add0 = ( 0x70 << 1 ) & 0xfe; //address of the device (slave) under communication
    add1 = ( 0x71 << 1 ) & 0xfe; //address of the device (slave) under communication
    //---INITIALISE THE I2C MODULE FOR MASTER MODE WITH 100KHz ---
    sync_mode = MASTER;
    slew = SLEW_OFF;
    
    OpenI2C(sync_mode,slew);
    SSPADD=0x09; //100kHz Baud clock(9) @4MHz
    TurnMatrixOn( add0 );
    TurnMatrixOn( add1 );
    setBlinkRate( add0, Blink_OFF );
    setBlinkRate( add1, Blink_OFF );
    setBrightness( add0, 10 );
    setBrightness( add1, 10 );
    CloseI2C();
    
}

