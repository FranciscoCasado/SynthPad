#define USE_OR_MASKS
#include <p18f4550.h>
#include <xc.h> // Absolutely needed for XC8 compiler
#include <stdio.h>  // Are you working with printing messages?
#include <stdlib.h>  // Are you using any of the standard c library functions?
#include <ctype.h>  // Are you processing ASCII chars?
#include <math.h>  // Are you going to be using these relatively slow math functions?
#include <plib.h>

#define matrix0 ( 0x70 << 1 )
#define matrix1 ( 0x71 << 1 )

#define Blink_OFF 0x00
#define Blink_2Hz 0x01
#define Blink_1Hz 0x02
#define Blink_0Hz5 0x03

#define bit(x,n) (((x) >> (n)) & 1)

const char ledLUT[] =           // Translated from Adafruit lib
    { 0x72, 0x67, 0x65, 0x64,   // Don't mess with it... never!!!
      0x50, 0x51, 0x43, 0x44,
      0x26, 0x33, 0x21, 0x20,
      0x16, 0x15, 0x14, 0x02 };

unsigned char ledBuffer[] =
    { 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00 };

const char buttonLUT[] =
    { 0x07, 0x04, 0x02, 0x22,
      0x05, 0x06, 0x00, 0x01,
      0x03, 0x10, 0x30, 0x21,
      0x13, 0x12, 0x11, 0x31 };

unsigned char switches[] = {0x00, 0x00, 0x00, 0x00};
unsigned char switches_past[] = {0x00, 0x00, 0x00, 0x00};

unsigned char button_state[] = 
    { 0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0 };

void Init(void){
    TRISC = 1;
    ADCON1 = 0x0f;
    TRISB0 = 1;
    TRISB1 = 1;
    TRISD = 1;
}

void WriteI2CByte(unsigned char matrix, unsigned char data){
    IdleI2C();              // Wait for available bus
    StartI2C();             // Send Start condition
    IdleI2C();
    WriteI2C( matrix & 0xfe);    // Call address
    IdleI2C();
    WriteI2C( data );       // Send data Byte
    IdleI2C();
    StopI2C();              // Send Stop condition
}

void WriteI2CByteByte(unsigned char matrix, unsigned char data0, unsigned char data1){
    IdleI2C();              // Wait for available bus
    StartI2C();             // Send Start condition
    IdleI2C();
    WriteI2C( matrix & 0xfe);    // Call address
    IdleI2C();
    WriteI2C( data0 );       // Send data Byte
    IdleI2C();
    WriteI2C( data1 );       // Send data Byte
    IdleI2C();
    StopI2C();              // Send Stop condition
}

void ReadSwitches(unsigned char matrix){
    unsigned char byte0, byte1, byte2, byte3;
    IdleI2C();              // Wait for available bus
    StartI2C();             // Send Start condition
    IdleI2C();
    WriteI2C( matrix & 0xfe);  // Call address (Write)
    IdleI2C();
    WriteI2C( 0x40 );          // Send data Byte
    IdleI2C();
    StopI2C();              // Send Stop condition
    IdleI2C();
    StartI2C();             // Send Start condition
    WriteI2C( matrix | 0x01);  // Call address (Read)
    // All addresses are read:
    byte0 = ReadI2C();
    AckI2C();
    byte1 = ReadI2C();
    AckI2C();
    byte2 = ReadI2C();
    AckI2C();
    byte3 = ReadI2C();
    NotAckI2C(); //send the end of transmission signal through Nack
    StopI2C();              // Send Stop condition
    switches[0] = byte0;
    switches[1] = byte1;
    switches[2] = byte2;
    switches[3] = byte3;    
}

void TurnMatrixOn(unsigned char matrix){
    WriteI2CByte( matrix, 0x21 );
}

void setBrightness(unsigned char matrix, unsigned char brightness){
    if (brightness > 15)
        brightness = 15;
    WriteI2CByte(matrix, 0xE0 | brightness);
}

void setBlinkRate(unsigned char matrix, unsigned char freq){
    if (freq > 3)
        freq = 0;
    WriteI2CByte(matrix, 0x81 | (freq << 1));
}

void setLED(unsigned char matrix, unsigned char k){
    if ( k > 15)
        return;
    else{
        unsigned char x = (ledLUT[k]&0xF0) >> 4;
        ledBuffer[x] |= 0x01 << (ledLUT[k] & 0x0F);
    }
}

void clrLED(unsigned char matrix, unsigned char k){
    if ( k > 15)
        return;
    else{
        unsigned char x = (ledLUT[k]&0xF0) >> 4;
        ledBuffer[x] &= 0xfe << (ledLUT[k] & 0x0F);
    }
}

void display(unsigned char matrix){
    for(int k = 0; k < 8 ; k++ ){
        WriteI2CByteByte(matrix, k & 0xff, (ledBuffer[k] & 0x0F));
    }
}

void blackOut(unsigned char matrix){
    WriteI2CByteByte(matrix,0x00,0x00);
    WriteI2CByteByte(matrix,0x01,0x00);
    WriteI2CByteByte(matrix,0x02,0x00);
    WriteI2CByteByte(matrix,0x03,0x00);
    WriteI2CByteByte(matrix,0x04,0x00);
    WriteI2CByteByte(matrix,0x05,0x00);
    WriteI2CByteByte(matrix,0x06,0x00);
    WriteI2CByteByte(matrix,0x07,0x00);
}

void sunnyDay(unsigned char matrix){
    WriteI2CByteByte(matrix,0x00,0xFF);
    WriteI2CByteByte(matrix,0x01,0xFF);
    WriteI2CByteByte(matrix,0x02,0xFF);
    WriteI2CByteByte(matrix,0x03,0xFF);
    WriteI2CByteByte(matrix,0x04,0xFF);
    WriteI2CByteByte(matrix,0x05,0xFF);
    WriteI2CByteByte(matrix,0x06,0xFF);
    WriteI2CByteByte(matrix,0x07,0xFF);

}

void delay(void){
     int i, j;
     for(i=0;i<5000;i++){
         for(j=0;j<1;j++){
         }
     }         
}


/*
  [ok] void blinkRate(uint8_t b);
  [  ] boolean isLED(uint8_t x);
  [  ] void setLED(uint8_t x);
  [  ] void clrLED(uint8_t x);
  [  ] void writeDisplay(void);
  [  ] void clear(void);
 *
  [  ] boolean isKeyPressed(uint8_t k);
  [  ] boolean wasKeyPressed(uint8_t k);
  [  ] boolean readSwitches(void);
  [  ] boolean justPressed(uint8_t k);
  [  ] boolean justReleased(uint8_t k);
 */