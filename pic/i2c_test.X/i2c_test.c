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
    TRISBbits.RB0 = 0;
    TRISBbits.RB1 = 0;
    PORTBbits.RB0 = 1;
    PORTBbits.RB1 = 1;

    LATCbits.LATC0 = 1;

    // Example from datasheet, page 1123;
    unsigned char sync_mode=0, slew=0, add1,w,data,status,length;
    for(w=0;w<20;w++)
        I2C_Recv[w]=0;
    
    add1 = 0x70 << 1; //address of the device (slave) under communication
    CloseI2C(); //close i2c if was operating earlier
    
    //---INITIALISE THE I2C MODULE FOR MASTER MODE WITH 100KHz ---
    sync_mode = MASTER;
    slew = SLEW_OFF;
    
    OpenI2C(sync_mode,slew);
    SSPADD=0x09; //100kHz Baud clock(9) @8MHz
    //check for bus idle condition in multi master communication
    IdleI2C();
    //---START I2C---
    StartI2C();
    //****write the address of the device for communication***
    data = SSPBUF; //read any previous stored content in buffer to clear buffer full status
    
    do{
        status = WriteI2C( add1 ); //write the address of slave
        if(status == -1){ //check if bus collision happened
            data = SSPBUF; //upon bus collision detection clear the buffer,
            SSPCON1bits.WCOL=0; // clear the bus collision status bit
        }
    }
    while(status!=0); //write untill successful communication
    //R/W BIT IS '0' FOR FURTHER WRITE TO SLAVE
    //***WRITE THE THE DATA TO BE SENT FOR SLAVE***
    while(putsI2C(I2C_Send)!=0); //write string of data to be transmitted to slave
    //---TERMINATE COMMUNICATION FROM MASTER SIDE---
    IdleI2C();
  
}