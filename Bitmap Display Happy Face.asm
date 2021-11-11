# File: Bitmap Display Happy Face.asm
# Author: Cameron Baker with init from Professor Meacham
# Date: Nov. 11, 2021
# Purpose: Draws a face on the bitmap display. TOTAL ELEMENTS: 12

# Task 1.  Write a function that returns the base address given row,col
# Task 2.  Write a function that draws a vertical line
# Task 3.  Write a function that draws a diagonal line from upper left to lower right
# Task 4.  Draw a picture.

# Assume Unit Width 8,  Display Width 256.  Base address is static data

.eqv BIT_MAP_ADDR 0x10010000  # Base address for bit display
.eqv RED   0x00ff0000
.eqv GREEN 0x0000ff00
.eqv BLUE  0x000000ff

.text
  .globl main
main:

  li $s0, BIT_MAP_ADDR       # Let's store our base address of the bitmap array in $s0
  li $s1, GREEN                      # 0x00RRGGBB  1 byte for red, 1 for green 1 for blue
  li $s2, BLUE
  li $s3, RED
  
  li $a0, 8 			# Set row
  li $a1, 8 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, RED			# Set color
  li $a2, 4       	# Set length
  jal DRAW_HORIZ_LINE
  
  li $a0, 8 			# Set row
  li $a1, 19 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, RED			# Set color
  li $a2, 4       	# Set length
  jal DRAW_HORIZ_LINE

  li $a0, 12 			# Set row
  li $a1, 15 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, GREEN		# Set color
  li $a2, 2       	# Set length
  jal DRAW_VERTICAL_LINE
  
  li $a0, 24 			# Set row
  li $a1, 8 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 15       	# Set length
  jal DRAW_HORIZ_LINE
  
  li $a0, 20 			# Set row
  li $a1, 8 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 15       	# Set length
  jal DRAW_HORIZ_LINE
  
  li $a0, 17 			# Set row
  li $a1, 5 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 3       	# Set length
  jal DRAW_DIAG_DOWN_LINE
  
  li $a0, 22 			# Set row
  li $a1, 6 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 2       	# Set length
  jal DRAW_DIAG_DOWN_LINE
  
  li $a0, 19 			# Set row
  li $a1, 23 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 3       	# Set length
  jal DRAW_DIAG_UP_LINE
  
  li $a0, 23 			# Set row
  li $a1, 23 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 2       	# Set length
  jal DRAW_DIAG_UP_LINE
  
  li $a0, 19 			# Set row
  li $a1, 6 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 3       	# Set length
  jal DRAW_VERTICAL_LINE
  
  li $a0, 19 			# Set row
  li $a1, 24 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 3       	# Set length
  jal DRAW_VERTICAL_LINE

  li $a0, 13 			# Set row
  li $a1, 13 			# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, GREEN		# Set color
  li $a2, 3       	# Set length
  jal DRAW_DIAG_UP_LINE
  
  li $s4, 0
  li $s6, 10
  TEETH_LOOP:
  slti $s5, $s4, 3 # Number of teeth lines
  beq $s5, $zero, END_TEETH_LOOP
  
  li $a0, 21 			# Set row
  move $a1, $s6 		# Set column
  jal LOC_TO_ADDR 	# Find base address
  move $a1, $v0 		# Move base address to $a1
  li $a0, BLUE			# Set color
  li $a2, 3       	# Set length
  jal DRAW_VERTICAL_LINE
 
  addi $s6, $s6, 5 # Teeth offset
  addi $s4, $s4, 1
  
  b TEETH_LOOP
  
  END_TEETH_LOOP:

  
  # Quit
  li $v0, 10
  syscall


  # Draw Horizontal Line
  # Color - $a0 - Use $s0
  # Starting Location - Base - $a1 - $s1
  # Length - $a2 - $s2
.text
  DRAW_HORIZ_LINE:  
    #Prolog
    sub $sp, $sp, 16        # Need to store four words
    sw  $ra, 0($sp)
    sw  $s0, 4($sp)
    sw  $s1, 8($sp)
    sw  $s2, 12($sp)
    
    # Logic
    move $s0, $a0   # Color  
    move $s1, $a1   # Base
    move $s2, $a2   # Length
    
    li $t0, 0       # i = 0
DHL_FOR_LOOP:
    slt $t1, $t0, $s2  # As long as $t0 is < $s2
    beq $t1, $zero, DHL_END_FOR_LOOP 
      sw $s0, 0($s1)   # Write to the screen
      
      addi $t0, $t0, 1    # i++
      addi $s1, $s1, 4  # Increment our pointer
      b DHL_FOR_LOOP

DHL_END_FOR_LOOP:
    # Epilog
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra
    
    
  # Draw Vertical Line
  # Color - $a0 - Use $s0
  # Starting Location - Base - $a1 - $s1
  # Length - $a2 - $s2
.text
  DRAW_VERTICAL_LINE:  
    #Prolog
    sub $sp, $sp, 16        # Need to store four words
    sw  $ra, 0($sp)
    sw  $s0, 4($sp)
    sw  $s1, 8($sp)
    sw  $s2, 12($sp)
    
    # Logic
    move $s0, $a0   # Color  
    move $s1, $a1   # Base
    move $s2, $a2   # Length
    
    li $t0, 0       # i = 0
DVL_FOR_LOOP:
    slt $t1, $t0, $s2  # As long as $t0 is < $s2
    beq $t1, $zero, DVL_END_FOR_LOOP 
      sw $s0, 0($s1)   # Write to the screen
      addi $t0, $t0, 1    # i++
      addi $s1, $s1, 128  # Increment our pointer
      b DVL_FOR_LOOP

DVL_END_FOR_LOOP:
    # Epilog
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16 
    jr $ra
   
  # Draw Diagonal Down Line
  # Color - $a0 - Use $s0
  # Starting Location - Base - $a1 - $s1
  # Length - $a2 - $s2
.text
  DRAW_DIAG_DOWN_LINE:  
    #Prolog
    sub $sp, $sp, 16        # Need to store four words
    sw  $ra, 0($sp)
    sw  $s0, 4($sp)
    sw  $s1, 8($sp)
    sw  $s2, 12($sp)
    
    # Logic
    move $s0, $a0   # Color  
    move $s1, $a1   # Base
    move $s2, $a2   # Length
    
    li $t0, 0       # i = 0
DDDL_FOR_LOOP:
    slt $t1, $t0, $s2  # As long as $t0 is < $s2
    beq $t1, $zero, DDDL_END_FOR_LOOP 
      sw $s0, 0($s1)   # Write to the screen
      addi $t0, $t0, 1    # i++
      addi $s1, $s1, 132  # Increment our pointer
      b DDDL_FOR_LOOP

DDDL_END_FOR_LOOP:
    # Epilog
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16 
    jr $ra
  
  # Draw Diagonal Up Line
  # Color - $a0 - Use $s0
  # Starting Location - Base - $a1 - $s1
  # Length - $a2 - $s2
.text
  DRAW_DIAG_UP_LINE:  
    #Prolog
    sub $sp, $sp, 16        # Need to store four words
    sw  $ra, 0($sp)
    sw  $s0, 4($sp)
    sw  $s1, 8($sp)
    sw  $s2, 12($sp)
    
    # Logic
    move $s0, $a0   # Color  
    move $s1, $a1   # Base
    move $s2, $a2   # Length
    
    li $t0, 0       # i = 0
DDUL_FOR_LOOP:
    slt $t1, $t0, $s2  # As long as $t0 is < $s2
    beq $t1, $zero, DDUL_END_FOR_LOOP 
      sw $s0, 0($s1)   # Write to the screen
      addi $t0, $t0, 1    # i++
      subi $s1, $s1, 124  # Increment our pointer
      b DDUL_FOR_LOOP

DDUL_END_FOR_LOOP:
    # Epilog
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16 
    jr $ra
  
  # Given row and column location return base address in $v0
  # Rows and columns are from 0 to 31
  # Row - $a0 - $s0
  # Column - $a1 - $s1
.text
	LOC_TO_ADDR:
		#Prolog
		sub $sp, $sp, 12
		sw  $ra, 0($sp)
		sw  $s0, 4($sp)
		sw  $s1, 8($sp)
		
		# Logic
		li $v0, BIT_MAP_ADDR # Load base address
		li $t0, 4 # Word offset
		li $t1, 128 # Vertical offset
		
		mult $a0, $t1 # Find vertical pos
		mflo $t2 # Move vertical pos to $t2
		add $v0, $v0, $t2 # Add vertical position to base address
		
		mult $a1, $t0 # Find horizontal pos
		mflo $t2 # Move horizontal pos to $t2
		add $v0, $v0, $t2 # Add horizontal position to base address.
		
		#Epilog
		lw $s1, 8($sp)
		lw $s0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12 
		jr $ra