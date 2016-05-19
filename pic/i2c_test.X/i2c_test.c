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
#include <float.h>  // This should not be needed unless you are manually controlling floats/doubles
#include <math.h>  // Are you going to be using these relatively slow math functions?
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

unsigned char I2C_Send[21] = "MICROCHIP:I2C_MASTER";
unsigned char I2C_Recv[21];

void main(void){
    
    TRISCbits.RC0 = 0;

    LATCbits.LATC0 = 1;

    unsigned char sync_mode = 0, slew = 1, slave_address, w, data, status, length;

    for( w=0; w<20; w++)
        I2C_Recv[w] = 0;

    slave_address = 0x70 << 1;    // Address of the slave device under communication
    data = 0x3A;

    //CloseI2C();

    // Initialize I2C module for master mode @100kHz
    sync_mode = MASTER;
    slew = SLEW_OFF;

    OpenI2C(sync_mode, slew);

    SSPADD = 0x09;      // set baudrate at 100kHz
    while(1){
        // Check for bus idle condition
        IdleI2C();

        // Start I2C
        StartI2C();
        IdleI2C();                         // Wait for the end of the START condition
        WriteI2C( slave_address & 0xfe );  // Send address with R/W cleared for write
        IdleI2C();                         // Wait for ACK
        WriteI2C( data & 0xff );                  // Write first byte of data
        IdleI2C();                         // Wait for ACK
        StopI2C();                         // Hang up, send STOP condition

        LATCbits.LATC0 = !LATCbits.LATC0 ;
    }
}