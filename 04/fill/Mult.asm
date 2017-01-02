// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
    // initialization
    @0
    D=A
    @R2
    M=D
    @acc
    M=D
    @R1
    D=M
    @count
    M=D


    //loop start
    (LOOP)
    // if second number == 0 then end loop
    @count
    D=M
    @END
    D;JEQ

    // sum first number to accumulator
    @R0
    D=M
    @acc
    M=M+D
   
    // second--; if second != 0 jump to LOOP
    @count
    M=M-1
    D=M
    @LOOP
    D;JNE

    // ram[2] = accumulator
    (END)
    @acc
    D=M
    @R2
    M=D

    // app end
    (APPEND)
    @APPEND
    0;JMP

