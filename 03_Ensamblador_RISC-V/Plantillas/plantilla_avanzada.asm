###############################################################################
# PLANTILLA GENERICA DE PROGRAMA PARA RARS (RISC-V)
#
# Nombre:
# ESTRUCTURA DE COMPUTADORES UAX
# Fecha:
#
# Descripcion:
#   Explica aqui en 2-3 lineas que hace tu programa.
#
# Esta plantilla ENSAMBLA Y EJECUTA tal cual en RARS. Sustituye/borra las
# partes de ejemplo por tu propio codigo, manteniendo la estructura general.
###############################################################################


###############################################################################
# SEGMENTO DE DATOS
# Aqui van las variables globales: numeros, cadenas de texto, vectores, etc.
# Cada dato tiene una ETIQUETA (nombre) y un TIPO de reserva de memoria.
###############################################################################
.data

    # --- Cadenas de texto (para imprimir mensajes con la syscall PrintString) ---
    msg_bienvenida: .asciz "El programa se ha iniciado\n"
    msg_resultado:  .asciz "El resultado es: "
    salto_linea:    .asciz "\n"

    # --- Enteros individuales ---
    dato1:  .word 10        # una palabra de 32 bits con valor 10
    dato2:  .word 25

    # --- Vector de enteros (ejemplo: 5 elementos) ---
    vector: .word 1, 2, 3, 4, 5
    N:      .word 5          # tamano del vector, util para bucles

    # --- Espacio reservado sin inicializar (por ejemplo, para guardar un resultado) ---
    resultado: .word 0


###############################################################################
# CONSTANTES SIMBOLICAS (opcional)
# Dan nombre a numeros para hacer el codigo más legible.
# Sintaxis de .eqv: "NOMBRE valor" (sin coma).
###############################################################################
.eqv IMPRIMIR_INT    1
.eqv IMPRIMIR_STRING 4
.eqv SALIDA         10


###############################################################################
# SEGMENTO DE TEXTO (CODIGO)
# Aqui van las instrucciones del programa.
###############################################################################
.text

.globl main        # punto de entrada 

main:
    # ---------------------------------------------------------------
    # 1) Mensaje de bienvenida (syscall PrintString)
    # ---------------------------------------------------------------
    la   a0, msg_bienvenida    # a0 = direccion de la cadena a imprimir
    li   a7, IMPRIMIR_STRING   # a7 = codigo de la syscall (4 = print string)
    ecall

    # ---------------------------------------------------------------
    # 2) Cargar datos desde memoria a registros
    # ---------------------------------------------------------------
    lw   t0, dato1               # t0 = dato1 (10)
    lw   t1, dato2               # t1 = dato2 (25)

    # ---------------------------------------------------------------
    # 3) Cuerpo del programa: aqui va tu logica / algoritmo
    #    (ejemplo simple: sumar t0 + t1)
    # ---------------------------------------------------------------
    add  t2, t0, t1              # t2 = t0 + t1

    # Para guardar en memoria una variable con "sw", primero se necesita
    # su DIRECCION en un registro (no se puede usar la etiqueta directamente
    # como offset). Se carga con "la" y se usa offset 0.
    la   t3, resultado           # t3 = direccion de "resultado"
    sw   t2, 0(t3)               # mem[resultado] = t2

    # ---------------------------------------------------------------
    # 4) Mostrar el resultado por pantalla
    # ---------------------------------------------------------------
    la   a0, msg_resultado
    li   a7, IMPRIMIR_STRING
    ecall

    lw   a0, 0(t3)              # a0 = valor guardado en "resultado"
    li   a7, IMPRIMIR_INT       # 1 = print int
    ecall

    la   a0, salto_linea
    li   a7, IMPRIMIR_STRING
    ecall

    # ---------------------------------------------------------------
    # 5) Ejemplo de bucle recorriendo el vector (imprime cada elemento)
    # ---------------------------------------------------------------
    la   t3, vector               # t3 = direccion base del vector
    lw   t4, N                    # t4 = numero de elementos (limite)
    li   t5, 0                    # t5 = indice i = 0

bucle:
    beq  t5, t4, fin_bucle        # si i == N, salir del bucle
    slli t6, t5, 2                # t6 = i * 4 (desplazamiento en bytes)
    add  t6, t3, t6               # t6 = direccion de vector[i]
    lw   a0, 0(t6)                # a0 = vector[i]

    li   a7, IMPRIMIR_INT
    ecall

    la   a0, salto_linea
    li   a7, IMPRIMIR_STRING
    ecall

    addi t5, t5, 1                # i = i + 1
    j    bucle

fin_bucle:

    # ---------------------------------------------------------------
    # 6) Fin del programa: SIEMPRE termina con la syscall Exit
    # ---------------------------------------------------------------
    li   a7, SALIDA
    ecall

