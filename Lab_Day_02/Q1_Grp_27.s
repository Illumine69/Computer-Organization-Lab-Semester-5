
# Assignment 1
# Problem No 1
# Semester: 5
# Group No 27
# Sanskar Mittal (21CS10057)
# Yash Sirvi (21CS10083)

.data

str_prompt:                                         # input prompt
    .asciiz "Please enter an integer (x): "
out_msg1:                                           # output prompt 1
    .asciiz "\ne^x = "
out_msg2:                                           # output prompt 2
    .asciiz "\nnumber of iterations: = "
newline:                                    
    .asciiz "\n"
    
.text
.globl main
main:
    la $a0, str_prompt                              # Asks user for input of value of x
    li $v0, 4
    syscall

    li $v0, 5                                       # read integer
    syscall
    move $t1, $v0                                   # t1: x

    la $a0, out_msg1
    li $v0, 4
    syscall

    li $t0, 0                                       # t0: iterations(i), initialised to 0
    li $t2, 1                                       # t2: sum
    li $t3, 1                                       # t3: numerator
    li $t4, 1                                       # t4: denominator

Loop:
    addu $t0, $t0, 1                                # i += 1
    mul $t3, $t3, $t1                               # t3 = t3*x ( t3 becomes x^i)
    mul $t4, $t4, $t0                               # t4 *= t0 (t4 becomes i!)
    div $t3, $t4                                    # set lo = t3/t4
    mflo $t5                                        # t5 = lo
    beqz $t5, exit_loop                             # if t5 == 0 , exit the loop
    add $t2, $t2, $t5                               # sum += t5 (add value in sum)
    b Loop                                          # loop back to beginning

exit_loop:  
    move $a0, $t2                                   # Prints the final sum
    li $v0, 1
    syscall

    la $a0, out_msg2                                # Output prompt for number of iterations
    li $v0, 4
    syscall

    move $a0, $t0                                   # Prints the number of iterations
    li $v0, 1
    syscall

    la $a0, newline                                 # Add a new line
    li, $v0, 4
    syscall 

exit:
    li $v0, 10                                      # system exit call
    syscall