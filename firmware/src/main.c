/*
 * File:   main.c
 * Author: Marcos Bernard Calixto López
 * Project: DomoNode - Iteration 02: UART Validation
 */

#include <xc.h>

// --- CONFIGURACIÓN DE FUSES (Indispensable para que el compilador sepa el target) ---
#pragma config FOSC = INTOSC, WDTE = OFF, PWRTE = ON, MCLRE = ON, CP = OFF, BOREN = ON, CLKOUTEN = OFF, IESO = OFF, FCMEN = OFF

#define _XTAL_FREQ 500000 

// Mapeo de Hardware
#define HEARTBEAT_LED LATDbits.LATD7
#define HEARTBEAT_TRIS TRISDbits.TRISD7

// Prototipos de funciones propias (Capa 0)
void system_init(void);
void uart_init(void);
void uart_putc(char c);

void uart_init(void) {
    // Configuración de pines para UART
    TRISCbits.TRISC6 = 1; 
    TRISCbits.TRISC7 = 1; 

    // Baud Rate: 9600 bps @ 500kHz
    BAUDCONbits.BRG16 = 1; 
    TXSTAbits.BRGH = 1;    
    SPBRGL = 12;           
    SPBRGH = 0;

    TXSTAbits.SYNC = 0;    
    RCSTAbits.SPEN = 1;    
    TXSTAbits.TXEN = 1;    
}

void uart_putc(char c) {
    while(!PIR1bits.TXIF); 
    TXREG = c;             
}

void system_init(void) {
    OSCCON = 0x38;          // 500kHz
    ANSELD = 0;             
    // ANSELC = 0;             // ¡Importante para UART! ¡No existe para el PIC16F1939!
    HEARTBEAT_TRIS = 0;     
    HEARTBEAT_LED = 0;      
    uart_init();
}

void main(void) {
    system_init();
    
    while(1) {
        HEARTBEAT_LED = 1;
        uart_putc('B');    // Enviamos el testigo 'B'
        __delay_ms(500); 
        
        HEARTBEAT_LED = 0;
        __delay_ms(500);
    }
}