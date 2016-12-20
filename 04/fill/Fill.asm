// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

    @screenValue
    M=0
    @screenShouldBe
    M=-1
    @key
    M=0

    //key check
    (KEYCHECK)
    @KBD
    D=M
    @NOTPRESSED
    D;JEQ
    @PRESSED
    D;JNE
    (PRESSED)
    @key
    M=-1
    @CHECKED
    0;JMP
    (NOTPRESSED)
    @key
    M=0
    @CHECKED
    0;JMP

    // main loop
    (LOOP)
    @KEYCHECK
    0;JMP
    (CHECKED)
    @FILL
    D;JMP

    //fill black
    (FILL)
    //go back if already filled
    @screenValue
    D=M
    @key
    D=D-M
    @LOOP
    D;JEQ
    // fill if not

    // swap values
    @screenValue
    D=M
    @temp
    M=D
    @screenShouldBe
    D=M
    @screenValue
    M=D
    @temp
    D=M
    @screenShouldBe
    M=D


    //take screen pointer
    @SCREEN
    D=A
    @screenPointer
    M=D

    //main fill loop
    (SCREENLOOP)
    @screenValue
    D=M
    //goto pointer
    @screenPointer
    A=M
    
    M=D
    //increment pointer
    @screenPointer
    M=M+1
    D=M
    // do fill again if not KBD register
    @KBD
    D=A-D
    @SCREENLOOP
    D;JNE
    @LOOP
    0;JMP







