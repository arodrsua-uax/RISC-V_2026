# Generar la tabla de multiplicar del un número cargado en memoria (multiplicador×1 hasta multiplicador×10) usando un bucle for,
# e imprimir cada resultado por consola con ecall (a7=1 para imprimir enteros, a7=11 para caracteres)

.data
multiplicador: .word 99

.text
.global main
main:
	li t0, 0 # base que se suma 7 veces
	li s0, 0 # resultado de la multiplicación
	li t1, 11 # límite para dejar de hacer la tabla
	li s1, 0  # inicializa contador interno de la multiplicación
	la s3, multiplicador
	lw s2, 0(s3) # multiplicar x multiplicador
	
multiplica:                 #********************
	add s0, s0, t0            #*  Multiplicación  *
	addi s1, s1, 1            #*									*
	blt s1, s2, multiplica    #********************
	li a7, 1							# implrimir índice
	addi	a0, t0, 0
	ecall
	li a7, 11							# imprimir x
	addi a0, zero, 'x'
	ecall
	li a7, 1							# imprimir resultado
	add	a0, zero, s2
	ecall
	li a7, 11							# imprimir =
	addi a0, zero, '='
	ecall
	li a7, 1							# imprimir resultado
	addi	a0, s0, 0
	ecall
	li a7, 11							# imprimir salto de línea
	addi a0, zero, '\n'
	ecall	
	li s0, 0							# inicializar multiplicación
	li s1, 0 						# inicializar contador interno de la multiplicación
	addi t0, t0, 1				# incrementar el índice
	blt t0, t1, multiplica	# verificar que no hemos terminado
	
	
	li a7, 10		# finalizarr el programa
	ecall
