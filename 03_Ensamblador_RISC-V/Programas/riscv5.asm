# Operaciones lógicas. Dado un valor en t0, usa andi, ori y xori para:
# (a) quedarte solo con el byte bajo,
# (b) forzar el bit 3 a 1,
# (c) invertir el bit 0.

.data

.eqv dato_1 0xfffffff7		# otra forma de meter el dato definiendo el valor mediante una etiqueta
dato_0:  .word 0xfffffff7 # una palabra de 32 bits con valor FF. Otra forma de meter el dato: guardándolo en memoria  
			

.text

.globl main        

main:

# Para una de las formas de meter el dato:
	addi	t0, zero, dato_1 # Cargar el valor de la etiqueta dato_1 en el registro t0
	
# Para la otra forma de meter el dato:
	la	s0, dato_0	# Cargar la dirección donde está el dato en el registro s0
	lw	t1, 0(s0)		# Cargar el contenido apuntado por el registro s0 en el registro t1
	
# **********************
# (a) quedarte solo con el byte bajo, operando sobre t0

	andi t0, t0, 0x0FF
	
# (a) quedarte solo con el byte bajo, el valor que trajimos de memoria y guardándolo en la siguiente localidad de memotia
	andi t1, t1, 0xFF
	sw t1, 4(s0)
# ************************************
# (b) forzar el bit 3 a 1, operando sobre t0

	ori t0, t0, 0x08

# (b) forzar el bit 3 a 1, en el valor que trajimos de memoria y guardándolo en la siguiente localidad de memotia
	ori t1, t1, 0x08
	sw t1, 4(s0)

# *****************************************
# (c) invertir el bit 0, operando sobre t0

	xori t0, t0, 0x01
	
# (c) invertir el bit 0, en el valor que trajimos de memoria y guardándolo en la siguiente localidad de memotia

	xori t1, t1, 0x01
	sw t1, 4(s0)

	

# FIN 
    li   a7, 10
    ecall

