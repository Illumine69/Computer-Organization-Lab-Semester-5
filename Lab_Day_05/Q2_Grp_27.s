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
    .asciiz "Number of Steps: "
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

    addi $t2, $zero, 2                              # store t2 <- 2 for global use
    addi $t3, $zero, 3                              # store t3 <- 3 for global use
    jal collatz                                     # jump collatz and save position to $ra
    move $t0, $v0                                   

    la $a0, ans_prompt                              # Answer prompt
    li $v0, 4
    syscall

    li $v0, 1                                       # print the result
    move $a0, $t0
    syscall
    
    j exit                                          # return 0

collatz:                                            # recursive function to find collatz steps

    addi $sp, $sp, -4                               # adjust stack pointer to store return argument
    sw $ra, 0($sp)
    bne $a0, 1, check_odd                           # if n != 1, check if n is odd or even 
    move $v0, $zero                                 # base case to return 0
    j collatz_ret

check_odd:                                          # if n is odd, n <-- 3*n +1
    div $a0, $t2                                    # hi <-- n % 2
    mfhi $t4                                        # t4 <-- hi
    beq $t4, 0, else                                # if t4 is even, go to else condition

    # since n is odd, n <- 3 * n + 1
    multu $a0, $t3                                  
    mflo $a0
    addi $a0, $a0, 1
    jal collatz         
                            
    addi $v0, $v0, 1                                # add 1 to step count
    j collatz_ret

else:                                               # set n <- n/2 if n is even
    div $a0, $t2 
    mflo $a0
    jal collatz 
    addi $v0, $v0, 1                                # add 1 to step count

collatz_ret:
    lw $ra, 0($sp)                                  # return to old stack
    addi $sp, $sp, 4
    jr $ra

err:                                                # show error if n < 1
    la $a0, err_prompt
    li $v0, 4
    syscall

exit:                                               # exit call
    li $v0, 10
    syscall