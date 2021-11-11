# File: Bitmap Display Happy Face.asm
# Author: Cameron Baker with init from Professor Meacham
# Date: Nov. 11, 2021
# Purpose: Draws a face on the bitmap display.

# Task 1.  Write a function that returns the base address given row,col
# Task 2.  Write a function that draws a vertical line
# Task 3.  Write a function that draws a diagonal line from upper left to lower right
# Task 4.  Draw a picture.
# Due Sunday Night.
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

  li  $a0, BLUE            # Color
  add $a1, $s0, 808  # Let's see
  li  $a2, 8        # Length of 7
  jal DRAW_HORIZ_LINE

  li   $a0,  BLUE
  addi $a1, $s0, 848
  li   $a2,   8
  jal DRAW_HORIZ_LINE
  
  li   $a0,  GREEN
  addi $a1, $s0, 0
  li   $a2,   14
  jal DRAW_VERTICAL_LINE
  
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
   
   # Task 3.  Draw Diagonal line!!! 
  
  # Task 1
  # Write a subroutine that is given a row $a0, col, $a1.  Assume Unit Width of 8 and Display Width of 256
  # Returns the Base Address (starting point) of the line...  returns it in $v0
