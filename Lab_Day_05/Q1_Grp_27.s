# Assignment 4
# Problem No 1
# Semester: 5
# Group No 27
# Sanskar Mittal (21CS10057)
# Yash Sirvi (21CS10083)

.data
num_prompt:
    .asciiz "Input a non negative number:"
ans_prompt:
    .asciiz "Final Sum: "
err_prompt:
    .asciiz "Error: n should be a positive integer\n"
.text 

.globl main
main:
    la $a0, num_prompt                              # Asks user for a positive number
    li $v0, 4
    syscall

    li $v0, 5                                       # read integer n
    syscall
    move $a0, $v0                                   # a0 =  n

    blt $a0, 1, err                                 # check if n < 0, show error
                                  
    jal sum_rec                                     # jump sum_rec and save position to $ra
    move $t0, $v0  

    la $a0, ans_prompt                              # Answer prompt
    li $v0, 4
    syscall

    li $v0, 1                                       # print the result
    move $a0, $t0
    syscall

    j exit                                          # return 0

sum_rec:
    addi $sp, $sp, -8                               # adjust stack pointer to store return address and argument
    sw $s0, 4($sp)  
    sw $ra, 0($sp)                                      
    bne $a0, 1, else                                # if n != 1, go to else condition
    addi $v0, $zero,1                               # set $v0 = 1
    j sum_ret                                       

else:
    move $s0, $a0                                   # s0 <- current n
    addi $a0, $a0, -1                               # decrement current n
    jal sum_rec

    move $a0, $s0                                   # a0 <- s0 (counter for power of n)
    add $a1, $zero, $a0                             # a1 <- a0 ( store n^i )
    move $a2, $a0                                   # a2 <- a0 ( store n)
    sub $a0, $a0, 1                                 # a0--
    jal power_sum                                   # calculate n^n
    
    addu $v0, $a1, $v0                              # sum(n) = n^n + sum(n-1)

sum_ret:
    lw $s0, 4($sp)                                  # restore old value of n
    lw $ra, 0($sp)                                  # return to old stack frame
    addi $sp, $sp, 8                                # move to new stack pointer
    jr $ra

power_sum:
    beq $a0, $zero, power_sum_ret                   # if count <- 0, return n^n
    multu $a1, $a2                                  # lo = n^i * n
    mflo $a1                                        # a1 = lo
    sub $a0, $a0, 1                                 # count--
    j power_sum             

power_sum_ret:
    jr $ra

err:                                                # show error if n < 1
    la $a0, err_prompt
    li $v0, 4
    syscall

exit:                                               # exit call
    li $v0, 10
    syscall