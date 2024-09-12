
# Assignment 2
# Problem No 1
# Semester: 5
# Group No 27
# Sanskar Mittal (21CS10057)
# Yash Sirvi (21CS10083)


# INPUT FORMAT:
# n1n2n3.
# end the input with a dot
# eg: 123.
.data

str_prompt:                                         # asking user for number of cycles in a permutation
    .asciiz "Enter no of cycles in permutation : "
out_msg1:                                           # asking user to enter a particular cycle
    .asciiz "Enter cycle:  "
out_msg2:                                           # output for product permutation cycle
    .asciiz "Product permutation cycle "
out_msg3:                                           # 2nd half of the output string
    .asciiz "is :"                  
newline:                                    
    .asciiz "\n"                                    # newline
err_msg1:
    .asciiz "Wrong Cycle\n"                         # error message when user inputs an invalid cycle. eg: 1233.
.align 4                                            # aligning memory addresses
arr1:                                               # allocating space for array1: this will store the mapping for 1st permutation
    .space 40                                       
.align 4
arr2:                                               # allocating space for array1: this will store the mapping for 2nd permutation
    .space 40
.align 4
arr3:                                               # allocating space for array1: this will store the mapping for 3rd permutation
    .space 40
.align 4
input:                                              # space for input string
    .space 40
.align 4

.text
.globl main
main:
    la $a0, str_prompt                              # Asks user for input of cycle number
    li $v0, 4
    syscall

    li $v0, 5                                       # read integer
    syscall
    move $t1, $v0                                   # t1: num_cycle_1

# INITIALISING ALL THE ARRAYS WITH HEX VALUE 10. WILL BECOME USEFUL WHILE CHECKING FOR INVALID CYCLES
    li $t2, 0   # counter
    li $t7, 10  # value to be stored
init_arr1:
    sw $t7, arr1($t2)   # store word, value of $t7 into address arr1+($t2)
    add $t2, $t2, 4     # increase counter by 4
    beq $t2, 40, end_i1 # exit if 10 inits have been made
    j init_arr1
end_i1:
li $t2, 0
# repeat init for arr2 and arr3
init_arr2:
    sw $t7, arr2($t2)
    add $t2, $t2, 4
    beq $t2, 40, end_i2
    j init_arr2
end_i2:
li $t2, 0
init_arr3:
    sw $t7, arr3($t2)
    add $t2, $t2, 4
    beq $t2, 40, end_i3
    j init_arr3
end_i3:



cycle_loop1:                                        # Taking cycles as input
    beqz $t1, end_c1
    la $a0, out_msg1
    li $v0, 4
    syscall
    
    la $a0, input
    li $a1, 11 
    li $v0, 8
    syscall

    la $t2, input
    la $t3, arr1

    # Start mapping the cycles into the map
    map_loop1:
        addi $t2, $t2, 1    # counter
        # load byte stored at $t2 to $t4, mask the lower 4 bits to get the number stored in the byte
        lb $t4, ($t2)       
        beq $t4, 0x2E, end_m1 # if character stored is a dot character (0x2E), end the loop
        # t4 = arr1[i], t5 = arr[i-1]
        and $t4, $t4, 0x0F
        lb $t5, -1($t2)
        and $t5, $t5, 0x0F
        sll $t5, $t5, 2 # get address by multiplying by 4 or left shifting by 2
        # add $t5, $t5, $t
        lw $t6, arr1($t5)
        ble $t6, 9, error_m1    # if a map already exists, print error.
        sw $t4, arr1($t5)
        j map_loop1 # loop
    end_m1:
    # handle the last input
        lb $t5, -4($t2)
        and $t5, $t5, 0x0F
        sll $t5, $t5, 2
        # add $t5, $t5, $t3
        lw $t6, arr1($t5)
        ble $t6, 9, error_m1
        lw $t4, input($0) # get the first char
        and $t4, $t4, 0x0F
        sw $t4, arr1($t5)   # store the map of last input to first input
        sub $t1, $t1, 1
        j cycle_loop1
    error_m1:
        la $a0, err_msg1 # print error message
        li $v0, 4
        syscall
end_c1:
# REPEAT FOR 2nd PERMUTATION

    la $a0, str_prompt                              # Asks user for input of cycle number
    li $v0, 4
    syscall

    li $v0, 5                                       # read integer
    syscall
    move $t1, $v0                                   # t1: num_cycle_2

cycle_loop2:                                        # Taking cycles as input
    beqz $t1, end_c2
    la $a0, out_msg1
    li $v0, 4
    syscall
    
    la $a0, input
    li $a1, 11 
    li $v0, 8
    syscall

    la $t2, input
    la $t3, arr2

    map_loop2:
        addi $t2, $t2, 1
        lb $t4, ($t2)
        beq $t4, 0x2E, end_m2
        and $t4, $t4, 0x0F
        lb $t5, -1($t2)
        and $t5, $t5, 0x0F
        sll $t5, $t5, 2
        # add $t5, $t5, $t
        lw $t6, arr2($t5)
        ble $t6, 9, error_m2
        sw $t4, arr2($t5)
        j map_loop2
    end_m2:
        lb $t5, -4($t2)
        and $t5, $t5, 0x0F
        sll $t5, $t5, 2
        # add $t5, $t5, $t3
        lw $t6, arr2($t5)
        ble $t6, 9, error_m2
        la $t2, input
        lw $t4, input($0)
        and $t4, $t4, 0x0F
        sw $t4, arr2($t5)
        sub $t1, $t1, 1
        j cycle_loop2
    error_m2:
        la $a0, err_msg1
        li $v0, 4
        syscall
end_c2:

    li $t2, 0

# HANDLE SINGLE CYCLES
single_cycle1:
    beq $t2, 10, end_cyc1
    sll $t5, $t2, 2
    lw $t6, arr1($t5)
    bgt $t6, 9, init1   # if the number is not mapped to anything, map it to itself
    add $t2, $t2, 1
    j single_cycle1
init1:
    sw $t2, arr1($t5)
    add $t2, $t2, 1
    j single_cycle1
end_cyc1:

# REPEAT SINGLE CYCLE HANDLING FOR 2nd ARRAY
li $t2, 0
single_cycle2:
    beq $t2, 10, end_cyc2
    sll $t5, $t2, 2
    lw $t6, arr2($t5)
    bgt $t6, 9, init2
    add $t2, $t2, 1
    j single_cycle2
init2:
    sw $t2, arr2($t5)
    add $t2, $t2, 1
    j single_cycle2
end_cyc2:

li $t2, 0

perm_count:
    beq $t2, 40, end_per
    lw $t4, arr1($t2)
    lw $t4, arr2($t4)
    sw $t4, arr3($t2)
    add $t2, $t2, 4
    j perm_count
end_per:
    j exit_loop


# end2:
#     la $a0, str_prompt                              # Asks user for input of cycle number
#     li $v0, 4
#     syscall#
#     li $v0, 5                                       # read integer
#     syscall
#     move $t1, $v0                                   # t1: num_cycle_2#
# cycle_loop2:
#     beqz $t1, end
#     la $a0, out_msg1
#     li $v0, 4
#     syscall
#     sub $t1, $t1, 1
#     j cycle_loop2






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