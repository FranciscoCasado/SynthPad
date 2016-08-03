#define USE_OR_MASKS
#include <p18f4550.h>
#include <xc.h> // Absolutely needed for XC8 compiler
#include <stdio.h>  // Are you working with printing messages?
#include <stdlib.h>  // Are you using any of the standard c library functions?
#include <ctype.h>  // Are you processing ASCII chars?
#include <math.h>  // Are you going to be using these relatively slow math functions?
#include <plib.h>

#define matrix0 ( 0x70 << 1 ) & 0xfe
#define matrix1 ( 0x71 << 1 ) & 0xfe

#define Blink_OFF 0x00
#define Blink_2Hz 0x01
#define Blink_1Hz 0x02
#define Blink_0Hz5 0x03

const char ledLUT[] =
    { 0x3A, 0x37, 0x35, 0x34,
      0x28, 0x29, 0x23, 0x24,
      0x16, 0x1B, 0x11, 0x10,
      0x0E, 0x0D, 0x0C, 0x02 };

const char buttonLUT[16] =
    { 0x07, 0x04, 0x02, 0x22,
      0x05, 0x06, 0x00, 0x01,
      0x03, 0x10, 0x30, 0x21,
      0x13, 0x12, 0x11, 0x31 };

unsigned char displaybuffer[];

void Init(void){
    TRISC = 1;
    ADCON1 = 0x0f;
    TRISB0 = 1;
    TRISB1 = 1;
}

void WriteI2CByte(unsigned char address, unsigned char data){
    IdleI2C();              // Wait for available bus
    StartI2C();             // Send Start condition
    IdleI2C();
    WriteI2C( address );    // Call address
    IdleI2C();
    WriteI2C( data );       // Send data Byte
    IdleI2C();
    StopI2C();              // Send Stop condition
}

void TurnMatrixOn(unsigned char address){
    WriteI2CByte( address, 0x21 );
}

void setBrightness(unsigned char address, unsigned char brightness){
    if (brightness > 15)
        brightness = 15;
    WriteI2CByte(address, 0xE0 | brightness);
}

void setBlinkRate(unsigned char address, unsigned char freq){
    if (freq > 3)
        freq = 0;
    WriteI2CByte(address, 0x81 | (freq << 1));
}

void setLED(unsigned char address, unsigned char k){
    if ( k > 15)
        return;
    else
        WriteI2CByte(address, 0xE0 );
}

/*
  [ok] void blinkRate(uint8_t b);
  [  ] boolean isLED(uint8_t x);
  [  ] void setLED(uint8_t x);
  [  ] void clrLED(uint8_t x);
  [  ] void writeDisplay(void);
  [  ] void clear(void);
 *
  [  ] bool isKeyPressed(uint8_t k);
  [  ] bool wasKeyPressed(uint8_t k);
  [  ] boolean readSwitches(void);
  [  ] boolean justPressed(uint8_t k);
  [  ] boolean justReleased(uint8_t k);
 */