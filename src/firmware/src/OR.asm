.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test XORI */
    addi x1  , x0,      0b00000000000   /* x1  = 0b00000000000 */
    addi x2  , x0,      0b11111111111   /* x2  = 0b11111111111 */
    addi x3  , x0,      0b10101010101   /* x3  = 0b10101010101 */
    addi x4  , x0,      0b11100001111   /* x4  = 0b11100001111 */
    addi x5  , x0,      0b00011110000   /* x5  = 0b00011110000 */
    addi x6  , x0,      0b11001100110   /* x6  = 0b11001100110 */
    addi x7  , x0,      0b00110011001   /* x7  = 0b00110011001 */
    addi x8  , x0,      0b11111100000   /* x8  = 0b11111100000 */
    addi x9  , x0,      0b00000011111   /* x8  = 0b00000011111 */
 
    OR x3  , x2, x1   
    OR x4  , x3, x2   
    OR x5  , x4, x3   
    OR x6  , x5, x4  
    OR x7  , x6, x5   
    OR x8  , x7, x6   
    OR x9  , x8, x7   