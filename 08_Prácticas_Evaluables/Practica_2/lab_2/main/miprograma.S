# tile.S 




# ---------- llamadas al sistema (deben coincidir con main.c) ---------- 
#  call os_ecall FUNCIONA CON ecall de RARS, y llama a la funcion C os_syscall(a0..a7) 
#  y conserva todos los registros salvo a0 (que trae el resultado), igual que RARS. 
    .equ SYS_EXIT,        10    # termina el programa                    
    .equ SYS_OLED_TILE,  100    # a0 = columna 0..15    
                                # a7 = SYS_OLED_TITLE = 100 
                                # a1 = fila 0..7
                                # a2 = direccion de los 8 bytes          
    .equ SYS_OLED_CLEAR, 101    # borra la pantalla            a7 = SYS_OLED_CLEA = 101




# =====================================================================
# Definicion de TODOS los tiles. Cada tile ocupa 8 bytes, asi que el
# tile numero N empieza en  tiles + N*8.
# Se pueden definir hasta 256 tiles (0..255). De momento, solo se usan los siguientes:
# 0..9: digitos 0..9  
# 10: pelota
# 11: pala izquierda
# 12: pala derecha
# 13: red
# 14: tile vacio (para borrar)
# 15: abre admiración (ganador)
# 16: cierra admiración (ganador)
# ===================================================================== 
    .section .data
    puntos_izquierda: .byte 0
    puntos_derecha: .byte 0
    .section .rodata
    .balign 4
tiles:
    .byte 0x00,0x3E,0x51,0x49,0x45,0x3E,0x00,0x00   # 0              
    .byte 0x00,0x00,0x42,0x7F,0x40,0x00,0x00,0x00   # 1              
    .byte 0x00,0x42,0x61,0x51,0x49,0x46,0x00,0x00   # 2              
    .byte 0x00,0x21,0x41,0x45,0x4B,0x31,0x00,0x00   # 3              
    .byte 0x00,0x18,0x14,0x12,0x7F,0x10,0x00,0x00   # 4              
    .byte 0x00,0x27,0x45,0x45,0x45,0x39,0x00,0x00   # 5              
    .byte 0x00,0x3C,0x4A,0x49,0x49,0x30,0x00,0x00   # 6              
    .byte 0x00,0x01,0x71,0x09,0x05,0x03,0x00,0x00   # 7              
    .byte 0x00,0x36,0x49,0x49,0x49,0x36,0x00,0x00   # 8              
    .byte 0x00,0x06,0x49,0x49,0x29,0x1E,0x00,0x00   # 9              
    .byte 0x18,0x66,0x42,0x81,0x81,0x42,0x66,0x18   # 10 pelota      
    .byte 0x00,0x00,0x00,0x00,0x00,0x00,0xff,0xff   # 11 pala izq.   
    .byte 0xff,0xff,0x00,0x00,0x00,0x00,0x00,0x00   # 12 pala der.   
    .byte 0x00,0x00,0x00,0x99,0x00,0x00,0x00,0x00   # 13 red 
    .byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00   # 14 tile vacio (para borrar)     
    .byte 0xf3,0x00,0x00,0x00,0xf3,0x00,0x00,0x00   # 15 abre admiración (ganador)
    .byte 0x00,0x00,0x00,0x00,0xcf,0x00,0x00,0xcf   # 16 cierra admiración (ganador)
# =====================================================================
# Código
# ===================================================================== 
    .section .text
    .global game_run            /* main.c llama a esta etiqueta          */


game_run:
    li   t0, 1
    csrw 0x7E0, t0           # contar ciclos
    csrw 0x7E1, t0           # habilitar contador
    jal  inicializa_juego
bucle:
    jal  procesa_teclas
    li   a0, 100             # 100 ms entre movimientos
    jal  delay_ms            # llama a la rutina de retardo
    jal mueve_pelota         # Mueve la pelota
    j    bucle               # se repite el bucle principal




    # Fin. La pantalla conserva la imagen aunque el programa acabe.
    li a7, SYS_EXIT
    call os_ecall
finaliza:     j    finaliza                   # nunca llega aqui, pero evita warning de "no hay retorno"

# =====================================================================
# RUTINA DE PROCESAMIENTO DE TECLAS PULSADAS

procesa_teclas:
    addi sp, sp, -16
    sw   ra, 12(sp)
    li t0, 0X6009103C        # Direccion del registro de teclas
    lw t1, 0(t0)             # Lee el registro de teclas   
    not t1, t1               # Invierte los bits (0 = tecla pulsada)
    andi t2, t1, 0x4         # bit 2  (GPIO2)  -> 0 = pulsado
    bnez t2, izq_up
    andi t2, t1, 0x8         # bit 3  (GPIO3)
    bnez t2, izq_down
    li   t3, 0x40000         # bit 18 (GPIO18)
    and  t2, t1, t3
    bnez t2, der_up
    li   t3, 0x80000         # bit 19 (GPIO19)
    and  t2, t1, t3
    bnez t2, der_down
    j    fin_tecla           # ninguna pulsada


  izq_up:
    # Mueve la pala izquierda hacia arriba
#   **************************************************
#   CÓDIGO A COMPLETAR POR EL ALUMNO
#   **************************************************
    j fin_tecla



  izq_down:
    # Mueve la pala izquierda hacia abajo
#   **************************************************
#   CÓDIGO A COMPLETAR POR EL ALUMNO
#   **************************************************
    j fin_tecla


 der_up:
    # Mueve la pala derecha hacia arriba
#   **************************************************
#   CÓDIGO A COMPLETAR POR EL ALUMNO
#   **************************************************
    j fin_tecla


 der_down:
    # Mueve la pala derecha hacia abajo 
#   **************************************************
#   CÓDIGO A COMPLETAR POR EL ALUMNO
#   **************************************************
    j fin_tecla
 
    
  fin_tecla:  
  lw ra, 12(sp)
  addi sp, sp, 16
    ret

# =====================================================================
# RUTINA DE MOVIMIENTO DE LA PELOTA
 mueve_pelota:
    # Mueve la pelota en la dirección indicada por a5 (delta X) y a6 (delta Y)
    # a3 = X columna actual de la pelota  
    # a4 = Y fila actual de la pelota
    addi sp, sp, -16
    sw   ra, 12(sp)
#   **************************************************
#   CÓDIGO A COMPLETAR POR EL ALUMNO
#   **************************************************
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
# =====================================================================
# SUBRUTINAS A IMPLEMENTAR POR EL ALUMNO
#
#
# =====================================================================
# RUTINA DE INICIALIZACION DEL JUEGO

inicializa_juego:
    addi sp, sp, -16
    sw   ra, 12(sp)
    # Inicializa el juego
#   **************************************************
#   CÓDIGO A COMPLETAR POR EL ALUMNO
#   **************************************************
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# =====================================================================
# RUTINA DE RETARDO

delay_ms:                    # a0 = milisegundos
    addi sp, sp, -16
    sw   ra, 12(sp)
    li   t3, 160000          # ciclos por ms a 160 MHz
dly_ms:
    blez a0, dly_fin
    csrr t4, 0x7E2
dly_cnt:
    csrr t2, 0x7E2
    sub  t2, t2, t4
    bltu t2, t3, dly_cnt
    addi a0, a0, -1
    j    dly_ms
dly_fin:
    lw ra, 12(sp)
    addi sp, sp, 16
    ret



# =====================================================================
# os_ecall: 
# Llama a la funcion C os_syscall(a0..a7) y conserva todos los
# registros salvo a0 (que trae el resultado), igual que RARS.

os_ecall:
    addi sp, sp, -64
    sw   ra, 60(sp)
    sw   t0, 56(sp)
    sw   t1, 52(sp)
    sw   t2, 48(sp)
    sw   t3, 44(sp)
    sw   t4, 40(sp)
    sw   t5, 36(sp)
    sw   t6, 32(sp)
    sw   a1, 28(sp)
    sw   a2, 24(sp)
    sw   a3, 20(sp)
    sw   a4, 16(sp)
    sw   a5, 12(sp)
    sw   a6,  8(sp)
    sw   a7,  4(sp)
    call os_syscall
    lw   a7,  4(sp)
    lw   a6,  8(sp)
    lw   a5, 12(sp)
    lw   a4, 16(sp)
    lw   a3, 20(sp)
    lw   a2, 24(sp)
    lw   a1, 28(sp)
    lw   t6, 32(sp)
    lw   t5, 36(sp)
    lw   t4, 40(sp)
    lw   t3, 44(sp)
    lw   t2, 48(sp)
    lw   t1, 52(sp)
    lw   t0, 56(sp)
    lw   ra, 60(sp)
    addi sp, sp, 64
    ret