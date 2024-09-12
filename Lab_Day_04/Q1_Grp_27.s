# Assignment 3
# Problem No 1
# Semester: 5
# Group No 27
# Sanskar Mittal (21CS10057)
# Yash Sirvi (21CS10083)

.data
num_prompt:
    .asciiz "Input a non negative number:"
arr_prompt:
    .asciiz "Enter the array:\n"
index_prompt:
    .asciiz "Enter the number at index "
index_prompt2:
    .asciiz " : "
ans_prompt:
    .asciiz "Final Max Circular Array Sum: "
.text 

.globl main
main:
    la $a0, num_prompt                              # Asks user for the length of the array
    li $v0, 4
    syscall

    li $v0, 5                                       # read integer
    syscall
    move $s0, $v0                                   # s0 = len(arr)

    sll $t2, $s0, 2                                 # allocate dynamic space to t2
    add $t2, $t2, $sp                               # t2 is final address of array
    add $t1, $zero, $sp                             # t1 is starting address of array

    la $a0, arr_prompt                              # Asks user for the array
    li $v0, 4
    syscall

    li $t7, 0                                       # t7 = total sum of array
    li $t4, 0                                       # t4 = index of current element in the array

read_arr:
    la $a0, index_prompt                            # Asks user for the array
    li $v0, 4
    syscall

    move $a0, $t4                                   # prints the index number of current element           
    li $v0, 1
    syscall

    la $a0, index_prompt2                           # Asks user for the array element at position i
    li $v0, 4
    syscall

    li $v0, 5                                       # read integer
    syscall

    move $t3, $v0                                   # t3 = current input element
    add $t7, $t7, $t3                               # sum += t3
    sw $t3, ($t1)                                   # t1 is the current stack location

    addi $t1, $t1, 4
    addi $t4, $t4, 1
    beq $t1, $t2, max_cir_sum                       # if last element is taken as input , exit loop
    j read_arr


max_cir_sum:
    add $t1, $zero, $sp                             # t1 = address of starting element of array
    li $t3, -1024                                   # t3 = maximum sum encountered so far in the array (initialised with minimum val of -1024)
    li $t4, -1024                                   # t4 = maximum current value
    li $t5, 1024                                    # t5 = minimum sum encountered so far in the array (initialised with maximum val of 1024)
    li $t6, 1024                                    # t6 = minimum current value

sum_loop:

    lw $t8, ($t1)                                   # t8 = arr[i]

    add $t9, $t8, $t4                               # t9 = max_current_val + a[i]

    jal check_max_curr                              # t4 = max(t4 + a[i], a[i])
    jal check_max_sum                               # t3 = max(t3, t4)

    add $t9, $t8, $t6
    jal check_min_curr
    jal check_min_sum

    add $t1, $t1, 4
    beq $t1, $t2, check_ans
    j sum_loop

check_max_curr:
    bgt $t8, $t9, set_max_curr                      # if (arr[i] > max_current_val + a[i] , set t3 = arr[i])
    move $t4, $t9                                   # else, set t4 = max_current_val + a[i]
    jr $ra

set_max_curr:
    move $t4, $t8                                   # set t4 = arr[i]
    jr $ra

check_max_sum:
    bgt $t4, $t3, set_max_sum                       # if (max_current_val > max_sum_so_far, set t3 = max_current_val)
    jr $ra

set_max_sum:
    move $t3, $t4                                   # t3 = t4
    jr $ra

check_min_curr:
    blt $t8, $t9, set_min_curr                      # if (arr[i] < min_current_val + a[i] , set t6 = arr[i])
    move $t6, $t9                                   # else, set t6 = min_current_val + a[i]
    jr $ra

set_min_curr:
    move $t6, $t8                                   # set t6 = arr[i]
    jr $ra

check_min_sum:
    blt $t6, $t5, set_min_sum                       # if (min_current_val < min_sum_so_far, set t5 = min_current_val)
    jr $ra

set_min_sum:
    move $t5, $t6                                   # t5 = t6
    jr $ra

check_ans:
    sub $t1, $t7, $t5                               # t1 = total_array_sum - min_sum_of_array
    bgt $t1, $t3, result                            # if(t1 > max_sum_of_array, return t1) 
    move $t1, $t3                                   # else t1 = max_sum_of_array
result:
    la $a0, ans_prompt                              # Give output message of largest circular subarray sum
    li $v0, 4
    syscall

    move $a0, $t1                                   # print max_subarray_sum
    li $v0, 1
    syscall

exit:
    li $v0, 10                                      # system exit call
    syscall