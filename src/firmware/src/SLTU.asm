.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test XORI */
    addi x1  , x1,        0b00000000000   /* x1  = 0b00000000000 */
    addi x2  , x2,        0b11111111111   /* x2  = 0b11111111111 */
    addi x3  , x3,        0b10101010101   /* x3  = 0b10101010101 */
    addi x4  , x4,        0b11100001111   /* x4  = 0b11100001111 */
    addi x5  , x5,        0b00011110000   /* x5  = 0b00011110000 */
    addi x6  , x6,        0b11001100110   /* x6  = 0b11001100110 */
    addi x7  , x7,        0b00110011001   /* x7  = 0b00110011001 */
    addi x8  , x8,        0b11111100000   /* x8  = 0b11111100000 */
    addi x9  , x9,        0b00000011111   /* x8  = 0b00000011111 */

    sltu x1  , x1, x2   /* x1  = 0b00000000000 */
    sltu x3  , x3, x2   /* x3  = 0b01010101010 */
    sltu x4  , x4, x2   /* x4  = 0b01110000111 */
    sltu x5  , x5, x2   /* x5  = 0b00001111000 */
    sltu x6  , x6, x2   /* x6  = 0b01100110011 */
    sltu x7  , x7, x2   /* x7  = 0b00011001100 */
    sltu x8  , x8, x2   /* x8  = 0b01111110000 */
    sltu x9  , x9, x2   /* x9  = 0b00000001111 */
