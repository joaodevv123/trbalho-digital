main:
    addi $s0,$zero,0x10010000
    addi $s1, $zero, 18
    add $a0, $zero, $s0
    add $a1,$zero,$s1
    jal criar_vetor

    add $a0,$s0,$zero
    add $a1,$zero,$zero
    add $t0, $s1, -1
    add $a2,$zero,$t0
    jal mergesort 
    li $v0,10
    syscall

criar_vetor:    
    add $v0,$a0,$zero
    loop_cria_vetor:
    sw $a1,0($a0)
    addi $a0,$a0,4
    addi $a1,$a1,-1
    beq $a1,$zero,fim_cria_vetor
    j loop_cria_vetor
    fim_cria_vetor:
    jr $ra

mergesort:
    # b0 
    sw $fp,-4($sp)
    addi $fp,$sp,-4
    addi $sp,$sp,-24
    sw $ra,-4($fp)
    sw $a0,-8($fp)
    sw $a1,-12($fp)
    sw $a2,-16($fp)
    sw $s0,-20($fp)

    #b1
    bge $a1,$a2,retorno

    #b2
    add $s0,$a1,$a2
    srl $s0,$s0,1

    #b3
    add $a2,$s0,$zero
    jal mergesort

    #b4
    lw $a2,-16($fp)
    addi $a1,$s0,1
    jal mergesort

    #b5
    lw $a1,-12($fp)
    add $a3,$a2,$zero
    add $a2,$s0,$zero
    jal merge

    #b6
    retorno:
    lw $ra,-4($fp)
    lw $a0,-8($fp)
    lw $a1,-12($fp)
    lw $a2,-16($fp)
    lw $s0,-20($fp)
    addi $sp,$fp,4
    lw $fp,-4($sp)
    
    jr $ra

#a0 = vetor,a1=esquerda,a2 = meio,a3 = direita
merge:
    #t0 = esquerda(i)
    add $t0,$a1,$zero
    #t1 = meio + 1(j)
    addi $t1,$a2,1

    loopmerge:
        bgt $t0,$a2,fim
        bgt $t1,$a3,fim
            sll $t0,$t0,2
            sll $t1,$t1,2
            add $t2,$a0,$t0
            add $t3,$a0,$t1
            #t2 = v[i]
            lw $t2,0($t2)
            #t3 = v[j]
            lw $t3,0($t3)
            srl $t0,$t0,2
            srl $t1,$t1,2

            bgt $t2,$t3,else
            addi $t0,$t0,1
            j loopmerge
        else:
            add $t4,$t1,$zero
            loop2:
                ble $t4,$t0,fimloop2
                sll $t4,$t4,2
                add $t5,$a0,$t4
                lw $t6,0($t5)
                lw $t7,-4($t5)
                sw $t6,-4($t5)
                sw $t7,0($t5)
                srl $t4,$t4,2
                addi $t4,$t4,-1
                j loop2
            fimloop2:
                addi $t0,$t0,1
                addi $t1,$t1,1
                addi $a2,$a2,1
                j loopmerge
fim:
    jr $ra
