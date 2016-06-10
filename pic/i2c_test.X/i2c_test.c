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
#include <i2c.h>  // Should work
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
    
    TRISC = 1;
    ADCON1 = 0x0f;
    TRISB0 = 1;
    TRISB1 = 1;
  

    // Example from datasheet, page 1123;
    unsigned char sync_mode, slew, add1;

    add1 = ( 0x70 << 1 ) & 0xfe; //address of the device (slave) under communication
    //CloseI2C(); //close i2c if was operating earlier
    
    //---INITIALISE THE I2C MODULE FOR MASTER MODE WITH 100KHz ---
    sync_mode = MASTER;
    slew = SLEW_OFF;
    OpenI2C(sync_mode,slew);
    SSPADD=0x09; //100kHz Baud clock(9) @4MHz
    I2C_SCL;
    //check for bus idle condition in multi master communication
    IdleI2C();

    StartI2C();
    IdleI2C();
    WriteI2C( add1 ) ; // call address
    IdleI2C();
    WriteI2C( 0x21 );
    IdleI2C();
    StopI2C();


    IdleI2C();

    StartI2C();
    IdleI2C();
    WriteI2C( add1 ) ; // call address
    IdleI2C();
    WriteI2C( 0x85 );
    IdleI2C();
    StopI2C();



    CloseI2C();
}