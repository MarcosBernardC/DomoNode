# DomoNode 🏠⚡

[![Language: C](https://img.shields.io/badge/Language-Embedded_C-blue.svg)](https://en.wikipedia.org/wiki/Embedded_C)
[![Compiler: XC8](https://img.shields.io/badge/Compiler-Microchip_XC8-orange.svg)](https://www.microchip.com/mplab/compilers)
[![Docs: LuaLaTeX](https://img.shields.io/badge/Docs-LuaLaTeX-darkgreen.svg)](https://www.latex-project.org/)
[![Cloud: Supabase](https://img.shields.io/badge/Cloud-Supabase-3ecf8e.svg)](https://supabase.com/)

**DomoNode** es un ecosistema IoT de grado industrial diseñado bajo una metodología de desarrollo iterativo. El proyecto escala desde el control de registros en silicio hasta la visualización de datos en la nube, priorizando la eficiencia energética y la documentación técnica rigurosa.

---

## 🏗️ Metodología de Desarrollo (MVP Iterativo)

El progreso del proyecto se documenta a través de reportes técnicos generados en **LuaLaTeX**, vinculando cada iteración con una capa del modelo de sistemas:

### [Iteración 01: System Heartbeat](./research/build/01_heartbeat.pdf) 📄

- **Foco:** Capa 0 (Hardware Core).
- **Hito:** Validación de estabilidad del oscilador interno y secuencia de arranque segura.
- **Resultado:** Consumo optimizado mediante configuración MFINTOSC a 500kHz.
- **🎥 [Ver Demostración](https://youtu.be/Y8ERYFn19mU)**

### [Iteración 02: UART Timing & Telemetry](./research/build/02_uart.pdf) 📄

- **Foco:** Capa 1 y 2 (Física y Enlace).
- **Hito:** Implementación de telemetría serial con error de baudaje del 0.16%.
- **Resultado:** Comunicación robusta a 9600 bps para transmisión de tramas de sensores.
- **🎥 [Ver Demostración](https://youtu.be/vGGgzFn22VY?si=uIu9ADjewPjObTmR)**

---

## 🛠️ Stack Tecnológico

| Dominio             | Tecnologías                                       |
| :------------------ | :------------------------------------------------ |
| **Firmware**        | Microchip XC8, PIC16F1939, Embedded C             |
| **Hardware**        | KiCad (Schematic), Proteus/PICSimLab (Simulación) |
| **Infraestructura** | Supabase (PostgreSQL), Koyeb (Deployment)         |
| **Documentación**   | LuaLaTeX, Inkscape (Vector Graphics)              |

---

## 🚀 Alcance del Proyecto

1. **Eficiencia en el Edge:** Algoritmos de bajo consumo para nodos autónomos.
2. **Integración Cloud:** Pipeline de datos real-time desde el microcontrolador al dashboard.
3. **Documentación Técnica:** Manuales de ingeniería con estándares DIN-Minimal.

## Licencia 📄

Este proyecto está bajo la licencia **Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)**.
Desarrollado por **Marcos Bernard Calixto López**.

---

_Ingeniería Electrónica | Hardware-to-Cloud Integration_
