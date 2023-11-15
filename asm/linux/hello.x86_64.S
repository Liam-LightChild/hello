# Hello World in Assembly (for x86_64 Linux)

/*
  This is Hello World
  written in x86_64 assembly.
*/

        .text
        .globl _start

SYS_EXIT = 60
SYS_WRITE = 1

STDOUT = 1

_start:
        # loop: remaining iterations in %rdx
        movq $10, %rdx

_start.loop:
        cmpq $0, %rdx
        je _start.exit
        call print_once
        decq %rdx
        jmp _start.loop

_start.exit:
        movq $SYS_EXIT, %rax
        movq $0, %rdi
        syscall
        
print_once:
        pushq %rdx

        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        leaq (message), %rsi
        call find_string_length # => %rdx
        syscall

        popq %rdx
        ret

# this function loops over the string and keeps track of how many characters
# it takes to get to the end of the string (marked by a NUL character)
find_string_length:
        # string ptr in %rsi
        # string length in %rdx
        pushw %ax
        xorq %rdx, %rdx # zero %rdx

find_string_length.loop:
        movb (%rsi, %rdx), %al
        cmpb $0, %al
        je find_string_length.exit
        incq %rdx
        jmp find_string_length.loop

find_string_length.exit:
        popw %ax
        ret

        .section .rodata
message: .asciz "Hello, world!\n"
