/* =====================================================================
 * main.c  -  "Sistema operativo" minimo para programas en ensamblador
 *
 * Este fichero SOLO hace dos cosas:
 *   1. Arrancar el hardware (bus I2C, pantalla SSD1306, pines de botones).
 *   2. Atender llamadas al sistema al estilo RARS mediante os_syscall().
 *
 * Toda la logica (juego, tiles, botones, retardos) esta en miprograma.S.
 * ===================================================================== */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "driver/gpio.h"
#include "driver/i2c_master.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_check.h"

#define PIN_SDA   6
#define PIN_SCL   7
#define OLED_ADDR 0x3C

/* Solo para configurarlos como entrada con pull-up.
   La LECTURA la hace miprograma.S directamente. Deben coincidir con miprograma.S */
#define BTN_P1_UP    2
#define BTN_P1_DOWN  3
#define BTN_P2_UP   18
#define BTN_P2_DOWN 19

/* Numeros de servicio (los mismos que en RARS cuando existen) */
enum {
    SYS_PRINT_INT  = 1,
    SYS_PRINT_STR  = 4,
    SYS_EXIT       = 10,
    SYS_PRINT_CHAR = 11,
    SYS_PRINT_HEX  = 34,
    SYS_OLED_TILE  = 100,   /* a0 = col 0..15, a1 = fila 0..7, a2 = &8 bytes */
    SYS_OLED_CLEAR = 101,
    SYS_OLED_FLUSH = 102,   /* a0 = &buffer de 1024 bytes                     */
};

extern void game_run(void);                 /* miprograma.S, no vuelve */

static i2c_master_dev_handle_t dev;

/* ------------------------- controlador SSD1306 ------------------------ */
static esp_err_t oled_cmd(const uint8_t *c, size_t n)
{
    uint8_t buf[8];
    buf[0] = 0x00;                          /* byte de control: comandos */
    memcpy(buf + 1, c, n);
    esp_err_t r = i2c_master_transmit(dev, buf, n + 1, 100);
    if (r != ESP_OK) printf("oled_cmd: %s\n", esp_err_to_name(r));
    return r;
}

static void oled_init(void)
{
    static const uint8_t init[] = {
        0xAE, 0xD5,0x80, 0xA8,0x3F, 0xD3,0x00, 0x40, 0x8D,0x14,
        0x20,0x02, 0xA1, 0xC8, 0xDA,0x12, 0x81,0xCF, 0xD9,0xF1,
        0xDB,0x40, 0xA4, 0xA6, 0xAF };
    size_t i = 0;
    while (i < sizeof init) {
        uint8_t op = init[i];
        size_t n = (op == 0xD5 || op == 0xA8 || op == 0xD3 || op == 0x8D ||
                    op == 0x20 || op == 0xDA || op == 0x81 || op == 0xD9 ||
                    op == 0xDB) ? 2 : 1;
        oled_cmd(&init[i], n);
        i += n;
    }
}

/* Coloca el puntero de escritura en (pagina, columna de pixel) */
static esp_err_t oled_set_pos(int page, int x)
{
    uint8_t c[3] = { (uint8_t)(0xB0 | page),
                     (uint8_t)(x & 0x0F),
                     (uint8_t)(0x10 | (x >> 4)) };
    return oled_cmd(c, 3);
}

static esp_err_t oled_data(const uint8_t *d, size_t n)   /* n <= 128 */
{
    uint8_t buf[129];
    buf[0] = 0x40;                          /* byte de control: datos */
    memcpy(buf + 1, d, n);
    esp_err_t r = i2c_master_transmit(dev, buf, n + 1, 100);
    if (r != ESP_OK) printf("oled_data: %s\n", esp_err_to_name(r));
    return r;
}

static int oled_tile(int col, int row, const uint8_t *t)
{
    if (col < 0 || col > 15 || row < 0 || row > 7 || t == NULL) return -1;
    if (oled_set_pos(row, col * 8) != ESP_OK) return -1;
    return oled_data(t, 8) == ESP_OK ? 0 : -1;
}

static int oled_flush(const uint8_t *fb)
{
    if (fb == NULL) return -1;
    for (int p = 0; p < 8; p++) {
        if (oled_set_pos(p, 0) != ESP_OK) return -1;
        if (oled_data(fb + p * 128, 128) != ESP_OK) return -1;
    }
    return 0;
}

static int oled_clear(void)
{
    static const uint8_t zero[1024];
    return oled_flush(zero);
}

/* ------------------------- llamadas al sistema ------------------------ */
/* Desde ensamblador: a7 = servicio, a0..a2 = argumentos.
   Por la convencion de llamada RISC-V, a0..a7 llegan aqui como los
   8 primeros argumentos. El valor devuelto vuelve en a0.
   (Se usa desde el envoltorio os_ecall de miprograma.S, que preserva el
   resto de registros como hace RARS.) */
int32_t os_syscall(int32_t a0, int32_t a1, int32_t a2, int32_t a3,
                   int32_t a4, int32_t a5, int32_t a6, int32_t a7)
{
    (void)a3; (void)a4; (void)a5; (void)a6;

    switch (a7) {
    case SYS_PRINT_INT:  printf("%ld", (long)a0);                  break;
    case SYS_PRINT_HEX:  printf("0x%08lx", (unsigned long)a0);     break;
    case SYS_PRINT_CHAR: putchar((char)a0);                        break;
    case SYS_PRINT_STR:  fputs((const char *)(uintptr_t)a0, stdout); break;

    case SYS_OLED_TILE:
        return oled_tile(a0, a1, (const uint8_t *)(uintptr_t)a2);
    case SYS_OLED_CLEAR:
        return oled_clear();
    case SYS_OLED_FLUSH:
        return oled_flush((const uint8_t *)(uintptr_t)a0);

    case SYS_EXIT:
        printf("\n[programa terminado]\n");
        fflush(stdout);
        vTaskDelete(NULL);                  /* no vuelve */
        break;

    default:
        printf("\n[syscall desconocida: %ld]\n", (long)a7);
        return -1;
    }
    fflush(stdout);
    return a0;                              /* los print no cambian a0 */
}

/* ------------------------------ arranque ------------------------------ */
void app_main(void)
{
    i2c_master_bus_config_t bc = {
        .clk_source = I2C_CLK_SRC_DEFAULT, .i2c_port = -1,
        .sda_io_num = PIN_SDA, .scl_io_num = PIN_SCL,
        .glitch_ignore_cnt = 7, .flags.enable_internal_pullup = true };
    i2c_master_bus_handle_t bus;
    ESP_ERROR_CHECK(i2c_new_master_bus(&bc, &bus));
    i2c_device_config_t dc = {
        .dev_addr_length = I2C_ADDR_BIT_LEN_7,
        .device_address = OLED_ADDR, .scl_speed_hz = 400000 };
    ESP_ERROR_CHECK(i2c_master_bus_add_device(bus, &dc, &dev));
    oled_init();

    gpio_config_t io = {
        .pin_bit_mask = (1ULL << BTN_P1_UP) | (1ULL << BTN_P1_DOWN) |
                        (1ULL << BTN_P2_UP) | (1ULL << BTN_P2_DOWN),
        .mode = GPIO_MODE_INPUT, .pull_up_en = GPIO_PULLUP_ENABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE, .intr_type = GPIO_INTR_DISABLE };
    ESP_ERROR_CHECK(gpio_config(&io));

    game_run();                             /* el control pasa a miprograma.S */
}
