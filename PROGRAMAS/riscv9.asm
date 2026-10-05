# EJEMPLO DE USO DE MACROS 

.macro swap_regs(%r1, %r2)  # No se puede usar con t0 y x0 no puede cambiar
	mv t0, %r2
	mv %r2, %r1
	mv %r1, t0
.end_macro 

.macro swap_con_pila (%r1, %r2) # Se pueden usar todos (x0 no puede cambiar)
	  addi sp, sp, -16
    sw   %r1, 12(sp)
    sw	 %r2, 8(sp)
    lw   %r1, 8(sp)
    lw	 %r2, 12(sp)
	  addi sp, sp, 16
.end_macro 
	  
.text

li s0, 7
li s1, 42

swap_regs(s0,s1)

swap_con_pila(s0,s1)

fin: j fin