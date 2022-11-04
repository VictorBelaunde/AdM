Alumno: Victor Belaunde

# Preguntas orientadoras

### 1. Describa brevemente los diferentes perfiles de familias de microprocesadores/microcontroladores de ARM. Explique alguna de sus diferencias características.
R: Los 3 diferentes tipos son Application, Real Time y Microcontroller.
- Application: No es una arquitectura orientada al manejo de eventos bajo un SO como RTOS, sino que maneja memoria cache para ganar tiempo y emular que corren varias aplicaciones al mismo tiempo.
- Real time: Es una arquitectura para el manejo del tiempo con mucha presición, y este considerado como critico. Por ejemplo un sistema de Airbag de un automovil.
- Microcontroller: Es una arquitectura para dispositivos de uso masivo y con posibilidad de gestionar tareas y tiempo a través de un sistema RTOS o por bare-metal. 

## Cortex M

### 1. Describa brevemente las diferencias entre las familias de procesadores Cortex M0, M3 y M4.
R: El M0 es una familia para aplicaciónes que requieren bajo consumo y son de bajo costo. Cuenta con una arquitectura de memoria del tipo Von Neumann. 
En cambio los M3 y M4 tienen mucha mas capacidad y mejor performance, poseen set de instrucciones Thumb 2 y MPU para proteger espacio de memoria que son utilizados para perifericos, etc.

