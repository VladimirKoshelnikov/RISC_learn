.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test SAVE_LOAD */
    addi x3 , x3,  0x28


            addi  x0 , x0, 1
            jal   x1 , label2   
            addi  x0 , x0, 1
            addi  x0 , x0, 1
label2:     addi  x0 , x0, 2
            jalr  x1,  0(x3)   
            addi  x0 , x0, 2
            addi  x0 , x0, 2  
            addi  x0 , x0, 3
            addi  x0 , x0, 2  
            addi  x0 , x0, 3
            auipc x4,  0xff   
            addi  x0 , x0, 4
            addi  x0 , x0, 4
            addi  x0 , x0, 5
            addi  x0 , x0, 5
            addi  x0 , x0, 6
            addi  x0 , x0, 6
