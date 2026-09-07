# PROGRAMA PARA FAMILIARIZARSE CON RARS
# RARS: RISC-V Assembler and Runtime Simulator
.data 
mensaje: .ascii  "�Bienvenidos a Estructura de Computadores UAX!\n\n"
.eqv finaliza, 10
.eqv imprime 4

.text 
.globl main 
main:
	la a0, mensaje
	addi a7, zero, imprime
	ecall

	addi a7, zero, finaliza
	ecall
