.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test SAVE_LOAD */

    addi x1 , x1, 0xa0
    lui  x2 , 0xfffff

    sb  x2, 0(x1)   
    sh  x2, 4(x1)   
    sw  x2, 8(x1)   
    sw  x2, 12(x1)   
    sw  x2, 16(x1)   

    lb  x3, 0(x1)    
    lh  x3, 4(x1)    
    lw  x3, 8(x1)    
    lbu x3, 12(x1)     
    lhu x3, 16(x1)     

