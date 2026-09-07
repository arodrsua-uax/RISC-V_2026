
.data
.eqv VALOR 25

.text 
.globl main 
main:
	addi x5, x0, 0x20 # carga el valor 32 decimal (20 hexadecimal) en el registro x5 (t0)
	addi t1, zero, 16 # carga el valor 16 decimal (10 hexadecimal) en el registro x6 (t1)
	li t2, 12  				# carga el valor 12 decimal (C hexadecimal) en el registro x7 (t2)
	li s0, VALOR			# carga el valor 25 decimal (19 hexadecimal) en el registro x8 (s0)

# Calculamos t0 + t1 y lo guardamos en s0 (machacando lo que teníamos en s0)
	add s0, t0, t1
	
# Calculamos t2 + VALOR (25 en decimal) y lo guardamos en s1 
	addi s1, t2, VALOR
	
# Calculamos t2 - VALOR (25 en decimal) y lo guardamos en s2
	addi s2, t2, -VALOR
	
# Volvemos a caldular t2 - VALOR (25 en decimal) y lo guardamos en s3
	li t3, VALOR
	sub s3, t2, t3
	
# Calculamos t2 + 7 y lo guardamos en el mismo t2, machacando su valor anterior
	addi t2, t2, 7
		
# No imprimimos nada

	addi a7, zero, 10
	ecall	
	 
