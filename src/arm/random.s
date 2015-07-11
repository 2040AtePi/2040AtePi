.section .data
.align 4
lastRandom:
.int 1

.section .text
.globl Random
Random:
xnm .req r4
a .req r5
prevValLocation .req r6
push {r4, r5, r6, lr}

ldr prevValLocation,=lastRandom
ldr xnm,[prevValLocation]

mov a,#0xef00
mul a,xnm
mul a,xnm
add a,xnm
add xnm,a,#73

str xnm,[prevValLocation]
mov r0,xnm

.unreq xnm
.unreq a
.unreq prevValLocation
pop {r4, r5, r6, pc}

.globl SetSeed
SetSeed:
seed .req r0
addr .req r1

ldr addr,=lastRandom
str seed,[addr]

mov pc,lr
.unreq seed
.unreq addr

