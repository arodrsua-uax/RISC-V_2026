# Bucle while contador. Traducir a ensamblador un bucle que sume los números del 1 al 10 equivalente a:
# sum=0; i=1; while(i<=10){sum+=i; i++;}). Guardando el resultado final en s0

.data


.text
.global main
main:
	li t0, 10   # <=10
	li t1, 0		# i
	li s0, 0		# valor inicial de sum
bucle:
	beq	t1, t0, fin	# si i=10 finaliza
	addi t1, t1, 1	# i++
	add s0, s0, t1	# sum_i = suma_i-1 + i
	j bucle
fin:
	li a7, 10
	ecall