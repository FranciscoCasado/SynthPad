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

    // Start matrices
    TurnMatrixOn( matrix0 );
    TurnMatrixOn( matrix1 );
    setBlinkRate( matrix0, Blink_OFF );
    setBlinkRate( matrix1, Blink_OFF );
    setBrightness( matrix0, 10 );
    setBrightness( matrix1, 10 );
    CloseI2C();
    
}

