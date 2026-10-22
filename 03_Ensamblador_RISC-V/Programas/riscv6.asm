 # Máximo de tres valores. Dados tres enteros en t0, t1, t2, encuentra el máximo usando comparaciones encadenadas (bge/blt)
 # y guárdalo en t3.
 
.data


    dato0:  .word 18, 17, 14        # ucargo los valores en memoria, a partir de la dirección dato0


.text

.globl main        # punto de entrada: RARS empieza a ejecutar aqui

main:


  la	s0, dato0               # cargo la dirección dato0 en el registro s0

	lw t0, 0(s0)			# cargo el contenido de la localidad cuya dirección está contenida en el registro s0 en el registro t0
	lw t1, 4(s0)			# hago lo mismo con el contenido de la dirección anterior más 4 (la siguiente dirección de memoria)
	lw t2, 8(s0)			# más 8, la siguiente

	
	
	mv		t3, t0		# siempre muevo el primero a t3
	
	ble t1, t3, no_mueve  # comparo t1 con t3 y si es mayor machaco el valor anterior con el de t1
	mv	t3, t1
no_mueve:	
	ble t2, t3, end			# comparo t2 con t3 y si es mayor machaco el valor anterior con el de t2
	mv t3, t2
end:

    li   a7, 1       # 1 = imprimir entero
    mv   a0, t3		   # a0 = valor a imprimir
    ecall

		add a0, t3, zero
		li a7, 1

    li   a7, 10
    ecall

