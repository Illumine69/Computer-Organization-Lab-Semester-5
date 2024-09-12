# Binary search in mips

# Load numbers 1 to 10 in memory
#1: 
addi $1, 1
#2: 
st $1, 1, $0
#3: 
addi $1, 2
#4: 
st $1, 2, $0
#5: 
addi $1, 3
#6: 
st $1, 3, $0
#7: 
addi $1, 4
#8: 
st $1, 4, $0
#9: 
addi $1, 5
#10: 
st $1, 5, $0
#11: 
addi $1, 6
#12: 
st $1, 6, $0
#13: 
addi $1, 7
#14: 
st $1, 7, $0
#15: 
addi $1, 8
#16: 
st $1, 8, $0
#17: 
addi $1, 9
#18: 
st $1, 9, $0
#19: 
addi $1, 10
#20: 
st $1, 10, $0

# Branch to main
#21: 
br 54

# Binary Search
# Final result will be available in $1, if found 1 else -1

# Initialise lo($7) to 1 and hi($8) to 10
#22: 
compi $7, -1
#23: 
compi $8, -10

# Check if (hi-lo) >= 0, if not break out and anster is -1
#24: 
xor $15, $15 # $15 = 0
#25: 
add $15, $8 # $15 = hi
#26: 
xor $16, $16 # $16 = 0
#27: 
not $16, $7 # $16 = - lo
#28: 
add $15, $16 # $15 = hi - lo
#29: 
bmi $15, 52 # if hi - lo < 0, break out

# Calculate mid = (lo + hi) / 2
#30: 
xor $15, $15 # $15 = 0
#31: 
add $15, $7 # $15 = lo
#32: 
xor $16, $16 # $16 = 0
#33: 
add $16, $8 # $16 = hi
#34: 
add $15, $16 # $15 = lo + hi
#35: 
srai $15, 1 # $15 = (lo + hi) / 2

# Load number at memory location mid in $17
#36: 
lw $17, 0, $15

# Take xor with the number to find, if xor 0 means number found
#37: 
xor $18, $18
#38: 
add $18, $17
#39: 
xor $18, $2
#40: 
bz $18, 50 # if xor 0, break out

# Otherwise check if number at mid is less than number to find
#41: 
not $18, $2 # $18 = - number to find
#42: 
add $18, $17 # $18 = number at mid - number to find
#43: 
bmi $18, 47 # if number at mid < number to find, set lo = mid + 1

# Otherwise set hi = mid - 1
#44: 
compi $8, 1
#45: 
add $8, $15
#46: 
br 24

# Set lo = mid + 1
#47: 
compi $7, -1
#48: 
add $7, $15
#49: 
br 24

# Successful exit
#50: 
addi $1, 1
#51: 
br 53

# Unsuccessful exit
#52: 
addi $1, -1

# Return
#53:
br $31

# Main
#54:

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 1 # try to find 1
bl 22 # call binary search

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 2 # try to find 2
bl 22 # call binary search

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 3 # try to find 3
bl 22 # call binary search

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 15 # try to find 15
bl 22 # call binary search

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 47 # try to find 47
bl 22 # call binary search

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 55 # try to find 55
bl 22 # call binary search

# Clear $2 and $1
xor $2, $2
xor $1, $1
addi $2, 0 # try to find 0
bl 22 # call binary search

# add this extra newline
