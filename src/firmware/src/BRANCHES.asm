global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test SAVE_LOAD */

    addi x1 , x1,  0x0f
    addi x2 , x2,  0xf0
    addi x3 , x3,  0xf0
    addi x4 , x4, -1

label1:     addi  x0 , x0, 1
            beq   x2,  x3, label2   
            addi  x0 , x0, 1
            addi  x0 , x0, 1
label2:     addi  x0 , x0, 2
            bne   x1,  x2, label3   
            addi  x0 , x0, 2
            addi  x0 , x0, 2
label3:     addi  x0 , x0, 3
            blt   x1,  x2, label4   
            addi  x0 , x0, 3
            addi  x0 , x0, 3
label4:     addi  x0 , x0, 4
            bge   x2,  x1, label5   
            addi  x0 , x0, 4
            addi  x0 , x0, 4
label5:     addi  x0 , x0, 5 
            bltu  x2,  x1, label6   
            addi  x0 , x0, 5
            addi  x0 , x0, 5
label6:     addi  x0 , x0, 6  
            bgeu  x2,  x1, label1  
            addi  x0 , x0, 6
            addi  x0 , x0, 6
