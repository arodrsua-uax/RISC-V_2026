# Suma dos valores que están en localidades de memoria consecutivas y el resultado lo guarda en la siguiente.
# Guarda el resultado en s0.

.data

DIR_1: .word 0x01010101
DIR_2: .word 0x10101010


.text

.globl main        # punto de entrada: RARS empieza a ejecutar aqui

main:

	la	s0, DIR_1
#	la	s1, DIR_2  No hace falta hacer esto porque ya sé que está en la siguiente (+4)
	
	lw t0, 0(s0)
 	lw t1, 4(s0)
 	add t0, t0, t1
 	sw t0, 8(s0)
 
  li   a7, 10
  ecall
