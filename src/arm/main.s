.section .init
.globl _start
_start:
b main

.section .text


main:
mov sp,#0x8000
mov r0,#1024
mov r1,#768
mov r2,#16
bl InitialiseFrameBuffer
teq r0,#0
bne noError$

mov r0,#16
mov r1,#1
bl SetGpioFunction
mov r0,#16
mov r1,#0
bl SetGpio

error$:
b error$

noError$:
fbInfoAddr .req r4
mov fbInfoAddr,r0
bl SetGraphicsAddress


push {lr}
mov r0,#0
mov r1,#0
bl DrawStartScreen
pop {lr}

seed .req r5
blinked .req r6
blinktime .req r7
mov blinktime,#0x40000
mov seed,#1
seedLoop$:

sub blinktime,blinktime,#1
cmp blinktime,#0
bgt notBlink$

push {lr}
mov r0,blinked
bl ToggleBlink
mov blinked,r0
pop {lr}
mov blinktime,#0x40000

notBlink$:

add seed,seed,#1
push {lr}
bl ProcessInput
pop {lr}

cmp r0,#0
beq seedLoop$

push {lr}
mov r0,seed
bl SetSeed
pop {lr}
.unreq seed
.unreq fbInfoAddr
.unreq blinked
.unreq blinktime


bl ClearBoard

bl StartGame

endLoop$:
b endLoop$



.globl ToggleBlink
ToggleBlink:
push {lr}
cmp r0,#0
bne blinkElse$

ldr r0,=0xFFFF
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen7
mov r0,#1
pop {pc}

blinkElse$:

mov r0,#0x0000
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen7
mov r0,#0
pop {pc}





