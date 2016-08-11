#define USE_OR_MASKS
#include <p18f4550.h>
#include <xc.h> // Absolutely needed for XC8 compiler
#include <stdio.h>  // Are you working with printing messages?
#include <stdlib.h>  // Are you using any of the standard c library functions?
#include <ctype.h>  // Are you processing ASCII chars?
#include <math.h>  // Are you going to be using these relatively slow math functions?
#include <plib.h>

/* Global definitions */

#define matrix0 ( 0x70 << 1 )
#define matrix1 ( 0x71 << 1 )

#define bit(x,n) (((x) >> (n)) & 1)

#define state_both   0x00
#define state_clone1 0x01


const char CONFIG = USART_TX_INT_OFF | USART_RX_INT_OFF | USART_ASYNCH_MODE | USART_EIGHT_BIT | USART_CONT_RX | USART_BRGH_LOW;
const char BAUD_CONFIG = BAUD_8_BIT_RATE | BAUD_AUTO_OFF;

const char ledLUT[] =           // Translated from Adafruit lib
    { 0x72, 0x67, 0x65, 0x64,   // Don't mess with it... never!!!
      0x50, 0x51, 0x43, 0x44,
      0x26, 0x33, 0x21, 0x20,
      0x16, 0x15, 0x14, 0x02 };

const char buttonLUT[] =
    { 0x07, 0x04, 0x02, 0x22,
      0x05, 0x06, 0x00, 0x01,
      0x03, 0x10, 0x30, 0x21,
      0x13, 0x12, 0x11, 0x31 };

/* Global methods */

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

void WriteMIDICommand(unsigned char data0, unsigned char data1, unsigned char data2){
    OpenUSART(CONFIG, 1); //API configures USART for desired parameters
    while(BusyUSART()); //Check if Usart is busy or not
    WriteUSART(data0); //transmit the string
    while(BusyUSART()); //Check if Usart is busy or not
    WriteUSART(data1); //transmit the string
    while(BusyUSART()); //Check if Usart is busy or not
    WriteUSART(data2); //transmit the string
    while(BusyUSART()); //Check if Usart is busy or not
    CloseUSART();
}

void TurnMatrixOn(unsigned char matrix){
    OpenI2C(MASTER,SLEW_OFF);
    WriteI2CByte( matrix, 0x21 );
    CloseI2C();
}

void delay(int k){
     for( int i = 0 ; i < k ; i++ ){
     }         
}

/* Display */

#define Blink_OFF 0x00
#define Blink_2Hz 0x01
#define Blink_1Hz 0x02
#define Blink_0Hz5 0x03

unsigned char displayBuffer[] =
    { 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
    
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00 };


void setBrightness(unsigned char matrix, unsigned char brightness){
    if (brightness > 15)
        brightness = 15;
    OpenI2C(MASTER,SLEW_OFF);
    WriteI2CByte(matrix, 0xE0 | brightness);
    CloseI2C();
}

void setBlinkRate(unsigned char matrix, unsigned char freq){
    if (freq > 3)
        freq = 0;
    OpenI2C(MASTER,SLEW_OFF);
    WriteI2CByte(matrix, 0x81 | (freq << 1));
    CloseI2C();
}

void setLED(unsigned char matrix, unsigned char k){
    if ( k > 15)
        return;
    else{
        unsigned char x;
        if (matrix == matrix0 ){
            x = (ledLUT[k]&0xF0) >> 4;
        }
        else{
            x = ((ledLUT[k]&0xF0) >> 4) + 8;
        }
        displayBuffer[x] |= 0x01 << (ledLUT[k] & 0x0F);
        displayBuffer[x] |= 0x01 << (ledLUT[k] & 0x0F);
    }
}

void clrLED(unsigned char matrix, unsigned char k){
    if ( k > 15)
        return;
    else{
        unsigned char x;
        if (matrix == matrix0 ){
            x = (ledLUT[k]&0xF0) >> 4;
        }
        else{
            x = ((ledLUT[k]&0xF0) >> 4) + 8;        
        }
        displayBuffer[x] &= 0xfe << (ledLUT[k] & 0x0F);
        displayBuffer[x] &= 0xfe << (ledLUT[k] & 0x0F);
    }
}

void displayBoth(void){
    OpenI2C(MASTER, SLEW_OFF);
    for(char k = 0; k < 8 ; k++ ){
        WriteI2CByteByte(matrix0, k & 0xff, displayBuffer[k]);
        WriteI2CByteByte(matrix1, k & 0xff, displayBuffer[k+8]);
    }
    CloseI2C();
}

void clone1to0(void){
    OpenI2C(MASTER, SLEW_OFF);
    for(char k = 0; k < 8 ; k++ ){
        WriteI2CByteByte(matrix0, k & 0xff, displayBuffer[k+8]);
        WriteI2CByteByte(matrix1, k & 0xff, displayBuffer[k+8]);
    }
    CloseI2C();
    
}

void clone0to1(void){
    OpenI2C(MASTER, SLEW_OFF);
    for(char k = 0; k < 8 ; k++ ){
        WriteI2CByteByte(matrix0, k & 0xff, displayBuffer[k]);
        WriteI2CByteByte(matrix1, k & 0xff, displayBuffer[k]);
    }
    CloseI2C();
    
}

void blackOut(unsigned char matrix){
    OpenI2C(MASTER,SLEW_OFF);
    WriteI2CByteByte(matrix,0x00,0x00);
    WriteI2CByteByte(matrix,0x01,0x00);
    WriteI2CByteByte(matrix,0x02,0x00);
    WriteI2CByteByte(matrix,0x03,0x00);
    WriteI2CByteByte(matrix,0x04,0x00);
    WriteI2CByteByte(matrix,0x05,0x00);
    WriteI2CByteByte(matrix,0x06,0x00);
    WriteI2CByteByte(matrix,0x07,0x00);
    CloseI2C();
}

void sunnyDay(unsigned char matrix){
    OpenI2C(MASTER,SLEW_OFF);
    WriteI2CByteByte(matrix,0x00,0xFF);
    WriteI2CByteByte(matrix,0x01,0xFF);
    WriteI2CByteByte(matrix,0x02,0xFF);
    WriteI2CByteByte(matrix,0x03,0xFF);
    WriteI2CByteByte(matrix,0x04,0xFF);
    WriteI2CByteByte(matrix,0x05,0xFF);
    WriteI2CByteByte(matrix,0x06,0xFF);
    WriteI2CByteByte(matrix,0x07,0xFF);
    CloseI2C();
}


/* KeyScan*/


unsigned char switches[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
unsigned char switches_past[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

unsigned char button_state[] = 
    { 0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0 };

unsigned char button_state_past[] = 
    { 0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0 };

void ReadMatrix(unsigned char matrix){
    unsigned char byte0, byte1, byte2, byte3;
    OpenI2C(MASTER,SLEW_OFF);
    WriteI2CByte(matrix, 0x40);
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
    CloseI2C();
    if (matrix == matrix0 ){
        switches[0] = byte0;
        switches[1] = byte1;
        switches[2] = byte2;
        switches[3] = byte3;
    }
    else {
        switches[4] = byte0;
        switches[5] = byte1;
        switches[6] = byte2;
        switches[7] = byte3;
    }
    
}
void checkSwitches(void){     
    // Save previous state    
    for(int i = 0; i < 8; i++){
            switches_past[i] = switches[i];
    }
    // Read current state
    ReadMatrix(matrix0);
    ReadMatrix(matrix1);
}

void updateSwitches(unsigned char matrix){
    unsigned char offset_switch;
    unsigned char offset_state;
    if(matrix == matrix0){
        offset_switch = 0;
        offset_state = 0;
    }
    else{
        offset_switch = 4;
        offset_state = 16;
    }
    for(int i = 0; i < 16 ; i++){
        button_state_past[i+offset_state] = button_state[i+offset_state];
        // aux variables
        char x = ( buttonLUT[i] >> 4 ) & 0x0f;
        char y = ( buttonLUT[i] & 0x0f );
        // more aux variables
        char b0 = bit(switches_past[x + offset_switch],y);
        char b1 = bit(switches[x + offset_switch],y);
        
        if ( b0 == 0 & b1 == 1){
            button_state[i+offset_state] = 1;
            setLED(matrix,i);
        }
        else if ( b0 == 1 & b1 == 0 ){
            button_state[i+offset_state] = 0;
            clrLED(matrix,i);
        }
    }
}

void Init(void){
    /* Configure I2C*/
    TRISC = 1;
    ADCON1 = 0x0f;
    TRISB0 = 1;
    TRISB1 = 1;
    TRISD = 1;
    SSPADD=0x09; //100kHz Baud clock(9) @4MHz

    /* Configure U(S)ART*/
    baudUSART (BAUD_CONFIG);

    /* Set Matrices */
    // Turn all LEDs off
    blackOut(matrix0);
    blackOut(matrix1);
    // Start matrices
    TurnMatrixOn( matrix0 );
    TurnMatrixOn( matrix1 );
    setBlinkRate( matrix0, Blink_OFF );
    setBlinkRate( matrix1, Blink_OFF );
    setBrightness( matrix0, 12 );
    setBrightness( matrix1, 4 );
}


/*
  [ok] void blinkRate(uint8_t b);
  [  ] boolean isLED(uint8_t x);
  [ok] void setLED(uint8_t x);
  [ok] void clrLED(uint8_t x);
  [ok] void writeDisplay(void);
  [ok] void clear(void);
 *
  [  ] boolean isKeyPressed(uint8_t k);
  [  ] boolean wasKeyPressed(uint8_t k);
  [  ] boolean readSwitches(void);
  [  ] boolean justPressed(uint8_t k);
  [  ] boolean justReleased(uint8_t k);
 */