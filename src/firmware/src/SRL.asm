.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test XORI */
    addi x1  , x1,      0b00000000001   /* x1  = 0b00000000000 */
    addi x2  , x2,      0b11111111111   /* x2  = 0b11111111111 */
    addi x3  , x3,      0b10101010101   /* x3  = 0b10101010101 */
    addi x4  , x4,      0b11100001111   /* x4  = 0b11100001111 */
    addi x5  , x5,      0b00011110000   /* x5  = 0b00011110000 */
    addi x6  , x6,      0b11001100110   /* x6  = 0b11001100110 */
    addi x7  , x7,      0b00110011001   /* x7  = 0b00110011001 */
    addi x8  , x8,      0b11111100000   /* x8  = 0b11111100000 */
    addi x9  , x9,      0b00000011111   /* x8  = 0b00000011111 */

    srl x2  , x2,  x1   /* x1  = 0b11111111110 */
    srl x3  , x3,  x1   /* x1  = 0b01010101010 */
    srl x4  , x4,  x1   /* x1  = 0b11000011110 */
    srl x5  , x5,  x1   /* x1  = 0b00111100000 */
    srl x6  , x6,  x1   /* x1  = 0b10011001100 */
    srl x7  , x7,  x1   /* x1  = 0b01100110010 */
    srl x8  , x8,  x1   /* x1  = 0b11111000000 */
    srl x9  , x9,  x1   /* x1  = 0b00000111110 */
