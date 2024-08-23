.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test XORI */
    addi x1  , x1,      0b00000000000   /* x1  = 0b00000000000 */
    addi x2  , x2,      0b11111111111   /* x2  = 0b11111111111 */
    addi x3  , x3,      0b10101010101   /* x3  = 0b10101010101 */
    addi x4  , x4,      0b11100001111   /* x4  = 0b11100001111 */
    addi x5  , x5,      0b00011110000   /* x5  = 0b00011110000 */
    addi x6  , x6,      0b11001100110   /* x6  = 0b11001100110 */
    addi x7  , x7,      0b00110011001   /* x7  = 0b00110011001 */
    addi x8  , x8,      0b11111100000   /* x8  = 0b11111100000 */
    addi x9  , x9,      0b00000011111   /* x8  = 0b00000011111 */

    srli x1  , x1,      0b00000000001   /* x1  = 0b00000000000 */
    srli x2  , x2,      0b00000000001   /* x2  = 0b01111111111 */
    srli x3  , x3,      0b00000000001   /* x3  = 0b01010101010 */
    srli x4  , x4,      0b00000000001   /* x4  = 0b01110000111 */
    srli x5  , x5,      0b00000000001   /* x5  = 0b00001111000 */
    srli x6  , x6,      0b00000000001   /* x6  = 0b01100110011 */
    srli x7  , x7,      0b00000000001   /* x7  = 0b00011001100 */
    srli x8  , x8,      0b00000000001   /* x8  = 0b01111110000 */
    srli x9  , x9,      0b00000000001   /* x9  = 0b00000001111 */
