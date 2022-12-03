.syntax unified
.thumb
.text

@ Simbolos exportados -- Es necesario exportar el nombre de cada función que declaremos, de modo que el linker de C la encuentre
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global asm_productoEscalar16


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 1
@   void asm_zeros (uint32_t * vector, uint32_t longitud)
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vector
@   r1: longitud
.thumb_func               @ Se avisa al emsablador que esta es una funcion
    asm_zeros:            @ Etiqueta/nombre de la función.
        mov r2, 0         @ r2 = 0
        asm_zeros_bucle:  @ Etiqueta de comienzo de bucle.
    str r2, [r0]          @ Asigna 0 a la palabra en dirección r0.
    add r0, 4             @ Pasa a la siguiente palabra/elemento en vector.
    subs r1, 1            @ Resta 1 a la cantidad de elementos y actualiza flags de estado del procesador. En particular, estamos interesados en el flag Z.
    bne asm_zeros_bucle   @ La instrucción se ejecuta mientras el resultado de r1 - 1 no sea cero (Z == 0).
    bx lr                 @ La instrucción de salto no se ejecutó porque Z == 1, volvemos a quién nos llamó.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 2
@   void asm_productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar)
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vectorIn
@	r1: dirección de memoria de inicio del vectorOut
@	r2: longitud
@   r3: escalar
@ Variables
@	r4: i
@	r5: j variable auxiliar para contar las veces que sumo
@	r6: registro auxiliar
.thumb_func               				@ Se avisa al emsablador que esta es una funcion
    asm_productoEscalar32: 				@ Etiqueta/nombre de la función.
        push {r4-r6}					@ preservo los valores de los registros auxiliares en orden. (por seguridad)
        mov r4, 0         				@ r4 = 0 es la variable i
        asm_escalar32_bucle:  			@ Etiqueta de comienzo de bucle.
    		cmp r4,r2					@ Comparo i con longitud
    		bge exit_loop				@ si r4 es mayor o igual que r6 salto a la etiqueta exit_loop
    		mov r5, 0					@ r5 es para contar las veces que sumo (multiplicación)
    		multiplica_bucle:
    			cmp r5, r3
    			bge exit_multiplica
    			ldr r6,[r0]				@ carga  r6(registro auxiliar) el contenido de vectorIn.
    			add r6, r6				@ La multiplicación en SI
    			add r0, 4               @ Pasa a la siguiente palabra/elemento en vector.
    			adds r5, 1				@ incremento j (interna del loop for)
    			bne multiplica_bucle
    			exit_multiplica:
    		exit_loop:
    		str r6, [r1]				@ cargo en memoria (vectorOut) el resultado de la multiplicacion
    		add r1, 4               	@ Pasa a la siguiente palabra/elemento en vector.
    		adds r4, 1					@ incremento i
    		bne asm_escalar32_bucle
    		pop {r4-r6}					@ devuelvo los valores originales de los registros
    	bx lr                		@ La instrucción de salto no se ejecutó porque N == V, volvemos a quién nos llamó.
@En C:
@void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar)
@{
@	for (uint32_t i=0; i<longitud; i++) {
@		vectorOut[i] = vectorIn[i] * escalar;
@	}
@}
@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 3
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vectorIn
@	r1: dirección de memoria de inicio del vectorOut
@	r2: longitud
@   r3: escalar
@ Variables
@	r4: registro para guardar el resultado de la multiplicación


.thumb_func               				@ Se avisa al emsablador que esta es una funcion
    asm_productoEscalar16:
    		push {r4}					@ Guarda el registro en la memoria para pisar lo que tenia Eje push {r4-r6} guarda los 3 reg.
    		multiplica16_bucle:
    			ldrh r4, [r0], #2		@ Carga r4 con el vectorIn y suma 2 posiciones el sp(16bit)
    			mul r4, r3				@ Utilizo la instruccion mul que multiplica y actuliza r4
    			strh r4, [r1], #2		@ Cargo en moria el resultado de r4 y actualiza el sp de r1(16bit)
    			subs r2, 1				@ Resto 1 al contenido de r2
    			bne multiplica16_bucle
    		pop {r4}					@ Restablesco el valor de r4 original que tenia antes de entrar a la función
    		bx lr

@ void productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar)
@ {
@  	for (uint32_t i=0; i<longitud; i++) {
@		vectorOut[i] = vectorIn[i] * escalar;
@	}
@ }

