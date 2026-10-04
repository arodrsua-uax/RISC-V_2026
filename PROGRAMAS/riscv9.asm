# EJEMPLO DE USO DE MACROS 

.macro swap_regs(%r1, %r2)  # No se puede usar con t0
	mv t0, %r2
	mv %r2, %r1
	mv %r1, t0
.end_macro 


.text

li s0, 7
li s1, 42

swap_regs(s0,s1)

fin: j fin