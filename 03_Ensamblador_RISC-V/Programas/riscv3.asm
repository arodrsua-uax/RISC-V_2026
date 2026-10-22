# Calcula (a + b) * 2 - c con a=8, b=5, c=3, usando solo add, sub, slli (desplazamiento para multiplicar por 2).
# Guarda el resultado en s0.

.data

 .eqv a_1 8
 .eqv b_1 5
 .eqv c_1 3
 
.text

.globl main        # punto de entrada: RARS empieza a ejecutar aqui

main:
# s0 = a + be
 li t0, a_1
 li t1, b_1
 add s0, t0, t1
 
# s0 = (a+b)*2
 slli s0, s0, 1
 
# s0 = (a+b)*2 - c
	addi s0, s0, -c_1  
 
 
  li   a7, 10
  ecall
