.syntax unified
.thumb
.text

@ Simbolos exportados -- Es necesario exportar el nombre de cada función que declaremos, de modo que el linker de C la encuentre
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global asm_productoEscalar16
.global asm_productoEscalar12
.global asm_pack32to16
.global asm_max
.global asm_downsampleM
.global asm_filtroVentana10


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
    		push {r4}					@ Guarda el registro en la memoria para no pisar la info. Eje push {r4-r6} guarda los 3 reg.
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
@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 4
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vectorIn
@	r1: dirección de memoria de inicio del vectorOut
@	r2: longitud
@   r3: escalar
@ Variables
@	r4: registro para guardar el resultado intermedio
.thumb_func
	asm_productoEscalar12:
		push {r4}				@ Guarda el registro en la memoria para no pisar la info
		multiplica12_bucle:
			ldrh r4, [r0], #2	@ Guardo en r4 los primeros 16bit de r0 y suma 2 posiciones
			mul r4, r3			@ Multiplica r4 con el escalar y actualiza r4
			usat r4, #12, r4	@ Uso la instruccion "usat" para saturar a 12bit y lo guardo en r4. Eje USAT <Rd>,#,<Rn>
			strh r4, [r1], #2	@ Cargo en memoria el resultado de r4 y actualiza el sp de r1(16bit)
			subs r2, 1			@ Resto 1 al contenido de r2
			bne multiplica12_bucle
		pop {r4}
		bx lr
@void productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar)
@{
@	for (uint32_t i=0; i<longitud; i++) {
@		if (vectorIn[i] * escalar > 4096)
@		{
@			vectorOut[i] = 4095; // (2 elevado a la 12) - 1
@		}
@		else{
@			vectorOut[i] = vectorIn[i] * escalar;
@		}
@	}
@}
@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 5
@
@ Parámetros recibidos:
@   r0: dirección de memoria del vectorIn
@   r1: dirección de memoria del vectorOut
@	r2: longitud del vector
@ Variables
@	r3: contador i
@	r4: contador x
@	r5: variable auxiliar de indice
@	r6: auxiliar del registro r0
@	r7: suma de datos
@	r8: contador de samples
@	r9: auxiliar para r2

.thumb_func
	asm_filtroVentana10:
		push {r3-r9}
		mov r3, 0							@ Inicializar i
		mov r9, r2
		asm_filtroVentana10_bucle:
		mov r4, 5							@ Inicializa x en 5
		mov r6, 0
		mov r7, 0
		mov r8, 0
		asm_filtroVentana10_bucle_a:		@ Bucle a para la ventana del filtro
			subs r5, r3, r4					@ controlo si salgo de rango
			lsl r5, 1						@ Multiplico por 2 para desplazar  2 bytes
			ITTT PL							@ Controlo i es positivo o igaul a 0
			ldrhPL r6, [r0, r5]				@ Leo el índice correspondiente de r0
			addPL r7, r6					@ Acumulo el valor parte alta
			addPL r8, 1						@ Sumo un sample
			subs r4, 1
		bne asm_filtroVentana10_bucle_a
		mov r4, 5							@ actualizo en 5 a x
		asm_filtroVentana10_bucle_b:
			add r5, r3, r4					@ controlo si salgo de rango
			cmp r9, r5						@ Comparo con el límite superior del vector
			lsl r5, 1						@ Multiplico por 2 para desplazar  2 bytes
			ITTT hi							@ Controlo i es positivo o igaul a 0
				ldrhhi r6, [r0, r5]			@ Leo el índice correspondiente de r0
				addhi r7, r6				@ Acumulo el valor parte alta
				addhi r8, 1					@ Sumo un sample
			subs r4, 1
		bne asm_filtroVentana10_bucle_b
		udiv r7, r7, r8
		strh r7, [r1, r3]
		add r3, 1							@ Sumo uno a i
		subs r2, 1
		bne asm_filtroVentana10_bucle
		pop {r3-r9}
		bx lr

@	void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);
@
@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 6
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vectorIn
@	r1: dirección de memoria de inicio del vectorOut
@	r2: longitud
@ Variables
@	r3: registro para guardar el corrimiento de posiciones a 16bits
.thumb_func
	asm_pack32to16:
		push {r3}					@ Resguardo el valor de r3 en la pila
		pack32to16_bucle:
			ldr r3, [r0], #4		@ Cargo en r3 el vectorIn y actualizo posicion 4 lugares
			lsr r3, r3, 16			@ Shifteo el valor de r3 en 16 posiciones
			str r3, [r1], #2		@ Cargo en memoria y actualizo posicion en 2 lugares
			subs r2, 1				@ resto en 1 el registro de longitud
			bne pack32to16_bucle
		pop {r3}
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 7
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vectorIn
@	r1: longitud del vectorIn
@ Variables
@	r2: registro para cargar valor maximo
@	r3: resitro para cargar posicion max
@	r4: registro contador de posicion
@	r5: registro auxiliar
.thumb_func
	asm_max:
		push {r2-r5}
		mov r2, 0
		mov r3, 0
		mov r4, 0
		asm_max_bucle:
			ldr r5, [r0]
			cmp r5, r2
			bgt salta_if		@ Salta las siguientes 2 lineas si r5 es mayor que r2
			mov r2, r4			@ Gaurado los valores nuevos
			mov r3, r1
			salta_if:
			add r4, 1
			subs r1, 1
			bne asm_max_bucle
		pop {r2-r5}
		bx lr

@int32_t max (int32_t * vectorIn, uint32_t longitud)
@{
@	uint32_t valorMaximo = 0;
@	uint32_t posicionMaximo = 0;
@	for(uint32_t i=0; i<longitud; i++)
@	{
@		if (vectorIn[i] > valorMaximo)
@		{
@			valorMaximo = vectorIn[i];
@			posicionMaximo = i;
@		}
@	}
@	return posicionMaximo;
@}
@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 8
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vectorIn
@	r1: dirección de memoria de inicio del vectorOut
@	r2: longitud del vector
@	r3: valor de N
@ Variables
@	r4: variable auxiliar para r0
@	r5: resitro para variable N


.thumb_func
	asm_downsampleM:
		push {r4-r5}				 	@ Resguardo valores de los registros en la pila
		mov r5, 0						@ Inicializo r5
		asm_downsampleM_bucle:
			add r5, 1					@ Sumo 1 para comenzar con el elemento a leer
			ldr r4, [r0], #4			@ Cargo el vectorIn y me desplazo una posición 32bit
			cmp r5, r3					@ Comparo r5 con la variable N (elemento a descartar)
			ite eq						@ Si la operacion anterior es igual
				moveq r5, 0				@ Si es igual pongo a 0 el registro r5
				strne r4, [r1], #4		@ Si no es igual copio el valor en el vectorOut y me desplazo una posición
			subs r2, 1					@ Resto en 1 el registro de longitud actualizo con S para actualizar flags
			bne asm_downsampleM_bucle
		pop {r4-r5}						@ Antes de salir recupero los valores iniciales de los registros
		bx lr							@ Vuelvo a la dirección donde se invocó a la función

@
@ void asm_downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N);
@
@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C": Ejercicio 9
@
@ Parametros recibidos:
@   r0: dirección de memoria de inicio del vector
@	r1: longitud del vector
@ Variables
@	r2: contador para elementos inicio
@	r3: contador para elementos fin
@	r4: variable auxiliar para valores inicio
@	r5: variable auxiliar para valores fin

.thumb_func
	asm_invertir:
		push {r2-r5}
		mov r2, 2					@ Cargo el valor INICIO para usarlo en la inicialización de r3
		mov r3, r1					@ Cargo la cantidad de elementos qque tiene el vector
		sub r3, 1					@ Cargo r3 con el elemento  FIN - 1
		mul r3, r2					@ Obtengo los bytes a desplazarme en memoria para obtener el elementro FIN - 1
		mov r2, 0					@ Cargo r2 con 0 el primer elemento del vector
		asm_invertir_bucle:
			ldrh r4, [r0, r2]		@ Cargo el elemento INICIO
			ldrh r5, [r0, r3]		@ Cargo el elemento FIN
			strh r4, [r0, r3]		@ Traspaso los valores leidos en los elementos invertidos
			strh r5, [r0, r2]		@ Traspaso los valores leidos en los elementos invertidos
			add r2, 2				@ Posiciono r2 en el elemento siguiente INICIO + 1
			sub r3, 2				@ Posiciono r3 en el elemento siguiente FIN - 1
			cmp r3, r2				@ Comparo ambos elementos
			bgt	asm_invertir_bucle 	@ Si r3 es menor a r2 entonces continuo en el bucle
		pop {r2-r5}					@ Antes de salir recupero los valores iniciales de los registros
		bx lr
@
@ void asm_invertir(uint16_t * vector, uint32_t longitud);
@
@@@@@@@@@@@@@@@@@@@@@@@@@@

