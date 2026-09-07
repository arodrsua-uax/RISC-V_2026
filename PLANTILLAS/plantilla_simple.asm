
# PLANTILLA SIMPLE DE PROGRAMA PARA RARS (RISC-V)

###############################################################################
# SEGMENTO DE DATOS
# Aqui van las variables globales: numeros, cadenas de texto, vectores, etc.
# Cada dato tiene una ETIQUETA (nombre) y un TIPO de reserva de memoria.
###############################################################################
.data


    dato1:  .word 16        # una palabra de 32 bits con valor 10
    dato2:  .word 25


###############################################################################
# CONSTANTES SIMBOLICAS (opcional)
# Dan nombre a numeros para hacer el codigo mas legible.
###############################################################################

.eqv SALIDA         10


###############################################################################
# SEGMENTO DE CÓDIGO
# Aqui van las instrucciones del programa.
###############################################################################
.text

.globl main        # punto de entrada: RARS empieza a ejecutar aqui

main:

 
    # ---------------------------------------------------------------
    # 1) Cargar datos desde memoria a registros
    # ---------------------------------------------------------------
    lw   t0, dato1               # t0 = dato1 (10)
    lw   t1, dato2               # t1 = dato2 (25)

    # ---------------------------------------------------------------
    # 2) Cuerpo del programa: aqui va tu lógica / algoritmo
    #    (ejemplo simple: sumar t0 + t1 y cargar el resultado en t2)
    # ---------------------------------------------------------------
    add  t2, t0, t1              # t2 = t0 + t1


    # ---------------------------------------------------------------
    # 3) Mostrar el resultado por pantalla
    # ---------------------------------------------------------------

    li   a7, 1       # 1 = imprimir entero
    mv   a0, t2		   # a0 = valor a imprimir
    ecall


    # ---------------------------------------------------------------
    # 4) Fin del programa: SIEMPRE termina con la syscall Exit
    # ---------------------------------------------------------------
    li   a7, SALIDA
    ecall

