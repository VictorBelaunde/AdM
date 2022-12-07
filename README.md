Alumno: Victor Belaunde

# Preguntas orientadoras

### 1. Describa brevemente los diferentes perfiles de familias de microprocesadores/microcontroladores de ARM. Explique alguna de sus diferencias características.
R: Los 3 diferentes tipos son Application, Real Time y Microcontroller.
- Application: No es una arquitectura orientada al manejo de eventos bajo un SO como RTOS, sino que maneja memoria cache para ganar tiempo y emular que corren varias aplicaciones al mismo tiempo.
- Real time: Es una arquitectura para el manejo del tiempo con mucha presición, y este considerado como critico. Por ejemplo un sistema de Airbag de un automovil.
- Microcontroller: Es una arquitectura para dispositivos de uso masivo y con posibilidad de gestionar tareas y tiempo a través de un sistema RTOS o por bare-metal. 

## Cortex M

### 1. Describa brevemente las diferencias entre las familias de procesadores Cortex M0, M3 y M4.
R: El M0 pertenece a la arquitectura ARM v6 y es una familia para aplicaciónes que requieren bajo consumo y son de bajo costo. Cuenta con una arquitectura de memoria del tipo Von Neumann. 
En cambio los M3 y M4 son de la arquitectura ARM v7 que tienen mucha mas capacidad y mejor performance, poseen set de instrucciones Thumb 2 y MPU para proteger espacio de memoria que son utilizados para perifericos, etc.

### 2. ¿Por qué se dice que el set de instrucciones Thumb permite mayor densidad de código? Explique
R: Thumb es un conjunto de instrucciones más reducida con estructura de 16bit. Al tener la mitad de longitud (16 contra 32bit), se consigue disminuir la cantidad de código y mejorar su densidad. Por lo tanto, se va a requerir menos cantidad de memoria para ejecutar las instrucciones.

### 3. ¿Qué entiende por arquitectura load-store? ¿Qué tipo de instrucciones no posee este tipo de arquitectura?
R: La arquitectura load-store (carga y almacenamiento) indica que las instrucciones que acceden a memoria están separadas de las que procesan los datos. En este tipo de arquitectura no hay datos en si, porque estos "solo" se encuentran en registros.

### 4. ¿Cómo es el mapa de memoria de la familia?
R: El mapa de memoeria es de 4Gb. Este espacio está dividido por varias regiones, cada uno para un determinada utilización. Por ejemplo está la región para almacenar el código del programa, otra es usada para perifericos externos y otra para perifericos internos (todos aquellos que son propios del micro), una region de SRAM para almacenamiento de bit para hacer "bit banding", y por ultimo una RAM para almacenamiento de datos y uso externo.


### 5. ¿Qué ventajas presenta el uso de los “shadowed pointers” del PSP y el MSP?

### 6. Describa los diferentes modos de privilegio y operación del Cortex M, sus relaciones y como se conmuta de uno al otro. Describa un ejemplo en el que se pasa del modo privilegiado a no priviligiado y nuevamente a privilegiado.
R: Los diferentes modos de operación son Thread en modo privilegiado que se ejecuta ni bien se corre la aplicación y permite acceder a todas las instrucciones y recursos del micro, en cambio Thread en modo NO privilegiado (corren la mayoría de las aplicaciones) se pasa por ejecución de software y solo puede acceder a parte de la memoria y puertos. Algo para destacar es que una vez se pasa a Thread no provilegiado no es posible volver a privilegiado sino es a través del modo handler.
Por otro lado, tambien existe el modo Handler, se ejecuta con una interrupción y luego de ejecutada vuelve al modo Thread. Este modo protege al sistema operativo y evita acceder a lugares ilegales.
Por último está el modo Debug que es cuando se está debugeando la aplicación en el micro.
Por ejemplo cuando se resetea el micro entra en modo thread privilegiado con el cambio de un flag se pasa a modo no provilegiado, y hasta que no haya una interrupción por tiempo no pasará nuevamente a modo privilegiado.

### 7. ¿Qué se entiende por modelo de registros ortogonal? Dé un ejemplo
R: Se llama modelo de registro ortogonal porque cualquier Registro puede utilizarce para propositos general e instrucción y en ARM lo componen 13 registros a diferencia de otros micros que solo existe uno solo. Tambien existen algunos registros con limitaciones como lo son los PCS, MPS, etc.  


### 8. ¿Qué ventajas presenta el uso de intrucciones de ejecución condicional (IT)? Dé un ejemplo
R:

### 9. Describa brevemente las excepciones más prioritarias (reset, NMI, Hardfault)
R:

### 10. Describa las funciones principales de la pila. ¿Cómo resuelve la arquitectura el llamado a funciones y su retorno?
R: La pila se utiliza para almacenar en memoria en modo LiFo (ultimo en llagar - primero en salir) para utilizar el stack de memoria y son incorporadas las palabras de 32 bits con PUSH y sacado con POP para luego pasarlo al registro y operar. Un puntero me indica la dirección de memoria utilizada y es utilizado tanto para incorporar (SP + 1) o leer (SP, que luego decrece en 1 su dirección). Cuando se ejecuta una función debemos preservar los valores de los registros haciendo un PUSH al comenzar y luego un POP antes de salir, si es que esa función utiliza registros sino corremos el riesgo de perder los valores originales de la aplicación.

### 13. ¿Cómo se implementan las prioridades de las interrupciones? Dé un ejemplo
R: Las interrupciones pueden ser internas o externas (producto de un evento espontaneo), para que el micro sepa a que interrupción debe atender antes que otras es que cada una de ellas tiene seteado el nivel de prioridad que facilita su manejo. De existir dos interrupciones con la misma prioridad, se da paso al seteo del nivel de sub prioridad (sub priorities). El cortex en particular tiene 256 niveles de prioridad y quien es el encargado de gestionar y controlar estas interrupciones con sus prioridades es NVIC, existen interrupciones ya preconfiguradas con niveles muy bajos (negativos) con maxima prioridad. Ejemplo "Reset con prioridad -3".

### 14. ¿Qué es el CMSIS? ¿Qué función cumple? ¿Quién lo provee? ¿Qué ventajas aporta?
R: El CMSIS es una capa de abstracción del hardware facilitando la programación y uso de los recursos del micro. Genera una capa de software que separa al programador del hardware permitiendo en un nivel superior y con una interface unificada para todos los cortex. Quien provee es CMSIS es el mismo ARM para que cada fabricante tenga la posibilidad de unificar su hardware con el mercado.

### 15. Cuando ocurre una interrupción, asumiendo que está habilitada ¿Cómo opera el microprocesador para atender a la subrutina correspondiente? Explique con un ejemplo
R:

### 17. ¿Cómo cambia la operación de stacking al utilizar la unidad de punto flotante?
R:

### 16. Explique las características avanzadas de atención a interrupciones: tail chaining y late arrival.
R:

### 17. ¿Qué es el systick? ¿Por qué puede afirmarse que su implementación favorece la portabilidad de los sistemas operativos embebidos?
R: Los micros ARM Cortex incluye un timer llamado SysTick que implementan los fabricantes. Está pensado para usarlo como base de tiempos, así que es perfecto para el concepto de temporización y su aprovechamiento en las tareas como en SO como FreeRTOS.
Este periférico usa un contador descendente, cuando la cuenta está en 0 y dispara un evento, el registro de cuenta se recarga con un valor de “precarga” establecido por el programador y seguirá descontando a partir de ese valor.

### 18. ¿Qué funciones cumple la unidad de protección de memoria (MPU)?
R:La Unidad de protección de memoria es una unidad programable que permite que el programa gestione los permisos de acceso a la memoria. Supervisa las transacciones, incluidas las búsquedas de instrucciones y los accesos a datos del procesador, y puede detectar una violación de acceso. El  MPU permite que el programa privilegiado defina regiones de memoria y asigne permisos de acceso a memoria.

## ISA
### 1. ¿Qué son los sufijos y para qué se los utiliza? Dé un ejemplo 
R: Son complemento de las instrucciones y se utilizan para comprobar resultados, tareas, operaciones, etc. Un ejemplo es  "ANDNE r0,r0,r1" Realiza la suna si Z=0.

### 2. ¿Para qué se utiliza el sufijo ‘s’? Dé un ejemplo
R: Este sufijo es para realizar la operacion y luego actualizar el flag de estado. eje "adds r0, 1".

###3. ¿Qué utilidad tiene la implementación de instrucciones de aritmética saturada? Dé un ejemplo con operaciones con datos de 8 bits.
R: La aritmetica saturada puede ser utilizada para procesar señales, controlar el resultado de una operación o "convertir" un número de 32bit a 16bit por ejemplo. Eje: usat r4, #8, r4.

###4. Describa brevemente la interfaz entre assembler y C ¿Cómo se reciben los argumentos de las funciones? ¿Cómo se devuelve el resultado? ¿Qué registros deben guardarse en la pila antes de ser modificados?
R: Para trabajar entre C y asembler es necesario declarar la función en C y luego exportar los simbolos (.global asm_zeros) en asembler para que el linker de C la encuentre. En asembler los argumentos se reciben por los primeros 4 registros (R0, R1, R2 y R3), y de necesitar devolver un resultado en la función lo hace por medio del registro R4. El resto de los registros antes de utilizarlos se debe resguardar su contenido en la pila con un Push y antes de finalizar devolverlo con un Pop.

###5. ¿Qué es una instrucción SIMD? ¿En qué se aplican y que ventajas reporta su uso? Dé un ejemplo.
R: SIMD es una manera de acelerar el procesamiento con varios elementos a la vez en vez de lo tradicional que sería uno solo. Se utiliza mucho para DSP (procesamiento digital de señales). Divide la capacidad del registro en 2 o en 4 como si fueran de 16bit u 8bit respectivamente, con la particularidad que cada uno de ellos actua independiente del resto. 
