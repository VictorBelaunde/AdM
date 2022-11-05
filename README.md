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

### 2. ¿Por qué se dice que el set de instrucciones Thumb permite mayor densidad de código? Explique
R: Thumb es un conjunto de instrucciones más reducida con estructura de 16bit. Al tener la mitad de longitud (16 contra 32bit), se consigue disminuir la cantidad de código y mejorar su densidad. Por lo tanto, se va a requerir menos cantidad de memoria para ejecutar las instrucciones.

### 3. ¿Qué entiende por arquitectura load-store? ¿Qué tipo de instrucciones no posee este tipo de arquitectura?
R: La arquitectura load-store (carga y almacenamiento) indica que las instrucciones que acceden a memoria están separadas de las que procesan los datos. En este tipo de arquitectura no hay datos en si, porque estos "solo" se encuentran en registros.

### 4. ¿Cómo es el mapa de memoria de la familia?
R: El mapa de memoeria es de 4Gb. Este espacio está dividido por varias regiones, cada uno para un determinada utilización. Por ejemplo está la región para almacenar el código del programa, otra es usada para perifericos externos y otra para perifericos internos (todos aquellos que son propios del micro), una region de SRAM para almacenamiento de bit para hacer "bit banding", y por ultimo una RAM para almacenamiento de datos y uso externo.


