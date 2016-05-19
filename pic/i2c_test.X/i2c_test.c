/* 
 * File:   i2c_test.c
 * Author: PC4-Electronica
 *
 * Created on 18 de mayo de 2016, 06:58 PM
 */
#define USE_OR_MASKS
#include <p18f4550.h>
#include "i2c.h"
/*
 * 
 */

unsigned char I2C_Send[21] = "MICROCHIP:I2C_MASTER";
unsigned char I2C_Recv[21];

void main(void){
    unsigned char sync_mode = 0, slew = 1, slave_address, w, data, status, length;

    for( w=0; w<20; w++)
        I2C_Recv[w] = 0;

    slave_address = 0x70 << 1;    // Address of the slave device under communication
    data = 0x3A;

    CloseI2C();

    // Initialise I2C module for master mode @100kHz
    sync_mode = MASTER;
    slew = SLEW_OFF;

    OpenI2C(sync_mode, slew);

    SSPADD = 0x09;      // set baudrate at 100kHz

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

}

/* try #1
char sync_mode = MASTER;
unsigned char slew = SLEW_ON;


void OpenI2C (sync_mode, slew);

IdleI2C();                         // Wait until the bus is idle
StartI2C();                        // Send START condition
IdleI2C();                         // Wait for the end of the START condition
WriteI2C( slave_address & 0xfe );  // Send address with R/W cleared for write
IdleI2C();                         // Wait for ACK
WriteI2C( data[0] );               // Write first byte of data
IdleI2C();                         // Wait for ACK
// ...
WriteI2C( data[n] );               // Write nth byte of data
IdleI2C();                         // Wait for ACK
StopI2C();                         // Hang up, send STOP condition
 */