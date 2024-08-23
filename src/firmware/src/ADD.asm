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
 
    add x3  , x2, x2   
    add x4  , x3, x3   
    add x5  , x4, x4   
    add x6  , x5, x5   
    add x7  , x6, x6   
    add x8  , x7, x7   
    add x9  , x8, x8   


    add x10  , x9,   x9
    add x11  , x10,  x10
    add x12  , x11,  x11   
    add x13  , x12,  x12   
    add x14  , x13,  x13   
    add x15  , x14,  x14   
    add x16  , x15,  x15   
    add x17  , x16,  x16   
    add x18  , x17,  x17   
    add x19  , x18,  x18  
    add x20  , x19,  x19   


    add x21  , x20,  x20
    add x22  , x21,  x21   
    add x23  , x22,  x22   
    add x24  , x23,  x23   
    add x25  , x24,  x24   
    add x26  , x25,  x25   
    add x27  , x26,  x26   
    add x28  , x27,  x27   
    add x29  , x28,  x28  
    add x30  , x29,  x29   

    add x31  , x29,  x29   