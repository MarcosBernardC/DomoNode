/*
 * File:   main.c
 * Author: Marcos Bernard Calixto López
 * Project: DomoNode - System Heartbeat Validation
 * Architecture: Capa 0 - Hardware Core
 */

// Configuración de Fuses (Basado en tu Capa 0)
#pragma config FOSC = INTOSC    // Oscilador interno
#pragma config WDTE = OFF       // Watchdog Timer desactivado
#pragma config PWRTE = ON       // Power-up Timer activado
#pragma config MCLRE = ON       // MCLR pin habilitado (Pin 1)
#pragma config CP = OFF         // Code Protection desactivado
#pragma config BOREN = ON       // Brown-out Reset activado
#pragma config CLKOUTEN = OFF   // Clock out desactivado
#pragma config IESO = OFF       // Internal/External Switchover desactivado
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor desactivado

#include <xc.h>

// Definición de frecuencia para __delay_ms()
// Basado en tu ecuación: Fosc = 500kHz
#define _XTAL_FREQ 500000 

// Definición de Capa Física (I/O Mapping)
#define HEARTBEAT_LED LATDbits.LATD7
#define HEARTBEAT_TRIS TRISDbits.TRISD7

void system_init(void) {
    // 1. Configuración del Oscilador (OSCCON)
    // SPLLEN: 0, IRCF: 0111 (500kHz MF), SCS: 1x (Internal OSC)
    // Valor: 0x38 o 0x68 dependiendo de la estabilidad deseada
    OSCCON = 0x38; 

    // 2. Configuración de I/O
    ANSELD = 0;             // Desactivar analógicos en PORTD
    HEARTBEAT_TRIS = 0;     // RD7 como salida
    HEARTBEAT_LED = 0;      // Estado inicial apagado
}

void startup_sequence(void) {
    // Secuencia de inicio para diferenciar del bucle normal
    // 3 ráfagas rápidas tras MCLR
    for(int i = 0; i < 3; i++) {
        HEARTBEAT_LED = 1;
        __delay_ms(100);
        HEARTBEAT_LED = 0;
        __delay_ms(100);
    }
    __delay_ms(500); // Pausa antes de entrar al ciclo normal
}

void main(void) {
    system_init();
    startup_sequence();

    while(1) {
        // System Heartbeat (Normal execution)
        HEARTBEAT_LED = 1;
        __delay_ms(500); 
        HEARTBEAT_LED = 0;
        __delay_ms(500);
    }
}