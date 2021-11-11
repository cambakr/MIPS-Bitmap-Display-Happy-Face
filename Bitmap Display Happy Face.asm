# FunWithBitmapDisplay.asm  (Neutral Face!)
# Let's start the process of getting ready for your final project by
# drawing a picture.
# 
# Recap
# Task 1.  Write a function that returns the base address given row,col
# Task 2.  Write a function that draws a vertical line
# Task 3.  Write a function that draws a diagonal line from upper left to lower right
# Task 4.  Draw a picture.
# Due Sunday Night.
# Assume Unit Width 8,  Display Width 256.  Base address is static data


# Short class
# No class on Thursday, and you just took a test.  Let's make it an easy week.

# Etch a Sketch or Snake for your final project
# using the Bitmap Display and MMIO Simmulator
# Today we are going to learn how to use the Bitmap Display.  It's kinda fun

.eqv BIT_MAP_ADDR 0x10010000  # Let's save our base address
.eqv RED   0x00ff0000
.eqv GREEN 0x0000ff00
.eqv BLUE  0x000000ff
.eqv PUKE  0x0068A574

.text
  .globl main
main:

  li $s0, BIT_MAP_ADDR       # Let's store our base address of the bitmap array in $s0
  li $s1, GREEN                      # 0x00RRGGBB  1 byte for red, 1 for green 1 for blue
  li $s2, BLUE
  li $s3, RED
  li $s4, PUKE
  #sw $s1, 0($s0)                         # Write our color to the base address!!!            
  #sw $s2, 4($s0)
  #sw $s3, 8($s0)
  #sw $s4, 12($s0)
  
  # Where do I write to to get a green right below our current green.  Math
  #sw $s1, 164($s0)  # Let's figure out the offset.
  #//sw $s2, 268($s0)
  #//sw $s3, 172($s0)
  #//sw $s4, 376($s0)
  
  # Blend Colors
  #or $t0, $s1, $s2            # Just to show you how to use or, let's combine GREEN AND BLUE
  #sw $t0, 80($s0)                # Just invinted CYAN!  Can I patent it??
  
  #addi $t0, $t0, 0x0002b000
  #sw $t0, 84($s0)
  # How to write a sequence of memory.
  
  # Wrote a calc method that returns row and col address given row/col like row 12, col 3
  # Task 4.  Instead of a NEUTRAL FACE.  Create your own image.
  # must have at least 10 elements.  single pixels, horiz lines, vert lines, diagonal lines
  li  $a0, BLUE            # Color
  add $a1, $s0, 808  # Let's see
  li  $a2, 8        # Length of 7
  jal DRAW_HORIZ_LINE

  li   $a0,  BLUE
  addi $a1, $s0, 848
  li   $a2,   8
  jal DRAW_HORIZ_LINE
  
  li   $a0,  GREEN
  addi $a1, $s0, 1576
  li   $a2,   14
  jal DRAW_HORIZ_LINE
  
  
   # Get out of dodge
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
    
    move $s0, $a0        # Color  
    move $s1, $a1   # Base
    move $s2, $a2   # Length
   
    # for (int i = 0; i < length; i++) {  // Start of for loop
    #   $s1[0] = $s0;            //
    #   $s1++;
    # }
    #
    # init
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
    addi $sp, $sp, 16  # Students have replace the master dweeb
    
    jr $ra
    
   
   # Task 2.  Modify DRAW_HORIZ_LINE to make it DRAW_VERTICAL_LINE.  Dependent on Unit Width of 8
   
   # Task 3.  Draw Diagonal line!!! 
  
  # Task 1
  # Write a subroutine that is given a row $a0, col, $a1.  Assume Unit Width of 8 and Display Width of 256
  # Returns the Base Address (starting point) of the line...  returns it in $v0